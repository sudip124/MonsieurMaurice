//
//  AppDelegate.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (UIColor*) navigationBarTintColor;
+ (UIColor*) tableViewSelectionColor;
+ (UIColor*) tableViewTextColor;
+ (UIColor*) tableViewRowColor;
+ (UIColor*) tableViewBorderColor;
+ (NSString*) getDeviceModelNumber;
+ (NSString*) getLocale;
@end
