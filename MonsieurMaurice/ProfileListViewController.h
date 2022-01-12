//
//  MasterViewController.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol ProfileList

- (void) reloadProfile;

@end;

@interface ProfileListViewController : UITableViewController <NSFetchedResultsControllerDelegate, ProfileList, UITableViewDelegate>

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
