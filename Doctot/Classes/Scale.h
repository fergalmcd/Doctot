//
//  Scale.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleDefinition.h"
#import "Helper.h"
#import "Interview.h"
#import "Information.h"
#import "Scores.h"
#import "Question.h"


@interface Scale : UIViewController {
    
    NSUserDefaults *prefs;
    ScaleDefinition *definition;
    BOOL singleApp;
    
    Interview *interview;
    Information *information;
    Scores *scores;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    UILabel *introLabel;
    UIImageView *startHeader;
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    UIButton *startInterview;
    UIButton *viewInformation;
    UIButton *viewScores;
    UIImageView *advertiser;
    
    NSMutableArray *questions;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) ScaleDefinition *definition;
@property BOOL singleApp;
@property (nonatomic, retain) IBOutlet Interview *interview;
@property (nonatomic, retain) IBOutlet Information *information;
@property (nonatomic, retain) IBOutlet Scores *scores;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UILabel *introLabel;
@property (nonatomic, retain) IBOutlet UIImageView *startHeader;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, retain) IBOutlet UIButton *startInterview;
@property (nonatomic, retain) IBOutlet UIButton *viewInformation;
@property (nonatomic, retain) IBOutlet UIButton *viewScores;
@property (nonatomic, retain) IBOutlet UIImageView *advertiser;
@property (nonatomic, retain) NSMutableArray *questions;

- (void)goToInformation;


@end
