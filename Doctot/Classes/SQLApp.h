//
//  SQLApp.h
//  Doctot
//
//  Created by Fergal McDonnell on 21/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLApp : NSObject {
    
    int uniqueId;
    NSString *appstoreIdentifier;
    NSString *name;
    NSString *platform;
    
}

@property int uniqueId;
@property (nonatomic, retain) NSString *appstoreIdentifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *platform;

@end
