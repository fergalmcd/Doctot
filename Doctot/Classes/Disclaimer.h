//
//  Disclaimer.h
//  Doctot
//
//  Created by Fergal McDonnell on 25/07/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface Disclaimer : UIView {
    
    NSUserDefaults *prefs;
    BOOL isCurrentlyVisible;
    
    UIImageView *background;
    UIImageView *logo;
    WKWebView *content;
    UIButton *agree;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property BOOL isCurrentlyVisible;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet UIImageView *logo;
@property (nonatomic, retain) IBOutlet WKWebView *content;
@property (nonatomic, retain) IBOutlet UIButton *agree;

- (void)initialise;


@end
