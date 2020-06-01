//
//  SQLAppAccess.h
//  Doctot
//
//  Created by Fergal McDonnell on 20/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLAppAccess : NSObject {
    
    int uniqueId;
    int referenceAppId;
    int userId;
    int deviceId;
    NSDate *creationTimeStamp;
    
}

@property int uniqueId;
@property int referenceAppId;
@property int userId;
@property int deviceId;
@property (nonatomic, retain) NSDate *creationTimeStamp;

@end
