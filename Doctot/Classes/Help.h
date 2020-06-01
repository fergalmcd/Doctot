//
//  Help.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Help.h"
#import "HelpContent.h"
#import "ScaleDefinition.h"

@interface Help : UIViewController {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    HelpContent *helpContent;
    ScaleDefinition *scaleDefinition;
    
    float iPadButtonWidth;
    float iPadContentPadding;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet HelpContent *helpContent;
@property (nonatomic, retain) ScaleDefinition *scaleDefinition;
@property float iPadButtonWidth;
@property float iPadContentPadding;

@end
