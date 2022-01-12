//
//  CodGenderAgeControllerViewController.h
//  testTables
//
//  Created by Sudip Pal on 01/08/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilePageViewController.h"
#import "Profile.h"

@interface CodGenderAgeControllerViewController : UITableViewController <UITextViewDelegate>

@property(nonatomic, weak) id<ProfileAccessory> delegate;
@property(nonatomic, retain) NSString *genderAge;
@property (nonatomic, weak) Profile* userProfile;
@end
