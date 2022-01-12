//
//  ProfileNameViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 19/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "NameForProfileViewController.h"

@interface NameForProfileViewController ()

@end

@implementation NameForProfileViewController
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize delegate=_delegate;
@synthesize firstNameTextBox=_firstNameLabel;
@synthesize lastNameTextBox=_lastNameLabel;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.firstNameTextBox.placeholder = NSLocalizedString(@"FirstName", nil);
    self.lastNameTextBox.placeholder = NSLocalizedString(@"LastName", nil);
    [self.firstNameTextBox becomeFirstResponder];
    if ([self.firstName length] > 0)
        self.firstNameTextBox.text = self.firstName;
    
    if ([self.lastName length] > 0)
        self.lastNameTextBox.text = self.lastName;
}

-(void)cancelButtonClicked: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES]; // or popToRoot... if required.
}

- (IBAction)firstNameKeyboardNext:(id)sender {
    [self.lastNameTextBox becomeFirstResponder];
}

-(IBAction)saveButtonClicked: (id)sender
{
    self.firstName = self.firstNameTextBox.text;
    self.lastName = self.lastNameTextBox.text;
    if ([self.firstName length] < 1)
    {
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"FirstName", nil)];
        message = [message stringByAppendingString:NSLocalizedString(@"NameError", nil)];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([self.lastName length] < 1)
    {
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"LastName", nil)];
        message = [message stringByAppendingString:NSLocalizedString(@"NameError", nil)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
        
    [self.delegate saveFirstName:self.firstName lastName:self.lastName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFirstNameTextBox:nil];
    [self setLastNameTextBox:nil];
    [super viewDidUnload];
}
@end
