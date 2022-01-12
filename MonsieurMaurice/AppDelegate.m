//
//  AppDelegate.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/utsname.h>
#import "MainPageViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set Color for App
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Verdana" size:15.0]];
    [[UIButton appearance] setFont:[UIFont fontWithName:@"Verdana" size:12.0]];
    [[UITableViewCell appearance] setFont:[UIFont fontWithName:@"Verdana" size:15.0]];
    [[UINavigationBar appearance] setTintColor:[AppDelegate navigationBarTintColor]];
    
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MainPageViewController *controller = (MainPageViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MonsieurMaurice" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MonsieurMaurice.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

+ (UIColor*) navigationBarTintColor
{
    return [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1];
}

+ (UIColor*) tableViewSelectionColor
{
    return [UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
}

+ (UIColor*) tableViewTextColor
{
    return [UIColor colorWithRed:31.0/255.0 green:30.0/255.0 blue:29.0/255.0 alpha:1];
}

+ (UIColor*) tableViewRowColor
{
    return [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
}

+ (UIColor*) tableViewBorderColor
{
    return [UIColor colorWithRed:147.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+  (NSString*) getDeviceModelNumber
{
    /*  Return vlues
     [platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
     if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
     if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
     if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
     if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
     if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
     if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
     if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
     if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
     if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
     if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
     if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
     if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
     if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
     if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
     if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
     if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
     if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
     if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
     if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
     if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
     if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
     if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
     if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
     if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
     if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
     if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
     if ([platform isEqualToString:@"i386"])         return @"Simulator";
     if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
     */
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}



+ (NSString*) getLocale
{
    return [[NSLocale currentLocale] identifier];
}


@end
