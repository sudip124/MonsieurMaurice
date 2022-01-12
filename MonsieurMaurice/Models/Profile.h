//
//  Profile.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 16/09/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * belts;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * footWear;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * gloves;
@property (nonatomic, retain) NSString * hats;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * jeans;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * outerwearBust;
@property (nonatomic, retain) NSString * outerwearWaist;
@property (nonatomic, retain) NSString * profileLang;
@property (nonatomic, retain) NSString * rings;
@property (nonatomic, retain) NSString * shirts;
@property (nonatomic, retain) NSString * suit;
@property (nonatomic, retain) NSString * systemUnit;
@property (nonatomic, retain) NSString * trousers;
@property (nonatomic, retain) NSString * underwearBottom;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSNumber * jeansWaist;
@property (nonatomic, retain) NSNumber * jeansHeight;
@property (nonatomic, retain) NSNumber * trousersWaist;
@property (nonatomic, retain) NSNumber * beltsWaist;
@property (nonatomic, retain) NSNumber * glovesHand;

@end
