//
//  MainPageViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 17/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "MainPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileListViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface MainPageViewController ()
{
    BOOL isTitle;
    BOOL isDesc;
    BOOL isItem;
}
@property (strong, retain) NSXMLParser *parser;
@property (strong, nonatomic) NSString *titleHeader;
@property (strong, nonatomic) NSString *titleDesc;
@property (strong, nonatomic) UIActivityIndicatorView *progressIndicator;
@end

@implementation MainPageViewController
@synthesize parser=_parser;


@synthesize managedObjectContext;
@synthesize textContent=_textContent;
@synthesize textHeader=_textHeader;
@synthesize titleHeader=_titleHeader;
@synthesize titleDesc=_titleDesc;
@synthesize progressIndicator=_progressIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.textContent.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.textContent.textColor = [UIColor whiteColor];
    //self.textContent.text = NSLocalizedString(@"nointernet", nil);
    
    self.textHeader.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.textHeader.textColor = [UIColor whiteColor];
    self.textHeader.font = [UIFont fontWithName:@"Verdana-Bold" size:14.0];
    self.progressIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.progressIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.progressIndicator.hidesWhenStopped = YES;
    self.progressIndicator.center = self.view.center;
    [self.view addSubview:self.progressIndicator];
    [self.progressIndicator bringSubviewToFront:self.view];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isTitle = NO;
    isDesc = NO;
    isItem = NO;
    
    
    
    self.titleHeader = nil;
    self.titleDesc = nil;
    
    
    //Reachability* internetReach = [Reachability reachabilityForInternetConnection];
    Reachability* internetReach = [Reachability reachabilityWithHostName: @"monsieurmaurice.ch"] ;
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    NSLog(@"Reachibility Status: %d",netStatus);
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Access Not Available");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.progressIndicator stopAnimating];
            self.textContent.text = NSLocalizedString(@"nointernet", nil);
            break;
        }
            
        case ReachableViaWWAN:
        {
            NSLog(@"Reachable WWAN");
            [self startParsingForRSS];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"Reachable WiFi");
            [self startParsingForRSS];
            break;
        }
        default:
        {
            NSLog(@"Internet Reachable");
            [self startParsingForRSS];
        }
    }
}

- (void)startParsingForRSS
{
    NSLog(@"Inside startParsingForRSS at: %@", [[NSDate date] description]);
    if(self.parser == nil)
    {
        NSLog(@"Parser Object Nil");
        //NSURL *url = [NSURL URLWithString:@"http://www.inswigo.com/mmfeeds.php"];
        NSURL *url = [NSURL URLWithString:@"http://monsieurmaurice.ch/mmfeeds.php"];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [self.parser setDelegate:self];
        [self.parser setShouldResolveExternalEntities:NO];
    }
    
    BOOL parsereturn = [self.parser parse];
    if(!parsereturn)
    {
        
        NSError *error = [self.parser parserError];
        NSLog(@"Unable to parse. NSXMLParser returning false: %@",error.description);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.progressIndicator stopAnimating];
        self.textContent.text = NSLocalizedString(@"nointernet", nil);
        /*parsereturn = [self.parser parse];
        if(!parsereturn)
        {
            NSLog(@"Unable to parse again");
        }*/
    }
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"item"])
    {
        isItem = YES;
    }
    if([elementName isEqualToString:@"title"])
    {
        isTitle = YES;
    }
    if([elementName isEqualToString:@"description"])
    {
        isDesc = YES;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //NSLog(@"didEndElement: %@",elementName);
    
    if([elementName isEqualToString:@"title"])
    {
        isTitle = NO;
    }
    if([elementName isEqualToString:@"description"])
    {
        isDesc = NO;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"foundCharacters");
   // NSLog(@"foundCharacters: %@",string);
    
    if(isTitle && isItem)
    {
        if(self.titleHeader == nil)
            self.titleHeader = string;
        else
            self.titleHeader = [self.titleHeader stringByAppendingFormat:@"%@",string];
    }
    
    if(isDesc && isItem)
    {
        if(self.titleDesc == nil)
            self.titleDesc = string;
        else
            self.titleDesc = [self.titleDesc stringByAppendingFormat:@"%@",string];
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //NSLog(@"parserDidEndDocument");
    //[self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.progressIndicator stopAnimating];
    if (self.titleHeader != nil || self.titleDesc != nil)
    {
        self.textHeader.text = self.titleHeader;
        self.textContent.text = self.titleDesc;
    }
    else
    {
        self.textContent.text = NSLocalizedString(@"nointernet", nil);
    }
    NSLog(@"Parsing ends: %@",[[NSDate date] description]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *newsButton = [self.toolbarItems objectAtIndex:2];
    newsButton.tintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    ;
    newsButton.enabled = NO;
    
    UIBarButtonItem *mesureButton = [self.toolbarItems objectAtIndex:0];
    mesureButton.tintColor = [AppDelegate navigationBarTintColor];
    mesureButton.enabled = YES;
    
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbar.tintColor = [AppDelegate navigationBarTintColor];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.progressIndicator startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIBarButtonItem *newsButton = [self.toolbarItems objectAtIndex:2];
    newsButton.tintColor = [AppDelegate navigationBarTintColor];
    newsButton.enabled = YES;
    
    UIBarButtonItem *mesureButton = [self.toolbarItems objectAtIndex:0];
    mesureButton.tintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    ;
    mesureButton.enabled = NO;
    
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.parser abortParsing];
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload
{
    self.navigationController.navigationBarHidden = NO;
    [self setTextContent:nil];
    [self setTextContent:nil];
    [self setTextHeader:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)measureButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"sizer" sender:self];
}
- (IBAction)rssFeed:(id)sender {
    //[self performSegueWithIdentifier:@"rssFeed" sender:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [[segue destinationViewController] setToolbarItems:self.toolbarItems];
    if ([[segue identifier] isEqualToString:@"sizer"])
    {
        ProfileListViewController *dest = (ProfileListViewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.title = NSLocalizedString(@"Profiles", nil);
        //dest.toolbarItems = self.toolbarItems;
    }
}

- (IBAction)invokeContact:(id)sender {
    [self performSegueWithIdentifier:@"contact" sender:self];
    
}
@end
