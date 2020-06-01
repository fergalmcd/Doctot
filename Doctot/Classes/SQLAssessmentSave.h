//
//  SQLAssessmentSave.h
//  Doctot
//
//  Created by Fergal McDonnell on 20/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLAssessmentSave : NSObject {
    
    int uniqueId;
    NSDate *creationTimeStamp;
    int userId;
    int patientId;
    int assessmentId;
    int appId;
    float score;
    NSString *description;
    
}

@property int uniqueId;
@property (nonatomic, retain) NSDate *creationTimeStamp;
@property int userId;
@property int patientId;
@property int assessmentId;
@property int appId;
@property float score;
@property (nonatomic, retain) NSString *description;

@end
