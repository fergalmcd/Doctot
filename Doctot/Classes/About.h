//
//  About.h
//  Doctot
//
//  Created by Fergal McDonnell on 29/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Social/Social.h"

@interface About : UIViewController {
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    UIImageView *logo;
    UILabel *slogan;
    WKWebView *content;
    UIButton *urlButton;
    
}

@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIImageView *logo;
@property (nonatomic, retain) IBOutlet UILabel *slogan;
@property (nonatomic, retain) IBOutlet WKWebView *content;
@property (nonatomic, retain) IBOutlet UIButton *urlButton;

@end

