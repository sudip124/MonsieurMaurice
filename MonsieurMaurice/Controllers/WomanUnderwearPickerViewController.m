//
//  CustomPickerViewController.m
//  testTables
//
//  Created by Sudip Pal on 02/08/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import "WomanUnderwearPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NotePadViewController.h"
#import <math.h>

@interface WomanUnderwearPickerViewController()
{
    //UISegmentedControl *segmentedControl;
}

//@property (nonatomic, retain) NSMutableArray *slider1;
@property (nonatomic, retain) NSString *systemUnit;
@property (nonatomic, retain) NSMutableArray *pickerColumn1;
@property (nonatomic, retain) NSMutableArray *pickerColumn2;
@property (nonatomic, retain) NSMutableArray *pickerColumn3;
@property (nonatomic, retain) NSArray *cupSize;

- (void) setFirstSliderTextValue:(float)val;
- (void) initializeUIValues;
@end


@implementation WomanUnderwearPickerViewController

@synthesize picker                  =_picker;
@synthesize pickerColumnNumber      =_columnNumber;
@synthesize accessoryName           =_accessoryName;
@synthesize delegate                =_delegate;
@synthesize firstSliderText         =_measurementSystem;
@synthesize firstSliderValue        =_sliderValue;
@synthesize firstSliderParentView   =_sliderView;
@synthesize firstSlider             =_sliderControl;

//@synthesize slider1=_slider1;
@synthesize systemUnit=_systemUnit;
@synthesize pickerColumn1=_pickerColumn1;
@synthesize pickerColumn2=_pickerColumn2;
@synthesize pickerColumn3=_pickerColumn3;
@synthesize cupSize=_cupSize;

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
    [self setSecondSliderText:nil];
    [self setSecondSliderValue:nil];
    [self setSecondSliderParentView:nil];
    [self setSecondSlider:nil];
    [super viewDidUnload];
    self.picker = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    //self.slider1 = nil;
    self.pickerColumn1=nil;
    self.pickerColumn2=nil;
    self.pickerColumn3=nil;
}

- (void) setUpSliders:(NSString *)storedValue
{
    self.firstSlider.minimumValue = 60;
    self.firstSlider.maximumValue = 115;
    NSInteger temp = [storedValue floatValue] - 28;
    temp = temp/2;
    float firstVal = 60 + (temp * 5);
    
    if (firstVal < self.firstSlider.minimumValue)
        self.firstSlider.value = self.firstSlider.minimumValue;
    else
        self.firstSlider.value = firstVal;
    [self setFirstSliderTextValue:self.firstSlider.value];
    
    self.secondSlider.minimumValue = 65;
    self.secondSlider.maximumValue = 143;
    self.secondSlider.value = 65;
    [self setSecondSliderTextValue:65];
    NSCharacterSet *alphaSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    NSString *cupString = [storedValue stringByTrimmingCharactersInSet:alphaSet];
    NSInteger cupIndex= [self.cupSize indexOfObject:cupString];
    NSInteger cupNumber = 0;
    
    if(cupIndex != NSNotFound)
    {
        cupNumber = 12 + ((cupIndex + 1) * 2);
        self.secondSlider.value = (firstVal + cupNumber);
        [self setSecondSliderTextValue:(firstVal + cupNumber)];
    }
    
    self.firstSliderText.text = NSLocalizedString(@"breast", nil);
    self.SecondSliderText.text = NSLocalizedString(@"bust", nil);
}

- (void) initializeUIValues
{
    self.pickerColumn1 = [[NSMutableArray alloc] init];
    self.pickerColumn2 = [[NSMutableArray alloc] init];
    self.pickerColumn3 = [[NSMutableArray alloc] init];
    self.cupSize = [[NSArray alloc] initWithObjects:@"AA", @"A", @"B", @"C", @"D", @"DD", @"E", @"F", nil];
    
    NSString *temp = nil;
    for (int i = 28; i < 50; i = i + 2)
    {
        for (int j = 0; j < [self.cupSize count]; j++)
        {
            temp = [[NSString alloc] initWithFormat:@"%d%@", i, [self.cupSize objectAtIndex:j]];
            [self.pickerColumn1 addObject:temp];
            [self.pickerColumn2 addObject:temp];
        }
    }
    
    /*for (int i = 28; i < 50; i = i + 2)
    {
        for (int j = 0; j < [self.cupSize count]; j++)
        {
            temp = [[NSString alloc] initWithFormat:@"%d%@", i, [self.cupSize objectAtIndex:j]];
            [self.pickerColumn2 addObject:temp];
        }
    }*/
    
    for (int i = 60; i < 115; i = i + 5)
    {
        for (int j = 0; j < [self.cupSize count]; j++)
        {
            temp = [[NSString alloc] initWithFormat:@"%d%@", i, [self.cupSize objectAtIndex:j]];
            [self.pickerColumn3 addObject:temp];
        }
    }
    
    [self setUpSliders:self.userProfile.shirts];
    [self setPickerRowsFromSlider:self.userProfile.shirts];
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
    for (int i=0; i < self.pickerColumnNumber; i++)
    {
        if(i != component)
        {
            [self.picker selectRow:row inComponent:i animated:YES];
            [self.picker reloadComponent:i];
        }
    }
    [self setUpSliders:[self.pickerColumn1 objectAtIndex:row]];
}

