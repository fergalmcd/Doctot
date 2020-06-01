//
//  NewsItem.m
//  Doctot
//
//  Created by Fergal McDonnell on 13/09/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "NewsItem.h"
#import "Helper.h"
#import "Constants.h"


@implementation NewsItem

@synthesize index, title, message, image, link, isAppSpecific, appId, notificationEnabled, newsFeedEnabled, dateToDisplayNotification, creationTimeStamp;

/*
 {"uniqueId":"1","appSpecific":"NO","appId":"0","notificationEnabled":"0","newsFeedEnabled":"1","creationTimeStamp":"2018-09-13 09:17:28","dateToDisplayNotification":"0000-00-00","title":"Welcome to Doctot","message":"Thank you for downloading this Doctot app. we aim to deliver ...","image":"orb_blue.png","link":"http:\/\/www.gaa.ie"}
 */

- (void)initialiseWithObject:(id)initialItem {
    
    index = (int)[[initialItem valueForKey:@"uniqueId"] integerValue];
    title = [initialItem valueForKey:@"title"];
    message = [initialItem valueForKey:@"message"];
    
    NSString *imageShortName = [initialItem valueForKey:@"image"];
    NSString *imageURL = [NSString stringWithFormat:@"%@/news/%@", RESOURCE_URL_BASE, imageShortName];
    if( [imageShortName length] == 0 ){
        image = nil;
    }else{
        NSURL *url = [NSURL URLWithString:imageURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
    }
    
    NSString *theLink = (NSString *)[initialItem valueForKey:@"link"];
    if( [theLink length] > 0 ){
        link = [NSURL URLWithString:theLink];
    }else{
        link = nil;
    }
    
    if( [[initialItem valueForKey:@"appSpecific"] isEqualToString:@"YES"] ){
        isAppSpecific = YES;
    }else{
        isAppSpecific = NO;
    }
    
    appId =(int)[[initialItem valueForKey:@"appId"] integerValue];
    
    if( [[initialItem valueForKey:@"notificationEnabled"] isEqualToString:@"1"] ){
        notificationEnabled = YES;
    }else{
        notificationEnabled = NO;
    }
    
    if( [[initialItem valueForKey:@"newsFeedEnabled"] isEqualToString:@"1"] ){
        newsFeedEnabled = YES;
    }else{
        newsFeedEnabled = NO;
    }
    
    creationTimeStamp = [Helper convertStringToDate:(NSString *)[initialItem objectForKey:@"creationTimeStamp"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateToDisplayNotification = [Helper convertStringToDate:(NSString *)[initialItem objectForKey:@"dateToDisplayNotification"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
