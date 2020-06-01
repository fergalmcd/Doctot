//
//  CustomWebView.h
//  Doctot
//
//  Created by Fergal McDonnell on 23/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface CustomWebView : UIView <WKNavigationDelegate, WKUIDelegate> {
    
    WKWebView *content;
    
    NSString *source;
    NSString *type;
    NSString *contentString;
    NSString *alternateContentString;
    
    NSString *path;
    NSURL *theBaseURL;
    
}

@property (nonatomic, retain) WKWebView *content;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *contentString;
@property (nonatomic, retain) NSString *alternateContentString;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSURL *theBaseURL;

- (void)setup:(NSString *)identifier;


@end