- (void) setPickerRowsFromSlider:(NSString *)pickerValue
{
    NSInteger sliderRowIndex = [self.pickerColumn1 indexOfObject:pickerValue];
    if(sliderRowIndex == NSNotFound)
    {
        NSLog(@"No picker value for %@ in function: setPickerRowsFromSlider",pickerValue);
        return;
    }
    for (int i = 0; i < self.pickerColumnNumber; i++)
        [self.picker selectRow:sliderRowIndex inComponent:i animated:YES];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    CGFloat componentWidth = 70;
    return componentWidth;
}

- (IBAction)firstSliderValueChanged:(id)sender
{
    float sliderVal = self.firstSlider.value;
    NSCharacterSet *alphaSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    NSString *storedValue = [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    NSString *cupString = [storedValue stringByTrimmingCharactersInSet:alphaSet];
    
    int temp = (sliderVal - 60)/5;
    temp = 28 + temp * 2;
    NSString *tempObj =  [[NSString alloc] initWithFormat:@"%d%@", temp, cupString];
    NSInteger tempIndex = [self.pickerColumn1 indexOfObject:tempObj];
    if(tempIndex!= NSNotFound)
    {
        for (int i =0; i < self.pickerColumnNumber; i ++)
        {
            [self.picker selectRow:tempIndex inComponent:i animated:YES];
        }
    }
    [self setFirstSliderTextValue:sliderVal];
}

- (IBAction)secondSliderValueChanged:(id)sender
{
    float sliderVal = self.secondSlider.value;
    [self setSecondSliderTextValue:sliderVal];
    
    NSString *storedValue = [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    int breastPicker1 = [storedValue intValue];
    
    NSString *newCupSize = nil;
    NSString *newCupPicker = nil;
    NSInteger sliderDiff = self.secondSlider.value - self.firstSlider.value;
    if(sliderDiff < 12)
    {
        //Bust less than breast so no changes
        newCupSize = (NSString*)[self.cupSize objectAtIndex:0];
        
        newCupPicker = [[NSString alloc] initWithFormat:@"%d%@",breastPicker1,newCupSize];
        [self setPickerRowsFromSlider:newCupPicker];
    }
    else if (sliderDiff > 26)
    {
        newCupSize = (NSString*)[self.cupSize objectAtIndex:([self.cupSize count] -1)];

        newCupPicker = [[NSString alloc] initWithFormat:@"%d%@",breastPicker1,newCupSize];
        [self setPickerRowsFromSlider:newCupPicker];
    }
    else
    {
        NSInteger *setNewIndex = (sliderDiff - 12)/2;
        newCupSize = (NSString*)[self.cupSize objectAtIndex:setNewIndex];
        newCupPicker = [[NSString alloc] initWithFormat:@"%d%@",breastPicker1,newCupSize];
        [self setPickerRowsFromSlider:newCupPicker];
    }
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

    if([self.accessoryName isEqualToString:NSLocalizedString(@"Shirts", nil)])
    {
        self.userProfile.shirts = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    [self.delegate reloadTableRow];
    [self.navigationController popViewControllerAnimated: YES];
}


- (UIView *)getSelectionFlags
{
    UIImage *selectorImage = nil;
    UIView *customSelector = nil;
    NSString *devType = [AppDelegate getDeviceModelNumber];
    switch (self.pickerColumnNumber) {
        case 1:
            selectorImage = [UIImage imageNamed:@"us"];
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            if ([devType rangeOfString:@"iPhone5"].location != NSNotFound || [devType rangeOfString:@"iPhone6"].location != NSNotFound )
                customSelector.frame = CGRectMake(125, 300, 72, 40);
            else
                customSelector.frame = CGRectMake(125, 220, 72, 40);
            
            break;
        case 2:
            selectorImage = [UIImage imageNamed:@"usue"];
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            if ([devType rangeOfString:@"iPhone5"].location != NSNotFound || [devType rangeOfString:@"iPhone6"].location != NSNotFound)
                customSelector.frame = CGRectMake(88, 300, 140, 40);
            else
                customSelector.frame = CGRectMake(88, 220, 140, 40);
            break;
        default:
            selectorImage = [UIImage imageNamed:@"usukue"];
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            if ([devType rangeOfString:@"iPhone5"].location != NSNotFound || [devType rangeOfString:@"iPhone6"].location != NSNotFound)
                customSelector.frame = CGRectMake(55, 300, 211, 40);
            else
                customSelector.frame = CGRectMake(55, 220, 211, 40);
            break;
    }
    customSelector.alpha = .3f;
    return customSelector;
}

@end
