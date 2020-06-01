//
//  Information.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "InformationContent.h"
#import "Help.h"
#import "ScaleDefinition.h"

@interface Information : UIViewController {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    UIButton *help;
    
    ScaleDefinition *scaleDefinition;
    InformationContent *informationContent;
    Help *helpSection;
    
    WKWebView *iPadContent;
    float iPadButtonWidth;
    float iPadContentPadding;
    BOOL singleApp;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *help;
@property (nonatomic, retain) ScaleDefinition *scaleDefinition;
@property (nonatomic, retain) IBOutlet InformationContent *informationContent;
@property (nonatomic, retain) IBOutlet Help *helpSection;
@property (nonatomic, retain) IBOutlet WKWebView *iPadContent;
@property float iPadButtonWidth;
@property float iPadContentPadding;
@property BOOL singleApp;

- (void)setupForScale:(NSString *)theScale andContent:(NSString *)theContent;


@end
