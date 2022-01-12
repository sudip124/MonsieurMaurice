//
//  CustomPickerViewController.m
//  testTables
//
//  Created by Sudip Pal on 02/08/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import "WomenOuterWearVewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NotePadViewController.h"
#import <math.h>

@interface WomenOuterWearVewController()
{
    //UISegmentedControl *segmentedControl;
}

@property (nonatomic, retain) NSMutableArray *column1;
@property (nonatomic, retain) NSMutableArray *column2;
@property (nonatomic, retain) NSMutableArray *column3;
@property (nonatomic, retain) NSMutableArray *slider1;
@property (nonatomic, retain) NSMutableArray *slider2;
@property (nonatomic, retain) NSString *systemUnit;
@property (nonatomic, retain) NSMutableArray *pickerColumn1;
@property (nonatomic, retain) NSMutableArray *pickerColumn2;
@property (nonatomic, retain) NSMutableArray *pickerColumn3;

- (void)loadFromJSONfile:(NSString*)path;
- (void) setFirstSliderTextValue:(float)val;
- (void) initializeUIValues;
@end


@implementation WomenOuterWearVewController

@synthesize picker                  =_picker;
@synthesize pickerColumnNumber      =_columnNumber;
@synthesize accessoryName           =_accessoryName;
@synthesize delegate                =_delegate;
@synthesize firstSliderText         =_measurementSystem;
@synthesize firstSliderValue        =_sliderValue;
@synthesize firstSliderParentView   =_sliderView;
@synthesize firstSlider             =_sliderControl;

@synthesize column1=_column1;
@synthesize column2=_column2;
@synthesize column3=_column3;
@synthesize slider1=_slider1;
@synthesize slider2=_slider2;
@synthesize systemUnit=_systemUnit;
@synthesize pickerColumn1=_pickerColumn1;
@synthesize pickerColumn2=_pickerColumn2;
@synthesize pickerColumn3=_pickerColumn3;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    self.firstSliderParentView.layer.cornerRadius = 5;
    self.firstSliderParentView.layer.masksToBounds = YES;
    self.firstSliderParentView.backgroundColor = [AppDelegate tableViewRowColor];
    
    self.secondSliderParentView.layer.cornerRadius = 5;
    self.secondSliderParentView.layer.masksToBounds = YES;
    self.secondSliderParentView.backgroundColor = [AppDelegate tableViewRowColor];
    
    self.firstSliderText.font = [UIFont fontWithName:@"Verdana" size:11.0];
    self.firstSliderValue.font = [UIFont fontWithName:@"Verdana" size:11.0];
    self.SecondSliderText.font = [UIFont fontWithName:@"Verdana" size:11.0];
    self.secondSliderValue.font = [UIFont fontWithName:@"Verdana" size:11.0];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked:)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
    UIBarButtonItem *centerBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *buttons = [NSArray arrayWithObjects:leftBarButton,flexible,centerBarButton,flexible,rightBarButton,nil];
    
    self.navigationItem.leftBarButtonItems = buttons;
    
    
    [self.view addSubview:[self getSelectionFlags]];
    self.systemUnit = self.userProfile.systemUnit;
    
    [self initializeUIValues]; //KEEP ALL changes after this 
    
    
    
}

-(void)cancelButtonClicked: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    //[self setPickerSelectorView:nil];
    [self setSecondSliderText:nil];
    [self setSecondSliderValue:nil];
    [self setSecondSliderParentView:nil];
    [self setSecondSlider:nil];
    [super viewDidUnload];
   // self.picker = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.column3 = nil;
    self.column1 = nil;
    self.column2 = nil;
    self.slider1 = nil;
    self.pickerColumn1=nil;
    self.pickerColumn2=nil;
    self.pickerColumn3=nil;
}

- (void) setUpFirstSlider:(NSString *)storedValue
{
    if(storedValue == nil)
        storedValue = [self.slider1 objectAtIndex:0];

    self.firstSlider.minimumValue = [[self.slider1 objectAtIndex:0] floatValue];
    self.firstSlider.maximumValue = [[self.slider1 objectAtIndex:self.slider1.count - 1] floatValue];
    self.firstSlider.value = [storedValue floatValue];
    
    [self setFirstSliderTextValue:self.firstSlider.value];
}

