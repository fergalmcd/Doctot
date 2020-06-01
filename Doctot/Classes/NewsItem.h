//
//  NewsItem.h
//  Doctot
//
//  Created by Fergal McDonnell on 13/09/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsItem : NSObject {
    
    NSInteger index;
    NSString *title;
    NSString *message;
    UIImage *image;
    NSURL *link;
    BOOL isAppSpecific;
    int appId;
    BOOL notificationEnabled;
    BOOL newsFeedEnabled;
    NSDate *dateToDisplayNotification;
    NSDate *creationTimeStamp;
    
}

@property NSInteger index;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSURL *link;
@property BOOL isAppSpecific;
@property int appId;
@property BOOL notificationEnabled;
@property BOOL newsFeedEnabled;
@property (nonatomic, retain) NSDate *dateToDisplayNotification;
@property (nonatomic, retain) NSDate *creationTimeStamp;

- (void)initialiseWithObject:(id)initialItem;


@end
