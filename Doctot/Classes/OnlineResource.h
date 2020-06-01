//
//  OnlineResource.h
//  Doctot
//
//  Created by Fergal McDonnell on 01/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineResource : NSObject {
    
    NSUserDefaults *prefs;
    
    NSString *sourceApp;
    NSString *saveTitle;
    NSString *saveType;
    NSString *documentsSaveDirectory;
    NSString *onlineURLString;
    NSURL *onlineURL;
    NSData *urlData;
    NSString *documentsfileName;
    NSString *documentsFullPath;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *sourceApp;
@property (nonatomic, retain) NSString *saveTitle;
@property (nonatomic, retain) NSString *saveType;
@property (nonatomic, retain) NSString *documentsSaveDirectory;
@property (nonatomic, retain) NSString *onlineURLString;
@property (nonatomic, retain) NSURL *onlineURL;
@property (nonatomic, retain) NSData *urlData;
@property (nonatomic, retain) NSString *documentsfileName;
@property (nonatomic, retain) NSString *documentsFullPath;

- (void)setupOnlineResourceFor:(NSString *)identifier;
- (void)downloadFileToDocuments;


@end