- (void) setUpSecondSlider:(NSString *)storedValue
{
    if(storedValue == nil)
        storedValue = [self.slider2 objectAtIndex:0];

    self.secondSlider.minimumValue = [[self.slider2 objectAtIndex:0] floatValue];
    self.secondSlider.maximumValue = [[self.slider2 objectAtIndex:self.slider2.count - 1] floatValue];
    self.secondSlider.value = [storedValue floatValue];
    
    [self setSecondSliderTextValue:self.secondSlider.value];
}

- (void) initializeUIValues
{
    self.slider1 = [[NSMutableArray alloc] init];
    self.slider2 = [[NSMutableArray alloc] init];
    self.column1 = [[NSMutableArray alloc] init];
    self.pickerColumn1= [[NSMutableArray alloc] init];
    self.column2 = [[NSMutableArray alloc] init];
    self.pickerColumn2= [[NSMutableArray alloc] init];
    self.column3 = [[NSMutableArray alloc] init];
    self.pickerColumn3= [[NSMutableArray alloc] init];
    
    [self loadFromJSONfile:@"womanouterwear"];
    self.firstSliderText.text = NSLocalizedString(@"bust", nil);
    self.SecondSliderText.text = NSLocalizedString(@"waist", nil);
    [self setUpFirstSlider:self.userProfile.outerwearBust];
    [self setUpSecondSlider:self.userProfile.outerwearWaist];
    NSString *tempPickerValue = self.userProfile.suit;
    if(tempPickerValue != nil)
    {
        NSInteger tempIndex = [self.column1 indexOfObject:tempPickerValue];
        if(tempIndex != NSNotFound)
        {
            [self setPickerRowsFromSlider:tempIndex];
            //[self.picker selectRow:tempIndex inComponent:0 animated:YES];
            //[self.picker selectRow:tempIndex inComponent:1 animated:YES];
            //[self.picker selectRow:tempIndex inComponent:2 animated:YES];
        }
    }

}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.pickerColumnNumber;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger retVal = 0;
    switch (component) {
        case 0:
            retVal = self.pickerColumn1.count;
            break;
            
        case 1:
            retVal = self.pickerColumn2.count;
            break;
            
        default:
            retVal = self.pickerColumn3.count;
            break;
            
    }
    
    return retVal;
}

#pragma mark Picker Delegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //pickerView.backgroundColor = [UIColor redColor];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 35)];
    userName.font = [UIFont fontWithName:@"Verdana" size:15.0];
    NSString* val = nil;
    NSArray *colnVal= nil;
    switch (component) {
        case 0:
            colnVal = self.pickerColumn1;
            break;
            
        case 1:
            colnVal = self.pickerColumn2;
            break;
            
        default:
            colnVal = self.pickerColumn3;
            break;
    }
    
    val = (NSString*) [colnVal objectAtIndex:row];
    [userName setText:val];
    [userName setTextAlignment:NSTextAlignmentCenter];
    userName.backgroundColor = [UIColor clearColor];
    return userName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *temp = nil;
    NSInteger tempIndex = 0;
    NSString *newValueForRow = nil;
    NSInteger newIndex = 0;
    switch (component) {
        case 0:
            temp = (NSString*)[self.pickerColumn1 objectAtIndex:row];
            tempIndex = [self.column1 indexOfObject:temp];
            temp = nil;
            break;
            
        case 1:
            temp = (NSString*)[self.pickerColumn2 objectAtIndex:row];
            tempIndex = [self.column2 indexOfObject:temp];
            temp = nil;
            break;
            
        default:
            temp = (NSString*)[self.pickerColumn3 objectAtIndex:row];
            tempIndex = [self.column3 indexOfObject:temp];
            temp = nil;
            break;
    }
    for (int i=0; i < self.pickerColumnNumber; i++)
    {
        if(i != component)
        {
            
            switch (i) {
                case 0:
                    newValueForRow = (NSString*) [self.column1 objectAtIndex:tempIndex];
                    newIndex = [self.pickerColumn1 indexOfObject:newValueForRow];
                    break;
                    
                case 1:
                    newValueForRow = (NSString*) [self.column2 objectAtIndex:tempIndex];
                    newIndex = [self.pickerColumn2 indexOfObject:newValueForRow];
                    break;
                    
                default:
                    newValueForRow = (NSString*) [self.column3 objectAtIndex:tempIndex];
                    newIndex = [self.pickerColumn3 indexOfObject:newValueForRow];
                    break;
            }
            [self.picker selectRow:newIndex inComponent:i animated:YES];
            [self.picker reloadComponent:i];
        }
    }
    NSString *setVal = (NSString *) [self.slider1 objectAtIndex:tempIndex];
    if(self.firstSlider.value < [setVal floatValue])
    {
        [self setFirstSliderTextValue:[setVal floatValue]];
        self.firstSlider.value = [setVal floatValue];
    }
    
    setVal = nil;
    
    setVal = (NSString *) [self.slider2 objectAtIndex:tempIndex];
    if(self.secondSlider.value < [setVal floatValue])
    {
        [self setSecondSliderTextValue:[setVal floatValue]];
        self.secondSlider.value = [setVal floatValue];
    }
    
    setVal = nil;
}

