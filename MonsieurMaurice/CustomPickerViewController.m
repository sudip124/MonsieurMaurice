//
//  CustomPickerViewController.m
//  testTables
//
//  Created by Sudip Pal on 02/08/13.
//  Copyright (c) 2013 Codez. All rights reserved.
//

#import "CustomPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NotePadViewController.h"
#import <math.h>

@interface CustomPickerViewController()
{
    //UISegmentedControl *segmentedControl;
}

@property (nonatomic, retain) NSMutableArray *column1;
@property (nonatomic, retain) NSMutableArray *column2;
@property (nonatomic, retain) NSMutableArray *column3;
@property (nonatomic, retain) NSMutableArray *slider1;
@property (nonatomic, retain) NSString *systemUnit;
@property (nonatomic, retain) NSMutableArray *pickerColumn1;
@property (nonatomic, retain) NSMutableArray *pickerColumn2;
@property (nonatomic, retain) NSMutableArray *pickerColumn3;

- (void)loadFromJSONfile:(NSString*)path;
- (void) setFirstSliderTextValue:(float)val;
- (void) initializeUIValues;
@end


@implementation CustomPickerViewController

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
    
    self.firstSliderText.font = [UIFont fontWithName:@"Verdana" size:11.0];
    self.firstSliderValue.font = [UIFont fontWithName:@"Verdana" size:11.0];
    //self.SecondSliderText.font = [UIFont fontWithName:@"Verdana" size:11.0];
    //self.secondSliderValue.font = [UIFont fontWithName:@"Verdana" size:11.0];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked:)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
    UIBarButtonItem *centerBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *buttons = [NSArray arrayWithObjects:leftBarButton,flexible,centerBarButton,flexible,rightBarButton,nil];
    
    self.navigationItem.leftBarButtonItems = buttons;
    
    /*if(![self.accessoryName isEqualToString:NSLocalizedString(@"Gloves", nil)] && ![self.accessoryName isEqualToString:NSLocalizedString(@"Belts", nil)])
    {
        [self.view addSubview:[self getSelectionFlags]];
    }*/
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
    //[self setSecondSliderText:nil];
    //[self setSecondSliderValue:nil];
    //[self setSecondSliderParentView:nil];
    //[self setSecondSlider:nil];
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
    //NSString *temp = nil;
    NSInteger tempindex = 0;
    if(storedValue != nil)
    {
        tempindex = [self.column1 indexOfObject:storedValue];
        if(tempindex != NSNotFound)
        {
            storedValue = (NSString *)[self.slider1 objectAtIndex:tempindex];
        }
        
    }
    
    
    NSString *tempSliderText = [self.slider1 objectAtIndex:0];
    self.firstSlider.minimumValue = [tempSliderText floatValue];
    tempSliderText = [self.slider1 objectAtIndex:self.slider1.count - 1];
    self.firstSlider.maximumValue = [tempSliderText floatValue];
    float val = [storedValue floatValue];
    if (val < self.firstSlider.minimumValue)
        self.firstSlider.value = self.firstSlider.minimumValue;
    else
        //self.firstSlider.value = [self.userProfile.footWear floatValue];
        self.firstSlider.value = val;
    
    [self setFirstSliderTextValue:self.firstSlider.value];
    
    [self setPickerRowsFromSlider:tempindex];
}

