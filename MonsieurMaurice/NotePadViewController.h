//
//  NotePadViewController.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 27/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NotePadViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *notesView;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *accessoryName;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
