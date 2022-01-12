//
//  RSSFeedListViewController
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "RSSFeedListViewController.h"
#import "RSSFeedDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileListViewController.h"
#import "AppDelegate.h"

@interface RSSFeedListViewController ()

@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSMutableString *title;
@property (strong, nonatomic) NSMutableString *link;
@property (strong, nonatomic) NSString *element;
@end

@implementation RSSFeedListViewController

@synthesize parser=_parser;
@synthesize feeds=_feeds;
@synthesize item=_item;
@synthesize title=title_;
@synthesize link=_link;
@synthesize element=_element;



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = NSLocalizedString(@"Latest News", nil);
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    self.feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.espncricinfo.com/rss/content/story/feeds/0.xml"];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbar.tintColor = [AppDelegate navigationBarTintColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (IBAction)measureButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"sizer" sender:self];
}
- (IBAction)rssFeed:(id)sender
{
    //[self performSegueWithIdentifier:@"rssFeed" sender:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)contact:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    NSArray *toReceipents = [[NSArray alloc] initWithObjects:@"aas@dd.com", nil];
    [controller setToRecipients:toReceipents];
    [controller setSubject:NSLocalizedString(@"MailSubject", nil)];
    [controller setMessageBody:NSLocalizedString(@"MailBody", nil) isHTML:NO];
    if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [[self.feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView* headerView  = [[UIView alloc] init];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 200, 70)];
    logo.image = [UIImage imageNamed:@"logo"];
    [headerView addSubview:logo];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    return footerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*CGRect tbFrame = [self.tableView frame];
    tbFrame.size.height = cell.frame.size.height * 5;
    [self.tableView setFrame:tbFrame];*/
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [AppDelegate tableViewSelectionColor];
    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    cell.backgroundColor = [AppDelegate tableViewRowColor];
    cell.textLabel.textColor = [AppDelegate tableViewTextColor];
    cell.selectedBackgroundView.backgroundColor = [AppDelegate tableViewSelectionColor];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.element = elementName;
    
    if ([self.element isEqualToString:@"item"]) {
        
        self.item    = [[NSMutableDictionary alloc] init];
        self.title   = [[NSMutableString alloc] init];
        self.link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [self.item setObject:self.title forKey:@"title"];
        [self.item setObject:self.link forKey:@"link"];
        
        [self.feeds addObject:[self.item copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.element isEqualToString:@"title"]) {
        [self.title appendString:string];
    } else if ([self.element isEqualToString:@"link"]) {
        [self.link appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setToolbarItems:self.toolbarItems];
    if ([[segue identifier] isEqualToString:@"sizer"])
    {
        ProfileListViewController *dest = (ProfileListViewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.title = NSLocalizedString(@"Profiles", nil);
    }
    else if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [self.feeds[indexPath.row] objectForKey: @"link"];
        
        NSString *titleText = [[self.feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
        [[segue destinationViewController] setTitle:titleText];
        
        [[segue destinationViewController] setUrl:string];
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

@end
