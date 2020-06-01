//
//  HelpContent.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HelpContent.h"

@interface HelpContent : UIViewController <WKNavigationDelegate, WKUIDelegate> {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    NSString *source;
    NSString *parentApp;
    NSString *scale;
    NSString *htmlContentReference;
    WKWebView *content;
    UILabel *internetRequiredText;
    UIActivityIndicatorView *spinner;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *parentApp;
@property (nonatomic, retain) NSString *scale;
@property (nonatomic, retain) NSString *htmlContentReference;
@property (nonatomic, retain) IBOutlet WKWebView *content;
@property (nonatomic, retain) IBOutlet UILabel *internetRequiredText;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@end
