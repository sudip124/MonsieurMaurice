//
//  ProfileNameViewController.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 19/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilePageViewController.h"

@interface NameForProfileViewController : UIViewController
@property(nonatomic, weak) id<ProfileAccessory> delegate;

@property (nonatomic, strong)NSString *firstName;
@property (nonatomic, strong)NSString *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextBox;
- (IBAction)firstNameKeyboardNext:(id)sender;

-(IBAction) saveButtonClicked: (id)sender;
@end
