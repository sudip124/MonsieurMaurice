//
//  JeansAccessoryViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 09/09/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "JeansAccessoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NotePadViewController.h"
#import <math.h>

@interface JeansAccessoryViewController ()
//@property (nonatomic, retain) NSMutableArray *column1;
//@property (nonatomic, retain) NSMutableArray *column2;
//@property (nonatomic, retain) NSMutableArray *column3;
@property (nonatomic, retain) NSMutableArray *slider1;
@property (nonatomic, retain) NSMutableArray *slider2;
@property (nonatomic, retain) NSString *systemUnit;
@property (nonatomic, retain) NSMutableArray *pickerColumn1;
@property (nonatomic, retain) NSMutableArray *pickerColumn2;
//@property (nonatomic, retain) NSMutableArray *pickerColumn3;

- (void)loadFromJSONfile:(NSString*)path firstRow:(BOOL)firstRow;
- (void) setFirstSliderTextValue:(float)val;
- (void) initializeUIValues;

@end

@implementation JeansAccessoryViewController

@synthesize picker                  =_picker;
@synthesize pickerColumnNumber      =_columnNumber;
@synthesize accessoryName           =_accessoryName;
@synthesize delegate                =_delegate;
@synthesize firstSliderText         =_measurementSystem;
@synthesize firstSliderValue        =_sliderValue;
@synthesize firstSliderParentView   =_sliderView;
@synthesize firstSlider             =_sliderControl;

//@synthesize column1=_column1;
//@synthesize column2=_column2;
//@synthesize column3=_column3;
@synthesize slider1=_slider1;
@synthesize systemUnit=_systemUnit;
@synthesize pickerColumn1=_pickerColumn1;
@synthesize pickerColumn2=_pickerColumn2;

- (void)viewDidLoad
{
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
    
    [self initializeUIValues];
    if(self.userProfile.jeansWaist != nil)
    {
        self.firstSlider.value = [self.userProfile.jeansWaist floatValue];
        self.secondSlider.value = [self.userProfile.jeansHeight floatValue];
        [self setFirstSliderTextValue:self.firstSlider.value];
        [self setSecondSliderTextValue:self.secondSlider.value];
    }
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
    [super viewDidUnload];
    // self.picker = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    //self.column3 = nil;
    //self.column1 = nil;
    //self.column2 = nil;
    self.slider1 = nil;
    self.pickerColumn1=nil;
    self.pickerColumn2=nil;
    ///self.pickerColumn3=nil;
}

- (void) setUpSliderValues:(NSString *)storedValue :(BOOL)isOne
{
    //NSString *temp = nil;
    NSInteger tempindex = 0;
    NSString *tempSliderText =nil;
    float val = 0;
    
    if(isOne)
    {
        if(storedValue != nil)
        {
            tempindex = [self.pickerColumn1 indexOfObject:storedValue];
            if(tempindex != NSNotFound)
                storedValue = (NSString *)[self.slider1 objectAtIndex:tempindex];
        }
        
        tempSliderText = [self.slider1 objectAtIndex:0];
        self.firstSlider.minimumValue = [tempSliderText floatValue];
        tempSliderText = [self.slider1 objectAtIndex:self.slider1.count - 1];
        self.firstSlider.maximumValue = [tempSliderText floatValue];
        val = [storedValue floatValue];
        if (val < self.firstSlider.minimumValue)
            self.firstSlider.value = self.firstSlider.minimumValue;
        else
            self.firstSlider.value = val;
        
        [self setFirstSliderTextValue:self.firstSlider.value];
        [self setPickerRowsFromSlider:tempindex sliderNumber:YES];
    }
    else
    {
        if(storedValue != nil)
        {
            tempindex = [self.pickerColumn2 indexOfObject:storedValue];
            if(tempindex != NSNotFound)
                storedValue = (NSString *)[self.slider2 objectAtIndex:tempindex];
        }

        tempSliderText = [self.slider2 objectAtIndex:0];
        self.secondSlider.minimumValue = [tempSliderText floatValue];
        tempSliderText = [self.slider2 objectAtIndex:self.slider2.count - 1];
        self.secondSlider.maximumValue = [tempSliderText floatValue];
        val = [storedValue floatValue];
        if (val < self.secondSlider.minimumValue)
            self.secondSlider.value = self.secondSlider.minimumValue;
        else
            self.secondSlider.value = val;
        
        [self setSecondSliderTextValue:self.secondSlider.value];
        [self setPickerRowsFromSlider:tempindex sliderNumber:NO];
    }
    
    
}

