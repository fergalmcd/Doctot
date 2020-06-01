//
//  NewsNotification.h
//  Doctot
//
//  Created by Fergal McDonnell on 11/10/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface NewsNotification : NSObject <UNUserNotificationCenterDelegate> {
    
    NSInteger index;
    
}

@property NSInteger index;

- (void)initialiseWithTitle:(NSString *)theTitle andMessage:(NSString *)theMessage;


@end
