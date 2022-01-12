//
//  CodViewController.h
//  testTables
//
//  Created by Sudip Pal on 31/07/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "ProfileListViewController.h"

@protocol ProfileAccessory

- (void) genderAgeValue:(NSString*) gender;
- (void) saveFirstName:(NSString*) firstName lastName:(NSString*) lastName;
- (void) reloadTableRow;

@end;

@interface ProfilePageViewController : UITableViewController <ProfileAccessory, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//@property (retain, nonatomic) IBOutlet UITableViewCell *genderAgeCell;

@property (nonatomic, retain) Profile *userProfile;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id<ProfileList> delegate;

@end
