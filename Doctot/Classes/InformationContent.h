//
//  InformationContent.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface InformationContent : UIViewController <WKNavigationDelegate> {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    NSString *scale;
    NSString *htmlContentReference;
    UIImageView *contentHolder;
    WKWebView *content;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) NSString *scale;
@property (nonatomic, retain) NSString *htmlContentReference;
@property (nonatomic, retain) IBOutlet UIImageView *contentHolder;
@property (nonatomic, retain) IBOutlet WKWebView *content;

@end
