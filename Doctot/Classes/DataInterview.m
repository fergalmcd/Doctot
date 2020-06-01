//
//  DataInterview.m
//  Doctot
//
//  Created by Fergal McDonnell on 19/04/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import "DataInterview.h"
#import "Helper.h"


@implementation DataInterview

@synthesize mirrorEntity, uniqueID, dtPlusID, scale, score, scoreCategory, creationDate, creationDateOnly, creationTimeOnly, questions;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithNSManagedObject:(NSManagedObject *)entityObject {
    self = [self init];
    
    if( self ){
        
        if( [[[entityObject entity] name] isEqualToString:@"Interview"] ){
            [self configureData:entityObject];
        }
        
    }
    
    return self;
}

- (void)configureData:(NSManagedObject *)entityObject {

    mirrorEntity = (NSManagedObject *)entityObject;
    
    uniqueID = [entityObject valueForKey:@"uniqueID"];
    dtPlusID = [[entityObject valueForKey:@"dtPlusId"] integerValue];
    scale = [entityObject valueForKey:@"scale"];
    score = [[entityObject valueForKey:@"score"] floatValue];
    scoreCategory = [entityObject valueForKey:@"scoreCategory"];
    creationDate = [entityObject valueForKey:@"creationDate"];
    //creationDateOnly = [entityObject valueForKey:@"creationDateOnly"];
    creationTimeOnly = [entityObject valueForKey:@"creationTime"];
    
    //questions = [entityObject valueForKey:@"questions"];
    
    NSMutableArray *questionEntities = (NSMutableArray *)[mirrorEntity valueForKey:@"questions"];    
    DataQuestion *thisQuestion;
    questions = [[NSMutableArray alloc] init];
    for( NSManagedObject *entityQustionObject in questionEntities ){
        thisQuestion = [[DataQuestion alloc] init];
        [thisQuestion configureData:entityQustionObject];
        [questions addObject:thisQuestion];
    }
    
}

- (void)initialiseCreationDateAndTime:(NSString *)name {
    
    creationDate = [NSDate date];
    
    creationDateOnly = [Helper convertDateToString:creationDate forStyle:@"Text"];
    creationTimeOnly = [Helper convertDateToTimeString:creationDate];
 
    uniqueID = [NSString stringWithFormat:@"%@%@%@", creationDate, name, scale];
    
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
