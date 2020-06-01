//
//  DataInterview.h
//  Doctot
//
//  Created by Fergal McDonnell on 19/04/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DataInterview : NSObject {
    
    NSManagedObject *mirrorEntity;
    
    NSString *uniqueID;
    NSInteger dtPlusID;
    NSString *scale;
    float score;
    NSString *scoreCategory;
    NSDate *creationDate;
    NSString *creationDateOnly;
    NSString *creationTimeOnly;
    
    NSMutableArray *questions;
    
}

@property (nonatomic, retain) NSManagedObject *mirrorEntity;
@property (nonatomic, retain) NSString *uniqueID;
@property NSInteger dtPlusID;
@property (nonatomic, retain) NSString *scale;
@property float score;
@property (nonatomic, retain) NSString *scoreCategory;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSString *creationDateOnly;
@property (nonatomic, retain) NSString *creationTimeOnly;
@property (nonatomic, retain) NSMutableArray *questions;

- (instancetype)initWithNSManagedObject:(NSManagedObject *)entityObject;
- (void)configureData:(NSManagedObject *)entityObject;
- (void)initialiseCreationDateAndTime:(NSString *)name;


@end
