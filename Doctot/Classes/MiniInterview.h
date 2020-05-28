//
//  MiniInterview.h
//  Doctot
//
//  Created by Fergal McDonnell on 12/09/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interview.h"
#import "Question.h"
#import "ScaleDefinition.h"


@interface MiniInterview : UIViewController <UIScrollViewDelegate> {
    
    UIButton *leftNavBarButton;
    
    UIImageView *headerLayer1;
    UIImageView *headerLayer2;
    UILabel *progressIndicatorlabel;
    UILabel *itemScore;
    UILabel *itemScoreLabel;
    UILabel *interviewScore;
    UILabel *interviewScoreLabel;
    UILabel *questionHeading;
    UILabel *questionSubheading;
    UIButton *moreInfo;
    UIScrollView *questionContent;
    UIImageView *progressIndicatorBackground;
    UIImageView *progressIndicator;
    UIButton *previousButton;
    UIButton *nextButton;
    
    NSUserDefaults *prefs;
    ScaleDefinition *definition;
    NSMutableArray *questions;
    Question *currentQuestion;
    NSInteger currentQuestionIndex;
    float score;
    NSString *scorePrecision;
    DiagnosisElement *currentDiagnosis;
    NSString *moreInfoDetail;
    Interview *parentInterview;
    
}

@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIImageView *headerLayer1;
@property (nonatomic, retain) IBOutlet UIImageView *headerLayer2;
@property (nonatomic, retain) IBOutlet UILabel *progressIndicatorlabel;
@property (nonatomic, retain) IBOutlet UILabel *itemScore;
@property (nonatomic, retain) IBOutlet UILabel *itemScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *interviewScore;
@property (nonatomic, retain) IBOutlet UILabel *interviewScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *questionHeading;
@property (nonatomic, retain) IBOutlet UILabel *questionSubheading;
@property (nonatomic, retain) IBOutlet UIButton *moreInfo;
@property (nonatomic, retain) IBOutlet UIScrollView *questionContent;
@property (nonatomic, retain) IBOutlet UIImageView *progressIndicatorBackground;
@property (nonatomic, retain) IBOutlet UIImageView *progressIndicator;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) ScaleDefinition *definition;
@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) Question *currentQuestion;
@property NSInteger currentQuestionIndex;
@property float score;
@property (nonatomic, retain) NSString *scorePrecision;
@property (nonatomic, retain) DiagnosisElement *currentDiagnosis;
@property (nonatomic, retain) NSString *moreInfoDetail;
@property (nonatomic, retain) Interview *parentInterview;

- (void)initialiseDefinition:(ScaleDefinition *)theDefinition;
- (void)initialiseQuestions:(NSMutableArray *)theQuestions;
- (IBAction)navigatePrevious;
- (IBAction)navigateNext;
- (void)updateScore;


@end
