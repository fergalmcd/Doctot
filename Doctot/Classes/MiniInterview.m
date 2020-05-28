//
//  MiniInterview.m
//  Doctot
//
//  Created by Fergal McDonnell on 12/09/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import "MiniInterview.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"

@interface MiniInterview ()

@end

@implementation MiniInterview

@synthesize leftNavBarButton, headerLayer1, headerLayer2, progressIndicatorlabel, itemScore, itemScoreLabel, interviewScore, interviewScoreLabel, questionHeading, questionSubheading, moreInfo, questionContent, progressIndicatorBackground, progressIndicator, previousButton, nextButton;
@synthesize prefs, definition, questions, currentQuestion, currentQuestionIndex, score, scorePrecision, currentDiagnosis, moreInfoDetail, parentInterview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = definition.name;
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(resetAndLeaveInterview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    prefs = [NSUserDefaults standardUserDefaults];
    parentInterview = [self getParentInterview];
    score = 0;
    currentQuestionIndex = 1;
    [self adjustNavigationVisibility];
    
    // Specifies that the questions are in a MiniInterview
    for( Question *aQuestion in questions ){
        aQuestion.isInMiniInterview = YES;
        aQuestion.miniInterviewPlain = self;
    }
    
    itemScoreLabel.text = [Helper getLocalisedString:@"Scale_ItemLabel" withScalePrefix:NO];
    interviewScoreLabel.text = [Helper getLocalisedString:@"Scale_TotalLabel" withScalePrefix:NO];
    
    scorePrecision = [NSString stringWithFormat:@"%%.%lif", (long)definition.precision];
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    currentQuestion = [[Question alloc] initWithFrame:CGRectMake(0, 0, questionDimensions.width, questionDimensions.height)];
    [self navigateTo:currentQuestionIndex];
    [self clearAllData];
    
    parentInterview.currentQuestion.previousSelectedItemIdenifier = -1;
    
}

- (void)initialiseDefinition:(ScaleDefinition *)theDefinition {
    definition = theDefinition;
}

- (void)initialiseQuestions:(NSMutableArray *)theQuestions {
    questions = theQuestions;
}

- (void)resetAndLeaveInterview {
    
    if( [parentInterview.definition.name isEqualToString:@"COM"] ){
        if( [definition.name isEqualToString:@"MMRC"] ){
            if( score > 1 ){
                parentInterview.currentQuestion.score = 1;
            }else{
                parentInterview.currentQuestion.score = 0;
            }
        }
        if( [definition.name isEqualToString:@"CAT"] ){
            if( score >= 10 ){
                parentInterview.currentQuestion.score = 1;
            }else{
                parentInterview.currentQuestion.score = 0;
            }
        }
        parentInterview.currentQuestion.previousSelectedItemIdenifier = 1;
        [parentInterview updateScore];
    }
    
    [self clearAllData];
    [self dismiss];
    
}

- (void)adjustNavigationVisibility {

    if( [questions count] <= 1 ){
        progressIndicatorBackground.hidden = YES;
        progressIndicator.hidden = YES;
        previousButton.hidden = YES;
        nextButton.hidden = YES;
    }
    
}

- (Interview *)getParentInterview {
    Interview *theInterview;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    Scale *thisScale = home.scale;
    theInterview = thisScale.interview;
    
    return theInterview;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Interview Navigation methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)navigatePrevious {
    
    // Firstly check if the user is on the Summary Screen
    if( currentQuestionIndex == -1 ){
        currentQuestionIndex = [questions count];
        [self navigateTo:currentQuestionIndex];
        return;
    }
    
    // Normal operation
    if( currentQuestionIndex > 1 ){
        currentQuestionIndex--;
        [self navigateTo:currentQuestionIndex];
    }
}

- (IBAction)navigateNext {
    if( currentQuestionIndex < [questions count] ){
        currentQuestionIndex++;
        [self navigateTo:currentQuestionIndex];
    }else{
        currentQuestionIndex = -1;
    }
}

- (void)navigateTo:(NSInteger)newQuestionIndex {
    currentQuestionIndex = newQuestionIndex;
    
    currentQuestion = (Question *)[questions objectAtIndex:(currentQuestionIndex - 1)];
    
    [questionContent addSubview:currentQuestion];
    questionContent.contentSize = CGSizeMake(currentQuestion.frame.size.width, currentQuestion.frame.size.height);
    
    [self updateFrontend];
}

- (void)updateFrontend {
    
    questionHeading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Q%li", definition.name, (long)currentQuestion.index] withScalePrefix:NO];
    questionSubheading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Q%li_Subheading", definition.name, (long)currentQuestion.index] withScalePrefix:NO];
    
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    progressIndicatorlabel.text = [NSString stringWithFormat:NSLocalizedString(@"Scale_Progress", @""), currentQuestion.index, [questions count]];
    progressIndicator.frame = CGRectMake( ( progressIndicator.frame.size.width * ( (float)(currentQuestionIndex + 1) / (float)([questions count] + 1) ) ) - (progressIndicator.frame.size.width),
                                         questionDimensions.height - progressIndicator.frame.size.height,
                                         progressIndicator.frame.size.width,
                                         progressIndicator.frame.size.height);
    
    NSString *moreInfoReference = [NSString stringWithFormat:@"%@_Q%li_Subheading_Extended", definition.name, (long)currentQuestion.index];
    moreInfoDetail = [Helper getLocalisedString:moreInfoReference withScalePrefix:NO];
    if( [moreInfoDetail length] > 0 ){
        moreInfo.hidden = NO;
    }else{
        moreInfo.hidden = YES;
    }
    
    questionContent.contentOffset = CGPointMake(0, 0);
    [self displayNavigationButtons];
    
    [self updateScore];
}

- (void)displayNavigationButtons {
    
    if( currentQuestionIndex == -1 ){
        progressIndicatorBackground.hidden = YES;
        progressIndicator.hidden = YES;
        nextButton.hidden = YES;
    }else{
        progressIndicatorBackground.hidden = NO;
        progressIndicator.hidden = NO;
        nextButton.hidden = NO;
    }
    
    [self adjustNavigationVisibility];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Scoring methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)updateScore {
    
    score = 0;
    for( Question *aQuestion in questions ){
        score += aQuestion.score;
        if( currentQuestion == aQuestion ){
            itemScore.text = [NSString stringWithFormat:scorePrecision, currentQuestion.score];
        }
    }
    [self adjustAwkwardScaleScore];
    
    interviewScore.text = [NSString stringWithFormat:scorePrecision, score];
    [self updateCategory];
    
}

- (void)updateCategory {
    
    for(DiagnosisElement *diagnosisElement in definition.diagnosisLevels){
        if( score >= diagnosisElement.minScore ){
            currentDiagnosis = diagnosisElement;
        }
    }
    interviewScore.textColor = currentDiagnosis.colour;
    
}

- (void)adjustAwkwardScaleScore {
    
    if( [definition.name isEqualToString:@"COM"] ){
            
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)clearAllData {
    
    for( Question *aQuestion in questions ){
        [aQuestion clearDetails];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

