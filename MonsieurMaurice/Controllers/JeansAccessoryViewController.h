//
//  JeansAccessoryViewController.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 09/09/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilePageViewController.h"

@interface JeansAccessoryViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, NSXMLParserDelegate>

@property (nonatomic) NSInteger pickerColumnNumber;
@property (nonatomic, retain) NSString* accessoryName;
@property (nonatomic, weak) id<ProfileAccessory> delegate;
@property (nonatomic, retain) Profile *userProfile;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UILabel *firstSliderText;
@property (weak, nonatomic) IBOutlet UILabel *firstSliderValue;
@property (weak, nonatomic) IBOutlet UIView *firstSliderParentView;
@property (weak, nonatomic) IBOutlet UISlider *firstSlider;
- (IBAction)firstSliderValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *SecondSliderText;
@property (weak, nonatomic) IBOutlet UILabel *secondSliderValue;
@property (weak, nonatomic) IBOutlet UIView *secondSliderParentView;
@property (weak, nonatomic) IBOutlet UISlider *secondSlider;
- (IBAction)secondSliderValueChanged:(id)sender;

@end