- (void) setPickerRowsFromSlider:(NSInteger)sliderRowIndex
{
    NSString *newValueForRow = (NSString*) [self.column1 objectAtIndex:sliderRowIndex];
    NSInteger newIndex = [self.pickerColumn1 indexOfObject:newValueForRow];
    [self.picker selectRow:newIndex inComponent:0 animated:YES];
    
    if(self.pickerColumnNumber > 1)
    {
        newValueForRow = (NSString*) [self.column2 objectAtIndex:sliderRowIndex];
        newIndex = [self.pickerColumn2 indexOfObject:newValueForRow];
        [self.picker selectRow:newIndex inComponent:1 animated:YES];
    }
    if(self.pickerColumnNumber > 2)
    {
        newValueForRow = (NSString*) [self.column3 objectAtIndex:sliderRowIndex];
        newIndex = [self.pickerColumn3 indexOfObject:newValueForRow];
        [self.picker selectRow:newIndex inComponent:2 animated:YES];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    CGFloat componentWidth = 70;
    return componentWidth;
}

- (IBAction)firstSliderValueChanged:(id)sender
{
    float sliderVal = 0;
    NSString *setVal = nil;
    NSInteger sliderRowIndex = 0;
    
    sliderVal = self.firstSlider.value;
    setVal = [[NSString alloc] initWithFormat:@"%.0f",sliderVal];
    sliderRowIndex = [self.slider1 indexOfObject:setVal];
    if(sliderRowIndex != NSNotFound)
    {
        [self setFirstSliderTextValue:sliderVal];
        [self setPickerRowsFromSlider:sliderRowIndex];
    }
    else
        NSLog(@"sliderRowIndex:%d  setVal:%@",sliderRowIndex,setVal);
    
    
    
    setVal = nil;
    sliderRowIndex = nil;
}

- (IBAction)secondSliderValueChanged:(id)sender
{
    float sliderVal = 0;
    NSString *setVal = nil;
    NSInteger sliderRowIndex = 0;
    
    sliderVal = self.secondSlider.value;
    setVal = [[NSString alloc] initWithFormat:@"%.0f",sliderVal];
    sliderRowIndex = [self.slider2 indexOfObject:setVal];
    if(sliderRowIndex != NSNotFound)
    {
        [self setSecondSliderTextValue:sliderVal];
        [self setPickerRowsFromSlider:sliderRowIndex];
    }
    else
        NSLog(@"sliderRowIndex:%d  setVal:%@",sliderRowIndex,setVal);
    
    
    
    setVal = nil;
    sliderRowIndex = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setToolbarItems:self.toolbarItems];
    NotePadViewController *dest = (NotePadViewController*)[segue destinationViewController];
    dest.accessoryName = self.accessoryName;
    dest.managedObjectContext = self.managedObjectContext;
    dest.name = [[NSString alloc] initWithFormat:@"%@%@",self.userProfile.firstName, self.userProfile.lastName];
}

