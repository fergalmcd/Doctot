//
//  DataQuestion.h
//  Doctot
//
//  Created by Fergal McDonnell on 19/04/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DataQuestion : NSObject {
    
    NSManagedObject *mirrorEntity;
    
    NSString *uniqueID;
    NSString *scale;
    NSInteger index;
    float score;
    NSInteger item;
    NSString *customInformation;
    
}

@property (nonatomic, retain) NSManagedObject *mirrorEntity;
@property (nonatomic, retain) NSString *uniqueID;
@property (nonatomic, retain) NSString *scale;
@property NSInteger index;
@property float score;
@property NSInteger item;
@property (nonatomic, retain) NSString *customInformation;

- (instancetype)initWithNSManagedObject:(NSManagedObject *)entityObject;
- (void)configureData:(NSManagedObject *)entityObject;


@end
