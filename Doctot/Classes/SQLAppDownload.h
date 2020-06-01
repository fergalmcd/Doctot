//
//  SQLAppDownload.h
//  Doctot
//
//  Created by Fergal McDonnell on 20/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLAppDownload : NSObject {
    
    int uniqueId;
    int referenceAppId;
    int userId;
    int deviceId;
    int disclaimerAccepted;
    int numberOfLogins;
    int numberOfSocialMediaShares;
    bool isDuplicate;
    int numberOfDuplicates;
    NSDate *creationTimeStamp;
    
}

@property int uniqueId;
@property int referenceAppId;
@property int userId;
@property int deviceId;
@property int disclaimerAccepted;
@property int numberOfLogins;
@property int numberOfSocialMediaShares;
@property bool isDuplicate;
@property int numberOfDuplicates;
@property (nonatomic, retain) NSDate *creationTimeStamp;

@end