- (void) initializeUIValues
{
    self.slider1 = [[NSMutableArray alloc] init];
    self.slider2 = [[NSMutableArray alloc] init];
    self.pickerColumn1= [[NSMutableArray alloc] init];
    self.pickerColumn2= [[NSMutableArray alloc] init];
    
    if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Man", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Jeans", nil)])
        {
            [self loadFromJSONfile:@"manjeans1" firstRow:YES];
            [self loadFromJSONfile:@"manjeans2" firstRow:NO];
            
            NSArray *splitValues = [self.userProfile.jeans componentsSeparatedByString:@"/"];
            NSString *firstVal = [splitValues objectAtIndex:0];
            NSString *secondVal = [splitValues objectAtIndex:1];
            [self setUpSliderValues:firstVal :YES];
            [self setUpSliderValues:secondVal :NO];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
            self.SecondSliderText.text = NSLocalizedString(@"height", nil);
        }
        
    }
    else if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Woman", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Jeans", nil)])
        {
            [self loadFromJSONfile:@"womanjeans1" firstRow:YES];
            [self loadFromJSONfile:@"womanjeans2" firstRow:NO];
            
            NSArray *splitValues = [self.userProfile.jeans componentsSeparatedByString:@"/"];
            NSString *firstVal = [splitValues objectAtIndex:0];
            NSString *secondVal = [splitValues objectAtIndex:1];
            [self setUpSliderValues:firstVal :YES];
            [self setUpSliderValues:secondVal :NO];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
            self.SecondSliderText.text = NSLocalizedString(@"height", nil);
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
            
        default:
            retVal = self.pickerColumn2.count;
            break;
            
    }
    
    return retVal;
}

#pragma mark Picker Delegate Methods



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{    
    CGFloat componentWidth = 70;
    return componentWidth;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 35)];
    userName.font = [UIFont fontWithName:@"Verdana" size:15.0];
    NSString* val = nil;
    NSArray *colnVal= nil;
    switch (component) {
        case 0:
            colnVal = self.pickerColumn1;
            break;
            
        default:
            colnVal = self.pickerColumn2;
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
    NSString *setVal;
    
    switch (component) {
        case 0:
            setVal = (NSString*)[self.slider1 objectAtIndex:row];
            [self setFirstSliderTextValue:[setVal floatValue]];
            self.firstSlider.value = [setVal floatValue];
            break;
            
        default:
            setVal = (NSString*)[self.slider2 objectAtIndex:row];
            [self setSecondSliderTextValue:[setVal floatValue]];
            self.secondSlider.value = [setVal floatValue];
            break;
    }
}

- (void) setPickerRowsFromSlider:(NSInteger)sliderRowIndex sliderNumber:(BOOL)isOne
{
    if(isOne)
        [self.picker selectRow:sliderRowIndex inComponent:0 animated:YES];
    else
        [self.picker selectRow:sliderRowIndex inComponent:1 animated:YES];
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
        [self setPickerRowsFromSlider:sliderRowIndex sliderNumber:YES];
    
    [self setFirstSliderTextValue:sliderVal];
    
    setVal = nil;
    sliderRowIndex = nil;
}
- (IBAction)secondSliderValueChanged:(id)sender {
    float sliderVal = 0;
    NSString *setVal = nil;
    NSInteger sliderRowIndex = 0;
    
    sliderVal = self.secondSlider.value;
    setVal = [[NSString alloc] initWithFormat:@"%.0f",sliderVal];
    sliderRowIndex = [self.slider2 indexOfObject:setVal];
    if(sliderRowIndex != NSNotFound)
        [self setPickerRowsFromSlider:sliderRowIndex sliderNumber:NO];

    [self setSecondSliderTextValue:sliderVal];
    
    
    
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

- (void)loadFromJSONfile:(NSString*)path firstRow:(BOOL)firstRow
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *e = nil;
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    data = nil;
    e = nil;
    
    //NSString *col1 = nil;
    //NSString *col2 = nil;
    //NSString *col3 = nil;
    
    for (NSDictionary *values in JSON)
    {
        if (firstRow)
        {
            [self.slider1 addObject:[values objectForKey:@"slider1"]];
            [self.pickerColumn1 addObject:[values objectForKey:@"column1"]];
        }
        
        else
        {
            [self.slider2 addObject:[values objectForKey:@"slider1"]];
            [self.pickerColumn2 addObject:[values objectForKey:@"column1"]];
        }
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

- (void) setSecondSliderTextValue:(float)val     //Sudip
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
    {
        self.userProfile.systemUnit = self.systemUnit;
    }
    NSString *firstVal = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    firstVal = [firstVal stringByAppendingFormat:@"/"];
    NSString *secondVal = (NSString *) [self.pickerColumn2 objectAtIndex:[self.picker selectedRowInComponent:1]];
    self.userProfile.jeans = [firstVal stringByAppendingFormat:@"%@",secondVal];
    self.userProfile.jeansWaist = [[NSNumber alloc] initWithFloat:self.firstSlider.value];
    self.userProfile.jeansHeight = [[NSNumber alloc] initWithFloat:self.secondSlider.value];
    [self.delegate reloadTableRow];
    [self.navigationController popViewControllerAnimated: YES];
}

- (UIView *)getSelectionFlags
{
    UIImage *selectorImage = nil;
    UIView *customSelector = nil;
    NSString *devType = [AppDelegate getDeviceModelNumber];
    selectorImage = [UIImage imageNamed:@"wl"];
    customSelector = [[UIImageView alloc] initWithImage:selectorImage];
    if ([devType rangeOfString:@"iPhone5"].location != NSNotFound || [devType rangeOfString:@"iPhone6"].location != NSNotFound)
        customSelector.frame = CGRectMake(92, 315, 140, 40);
    else
        customSelector.frame = CGRectMake(92, 235, 140, 40);
    
    /*switch (self.pickerColumnNumber) {
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
    }*/
    customSelector.alpha = .3f;
    return customSelector;
}


@end
