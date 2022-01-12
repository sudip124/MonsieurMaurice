//
//  MasterViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "ProfileListViewController.h"
#import "AppDelegate.h"
#import "NameForProfileViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ProfileListViewController ()
{
    BOOL shouldReload;
    NSInteger tableRow;
}


@property (nonatomic, retain) NSMutableArray *profileList;
@property (nonatomic, strong) UIImage *arrowImage;

@end

@implementation ProfileListViewController

@synthesize profileList=_profileList;
@synthesize arrowImage=_checkImage;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    shouldReload = NO;
    tableRow = -1;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.separatorColor = [AppDelegate tableViewBorderColor];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"Fetching from DB failed");
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"DBSaveError", nil)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setProfileList:mutableFetchResults];
    if(shouldReload)
    {
       [self.tableView reloadData];
        shouldReload = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertNewObject:(id)sender
{
    [self performSegueWithIdentifier:@"profileView" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    Profile *profile = (Profile *)[self.profileList objectAtIndex:indexPath.row];
    
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:100];
    UIImage *image = nil;
    if([profile.imagePath length] > 0)
    {
        NSURL *fileURL = [NSURL fileURLWithPath:profile.imagePath];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:fileURL];
        image = [[UIImage alloc] initWithData:imgData];
    }
    else
        image = [UIImage imageNamed:@"face"];
    
    imageView.image = image;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.clipsToBounds =YES;
    
    UILabel *firstNameLabel = (UILabel*)[cell viewWithTag:101];
    if(firstNameLabel != nil)
    {
        [firstNameLabel removeFromSuperview];
        firstNameLabel = nil;
    }
    
    firstNameLabel = [[UILabel alloc] init];
    [firstNameLabel setFrame:CGRectMake(80, 15, 100, 35)];
    [firstNameLabel setTag:101];
    firstNameLabel.clipsToBounds = YES;
    firstNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [firstNameLabel setText:profile.firstName];
    [firstNameLabel setTextColor:[UIColor whiteColor]];
    [firstNameLabel setBackgroundColor:[UIColor clearColor]];
    firstNameLabel.font = [UIFont fontWithName:@"Verdana" size:17.0];
    //firstNameLabel.userInteractionEnabled = YES;
    
    //adjust the label the the new height.
    CGSize firstNameMaxLabelSize = CGSizeMake(100,35);
    CGSize firstNameExptSize = [firstNameLabel.text sizeWithFont:firstNameLabel.font constrainedToSize:firstNameMaxLabelSize lineBreakMode:firstNameLabel.lineBreakMode];
    CGRect firstNameNewFrame = firstNameLabel.frame;
    firstNameNewFrame.size.height = firstNameExptSize.height;
    firstNameNewFrame.size.width = firstNameExptSize.width;
    firstNameLabel.frame = firstNameNewFrame;
    [cell addSubview:firstNameLabel];
    
    UILabel *lastNameLabel = (UILabel*)[cell viewWithTag:102];
    if(lastNameLabel != nil)
    {
        [lastNameLabel removeFromSuperview];
        lastNameLabel = nil;
    }
    
    lastNameLabel = [[UILabel alloc] init];
    [lastNameLabel setFrame:CGRectMake(80 + firstNameLabel.frame.size.width + 6, 15, 130, 35)];
    lastNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    [lastNameLabel setTag:102];
    [lastNameLabel setText:profile.lastName];
    lastNameLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:17.0];
    [lastNameLabel setTextColor:[UIColor whiteColor]];
    [lastNameLabel setBackgroundColor:[UIColor clearColor]];
    //lastNameLabel.userInteractionEnabled = YES;
    CGSize lastNameMaxLabelSize = CGSizeMake(110,35);
    CGSize lastNameExptSize = [lastNameLabel.text sizeWithFont:lastNameLabel.font constrainedToSize:lastNameMaxLabelSize lineBreakMode:lastNameLabel.lineBreakMode];
    CGRect lastNameNewFrame = lastNameLabel.frame;
    lastNameNewFrame.size.height = lastNameExptSize.height;
    lastNameNewFrame.size.width = lastNameExptSize.width;
    lastNameLabel.frame = lastNameNewFrame;
    [cell addSubview:lastNameLabel];
    
    
    
    cell.selectedBackgroundView.backgroundColor = [AppDelegate tableViewSelectionColor];
    cell.accessoryView = [self getArrowAccessory];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableRow = indexPath.row;
    [self performSegueWithIdentifier:@"profileView" sender:self];
    
}

/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
		NSManagedObject *eventToDelete = [self.profileList objectAtIndex:indexPath.row];
		[self.managedObjectContext deleteObject:eventToDelete];
		
		// Update the array and table view.
        [self.profileList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// Commit the change.
		NSError *error;
		if (![self.managedObjectContext save:&error]) {
			// Handle the error.
		}
    }
}
/*- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}*/

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
}

/*- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"profileView"])
    {
        ProfilePageViewController *dest = (ProfilePageViewController*)[segue destinationViewController];
        dest.managedObjectContext = self.managedObjectContext;
        dest.toolbarItems = self.toolbarItems;
        Profile *event = nil;
        if(tableRow == -1)
        {
            event = (Profile *)[NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:self.managedObjectContext];
            event.gender = NSLocalizedString(@"Man", nil);
            event.systemUnit = NSLocalizedString(@"cm", nil);
            event.uniqueID = [[NSNumber alloc] initWithInt:arc4random()];
            //event.profileLang = [AppDelegate getLocale];
            event.profileLang = @"en_fr";
        }
        else
            event = self.profileList[tableRow];
        
        tableRow = -1;
        dest.userProfile = event;
        dest.delegate = self;
    }
}

- (UIImageView*) getArrowAccessory
{
    if(self.arrowImage == nil)
        self.arrowImage = [UIImage imageNamed:@"arrow-light"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10.0, 20, 20)];
    imageView.image = self.arrowImage;
    return imageView;
    
}

- (void) reloadProfile
{
    //[self.tableView reloadData];
    shouldReload = YES;
}

@end
