//
//  CodViewController.m
//  testTables
//
//  Created by Sudip Pal on 31/07/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import "ProfilePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CodGenderAgeControllerViewController.h"
#import "CustomPickerViewController.h"
#import "AppDelegate.h"
#import "NameForProfileViewController.h"
#import "Notes.h"
#import "JeansAccessoryViewController.h"
#import "WomanUnderwearPickerViewController.h"
#import "WomenOuterWearVewController.h"

#define KAShrinkDimension 2

@interface ProfilePageViewController ()
{
    //NSInteger tableSection;
    //NSInteger tableRow;
    BOOL addUserMetadata;
}
@property (nonatomic, retain) NSArray* accessoryName;
@property (nonatomic, strong) UIImage *arrowImage;
@property (nonatomic, strong) NSString *genderAgeValue;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end



@implementation ProfilePageViewController

@synthesize accessoryName=_accessoryName;
@synthesize arrowImage=_arrowImage;
@synthesize genderAgeValue=_genderAgeValue;
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize selectedIndex=_selectedIndex;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [AppDelegate tableViewBorderColor];
    /*Footwear                      Footwear
     Hats                           Hats
     Rings                          Rings
     Outerwear                      Suites/Outerwear
     Jeans                          Jeans
     Trouser                        Trouser
     Shirts                         Shirts/Underwear top	for women
     Underwear top	for women
     Underwear bottom	for men
     Underwear bottom for women
     wear	
     Belts
     Gloves */
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.view.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1];
    self.accessoryName = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Footwear", nil), NSLocalizedString(@"Hats", nil), NSLocalizedString(@"Rings", nil), NSLocalizedString(@"Suites", nil), NSLocalizedString(@"Jeans", nil), NSLocalizedString(@"Trouser", nil), NSLocalizedString(@"Shirts", nil), NSLocalizedString(@"Underwearbottom", nil), NSLocalizedString(@"Belts", nil), NSLocalizedString(@"Gloves", nil), nil];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    addUserMetadata = NO;
    
    self.firstName = self.userProfile.firstName;
    self.lastName = self.userProfile.lastName;
    self.genderAgeValue = self.userProfile.gender;
    
    if([self.firstName length] < 1)
        self.firstName = NSLocalizedString(@"Your", nil);
    
    if([self.lastName length] < 1)
        self.lastName = NSLocalizedString(@"Name", nil);
    
    if([self.genderAgeValue length] < 1)
        self.genderAgeValue = NSLocalizedString(@"Man", nil);
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    if (([self.firstName length] < 1) || ([self.firstName isEqualToString:NSLocalizedString(@"Your", nil)]))
    {
        if(!addUserMetadata)
            [self.managedObjectContext deleteObject:self.userProfile];
        else
            addUserMetadata = NO;
    }
    else
    {
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
            NSLog(@"Saving to DB failed in ProfilePageViewController");
            NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"DBSaveError", nil)];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.firstName = nil;
    self.lastName = nil;
    self.genderAgeValue = nil;
    self.arrowImage = nil;
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retVal = 1;
    switch (section) {
            
        case 0:
            if ([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)] || [self.genderAgeValue isEqualToString:NSLocalizedString(@"Woman", nil)])
                retVal = 10;
            else
                retVal = 0;
            break;
            
        case 1:
            if ([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)] || [self.genderAgeValue isEqualToString:NSLocalizedString(@"Woman", nil)])
                retVal = 0;
            else
                retVal = 2;
            break;
        default:
            break;
    }
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [AppDelegate tableViewSelectionColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.backgroundColor = [AppDelegate tableViewRowColor];
    cell.selectedBackgroundView.backgroundColor = [AppDelegate tableViewSelectionColor];
    
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
    cell.detailTextLabel.text = @"";
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:12.0];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    UIImage *logoImage = [UIImage imageNamed:@"shirt_suit_right"];
    logoImageView.image = logoImage;
    
    
    if(section == 0)
    {
        cell.textLabel.text = self.accessoryName[row];
        switch (row)
        {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"footwear"];
                int val = [self.userProfile.footWear intValue];
                if (val > 0)
                    cell.detailTextLabel.text = self.userProfile.footWear;
                break;
                
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"hats"];
                cell.detailTextLabel.text = self.userProfile.hats;
                break;
            
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"rings"];
                val = [self.userProfile.rings intValue];
                if (val > 0)
                    cell.detailTextLabel.text = self.userProfile.rings;
                break;
                
            case 3:
                if ([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)])
                {
                    cell.imageView.image = [UIImage imageNamed:@"suit"];
                    cell.accessoryView = logoImageView;
                }
                else
                {
                    cell.textLabel.text = NSLocalizedString(@"Outerwear", nil);
                    cell.imageView.image = [UIImage imageNamed:@"outerwear"];
                    cell.accessoryView = UITableViewCellAccessoryNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.detailTextLabel.text = self.userProfile.suit;
                break;
            
            case 4:
                cell.imageView.image = [UIImage imageNamed:@"jeans"];
                cell.detailTextLabel.text = self.userProfile.jeans;
                break;
                
            case 5:
                cell.imageView.image = [UIImage imageNamed:@"trouser"];
                cell.detailTextLabel.text = self.userProfile.trousers;
                break;
                
            case 6:
                if ([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)])
                {
                    cell.imageView.image = [UIImage imageNamed:@"shirts"];
                    cell.accessoryView = logoImageView;    
                }
                else
                {
                    cell.textLabel.text = NSLocalizedString(@"UnderwearTop", nil);
                    cell.imageView.image = [UIImage imageNamed:@"underwear-top-for-women"];
                    cell.accessoryView = UITableViewCellAccessoryNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.detailTextLabel.text = self.userProfile.shirts;
                break;
                
            case 7:
                cell.textLabel.text = NSLocalizedString(@"UnderwearBottom", nil);
                if ([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)])
                    cell.imageView.image = [UIImage imageNamed:@"underwear-bottom-for-men"];
                else
                    cell.imageView.image = [UIImage imageNamed:@"underwear-bottom-for-women"];
                
                cell.detailTextLabel.text = self.userProfile.underwearBottom;
                break;
                
            case 8:
                cell.imageView.image = [UIImage imageNamed:@"belts"];
                cell.detailTextLabel.text = self.userProfile.belts;
                break;
                
            case 9:
                cell.imageView.image = [UIImage imageNamed:@"gloves"];
                cell.detailTextLabel.text = self.userProfile.gloves;
                break;
                
            default:
                cell.imageView.image = [UIImage imageNamed:@"jeans"];
                break;
        }
    }
    else if(section == 1)
    {
        switch (row)
        {
            case 0:
                cell.textLabel.text = self.accessoryName[row];
                cell.imageView.image = [UIImage imageNamed:@"footwear"];
                cell.detailTextLabel.text = self.userProfile.footWear;
                break;
                
            case 1:
                cell.detailTextLabel.text = self.userProfile.hats;
                cell.textLabel.text = NSLocalizedString(@"wear", nil),
                cell.imageView.image = [UIImage imageNamed:@"wear"];
                break;
                
            default:
                break;
        }
    }
    
    //cell.accessoryView = [self getArrowAccessory];
    return cell;
}

