//
//  DataPatient.m
//  Doctot
//
//  Created by Fergal McDonnell on 19/04/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import "DataPatient.h"
#import "DataInterview.h"
#import "DataQuestion.h"
#import "Constants.h"


@implementation DataPatient

@synthesize mirrorEntity, uniqueID, dtPlusID, hospitalNo, firstName, lastName, dob, address, notes, photoData, interviews;

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
        
        if( [[[entityObject entity] name] isEqualToString:@"Patient"] ){
            [self configureData:entityObject];
        }
        
    }
    
    return self;
}

- (void)configureData:(NSManagedObject *)entityObject {

    mirrorEntity = (NSManagedObject *)entityObject;
    
    uniqueID = [entityObject valueForKey:@"uniqueID"];
    dtPlusID = [[entityObject valueForKey:@"dtPlusId"] integerValue];
    hospitalNo = [entityObject valueForKey:@"hospitalNo"];
    firstName = [entityObject valueForKey:@"firstName"];
    lastName = [entityObject valueForKey:@"lastName"];
    dob = [entityObject valueForKey:@"dob"];
    address = [entityObject valueForKey:@"address"];
    notes = [entityObject valueForKey:@"notes"];
    photoData = [entityObject valueForKey:@"photoData"];
    
    NSMutableArray *interviewEntities = (NSMutableArray *)[mirrorEntity valueForKey:@"interviews"];
    DataInterview *thisInterview;
    interviews = [[NSMutableArray alloc] init];
    for( NSManagedObject *entityObj in interviewEntities ){
        thisInterview = [[DataInterview alloc] init];
        [thisInterview configureData:entityObj];
        [interviews addObject:thisInterview];
    }
    
}

- (void)setHospitalNumberBy:(int)index {

    NSString *padding;
    if( index > 999 )    padding = @"";
    if( index > 99 )    padding = @"0";
    if( index > 9 )    padding = @"00";
    if( index <= 9 )    padding = @"000";
    
    hospitalNo = [NSString stringWithFormat:@"%@%i", padding, index];
    
}

- (NSData *)convertImageToData:(UIImage *)theImage {
    NSData * returnData;
    
    returnData = UIImageJPEGRepresentation(theImage, 0.0);
    
    return returnData;
}

- (UIImage *)convertDataToImage:(NSData *)theData {
    UIImage *returnImage;
    
    returnImage = [UIImage imageWithData:theData];
    if( returnImage == nil ){
        returnImage = [UIImage imageNamed:emptyPatientContainer];
    }
    
    return returnImage;
}


- (UIImageView *)convertDataToImageView:(NSData *)theData {
    UIImageView * returnImageView;
    
    UIImage *theImage = [UIImage imageWithData:theData];
    if( theImage == nil ){
        theImage = [UIImage imageNamed:emptyPatientContainer];
    }
    returnImageView = [[UIImageView alloc] initWithImage:theImage];
    
    return returnImageView;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
