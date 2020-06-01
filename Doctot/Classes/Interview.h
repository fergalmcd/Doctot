//
//  Interview.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleDefinition.h"
#import "Question.h"
#import "DiagnosisElement.h"
#import "DiagnosisExtended.h"
//#import "MiniInterview.h"
#import "Scores.h"
#import "Summary.h"
#import "DataPatient.h"
#import "DataInterview.h"
#import "DataQuestion.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface Interview : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate> {
    
    NSUserDefaults *prefs;
    ScaleDefinition *definition;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    NSMutableArray *questions;
    Question *currentQuestion;
    
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
    UIProgressView *progressView;
    CAShapeLayer *progressArc;
    BOOL progressArcVisible;
    UIButton *previousButton;
    UIButton *nextButton;
    
    Summary *summary;
    DiagnosisExtended *diagnosisExtended;
    Scores *patientList;
    BOOL isNewPatient;
    NSInteger latestPatientDtPlusId;
    NSInteger latestAssessmentDtPlusId;
    //MiniInterview *miniInterview;
    ScaleDefinition *miniDefinition;
    NSMutableArray *miniQuestions;
    
    NSInteger currentQuestionIndex;
    float score;
    NSString *scorePrecision;
    DiagnosisElement *currentDiagnosis;
    NSString *moreInfoDetail;
    BOOL shakeEnabled;
    BOOL singleApp;
    NSInteger storedScores;
    NSInteger storedScoresAllowed;
    NSFetchedResultsController *fetchedResultsController;
    NSArray *fetchedObjects;
    DataPatient *patientObject;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) ScaleDefinition *definition;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) IBOutlet Question *currentQuestion;
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
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) CAShapeLayer *progressArc;
@property BOOL progressArcVisible;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet Summary *summary;
@property (nonatomic, retain) IBOutlet DiagnosisExtended *diagnosisExtended;
@property (nonatomic, retain) IBOutlet Scores *patientList;
@property BOOL isNewPatient;
@property NSInteger latestPatientDtPlusId;
@property NSInteger latestAssessmentDtPlusId;
//@property (nonatomic, retain) IBOutlet MiniInterview *miniInterview;
@property (nonatomic, retain) ScaleDefinition *miniDefinition;
@property (nonatomic, retain) NSMutableArray *miniQuestions;
@property NSInteger currentQuestionIndex;
@property float score;
@property (nonatomic, retain) NSString *scorePrecision;
@property (nonatomic, retain) DiagnosisElement *currentDiagnosis;
@property (nonatomic, retain) NSString *moreInfoDetail;
@property BOOL shakeEnabled;
@property BOOL singleApp;
@property NSInteger storedScores;
@property NSInteger storedScoresAllowed;
@property NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSArray *fetchedObjects;
@property (nonatomic, retain) DataPatient *patientObject;

- (IBAction)updateScore;
- (IBAction)navigateNext;
- (void)conjureInternalInterview:(NSString *)miniInterview;


@end