-(void)actionButtonClicked: (id)sender
{
    NSString *actionSheetTitle = nil; //Action Sheet Title
    NSString *other1 = NSLocalizedString(@"CmMeasure", nil);
    NSString *other2 = NSLocalizedString(@"InchMeasure", nil);
    NSString *other3 = NSLocalizedString(@"Note", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3, nil];
    actionSheet.actionSheetStyle = UIActivityIndicatorViewStyleGray;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if(![self.systemUnit isEqualToString: NSLocalizedString(@"cm", nil)])
            {
                self.systemUnit = NSLocalizedString(@"cm", nil);
                [self setFirstSliderTextValue:self.firstSlider.value];
                [self setSecondSliderTextValue:self.secondSlider.value];
            }
            break;
            
        case 1:
            if(![self.systemUnit isEqualToString:NSLocalizedString(@"inch", nil)])
            {
                self.systemUnit = NSLocalizedString(@"inch", nil);
                
                [self setFirstSliderTextValue:self.firstSlider.value];
                [self setSecondSliderTextValue:self.secondSlider.value];
            }
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"notes" sender:self];
            break;
            
        default:
            break;
    }
}

- (void)loadFromJSONfile:(NSString*)path
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *e = nil;
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    data = nil;
    e = nil;
    
    NSString *col1 = nil;
    NSString *col2 = nil;
    NSString *col3 = nil;
    
    for (NSDictionary *values in JSON)
        
        
    {
        [self.slider1 addObject:[values objectForKey:@"slider1"]];
        [self.slider2 addObject:[values objectForKey:@"slider2"]];
        col1 = [values objectForKey:@"column1"];
        [self.column1 addObject:col1];
        if([[self.pickerColumn1 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", col1]] count] < 1)
        {
            [self.pickerColumn1 addObject:col1];
            
        }
         if(self.pickerColumnNumber > 1)
         {
             col2 = [values objectForKey:@"column2"];
             [self.column2 addObject:col2];
             if([[self.pickerColumn2 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", col2]] count] < 1)
             {
                 [self.pickerColumn2 addObject:col2];
             }
         }
        
        if(self.pickerColumnNumber > 2)
        {
            col3 = [values objectForKey:@"column3"];
            [self.column3 addObject:col3];
            if([[self.pickerColumn3 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", col3]] count] < 1)
            {
                [self.pickerColumn3 addObject:col3];
            }
        }
        
        col1 = nil;
        col2 = nil;
        col3 = nil;
    }
} 

- (void) setFirstSliderTextValue:(float)val
{
    NSString *showSystem = nil;
    if([self.systemUnit isEqualToString: NSLocalizedString(@"cm", nil)])
        showSystem = @"cm";
    else
    {
        showSystem = @"in";
        val = val * 0.393701;
    }
    self.firstSliderValue.text = [[NSString alloc] initWithFormat:@"%.0f %@", val, showSystem];
}

- (void) setSecondSliderTextValue:(float)val
{
    NSString *showSystem = nil;
    if([self.systemUnit isEqualToString: NSLocalizedString(@"cm", nil)])
        showSystem = @"cm";
    else
    {
        showSystem = @"in";
        val = val * 0.393701;
    }
    self.secondSliderValue.text = [[NSString alloc] initWithFormat:@"%.0f %@", val, showSystem];
}

-(void)saveButtonClicked: (id)sender
{
    if(![self.systemUnit isEqualToString:self.userProfile.systemUnit])
        self.userProfile.systemUnit = self.systemUnit;

    self.userProfile.suit =  (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    self.userProfile.outerwearBust = [[NSString alloc] initWithFormat:@"%.0f",self.firstSlider.value];
    self.userProfile.outerwearWaist = [[NSString alloc] initWithFormat:@"%.0f",self.secondSlider.value];
    [self.delegate reloadTableRow];
    [self.navigationController popViewControllerAnimated: YES];
}
- (UIView *)getSelectionFlags
{
    UIImage *selectorImage = nil;
    UIView *customSelector = nil;
    
    switch (self.pickerColumnNumber) {
        case 1:
            selectorImage = [UIImage imageNamed:@"us"];
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            customSelector.frame = CGRectMake(125, 220, 72, 40);
            
            break;
        case 2:
            selectorImage = [UIImage imageNamed:@"usue"];
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            customSelector.frame = CGRectMake(88, 220, 140, 40);
            break;
        default:
            selectorImage = [UIImage imageNamed:@"usukue"];
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            customSelector.frame = CGRectMake(55, 220, 211, 40);
            break;
    }
    customSelector.alpha = .3f;
    return customSelector;
}

@end
