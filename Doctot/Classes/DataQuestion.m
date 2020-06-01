//
//  DataQuestion.m
//  Doctot
//
//  Created by Fergal McDonnell on 19/04/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import "DataQuestion.h"


@implementation DataQuestion

@synthesize mirrorEntity, uniqueID, scale, index, score, item, customInformation;

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
        
        if( [[[entityObject entity] name] isEqualToString:@"Question"] ){
            [self configureData:entityObject];
        }
        
    }
    
    return self;
}

- (void)configureData:(NSManagedObject *)entityObject {
    
    mirrorEntity = (NSManagedObject *)entityObject;
    
    uniqueID = [entityObject valueForKey:@"uniqueID"];
    scale = [entityObject valueForKey:@"scale"];
    index = [[entityObject valueForKey:@"index"] intValue];
    score = [[entityObject valueForKey:@"score"] floatValue];
    item = [[entityObject valueForKey:@"item"] intValue];
    customInformation = [entityObject valueForKey:@"customInformation"];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