#pragma table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (([self.firstName length] < 1) || ([self.firstName isEqualToString:NSLocalizedString(@"Your", nil)]))
    {
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"UnsavedName", nil)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FirstName", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    self.selectedIndex = indexPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    if([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)])
    {
        if([cellText isEqualToString:NSLocalizedString(@"Suites", nil)] || [cellText isEqualToString:NSLocalizedString(@"Shirts", nil)])
        {
            [self performSegueWithIdentifier:@"customOrders" sender:self];
            return;
        }
        else if([cellText isEqualToString:NSLocalizedString(@"Jeans", nil)])
        {
            [self performSegueWithIdentifier:@"jeans" sender:self];
            return;
        }
        
    }
    else if([self.genderAgeValue isEqualToString:NSLocalizedString(@"Woman", nil)])
    {
        if([cellText isEqualToString:NSLocalizedString(@"Jeans", nil)])
        {
            [self performSegueWithIdentifier:@"jeans" sender:self];
            return;
        }
        else if([cellText isEqualToString:NSLocalizedString(@"UnderwearTop", nil)])
        {
            [self performSegueWithIdentifier:@"underwear" sender:self];
            return;
        }
        else if([cellText isEqualToString:NSLocalizedString(@"Outerwear", nil)])
        {
            [self performSegueWithIdentifier:NSLocalizedString(@"womenOuterwear", nil) sender:self];
            return;
        }
    }
    [self performSegueWithIdentifier:@"SetRoller" sender:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        UIView* headerView  = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = nil;
        if([self.userProfile.imagePath length] > 0)
        {
            NSURL *fileURL = [NSURL fileURLWithPath:self.userProfile.imagePath];
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:fileURL];
            image = [[UIImage alloc] initWithData:imgData];
        }
        else
            image = [UIImage imageNamed:@"face"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10.0, 70, 70)];
        imageView.image = image;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.clipsToBounds =YES;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:imageTapRecognizer];
        [headerView addSubview: imageView];
        
        UILabel *firstNameLabel = [[UILabel alloc] init];
        [firstNameLabel setText:self.firstName];
        [firstNameLabel setFrame:CGRectMake(90, 12, 100, 35)];
        [firstNameLabel setTextColor:[UIColor whiteColor]];
        [firstNameLabel setBackgroundColor:[UIColor clearColor]];
        firstNameLabel.font = [UIFont fontWithName:@"Verdana" size:17.0];
        firstNameLabel.userInteractionEnabled = YES;
        
        //adjust the label the the new height.
        CGSize firstNameMaxLabelSize = CGSizeMake(100,35);
        CGSize firstNameExptSize = [self.firstName sizeWithFont:firstNameLabel.font constrainedToSize:firstNameMaxLabelSize lineBreakMode:firstNameLabel.lineBreakMode];
        CGRect firstNameNewFrame = firstNameLabel.frame;
        firstNameNewFrame.size.height = firstNameExptSize.height;
        firstNameNewFrame.size.width = firstNameExptSize.width;
        firstNameLabel.frame = firstNameNewFrame;
        
        UITapGestureRecognizer *firstnameTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTapped:)];
        [firstNameLabel addGestureRecognizer:firstnameTapRecognizer];
        [headerView addSubview:firstNameLabel];
        
        
        
        UILabel *lastNameLabel = [[UILabel alloc] init];
        [lastNameLabel setText:self.lastName];
        [lastNameLabel setFrame:CGRectMake(90 + firstNameLabel.frame.size.width + 5.0, 12, 130, 35)];
        lastNameLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:17.0];
        [lastNameLabel setTextColor:[UIColor whiteColor]];
        [lastNameLabel setBackgroundColor:[UIColor clearColor]];
        lastNameLabel.userInteractionEnabled = YES;
        
        //adjust the label the the new height.
        CGSize lastNameMaxLabelSize = CGSizeMake(130,35);
        CGSize lastNameExptSize = [self.lastName sizeWithFont:lastNameLabel.font constrainedToSize:lastNameMaxLabelSize lineBreakMode:lastNameLabel.lineBreakMode];
        CGRect lastNameNewFrame = lastNameLabel.frame;
        lastNameNewFrame.size.height = lastNameExptSize.height;
        lastNameNewFrame.size.width = lastNameExptSize.width;
        lastNameLabel.frame = lastNameNewFrame;
        
        UITapGestureRecognizer *lastnameTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTapped:)];
        [lastNameLabel addGestureRecognizer:lastnameTapRecognizer];
        [headerView addSubview:lastNameLabel];
        
        UILabel *genderLabel = [[UILabel alloc] init];
        genderLabel.text = self.genderAgeValue;
        genderLabel.font = [UIFont fontWithName:@"Verdana" size:15.0];
        [genderLabel setFrame:CGRectMake(90, 40, 150, 35)];
        [genderLabel setTextAlignment:NSTextAlignmentLeft];
        [genderLabel setTextColor:[UIColor whiteColor]];
        [genderLabel setBackgroundColor:[UIColor clearColor]];
        genderLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *genderTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderTapped:)];
        [genderLabel addGestureRecognizer:genderTapRecognizer];
        [headerView addSubview:genderLabel];
        
        UILabel *blank = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 400, 20)];
        [blank setText:@""];
        [blank setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:blank];
        
        return headerView;
    }
    else
        return  nil;
}

