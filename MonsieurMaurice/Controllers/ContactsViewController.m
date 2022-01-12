//
//  ContactsViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 30/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "ContactsViewController.h"
#import "AppDelegate.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize inswigoImage=_inswigoImage;
@synthesize mailIDLabel=_mailIDLabel;
@synthesize phoneNumberIDLabel=_phoneNumberIDLabel;
@synthesize webTitle=_webTitle;
@synthesize address=_address;
@synthesize phoneNumberDetails=_phoneNumberDetails;
@synthesize websiteDetails=_websiteDetails;
@synthesize mailIDDetails=_mailIDDetails;

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
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [self.inswigoImage addGestureRecognizer:imageTapRecognizer];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    self.mailIDLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:14.0];
    self.phoneNumberIDLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:14.0];
    
    self.webTitle.font = [UIFont fontWithName:@"Verdana-Bold" size:14.0];
    self.address.font = [UIFont fontWithName:@"Verdana-Bold" size:14.0];
    
    UITapGestureRecognizer *mailTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMail:)];
     [self.mailIDDetails addGestureRecognizer:mailTapRecognizer];
    
    UITapGestureRecognizer *phoneTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    [self.phoneNumberDetails addGestureRecognizer:phoneTapRecognizer];
    
    UITapGestureRecognizer *webTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startWebPage:)];
    [self.websiteDetails addGestureRecognizer:webTapRecognizer];
}

- (void)startWebPage:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.monsieurmaurice.ch"]];
}

- (void)callPhone:(id)sender
{
    NSString *phoneNumber = self.phoneNumberDetails.text;
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}
- (void)sendMail:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    NSArray *toReceipents = [[NSArray alloc] initWithObjects:@"info@monsieurmaurice.ch", nil];
    [controller setToRecipients:toReceipents];
    //[controller setSubject:NSLocalizedString(@"MailSubject", nil)];
    //[controller setMessageBody:NSLocalizedString(@"MailBody", nil) isHTML:NO];
    if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *ContactButton = [self.toolbarItems objectAtIndex:4];
    ContactButton.tintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    ;
    ContactButton.enabled = NO;
    
    UIBarButtonItem *mesureButton = [self.toolbarItems objectAtIndex:0];
    mesureButton.tintColor = [AppDelegate navigationBarTintColor];
    mesureButton.enabled = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *ContactButton = [self.toolbarItems objectAtIndex:4];
    ContactButton.tintColor = [AppDelegate navigationBarTintColor];
    ContactButton.enabled = YES;
    
    UIBarButtonItem *mesureButton = [self.toolbarItems objectAtIndex:0];
    mesureButton.tintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    ;
    mesureButton.enabled = NO;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInswigoImage:nil];
    [self setMailIDLabel:nil];
    [self setPhoneNumberIDLabel:nil];
    [self setAddress:nil];
    [self setWebTitle:nil];
    [self setWebsiteDetails:nil];
    [self setPhoneNumberDetails:nil];
    [self setMailIDDetails:nil];
    [super viewDidUnload];
}

- (void) imageViewTapped : (id) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.inswigo.com"]];
}
@end
