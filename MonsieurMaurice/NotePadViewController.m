//
//  NotePadViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 27/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "NotePadViewController.h"
#import "Notes.h"

@interface NotePadViewController ()
{
    BOOL keyBoardShown;
}

@property (nonatomic, retain) Notes *noteObject;

@end

@implementation NotePadViewController

@synthesize notesView=_notesView;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize name=_name;
@synthesize noteObject=_noteObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    keyBoardShown = NO;
	
    self.title = NSLocalizedString(@"Note", nil);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.notesView.textColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(calcelButtonClicked:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self. managedObjectContext];
	[request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@ AND accessory LIKE %@", self.name, self.accessoryName];
    [request setPredicate:predicate];
	
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"Fetching from DB failed");
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"DBSaveError", nil)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DBSaveError", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
	}
    else
    {
        NSArray *notesList = mutableFetchResults;
        NSInteger length = notesList.count;
        if (length > 0)
        {
            //If its more than one it is a problem. One solution will be to add imagepath. Then everytime image is being changed in Profile entity update the imagepath in Notes.
            self.noteObject = (Notes*) [notesList objectAtIndex:0];
            self.notesView.text = self.noteObject.notes;
        }
        else
        {
            self.noteObject = (Notes*) [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
            self.noteObject.name = self.name;
            self.noteObject.accessory = self.accessoryName;
            self.noteObject.imagepath = @"";
        }
    }
    
    self.notesView.delegate = self;
    self.notesView.returnKeyType = UIReturnKeyDefault;
	self.notesView.keyboardType = UIKeyboardTypeDefault;
	self.notesView.scrollEnabled = YES;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.notesView becomeFirstResponder];
}

-(void) calcelButtonClicked: (id)sender
{
    
    if (([self.notesView.text length] > 0) && ![self.notesView.text isEqualToString:self.noteObject.notes])
    {
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"UnsavedNotes", nil)];
        NSString *otherButton = NSLocalizedString(@"OK", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnsavedNotesTitle", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:otherButton, nil];
        [alert show];
    }
    else
        [self.navigationController popViewControllerAnimated: YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:NSLocalizedString(@"UnsavedNotes", nil)])
    {
        if(buttonIndex == 1)
            [self.navigationController popViewControllerAnimated: YES];
    }
}
-(void)saveButtonClicked: (id)sender
{
    self.noteObject.notes = self.notesView.text;
    NSError *error;
	if (![self.managedObjectContext save:&error]) {
		// Handle the error.
        NSLog(@"Saving to DB failed in NotePadViewController");
        NSString *message = [[NSString alloc] initWithString:NSLocalizedString(@"DBSaveError", nil)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        return;
	}
    [self.navigationController popViewControllerAnimated: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    keyBoardShown = NO;
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up
{
    if (up && keyBoardShown)
        return;
    
    keyBoardShown = YES;
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.notesView.frame;
    viewFrame.size.height -= (keyboardSize.height - self.navigationController.toolbar.frame.size.height)  * (up? 1 : -1);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.notesView setFrame:viewFrame];
    [UIView commitAnimations];
    
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UItextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (void)viewDidUnload {
    [self setNotesView:nil];
    [super viewDidUnload];
}
@end