- (void) nameTapped :(id)sender
{
    [self performSegueWithIdentifier:@"profileName" sender:self];
}

- (void) genderTapped :(id)sender
{
    [self performSegueWithIdentifier:@"GenderAge" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle retVal = UITableViewCellEditingStyleNone;
    NSInteger tableRow = indexPath.row;
    switch (tableRow) {
        case 0:
            if (self.userProfile.footWear!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
        case 1:
            if (self.userProfile.hats!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 2:
            if (self.userProfile.rings!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 3:
            if (self.userProfile.suit!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 4:
            if (self.userProfile.jeans!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 5:
            if (self.userProfile.trousers!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 6:
            if (self.userProfile.shirts!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 7:
            if (self.userProfile.underwearBottom!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 8:
            if (self.userProfile.belts!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
            
        case 9:
            if (self.userProfile.gloves!= nil)
                retVal = UITableViewCellEditingStyleDelete;
            break;
            
        default:
            retVal = UITableViewCellEditingStyleNone;
            break;
    }
    
    return retVal;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger tableRow = indexPath.row;
        switch (tableRow) {
            case 0:
                self.userProfile.footWear = nil;
                
            case 1:
                self.userProfile.hats = nil;
                break;
                
            case 2:
                self.userProfile.rings = nil;
                break;
                
            case 3:
                self.userProfile.suit = nil;
                break;
                                
            case 4:
                self.userProfile.jeans = nil;
                break;
                
                
            case 5:
                self.userProfile.trousers = nil;
                break;
                
                
            case 6:
                self.userProfile.shirts = nil;
                break;
                
                
            case 7:
                self.userProfile.underwearBottom = nil;
                break;
                
            case 8:
                self.userProfile.belts = nil;
                break;
                
                
            case 9:
                self.userProfile.gloves = nil;
                break;
                
            default:
                break;
        }
        [cell setEditing:NO animated:YES];
         self.selectedIndex = indexPath;
        [self reloadTableRow];
    }
}

- (void) imageViewTapped : (id) sender
{
    NSString *actionSheetTitle = nil; //Action Sheet Title
    NSString *destructiveTitle = nil;
    if([self.userProfile.imagePath length] > 0)
        destructiveTitle = NSLocalizedString(@"DeletePhoto", nil);
    
    NSString *galleryButton = NSLocalizedString(@"CameraRoll", nil);
    NSString *cameraButton = NSLocalizedString(@"TakePhoto", nil);
    NSString *cancelTitle = NSLocalizedString(@"Dismiss", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:galleryButton, cameraButton, nil];
    actionSheet.actionSheetStyle = UIActivityIndicatorViewStyleGray;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = nil;
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:NSLocalizedString(@"DeletePhoto", nil)])
    {
        [[NSFileManager defaultManager] removeItemAtPath:self.userProfile.imagePath error:nil];
        self.userProfile.imagePath = nil;
        [self.tableView reloadData];
        [self.delegate reloadProfile];
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"CameraRoll", nil)])
    {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.allowsEditing = YES;
        addUserMetadata = YES;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"TakePhoto", nil)])
    {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if(isCamera)
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        else
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.allowsEditing = YES;
        addUserMetadata = YES;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
    else
    {
        picker = nil;
    }
    buttonTitle = nil;
    actionSheet = nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 110;
    else
        return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setToolbarItems:self.toolbarItems];
    addUserMetadata = YES;
    if ([[segue identifier] isEqualToString:@"GenderAge"])
    {
        CodGenderAgeControllerViewController* dest = (CodGenderAgeControllerViewController*)[segue destinationViewController];
        dest.delegate = self;
        dest.genderAge = self.genderAgeValue;
        dest.userProfile = self.userProfile;
        
    }
    else if([[segue identifier] isEqualToString:@"jeans"])
    {
        JeansAccessoryViewController* dest = (JeansAccessoryViewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.userProfile = self.userProfile;
        dest.pickerColumnNumber = 2;
        NSInteger tableRow = self.selectedIndex.row;
        dest.accessoryName = self.accessoryName[tableRow];
        dest.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"womenOuterwear"])
    {
        WomenOuterWearVewController* dest = (WomenOuterWearVewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.userProfile = self.userProfile;
        dest.pickerColumnNumber = 3;
        NSInteger tableRow = self.selectedIndex.row;
        dest.accessoryName = self.accessoryName[tableRow];
        dest.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"underwear"])
    {
        WomanUnderwearPickerViewController* dest = (WomanUnderwearPickerViewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.userProfile = self.userProfile;
        dest.pickerColumnNumber = 3;
        NSInteger tableRow = self.selectedIndex.row;
        dest.accessoryName = self.accessoryName[tableRow];
        dest.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"SetRoller"])
    {
        CustomPickerViewController* dest = (CustomPickerViewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.userProfile = self.userProfile;
        NSInteger tableRow = self.selectedIndex.row;
        switch (tableRow) {
            case 0:
                dest.pickerColumnNumber = 3;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
                
            case 1:
                if ([self.genderAgeValue isEqualToString:NSLocalizedString(@"Man", nil)] || [self.genderAgeValue isEqualToString:NSLocalizedString(@"Woman", nil)])
                {
                    dest.pickerColumnNumber = 2;
                }
                else
                    dest.pickerColumnNumber = 1;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
                
            case 2:
                dest.pickerColumnNumber = 3;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
               //3 is suites (custom order for men) GenderAge
                //4 Jeans separate segue
            case 5: //Trouser
                dest.pickerColumnNumber = 1;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
                //6 shrit same as 4
            case 7:
                dest.pickerColumnNumber = 3;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
                
            case 8:
                dest.pickerColumnNumber = 3;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
                
            case 9:
                dest.pickerColumnNumber = 2;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
                
            default:
                dest.pickerColumnNumber = 3;
                dest.accessoryName = self.accessoryName[tableRow];
                break;
        }
        dest.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"profileName"])
    {
        NameForProfileViewController *dest = (NameForProfileViewController*)[segue destinationViewController];
        dest.delegate = self;
        if (([self.firstName length] > 0) && (![self.firstName isEqualToString:NSLocalizedString(@"Your", nil)]))
            dest.firstName = self.firstName;
            
        if (([self.lastName length] > 0) && (![self.lastName isEqualToString:NSLocalizedString(@"Name", nil)]))
            dest.lastName = self.lastName;
    }
}


/////////////////Delegates////////////////////////////

- (void) reloadTableRow
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndex, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
- (void) genderAgeValue:(NSString*) gender
{
    self.genderAgeValue = gender;
    self.userProfile.gender = self.genderAgeValue;
    [self.tableView reloadData];
}

- (void) saveFirstName:(NSString*) firstName lastName:(NSString*) lastName
{
    NSString *oldName = [[NSString alloc] initWithFormat:@"%@%@", self.firstName, self.lastName];
    NSString *newName = [[NSString alloc] initWithFormat:@"%@%@", firstName, lastName];
    self.userProfile.firstName = firstName;
    self.userProfile.lastName = lastName;
    
    self.firstName = firstName;
    self.lastName = lastName;
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self. managedObjectContext];
	[request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", oldName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults != nil)
    {
        NSArray *notesList = mutableFetchResults;
        Notes *userNotes = nil;
        for (int i=0; i < [notesList count]; i ++)
        {
            userNotes = [notesList objectAtIndex:i];
            userNotes.name = newName;
        }
		
	}
    
    
    [self.tableView reloadData];
    [self.delegate reloadProfile];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage *viewImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *viewImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissModalViewControllerAnimated:YES];
    viewImage = [self correctCapturedImageOrientation:viewImage];
    if ([self.userProfile.imagePath length] > 0)
    {
        [[NSFileManager defaultManager] removeItemAtPath:self.userProfile.imagePath error:nil];
        self.userProfile.imagePath = nil;
    }
    
    NSData *pngData = UIImagePNGRepresentation(viewImage);
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"/%u.png", self.userProfile.uniqueID.unsignedIntValue];
    filePath = [filePath stringByAppendingString:fileName];
    if(![pngData writeToFile:filePath atomically:YES])
        NSLog(@"Saving the image failed");
    else
        self.userProfile.imagePath = filePath;
    
    pngData = nil;
    viewImage = nil;
    picker = nil;
    [self.tableView reloadData];
    [self.delegate reloadProfile];
}

- (UIImage*)correctCapturedImageOrientation:(UIImage*)viewImage
{
    Boolean isNinetyDegree = NO;
    float rotRad = 0.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(viewImage.size.width, viewImage.size.height));
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    
    switch ([viewImage imageOrientation])
    {
        case UIImageOrientationLeft:
            rotRad = -M_PI_2;
            isNinetyDegree = YES;
            break;
            
        case UIImageOrientationRight:
            rotRad = M_PI_2;
            isNinetyDegree = YES;
            break;
            
        case UIImageOrientationDown:
            rotRad = M_PI;
            isNinetyDegree = NO;
            break;
            
        default:
            break;
    }
    
    CGContextTranslateCTM(graphicsContext, viewImage.size.width / KAShrinkDimension, viewImage.size.height / KAShrinkDimension);
    CGContextRotateCTM(graphicsContext, rotRad);
    CGContextScaleCTM(graphicsContext, 1.0, -1.0);
    float height = isNinetyDegree ? viewImage.size.width : viewImage.size.height;
    float width  = isNinetyDegree ? viewImage.size.height : viewImage.size.width;
    CGContextDrawImage(graphicsContext, CGRectMake(-width / KAShrinkDimension, -height / KAShrinkDimension, width, height), [viewImage CGImage]);
    
    if (isNinetyDegree)
        CGContextTranslateCTM(graphicsContext, -viewImage.size.height / KAShrinkDimension, -viewImage.size.width / KAShrinkDimension);
    
    UIImage* rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = nil;
    UIGraphicsEndImageContext();
    return rotatedImage;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (UIImageView*) getArrowAccessory
{
    if(self.arrowImage == nil)
        self.arrowImage = [UIImage imageNamed:@"arrow"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10.0, 20, 20)];
    imageView.image = self.arrowImage;
    return imageView;
    
}

@end
