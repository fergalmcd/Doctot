//
//  DataPatient.h
//  Doctot
//
//  Created by Fergal McDonnell on 19/04/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DataPatient : NSObject {
    
    NSManagedObject *mirrorEntity;
    
    NSString *uniqueID;
    NSInteger dtPlusID;
    NSString *hospitalNo;
    NSString *firstName;
    NSString *lastName;
    NSDate *dob;
    NSData *photoData;
    NSString *address;
    NSString *notes;
    NSMutableArray *interviews;
    
}

@property (nonatomic, retain) NSManagedObject *mirrorEntity;
@property (nonatomic, retain) NSString *uniqueID;
@property NSInteger dtPlusID;
@property (nonatomic, retain) NSString *hospitalNo;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSDate *dob;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSData *photoData;
@property (nonatomic, retain) NSMutableArray *interviews;

- (instancetype)initWithNSManagedObject:(NSManagedObject *)entityObject;
- (void)configureData:(NSManagedObject *)entityObject;
- (void)setHospitalNumberBy:(int)index;
- (NSData *)convertImageToData:(UIImage *)theImage;
- (UIImage *)convertDataToImage:(NSData *)theData;
- (UIImageView *)convertDataToImageView:(NSData *)theData;

@end
