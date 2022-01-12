//
//  CodGenderAgeControllerViewController.m
//  testTables
//
//  Created by Sudip Pal on 01/08/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import "CodGenderAgeControllerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface CodGenderAgeControllerViewController ()
{
    NSArray* genderList;
    NSArray* genderDescription;
}

@property (nonatomic, strong) UIImage *checkImage;
@end

@implementation CodGenderAgeControllerViewController

@synthesize delegate=_delegate;
@synthesize genderAge=_genderAge;
@synthesize checkImage=_imageView;
@synthesize userProfile=_userProfile;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [AppDelegate tableViewBorderColor];
    self.navigationItem.title = NSLocalizedString(@"Gender", nil);
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.view.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1];
    
    
    
    genderList = [NSArray arrayWithObjects: NSLocalizedString(@"Man", nil), NSLocalizedString(@"Woman", nil), NSLocalizedString(@"Kidboy", nil), NSLocalizedString(@"Kidgirl", nil), NSLocalizedString(@"Toddlerboy", nil), NSLocalizedString(@"Toddlergirl", nil), NSLocalizedString(@"Baby", nil), nil];
    genderDescription = [NSArray arrayWithObjects: @"", @"", @"5-14", @"5-14", @"2-5", @"2-5", @"0-2", nil];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = barButton;

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.separatorColor = [AppDelegate tableViewBorderColor];
}

-(void)cancelButtonClicked: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)saveButtonClicked: (id)sender
{
    if (![self.genderAge isEqualToString:self.userProfile.gender])
    {
        if (self.userProfile.footWear != nil || self.userProfile.hats != nil || self.userProfile.rings != nil || self.userProfile.jeans != nil || self.userProfile.trousers != nil || self.userProfile.shirts != nil || self.userProfile.underwearBottom != nil || self.userProfile.belts != nil || self.userProfile.gloves != nil)
        {
            NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"ChangeGenderMsg", nil)];
            NSString *otherButton = NSLocalizedString(@"OK", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ChangeGenderTitle", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:otherButton, nil];
            [alert show];
        }
        else
        {
            [self.delegate genderAgeValue:self.genderAge];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self.delegate genderAgeValue:self.genderAge];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:NSLocalizedString(@"ChangeGenderMsg", nil)])
    {
        if(buttonIndex == 1)
        {
            self.userProfile.footWear = nil;
            self.userProfile.hats = nil;
            self.userProfile.rings = nil;
            self.userProfile.jeans = nil;
            self.userProfile.trousers = nil;
            self.userProfile.shirts = nil;
            self.userProfile.underwearBottom = nil;
            self.userProfile.belts = nil;
            self.userProfile.gloves = nil;
            self.userProfile.suit = nil;
            self.userProfile.outerwearBust = nil;
            self.userProfile.outerwearWaist = nil;
            [self.delegate genderAgeValue:self.genderAge];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidUnload
{
    genderList = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString* row = [[NSString alloc] initWithFormat:@"Row selected %@", genderList[ indexPath.row ]];
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *data = cell.textLabel.text;
    if (data != self.genderAge) {
        self.genderAge = data;
    }
    
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = genderList[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
    NSString *detailText = genderDescription[indexPath.row];
    if([detailText length] > 0)
        detailText = [detailText stringByAppendingString:NSLocalizedString(@"years", nil)];
    cell.detailTextLabel.text = detailText;
    
    cell.backgroundColor = [AppDelegate tableViewRowColor];
    
    if([cell.textLabel.text isEqualToString:self.genderAge])
    {
        cell.accessoryView = [self getCheckMark];
        cell.backgroundColor = [AppDelegate tableViewSelectionColor];
        cell.detailTextLabel.textColor = [AppDelegate tableViewTextColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textLabel.textColor = [AppDelegate tableViewTextColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UIImageView*) getCheckMark
{
    if(self.checkImage == nil)
        self.checkImage = [UIImage imageNamed:@"tick"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10.0, 20, 20)];
    imageView.image = self.checkImage;
    return imageView;
    
}

@end
