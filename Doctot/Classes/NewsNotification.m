//
//  NewsNotification.m
//  Doctot
//
//  Created by Fergal McDonnell on 11/10/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "NewsNotification.h"
#import "Helper.h"
#import "Constants.h"


@implementation NewsNotification

@synthesize index;

- (void)initialiseWithTitle:(NSString *)theTitle andMessage:(NSString *)theMessage {
    
    // Create a notification for the News item
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:theTitle arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:theMessage arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = [NSNumber numberWithInteger:([UIApplication sharedApplication].applicationIconBadgeNumber + 1)];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.f repeats:NO];    // 1 second later
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"OneSecond" content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"add NotificationRequest succeeded!");
        }
    }];
    
}

// CAN'T GET THIS GOING
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"We're in!!");
    
    if ([response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) {
        // The user dismissed the notification without taking action.
    }
    else if ([response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
        // The user launched the app.
    }
    
    // Else handle any custom actions. . .
}

// CAN'T GET THIS GOING
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"Are we in!!");
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
