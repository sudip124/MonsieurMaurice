//
//  Notes.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 27/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * accessory;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * imagepath;

@end
