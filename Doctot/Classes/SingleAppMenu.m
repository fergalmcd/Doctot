//
//  ActivateView.m
//  Doctot
//
//  Created by Fergal McDonnell on 04/03/2019.
//  Copyright Doctot 2019. All rights reserved.
//

#import "SingleAppMenu.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Helper.h"
#import "Constants.h"


@implementation SingleAppMenu

@synthesize mainHeading, subHeading, startInterview, viewInformation, viewScores;
@synthesize singleAppViewPrefs, scaleDefinition;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)initialise {

    singleAppViewPrefs = [NSUserDefaults standardUserDefaults];
    
    self.backgroundColor = [UIColor clearColor];
    float xOffset = 10;

    mainHeading.frame = CGRectMake(xOffset, 0, (self.frame.size.width - (2 * xOffset)), 80);
    mainHeading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_FullTitle", scaleDefinition.name] withScalePrefix:NO];
    mainHeading.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    mainHeading.numberOfLines = 3;
    
    subHeading.frame = CGRectMake(mainHeading.frame.origin.x, (mainHeading.frame.origin.y + mainHeading.frame.size.height), mainHeading.frame.size.width, 25);
    subHeading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_SubTag", scaleDefinition.name] withScalePrefix:NO];
    subHeading.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    subHeading.numberOfLines = 3;
    
    float spacerToButtons = 25;
    
    startInterview.frame = CGRectMake(subHeading.frame.origin.x, (subHeading.frame.origin.y + subHeading.frame.size.height + spacerToButtons), mainHeading.frame.size.width, 50);
    [startInterview setTitle:[Helper getLocalisedString:@"Scale_Start" withScalePrefix:NO] forState:UIControlStateNormal];
    [startInterview setTitleColor:[Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]] forState:UIControlStateNormal];
    [self addIcon:@"watermark_assessment.png" toButton:startInterview];
    
    viewInformation.frame = CGRectMake(startInterview.frame.origin.x, (startInterview.frame.origin.y + startInterview.frame.size.height), mainHeading.frame.size.width, 50);
    [viewInformation setTitle:[Helper getLocalisedString:@"Scale_Info" withScalePrefix:NO] forState:UIControlStateNormal];
    [viewInformation setTitleColor:[Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]] forState:UIControlStateNormal];
    [self addIcon:@"watermark_info.png" toButton:viewInformation];
    
    viewScores.frame = CGRectMake(viewInformation.frame.origin.x, (viewInformation.frame.origin.y + viewInformation.frame.size.height), mainHeading.frame.size.width, 50);
    [viewScores setTitle:[Helper getLocalisedString:@"Scale_Score" withScalePrefix:NO] forState:UIControlStateNormal];
    [viewScores setTitleColor:[Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]] forState:UIControlStateNormal];
    [self addIcon:@"watermark_scores.png" toButton:viewScores];
    
    // Insert divider lines
    for( int i = 0; i < 4; i++ ){
        UIImageView *dividerline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_divider"]];
        float yHeight = 0.0;
        if( i == 0 ){
            yHeight = startInterview.frame.origin.y;
        }
        if( i == 1 ){
            yHeight = startInterview.frame.origin.y + startInterview.frame.size.height;
        }
        if( i == 2 ){
            yHeight = viewInformation.frame.origin.y + viewInformation.frame.size.height;
        }
        if( i == 3 ){
            yHeight = viewScores.frame.origin.y + viewScores.frame.size.height;
        }
        dividerline.frame = CGRectMake(startInterview.frame.origin.x, yHeight, startInterview.frame.size.width, 2);
        [self addSubview:dividerline];
    }
    
}

- (void)addIcon:(NSString *)iconName toButton:(UIButton *)sourceButton {
    
    float padding = 5;
    float xPos = sourceButton.frame.size.width - sourceButton.frame.size.height;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake( xPos, padding, (sourceButton.frame.size.height - (2 * padding)), (sourceButton.frame.size.height - (2 * padding)) )];
    icon.alpha = 0.6;
    icon.image = [UIImage imageNamed:iconName];
    [sourceButton addSubview:icon];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