- (void) initializeUIValues
{
    self.slider1 = [[NSMutableArray alloc] init];
    self.column1 = [[NSMutableArray alloc] init];
    self.pickerColumn1= [[NSMutableArray alloc] init];
    if(self.pickerColumnNumber > 1)
    {
        self.column2 = [[NSMutableArray alloc] init];
        self.pickerColumn2= [[NSMutableArray alloc] init];
    }
    if(self.pickerColumnNumber > 2)
    {
        self.column3 = [[NSMutableArray alloc] init];
        self.pickerColumn3= [[NSMutableArray alloc] init];
    }
    
    if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Man", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
        {
            [self loadFromJSONfile:@"manfootwear"];
            [self setUpFirstSlider:self.userProfile.footWear];
            self.firstSliderText.text = NSLocalizedString(@"foot", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
        {
            [self loadFromJSONfile:@"manhats"];
            [self setUpFirstSlider:self.userProfile.hats];
            self.firstSliderText.text = NSLocalizedString(@"head", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Rings", nil)])
        {
            [self loadFromJSONfile:@"manrings"];
            [self setUpFirstSlider:self.userProfile.rings];
            self.firstSliderText.text = NSLocalizedString(@"finger", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Jeans", nil)])
        {
            
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Trouser", nil)])
        {
            [self loadFromJSONfile:@"mantrousers"];
            [self setUpFirstSlider:self.userProfile.trousers];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
            if(self.userProfile.trousersWaist != nil)
            {
                self.firstSlider.value = [self.userProfile.trousersWaist floatValue];
                [self setFirstSliderTextValue:self.firstSlider.value];
            }
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Shirts", nil)])
        {
            NSLog(@"Code should not hit here: %@", self.accessoryName);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Underwearbottom", nil)])
        {
            [self loadFromJSONfile:@"manunderwearbottom"];
            [self setUpFirstSlider:self.userProfile.underwearBottom];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Belts", nil)])
        {
            [self loadFromJSONfile:@"manbelts"];
            [self setUpFirstSlider:self.userProfile.belts];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
            if(self.userProfile.beltsWaist != nil)
            {
                self.firstSlider.value = [self.userProfile.beltsWaist floatValue];
                [self setFirstSliderTextValue:self.firstSlider.value];
            }
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Gloves", nil)])
        {
            [self loadFromJSONfile:@"mangloves"];
            [self setUpFirstSlider:self.userProfile.gloves];
            self.firstSliderText.text = NSLocalizedString(@"hand", nil);
            if(self.userProfile.glovesHand != nil)
            {
                self.firstSlider.value = [self.userProfile.glovesHand floatValue];
                [self setFirstSliderTextValue:self.firstSlider.value];
            }
        }
    }
    else if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Woman", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
        {
            [self loadFromJSONfile:@"womanfootwear"];
            [self setUpFirstSlider:self.userProfile.footWear];
            self.firstSliderText.text = NSLocalizedString(@"foot", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
        {
            [self loadFromJSONfile:@"womanhats"];
            [self setUpFirstSlider:self.userProfile.hats];
            self.firstSliderText.text = NSLocalizedString(@"head", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Rings", nil)])
        {
            [self loadFromJSONfile:@"womanrings"];
            [self setUpFirstSlider:self.userProfile.rings];
            self.firstSliderText.text = NSLocalizedString(@"finger", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Jeans", nil)])
        {
            
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Trouser", nil)])
        {
            [self loadFromJSONfile:@"womantrousers"];
            [self setUpFirstSlider:self.userProfile.trousers];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
            if(self.userProfile.trousersWaist != nil)
            {
                self.firstSlider.value = [self.userProfile.trousersWaist floatValue];
                [self setFirstSliderTextValue:self.firstSlider.value];
            }
            
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Shirts", nil)])
        {
            NSLog(@"Code should not hit here: %@", self.accessoryName);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Underwearbottom", nil)])
        {
            [self loadFromJSONfile:@"womanunderwearbottom"];
            [self setUpFirstSlider:self.userProfile.underwearBottom];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Belts", nil)])
        {
            [self loadFromJSONfile:@"womanbelts"];
            [self setUpFirstSlider:self.userProfile.belts];
            self.firstSliderText.text = NSLocalizedString(@"waist", nil);
            if(self.userProfile.beltsWaist != nil)
            {
                self.firstSlider.value = [self.userProfile.beltsWaist floatValue];
                [self setFirstSliderTextValue:self.firstSlider.value];
            }
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Gloves", nil)])
        {
            [self loadFromJSONfile:@"mangloves"];
            [self setUpFirstSlider:self.userProfile.gloves];
            self.firstSliderText.text = NSLocalizedString(@"hand", nil);
            if(self.userProfile.glovesHand != nil)
            {
                self.firstSlider.value = [self.userProfile.glovesHand floatValue];
                [self setFirstSliderTextValue:self.firstSlider.value];
            }
        }
    }
    else  if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Kidboy", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
        {
            [self loadFromJSONfile:@"kidboyfootwear"];
            [self setUpFirstSlider:self.userProfile.footWear];
            self.firstSliderText.text = NSLocalizedString(@"foot", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
        {
            [self loadFromJSONfile:@"kidboywear"];
            [self setUpFirstSlider:self.userProfile.hats];
            self.firstSliderText.text = NSLocalizedString(@"height", nil);
        }
    }
    else  if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Kidgirl", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
        {
            [self loadFromJSONfile:@"kidboyfootwear"];
            [self setUpFirstSlider:self.userProfile.footWear];
            self.firstSliderText.text = NSLocalizedString(@"foot", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
        {
            [self loadFromJSONfile:@"kidgirlwear"];
            [self setUpFirstSlider:self.userProfile.hats];
            self.firstSliderText.text = NSLocalizedString(@"height", nil);
        }
    }
    else  if([self.userProfile.gender isEqualToString:NSLocalizedString(@"Toddlerboy", nil)] || [self.userProfile.gender isEqualToString:NSLocalizedString(@"Toddlergirl", nil)])
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
        {
            [self loadFromJSONfile:@"toddlerboy"];
            [self setUpFirstSlider:self.userProfile.footWear];
            self.firstSliderText.text = NSLocalizedString(@"foot", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
        {
            [self loadFromJSONfile:@"toddlergirl"];
            [self setUpFirstSlider:self.userProfile.hats];
            self.firstSliderText.text = NSLocalizedString(@"height", nil);
        }
    }
    else
    {
        if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
        {
            [self loadFromJSONfile:@"babyfootwear"];
            [self setUpFirstSlider:self.userProfile.footWear];
            self.firstSliderText.text = NSLocalizedString(@"foot", nil);
        }
        else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
        {
            [self loadFromJSONfile:@"babywear"];
            [self setUpFirstSlider:self.userProfile.hats];
            self.firstSliderText.text = NSLocalizedString(@"height", nil);
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
    [self setFirstSliderTextValue:[setVal floatValue]];
    self.firstSlider.value = [setVal floatValue];
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
    if(sliderRowIndex == NSNotFound)
    {
        sliderVal = self.firstSlider.value;
        setVal = [[NSString alloc] initWithFormat:@"%.1f",sliderVal];
        sliderRowIndex = [self.slider1 indexOfObject:setVal];
        if(sliderRowIndex == NSNotFound)
        {
            sliderVal = round(self.firstSlider.value * 2.0) / 2.0;
            setVal = [[NSString alloc] initWithFormat:@"%.1f",sliderVal];
            sliderRowIndex = [self.slider1 indexOfObject:setVal];
        }
    }
    
    [self setFirstSliderTextValue:sliderVal];
    
    [self setPickerRowsFromSlider:sliderRowIndex];
    
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
            }
            break;
            
        case 1:
            if(![self.systemUnit isEqualToString:NSLocalizedString(@"inch", nil)])
            {
                self.systemUnit = NSLocalizedString(@"inch", nil);
                [self setFirstSliderTextValue:self.firstSlider.value];
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
    self.firstSliderValue.text = [[NSString alloc] initWithFormat:@"%.1f %@", val, showSystem];
}

-(void)saveButtonClicked: (id)sender
{
    //Save the value to the model
    
    if(![self.systemUnit isEqualToString:self.userProfile.systemUnit])
    {
        self.userProfile.systemUnit = self.systemUnit;
        //[self inchCentimeterConversion];      Uncomment this
    }
    if([self.accessoryName isEqualToString:NSLocalizedString(@"Footwear", nil)])
    {
        self.userProfile.footWear = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Hats", nil)])
    {
        self.userProfile.hats = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Rings", nil)])
    {
        self.userProfile.rings = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Jeans", nil)])
    {
        self.userProfile.jeans = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Trouser", nil)])
    {
        self.userProfile.trousers = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
        self.userProfile.trousersWaist = [[NSNumber alloc] initWithFloat:self.firstSlider.value];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Shirts", nil)])
    {
        self.userProfile.shirts = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Underwearbottom", nil)])
    {
        self.userProfile.underwearBottom = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Belts", nil)])
    {
        self.userProfile.belts = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
        self.userProfile.beltsWaist = [[NSNumber alloc] initWithFloat:self.firstSlider.value];
    }
    else if([self.accessoryName isEqualToString:NSLocalizedString(@"Gloves", nil)])
    {
        self.userProfile.gloves = (NSString *) [self.pickerColumn1 objectAtIndex:[self.picker selectedRowInComponent:0]];
        self.userProfile.glovesHand = [[NSNumber alloc] initWithFloat:self.firstSlider.value];
    }
    [self.delegate reloadTableRow];
    [self.navigationController popViewControllerAnimated: YES];
}


- (UIView *)getSelectionFlags
{
    UIImage *selectorImage = nil;//[UIImage imageNamed:@"selectionIndicator"];
    UIView *customSelector = nil;//[[UIImageView alloc] initWithImage:selectorImage];
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
            if([self.accessoryName isEqualToString:NSLocalizedString(@"Gloves", nil)])
                selectorImage = [UIImage imageNamed:@"sizein"];
            else
                selectorImage = [UIImage imageNamed:@"usue"];
            
            customSelector = [[UIImageView alloc] initWithImage:selectorImage];
            if ([devType rangeOfString:@"iPhone5"].location != NSNotFound || [devType rangeOfString:@"iPhone6"].location != NSNotFound)
                customSelector.frame = CGRectMake(88, 300, 140, 40);
            else
                customSelector.frame = CGRectMake(88, 220, 140, 40);
            break;
            
            
        default:
            if([self.accessoryName isEqualToString:NSLocalizedString(@"Belts", nil)])
                selectorImage = [UIImage imageNamed:@"sizecmin"];
            else
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
