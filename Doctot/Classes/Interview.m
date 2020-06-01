//
//  Interview.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "Interview.h"
#import "Helper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "MiniInterview.h"

@interface Interview ()

@end

@implementation Interview

@synthesize prefs, definition;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize questions, currentQuestion;
@synthesize headerLayer1, headerLayer2, progressIndicatorlabel, itemScore, itemScoreLabel, interviewScore, interviewScoreLabel, questionHeading, questionSubheading, moreInfo, questionContent, progressIndicatorBackground, progressIndicator, progressView, progressArc, progressArcVisible, previousButton, nextButton, summary, diagnosisExtended, patientList, isNewPatient, latestPatientDtPlusId, latestAssessmentDtPlusId, miniDefinition, miniQuestions;
@synthesize currentQuestionIndex, score, scorePrecision, currentDiagnosis, moreInfoDetail, shakeEnabled, singleApp, storedScores, storedScoresAllowed, fetchedResultsController, fetchedObjects, patientObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = definition.displayTitle;
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(resetAndLeaveInterview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(goToInformation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    score = 0;
    currentQuestionIndex = 1;
    shakeEnabled = YES;
    progressArcVisible = NO;
    storedScores = [self numberOfStoredScores];
    storedScoresAllowed = [prefs integerForKey:@"MaxSaves"];
    
    itemScoreLabel.text = [Helper getLocalisedString:@"Scale_ItemLabel" withScalePrefix:NO];
    interviewScoreLabel.text = [Helper getLocalisedString:@"Scale_TotalLabel" withScalePrefix:NO];
    interviewScore.layer.cornerRadius = interviewScore.frame.size.width / 2;
    //interviewScore.layer.borderColor = [UIColor whiteColor].CGColor;
    //interviewScore.layer.borderWidth = 3.0f;
    
    [previousButton setTitle:NSLocalizedString(@"Button_Previous", @"") forState:UIControlStateNormal];
    [nextButton setTitle:NSLocalizedString(@"Button_Next", @"") forState:UIControlStateNormal];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    progressView.transform = transform;
    progressView.hidden = YES;
    
    scorePrecision = [NSString stringWithFormat:@"%%.%lif", (long)definition.precision];
    currentQuestion = [[Question alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self navigateTo:currentQuestionIndex movingForward:YES];
    [self clearAllData];
    
    for(DiagnosisElement *diagnosisElement in definition.diagnosisLevels){
        [diagnosisElement makeScaleSpecificAdjustments];
    }
    
    // Hack to get the headings roughly into the correct position at the start
    questionHeading.frame = CGRectMake( 20, 64, questionHeading.frame.size.width, questionHeading.frame.size.height);
    questionSubheading.frame = CGRectMake( questionHeading.frame.origin.x, (questionHeading.frame.origin.y + questionHeading.frame.size.height), questionSubheading.frame.size.width, questionSubheading.frame.size.height);
    
}

- (void)conjureInternalInterview:(NSString *)miniInterview {

    Interview *popupInterview;
    popupInterview = [[Interview alloc] init];
    miniDefinition = (ScaleDefinition *)[Helper generateDefinitionsArrayForSpecifiedScale:miniInterview];
    miniQuestions = [Helper createQuestionsForScale:miniDefinition];
    [self performSegueWithIdentifier:@"displayMiniInterview" sender:popupInterview];
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)resetAndLeaveInterview {
    
    UIAlertController *resetScaleAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Reset_ScaleShakeHeading", @"") andMessage:NSLocalizedString(@"Reset_ScaleShakeMessage", @"") includeCancel:NO];
        
    [resetScaleAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_Yes", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self clearAllData];
        [self dismissViewControllerAnimated:YES completion:^{}];
        [self dismiss];
    }]];
        
    [resetScaleAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_No", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
        
    [self presentViewController:resetScaleAlert animated:YES completion:nil];
    
}

- (void)goToInformation {
    Scale *theScale = [self parentScale];
    
    if( theScale.singleApp ){
        [[self navigationController] pushViewController:theScale.information animated:YES];
    }else{
        [theScale goToInformation];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Interview Navigation methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)navigatePrevious {
    
    // Firstly check if the user is on the Summary Screen
    if( currentQuestionIndex == -1 ){
        [summary removeFromSuperview];
        currentQuestionIndex = [questions count];
        [self navigateTo:currentQuestionIndex movingForward:NO];
        return;
    }
    
    // Normal operation
    if( currentQuestionIndex > 1 ){
        currentQuestionIndex--;
        [self navigateTo:currentQuestionIndex movingForward:NO];
        [self animateQuestionTransitionForiPad:NO];
    }
}

- (IBAction)navigateNext {
    if( currentQuestionIndex < [questions count] ){
        currentQuestionIndex++;
        [self navigateTo:currentQuestionIndex movingForward:YES];
        [self animateQuestionTransitionForiPad:YES];
    }else{
        currentQuestionIndex = -1;
        [self adjustAwkwardScaleScore];
        [self displaySummary];
    }
}

- (void)navigateTo:(NSInteger)newQuestionIndex movingForward:(BOOL)movingDirection {
    currentQuestionIndex = newQuestionIndex;
    
    Question *lastQuestion = currentQuestion;
    [lastQuestion tidyQuestionUponLeaving];
    
    currentQuestion = (Question *)[questions objectAtIndex:(currentQuestionIndex - 1)];
    
    [questionContent addSubview:currentQuestion];
    questionContent.contentSize = CGSizeMake(currentQuestion.frame.size.width, currentQuestion.frame.size.height);
    
    if( currentQuestionIndex < [questions count] ){
        [UIView transitionFromView:lastQuestion toView:currentQuestion duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    }
    
    [self ajustNavigationForAwkwardScale:movingDirection];
    
    [self updateFrontend];
}

- (void)updateFrontend {
    
    // Adjusting the header with padding and correct height
    float headerPadding = 10;
    float headerHeightInitialAdjustment = 14;
    headerLayer1.frame = CGRectMake(headerLayer1.frame.origin.x, headerLayer1.frame.origin.y, self.view.frame.size.width - (2 * headerPadding), headerLayer1.frame.size.height);
    if( !progressArcVisible ){
        headerLayer1.frame = CGRectMake(headerLayer1.frame.origin.x, headerLayer1.frame.origin.y, headerLayer1.frame.size.width, headerLayer1.frame.size.height + headerHeightInitialAdjustment);
    }
    float headingHeight = headerLayer1.frame.size.height / 2;
    
    // Rounded Corners on Top
    UIView *roundedView = headerLayer1;
    UIRectCorner corner = UIRectCornerTopRight | UIRectCornerTopLeft;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = roundedView.bounds;
    maskLayer.path = maskPath.CGPath;
    roundedView.layer.mask = maskLayer;
    
    // Inserting the text for Question and Question subheading
    questionHeading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"Q%li", (long)currentQuestion.index] withScalePrefix:YES];
    questionSubheading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"Q%li_Subheading", (long)currentQuestion.index] withScalePrefix:YES];
    
    // Adjusting the Question, Question subheading, itemScore & moreInfo elements with padding, correct height & visibility
    float headerLayer1Width = headerLayer1.frame.size.width;
    float itemScoreXPos = headerLayer1.frame.size.width - headingHeight;
    
    itemScore.frame = CGRectMake( itemScoreXPos, headerLayer1.frame.origin.y, headingHeight, headingHeight);
    moreInfo.frame = CGRectMake( (itemScore.frame.origin.x - headingHeight), (headerLayer1.frame.origin.y + (headingHeight / 2)), headingHeight, headingHeight);
    
    CGSize headingTextLength = [questionHeading.text sizeWithAttributes:@{NSFontAttributeName:questionHeading.font}];
    float headingMaximumWidth = headerLayer1Width - itemScore.frame.size.width - moreInfo.frame.size.width - (2 * headerPadding);
    float newHeightMultiplier = 1;
    
    // Expand the main heading height if there is no subheading
    // If there is a subheading, compute the main heading height needed AND reposition the moreInfo button
    if([questionSubheading.text length] == 0){
        headingHeight = headerLayer1.frame.size.height;
    }else{
        if( headingTextLength.width > headingMaximumWidth ) {
            int multiplier = (headingTextLength.width / headingMaximumWidth);
            newHeightMultiplier = multiplier + 1;
            headingHeight = headingTextLength.height * newHeightMultiplier;
        }
        moreInfo.frame = CGRectMake( itemScore.frame.origin.x, ( itemScore.frame.origin.y + itemScore.frame.size.height ), moreInfo.frame.size.height, moreInfo.frame.size.width);
    }
    
    questionHeading.numberOfLines = 5;
    
    questionHeading.frame = CGRectMake( (headerLayer1.frame.origin.x + headerPadding),
                                       headerLayer1.frame.origin.y,
                                       headingMaximumWidth,
                                       headingHeight
                                       );
    
    questionSubheading.numberOfLines = 5;
    questionSubheading.frame = CGRectMake( questionHeading.frame.origin.x,
                                       (questionHeading.frame.origin.y + questionHeading.frame.size.height),
                                       headingMaximumWidth,
                                       (headerLayer1.frame.size.height - questionHeading.frame.size.height)
                                       );
    
    progressIndicatorlabel.text = [NSString stringWithFormat:NSLocalizedString(@"Scale_Progress", @""), currentQuestion.index, [questions count]];
    progressIndicator.frame = CGRectMake( ( progressIndicator.frame.size.width * ( (float)(currentQuestionIndex + 1) / (float)([questions count] + 1) ) ) - (progressIndicator.frame.size.width),
                                         [UIScreen mainScreen].bounds.size.height - progressIndicator.frame.size.height,
                                         progressIndicator.frame.size.width,
                                         progressIndicator.frame.size.height);
    
    itemScore.frame = CGRectMake( itemScore.frame.origin.x, itemScore.frame.origin.y, itemScore.frame.size.width, headingHeight);
    
    if( [Helper isiPad] ){
        itemScore.frame = CGRectMake( ( questionContent.frame.origin.x + questionContent.frame.size.width - itemScore.frame.size.width ), headerLayer1.frame.origin.y, itemScore.frame.size.width, questionHeading.frame.size.height);
        moreInfo.frame = CGRectMake( itemScore.frame.origin.x, (itemScore.frame.origin.y + itemScore.frame.size.height), moreInfo.frame.size.width, moreInfo.frame.size.height);
    }
    
    progressView.progress = (float)currentQuestionIndex / (float)[questions count];
    
    NSString *moreInfoReference = [NSString stringWithFormat:@"Q%li_Subheading_Extended", (long)currentQuestion.index];
    moreInfoDetail = [Helper getLocalisedString:moreInfoReference withScalePrefix:YES];
    if( [moreInfoDetail length] > 0 ){
        moreInfo.hidden = NO;
    }else{
        moreInfo.hidden = YES;
    }
    
    if( currentQuestionIndex == 1 ){
        previousButton.hidden = YES;
    }else{
        previousButton.hidden = NO;
    }
    
    if( progressArcVisible ){
        [self showProgressArc];
    }
    progressArcVisible = YES;
    
    questionContent.contentOffset = CGPointMake(0, 0);
    [self displayNavigationButtons];
    
    [self updateScore];
    
    [self determineIfInterQuestionAlertIsToBeDisplayed];
    
}

- (void)ajustNavigationForAwkwardScale:(BOOL)movingForward {
    
    if( [definition.name isEqualToString:@"BCRSS"] ){
        /*if( !movingForward ){
            [currentQuestion clearDetails];
        }*/
    }
}

- (void)showProgressArc {
    
    int radius = (interviewScore.frame.size.height / 2);
    CGPoint centre_point = CGPointMake(0, 0);
    float percentage_complete = (float)currentQuestionIndex / (float)[questions count];
    float starting_angle = 3 * M_PI / 2;
    float ending_angle = (2 * M_PI * percentage_complete) + starting_angle;
    UIColor *arcLineColour = [Helper getColourFromString:[Helper returnValueForKey:@"ProgressArcLineColour"]];
    
    for (CALayer *layer in self.view.layer.sublayers) {
        if( layer == progressArc ){
            [layer removeFromSuperlayer];
        }
    }
    
    progressArc = [CAShapeLayer layer];
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centre_point.x, centre_point.y) radius:radius startAngle:starting_angle endAngle:ending_angle clockwise:YES];
    //[piePath addLineToPoint:CGPointMake(centre_point.x, centre_point.y)];
    
    progressArc.path = piePath.CGPath;
    //progressArc.position = CGPointMake( (self.view.frame.size.width - radius - 5), (radius + 50) );
    progressArc.position = CGPointMake( (self.view.frame.size.width / 2), ( interviewScore.frame.origin.y + (radius / 1) ) );
    progressArc.fillColor = [UIColor clearColor].CGColor;
    progressArc.strokeColor = arcLineColour.CGColor;
    progressArc.lineWidth = 3;
    
    [self.view.layer addSublayer:progressArc];
    
}

- (void)displayNavigationButtons {
    
    if( currentQuestionIndex == -1 ){
        progressIndicatorBackground.hidden = YES;
        progressIndicator.hidden = YES;
        nextButton.hidden = YES;
    }else{
        progressIndicatorBackground.hidden = YES;
        progressIndicator.hidden = YES;
        nextButton.hidden = NO;
    }
    
}

- (void)animateQuestionTransitionForiPad:(BOOL)directionNext {
    
    if( [Helper isiPad] ){
        
        float startXPos = 0, endXPos = 0;
        if( directionNext ){
            startXPos = questionContent.frame.size.width;
            endXPos = 0;
        }else{
            startXPos = (questionContent.frame.size.width * -1);
            endXPos = 0;
        }
        
        currentQuestion.frame = CGRectMake(startXPos, currentQuestion.frame.origin.y, currentQuestion.frame.size.width, currentQuestion.frame.size.height);
    
        [UIView beginAnimations:@"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration:1.0];
        
        currentQuestion.frame = CGRectMake(endXPos, currentQuestion.frame.origin.y, currentQuestion.frame.size.width, currentQuestion.frame.size.height);
        
        [UIView commitAnimations];
    
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    
    float headerPadding = 10;
    questionHeading.frame = CGRectMake( (headerLayer1.frame.origin.x + headerPadding),
                                       headerLayer1.frame.origin.y,
                                       questionHeading.frame.size.width,
                                       questionHeading.frame.size.height
                                       );
    
    questionSubheading.frame = CGRectMake( questionHeading.frame.origin.x,
                                       (questionHeading.frame.origin.y + questionHeading.frame.size.height),
                                       questionHeading.frame.size.width,
                                       (headerLayer1.frame.size.height - questionHeading.frame.size.height)
                                       );
    
    itemScore.frame = CGRectMake( ( headerLayer1.frame.origin.x + headerLayer1.frame.size.width - itemScore.frame.size.width ), questionHeading.frame.origin.y, itemScore.frame.size.width, questionHeading.frame.size.height);
    moreInfo.frame = CGRectMake( itemScore.frame.origin.x, (itemScore.frame.origin.y + itemScore.frame.size.height), moreInfo.frame.size.width, moreInfo.frame.size.height);
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Code to reset a question after User Shake
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if ( event.subtype == UIEventSubtypeMotionShake ){
        
        NSString *shakePreference = (NSString *)[prefs objectForKey:@"ShakeToReset"];
        BOOL shakeResult = NO;
        if( [shakePreference isEqualToString:@"Activated"] ){
            shakeResult = YES;
        }
        
        if( shakeResult ){
            
            if( currentQuestion.previousSelectedItemIdenifier == -1 ){
                [self resetAndLeaveInterview];
            }else{
                [currentQuestion clearDetails];
            }
            
        }
        
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
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
            itemScore.hidden = !aQuestion.questionStructure.showScore;
            if( aQuestion.score == -1 ){
                itemScore.text = @"";
            }
        }
    }
    [self adjustAwkwardScaleScore];
    
    interviewScore.text = [NSString stringWithFormat:scorePrecision, score];
    
    [self adjustAwkwardPostScaleScore];
    [self updateCategory];
    
}

- (void)updateCategory {
 
    for(DiagnosisElement *diagnosisElement in definition.diagnosisLevels){
        if( score >= diagnosisElement.minScore ){
            currentDiagnosis = diagnosisElement;
        }
    }
    interviewScore.backgroundColor = currentDiagnosis.colour;
    
}

- (void)adjustAwkwardScaleScore {
    
    if( [definition.name isEqualToString:@"CGI"] ){
        
        float severityScore = -1.0;
        float improvementScore = -1.0;
        float efficacyTherapeuticScore = -1.0;
        float efficacySideEffectsScore = -1.0;
        float efficacyCombinedScore = -1.0;
        for( Question *aQuestion in questions ){
            if( (aQuestion.index == 1) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                severityScore = aQuestion.score;
            }
            if( (aQuestion.index == 2) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                improvementScore = aQuestion.score;
            }
            if( (aQuestion.index == 3) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                efficacyTherapeuticScore = aQuestion.score;
            }
            if( (aQuestion.index == 4) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                efficacySideEffectsScore = aQuestion.score;
            }
        }
        
        if( ( severityScore == -1.0 ) || ( improvementScore == -1.0 ) || ( efficacyTherapeuticScore == -1.0 ) || ( efficacySideEffectsScore == -1.0 ) ){
            score = 0;
        }else{
            efficacyCombinedScore = ((efficacyTherapeuticScore - 1) * 4) + (efficacySideEffectsScore + 1);
            if( efficacyTherapeuticScore == 0 ){
                efficacyCombinedScore = 0;
            }
            score = (severityScore * 1000) + (improvementScore * 100) + efficacyCombinedScore;
        }
        
    }
    
    if( [definition.name isEqualToString:@"GDS"] ){
        
        score = 0;
        float adjustedScore = 0.0;
        int unansweredQuestions = 0;
        for( Question *aQuestion in questions ){
            if( aQuestion.score == -1 ){
                unansweredQuestions++;
            }else{
                score += aQuestion.score;
            }
            //NSLog(@"aQuestion[%li]: %f (ua: %i)", (long)aQuestion.index, aQuestion.score, unansweredQuestions);
        }
        
        if( currentQuestion.score == -1 ){
            itemScore.text = @"-";
        }
        
        // More than 5 missing questions invalidates the scale
        if( unansweredQuestions > 5 ){
            score = -1;
        }else{
            adjustedScore = score * ( [questions count] / ([questions count] - unansweredQuestions) );
            score = adjustedScore;
            interviewScore.text = [NSString stringWithFormat:@"%.0f", score];
        }
        
    }

    if( [definition.name isEqualToString:@"COM"] ){
        
        float fev1 = -1;
        float symptoms = -1;
        float exacerbtions = -1;
        for( Question *aQuestion in questions ){
            if( (aQuestion.index == 1) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                fev1 = aQuestion.score;
            }
            if( (aQuestion.index == 2) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                symptoms = aQuestion.score;
            }
            if( (aQuestion.index == 3) && (aQuestion.previousSelectedItemIdenifier != -1) ){
                exacerbtions = aQuestion.score;
            }
        }
        
        float interimCOMScore = -1;
        if( (symptoms == 0) && (exacerbtions == 0) )    interimCOMScore = 0;
        if( (symptoms == 1) && (exacerbtions == 0) )    interimCOMScore = 4;
        if( (symptoms == 0) && (exacerbtions == 1) )    interimCOMScore = 8;
        if( (symptoms == 1) && (exacerbtions == 1) )    interimCOMScore = 12;
        
        score = interimCOMScore + fev1;
        if( (interimCOMScore == -1) || (fev1 == -1) ){
            score = 0;
        }
    }
    
    if( [definition.name isEqualToString:@"CACH"] ){
        
        float calcium = 0.0;
        float albumin = 0.0;
        float normalAlbumin = 0.0;
        for( Question *aQuestion in questions ){
            if( (aQuestion.index == 1) ){
                calcium = aQuestion.score;
            }
            if( (aQuestion.index == 2) ){
                albumin = aQuestion.score;
            }
            if( (aQuestion.index == 3) ){
                normalAlbumin = aQuestion.score;
            }
        }
        
        if( (calcium == 0)|| (albumin == 0)|| (normalAlbumin == 0) ){
            score = 0;
        }else{
            // Adjustments for non-typical units
            float adjustedCalcium = calcium;
            float adjustedAlbumin = albumin;
            float adjustedNormalAlbumin = normalAlbumin;
            // If calcium is in mmol/L, we need to adjust it to mg/dL.
            //"Settings_CACH_CalciumUnits_Choice0" = "mg/dL";     "Settings_CACH_CalciumUnits_Choice1" = "mmol/L";
            if( [[prefs objectForKey:@"cachCalciumUnits"] isEqualToString:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice1" withScalePrefix:NO]] ){
                adjustedCalcium = calcium / CACH_CALCIUM_FACTOR;
            }
            // If albumin is in g/L, we need to adjust it to g/dL.
            //"Settings_CACH_AlbuminUnits_Choice0" = "g/dL";      "Settings_CACH_AlbuminUnits_Choice1" = "g/L";
            if( [[prefs objectForKey:@"cachAlbuminUnits"] isEqualToString:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice1" withScalePrefix:NO]] ){
                adjustedAlbumin = albumin / CACH_ALBUMIN_FACTOR;
                adjustedNormalAlbumin = normalAlbumin / CACH_ALBUMIN_FACTOR;
            }
            score = adjustedCalcium + (0.8 * (adjustedNormalAlbumin - adjustedAlbumin));
        }
                
    }
    
    if( [definition.name isEqualToString:@"BERG"] ){
        
        // BERG Q3
        // Checks if Q2 was set to score of 4 => Q3 should also be set to score of 4 also
        if( currentQuestion.index == 3 ) {
            // Q2
            Question *questionTwo = (Question *)[questions objectAtIndex:1];
            
            // Determine if any value has been set for Q3 yet
            BOOL workingBackwards = NO;
            for( ItemButton *aButton in currentQuestion.subviews ){
                if( [aButton isKindOfClass:[ItemButton class]] ){
                    if( aButton.status != 0 ){
                        workingBackwards = YES;
                    }
                }
            }
            
            // If Q3 was not already used, then check if Q2 has a score of 4. If YES, set Q3 to score of 4 also AND move to next Question, Q4
            if( !workingBackwards && ( questionTwo.score == 4 ) ){
                for( ItemButton *aButton in currentQuestion.subviews ){
                    if( [aButton isKindOfClass:[ItemButton class]] ){
                        if( aButton.index == 5 ){
                            [aButton setItemStatus:BUTTON_STATE_CONFIRMED];
                            currentQuestion.score = aButton.score;
                        }
                    }
                }
                [self navigateNext];
                
                //UIAlertController *skipQuestionAlert = [UIAlertController alertControllerWithTitle:[Helper getLocalisedString:@"BERG_Q3_AutomatedEntry_Heading" withScalePrefix:NO] message:[Helper getLocalisedString:@"BERG_Q3_AutomatedEntry_Message" withScalePrefix:NO] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertController *skipQuestionAlert = [Helper defaultAlertController:self withHeading:[Helper getLocalisedString:@"BERG_Q3_AutomatedEntry_Heading" withScalePrefix:NO] andMessage:[Helper getLocalisedString:@"BERG_Q3_AutomatedEntry_Message" withScalePrefix:NO] includeCancel:NO];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [skipQuestionAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                [skipQuestionAlert addAction:ok];
                [self presentViewController:skipQuestionAlert animated:YES completion:nil];
            }
            
        }
        
    }
    
    if( [definition.name isEqualToString:@"AINT"] ){
        
        score = 0;
        
        BOOL symptomsAsymptomatic = NO;
        BOOL symptomsMild = NO;
        BOOL symptomsModerateSevere = NO;
        BOOL symptomsDyspnoeaPresent = NO;
        BOOL ageUnder70 = NO;
        int prognosticFactorsCount = 0;
        BOOL chestXRayPneumonia = NO;
        BOOL chestXRayPneumoniaSevere = NO;
        BOOL respiratoryIssues = NO;
        BOOL hospitalOnset = NO;
        
        for( Question *aQuestion in questions ){
            
            // Q1: Age
            if( aQuestion.index == 1 ){
                if( aQuestion.score != aQuestion.questionStructure.defaultScore ){
                    if( aQuestion.score < 70 ){
                        ageUnder70 = YES;
                    }else{
                        prognosticFactorsCount++;
                    }
                }
            }
            
            // Q2: Gender
            if( aQuestion.index == 2 ){
                if( aQuestion.score == 1 ){
                    prognosticFactorsCount++;
                }
            }
            
            // Q3: Clinical Presentation / Symptoms (Fever / Cough / Nasal)
            if( aQuestion.index == 3 ){
                
                // Dyspnoea Status
                NSString *q3ScoreAsString = [NSString stringWithFormat:@"%.0f", aQuestion.score];
                if( [q3ScoreAsString length] >= 6 ){
                    // Gets the 6th digit, wich reflect the Dyspnoea item
                    NSString *dyspnoeaCharacter = [[q3ScoreAsString substringFromIndex:([q3ScoreAsString length] - 6)] substringToIndex:1];
                    if( [dyspnoeaCharacter integerValue] == 1 ){
                        symptomsDyspnoeaPresent = YES;
                    }
                }
                
                // Asymptomtic
                if( aQuestion.score == 0 ){
                    symptomsAsymptomatic = YES;
                }
                
                // Mild But Still Group1 (as far as Clinical Presentation / Symptoms are concerned)
                if( aQuestion.score == 1 ){
                    symptomsMild = YES;
                }
                
                // Severe
                if( aQuestion.score > 1 ){
                    symptomsModerateSevere = YES;
                }
                
            }
            
            // Q4: Prognostic Factors (Coronary Artery / Pregnant)
            if( aQuestion.index == 4 ){
                if( aQuestion.score > 0 ){
                    prognosticFactorsCount++;
                }
            }
            
            // Q5: Chest X-Ray
            if( aQuestion.index == 5 ){
                if( aQuestion.score == 1 ){
                    chestXRayPneumonia = YES;
                }
                if( aQuestion.score > 1 ){
                    chestXRayPneumoniaSevere = YES;
                }
            }
            
            // Q6: Respiratory Status (Respiratory Failure or Haemodynamic Instability)
            if( aQuestion.index == 6 ){
                if( aQuestion.score > 0 ){
                    respiratoryIssues = YES;
                }
            }
            
            // Q7: Onset Location
            if( aQuestion.index == 7 ){
                if( aQuestion.score == 1 ){
                    hospitalOnset = YES;
                }
            }
            
        }
        
        // Assigning the score based on the question answers
        // Group 1
        if( symptomsAsymptomatic || ( symptomsMild && !symptomsDyspnoeaPresent && ageUnder70 && (prognosticFactorsCount == 0) && !chestXRayPneumonia && !chestXRayPneumoniaSevere ) ){
            score = 1;
        }
        // Group 2
        if(
           ( (symptomsMild || symptomsModerateSevere) && symptomsDyspnoeaPresent ) || 
           ( chestXRayPneumonia && !chestXRayPneumoniaSevere ) ||
           ( symptomsMild && (prognosticFactorsCount > 0) )
        ){
            score = 2;
        }
        // Group 3
        if( chestXRayPneumoniaSevere && respiratoryIssues ){
            score = 3;
        }
        // Group 4
        if( hospitalOnset ){
            score = 4;
        }
        
    }
    
    // End of AINT
    
    if( [definition.name isEqualToString:@"BCRSS"] ){
    
        score = 0;
        [summary removeFromSuperview];
        
        BOOL covid19PostiveQ1 = NO;
        BOOL covid19PostiveQ2 = NO;
        int criteriaPositiveCount = 0;
        Question *q5;
        BOOL q5q6Positive = NO;
        Question *q8;
        BOOL q8Positive = NO;
        Question *q9;
        BOOL q9Positive = NO;
        Question *q10;
        Question *q11;
        BOOL q11Positive = NO;
        Question *q12;
        BOOL q12Positive = NO;
        
        for( Question *aQuestion in questions ){
            
            // Q1: COVID-19 Status
            if( ( aQuestion.index == 1 ) && ( aQuestion.score > 0 ) ){
                covid19PostiveQ1 = YES;
            }
            // Q2: PCR Status
            if( ( aQuestion.index == 2 ) && ( aQuestion.score > 0 ) ){
                covid19PostiveQ2 = YES;
            }
            
            // Q3: Criteria 1 - Dyspnoea
            if( ( aQuestion.index == 3 ) && ( aQuestion.score == 1 ) ){
                criteriaPositiveCount++;
            }
            // Q4: Criteria 2 - Breating Rate (scoreLevel 1 = score > 22)
            if( ( aQuestion.index == 4 ) && ( aQuestion.scoreLevel == 1 ) ){
                criteriaPositiveCount++;
            }
            // Q5: Criteria 3a - PaO2 (scoreLevel 2 = score < 65)
            if( aQuestion.index == 5 ){
                q5 = aQuestion;
                if( aQuestion.scoreLevel == 2 ) {
                    criteriaPositiveCount++;
                    q5q6Positive = YES;
                }
                
            }
            // Q6: Criteria 3b - SpO2 (scoreLevel 2 = score < 90)
            if( ( aQuestion.index == 6 ) && ( aQuestion.scoreLevel == 2 ) ){
                if( !q5q6Positive ){
                    criteriaPositiveCount++;
                }
                q5q6Positive = YES;
            }
            // Q7: Criteria 4 - Chest X-Ray
            if( ( aQuestion.index == 7 ) && ( aQuestion.score == 1 ) ){
                criteriaPositiveCount++;
            }
            
            // Q8: HFNC, NIV
            if( aQuestion.index == 8 ){
                q8 = aQuestion;
                if( aQuestion.score == 1  ){
                    q8Positive = YES;
                }
            }
            
            // Q9: CMV
            if( aQuestion.index == 9 ){
                q9 = aQuestion;
                if( aQuestion.score == 1  ){
                    q9Positive = YES;
                }
            }
            
            // Q10: PaO2 / FiO2
            if( aQuestion.index == 10 ){
                q10 = aQuestion;
            }
            
            // Q11: NMBA
            if( aQuestion.index == 11 ){
                q11 = aQuestion;
                if( aQuestion.score == 1  ){
                    q11Positive = YES;
                }
            }
            
            // Q12: ECLS
            if( aQuestion.index == 12 ){
                q12 = aQuestion;
                if( aQuestion.score == 1  ){
                    q12Positive = YES;
                }
            }
            
        }
        
        // Not a Covid-19 case
        if( currentQuestionIndex == 3 ){
            if( !covid19PostiveQ1 && !covid19PostiveQ2 ) {
                score = 11;
            }else{
                score = 0;
            }
        }
        
        // Initial Criteria Evaluation
        if( currentQuestionIndex == 8  ){
            if( q8.score == q8.questionStructure.defaultScore ){
                if( criteriaPositiveCount <= 2 ){
                    score = criteriaPositiveCount;
                }
                if( criteriaPositiveCount == 0 ){
                    score = 10;
                }
            }else{
                score = 0;
            }
        }
        
        // Decision on HFNC, NIV ("No" confirms Level 3)
        if( currentQuestionIndex == 9  ){
            if( q9.score == q9.questionStructure.defaultScore ){
                if( !q8Positive ){
                    score = 3;
                }
            }else{
                score = 0;
            }
        }
        
        // Decision on CMV ("No" means Level 4)
        if( currentQuestionIndex == 10  ){
            if( q10.score == q10.questionStructure.defaultScore ){
                if( !q9Positive ){
                    score = 4;
                }
            }else{
                score = 0;
            }
        }
        
        // Decision on PaO2 / FiO2 ("No" means Level 5)
        if( currentQuestionIndex == 11  ){
            if( q11.score == q11.questionStructure.defaultScore ){
                float pao2fio2 = q5.score / (q10.score / 100);
                if( pao2fio2 >= 150 ){
                    score = 5;
                }
            }else{
                score = 0;
            }
        }
        
        // Decision on NMBA ("No" means Level 6)
        if( currentQuestionIndex == 12  ){
            if( q12.score == q12.questionStructure.defaultScore ){
                if( !q11Positive ){
                    score = 6;
                }
            }else{
                if( !q12Positive ){
                    score = 7;
                }else{
                    score = 8;
                }
            }
        }
        
        // Jump to the end
        if( score > 0 ){
            [self updateCategory];
            [self displaySummary];
        }
    
    }
    
    // End of BCRSS
    
    if( [definition.name isEqualToString:@"HORW"] ){
        
        score = 0;
        
        float pao2Score = 0;
        float fio2Score = 0;
        
        for( Question *aQuestion in questions ){
            // Q1: PaO2
            if( aQuestion.index == 1 ){
                pao2Score = aQuestion.score;
            }
            // Q2: FiO2
            if( aQuestion.index == 2 ){
                fio2Score = aQuestion.score;
            }
        }
        
        if( ( pao2Score > 0 ) && ( fio2Score > 0 ) ){
            score = ( pao2Score * 100 ) / fio2Score;
        }
        
    }
    
    // End of HORW
    
    if( [definition.name isEqualToString:@"BERL"] ){
        
        score = 0;
        
        int criteriaCount = 0;
        BOOL riskFactorStatus = NO;
        int severityPart1 = 0;
        int severityPart2 = 0;
        
        for( Question *aQuestion in questions ){
            // Q1-Q3: Requested Criteria (All Needed for Positive ARDS)
            if( ( ( aQuestion.index == 1 ) || ( aQuestion.index == 2 ) || ( aQuestion.index == 3 ) ) && ( aQuestion.score > 0 ) ){
                criteriaCount++;
            }
            // Q4: Risk Factor (All Needed for Positive ARDS)
            if( ( aQuestion.index == 4 ) && ( aQuestion.score >= 0 ) ){
                riskFactorStatus = YES;
            }
            // Q5-Q6: Risk Factor (All Needed for Positive ARDS)
            if( aQuestion.index == 5 ){
                severityPart1 = aQuestion.scoreLevel;
            }
            if( aQuestion.index == 6 ){
                severityPart2 = aQuestion.scoreLevel;
            }
        }
        
        BOOL severityCompletionStatus = NO;
        if( ( severityPart1 > 0 ) && ( severityPart2 > 0 ) ){
            severityCompletionStatus = YES;
        }
        
        BOOL severityPositiveStatus = NO;
        if( ( ( severityPart1 == 2 ) || ( severityPart1 == 3 ) || ( severityPart1 == 4 ) ) && ( severityPart2 == 1 ) ){
            severityPositiveStatus = YES;
        }
        
        if( ( criteriaCount == 0 ) || ( !riskFactorStatus ) || ( !severityCompletionStatus ) ){
            score = 0;
        }else{
            if( ( criteriaCount == 3 ) && ( riskFactorStatus ) && ( severityPositiveStatus ) ){
                score = 2;
            }else{
                score = 1;
            }
        }
        
    }
    
    // End of BERL
    
}

- (void)adjustAwkwardPostScaleScore {
    
    if( [definition.name isEqualToString:@"CGI"] ){
        interviewScore.text = [NSString stringWithFormat:@"%.0f", score];
    }
    
    if( [definition.name isEqualToString:@"GDS"] ){
        if( score == -1 ){
            interviewScore.text = @"--";
        }
    }
    
    if( [definition.name isEqualToString:@"CACH"] ){
        if( score == 0 ){
            interviewScore.text = @"--";
        }
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Question-specific methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)displayMoreInfo {
    
    //UIAlertController *moreInfoAlert = [UIAlertController alertControllerWithTitle:currentQuestion.title message:moreInfoDetail preferredStyle:UIAlertControllerStyleAlert];
    UIAlertController *moreInfoAlert = [Helper defaultAlertController:self withHeading:currentQuestion.title andMessage:moreInfoDetail includeCancel:NO];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [moreInfoAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [moreInfoAlert addAction:ok];
    [self presentViewController:moreInfoAlert animated:YES completion:nil];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Question-specific methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)determineIfInterQuestionAlertIsToBeDisplayed {
    
    NSString *initialHeadingReference = [NSString stringWithFormat:@"Q%li_Initial", (long)currentQuestion.index];
    NSString *initialHeading = [Helper getLocalisedString:initialHeadingReference withScalePrefix:YES];
    if( [initialHeading length] > 0 ){
        NSString *initialMessageReference = [NSString stringWithFormat:@"Q%li_Initial_Subheading", (long)currentQuestion.index];
        NSString *initialMessage = [Helper getLocalisedString:initialMessageReference withScalePrefix:YES];
        
        if( ( [definition.name isEqualToString:@"MTS"] ) && ( currentQuestion.index == 3 ) ){
            initialMessage = [initialMessage stringByAppendingFormat:@"\n%@", (NSString *)[prefs objectForKey:@"mtsAddress"]];
        }
        
        if( [definition.name isEqualToString:@"BCRSS"] ){
            if( score > 0 ){
                return;
            }
        }
        
        //UIAlertController *initialAlert = [UIAlertController alertControllerWithTitle:initialHeading message:initialMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertController *initialAlert = [Helper defaultAlertController:self withHeading:initialHeading andMessage:initialMessage includeCancel:NO];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [initialAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [initialAlert addAction:ok];
        [self presentViewController:initialAlert animated:YES completion:nil];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Summary methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)displaySummary {
    
    progressIndicatorlabel.text = @"";
    questionHeading.text = [Helper getLocalisedString:@"Final_Score_Intro" withScalePrefix:YES];
    questionSubheading.text = [Helper getLocalisedString:@"Final_Score_Instruction" withScalePrefix:YES];
    itemScore.text = @"";
    
    summary.frame = CGRectMake(0, 0, questionContent.frame.size.width, questionContent.frame.size.height);
    summary.score = score;
    summary.scaleDefinition = definition;
    summary.diagnosis = currentDiagnosis;
    [summary initialise];
    
    moreInfo.hidden = YES;
    [self displayNavigationButtons];
    
    summary.questionsIncomplete.hidden = [self checkIfAllQuestionsAreAnswered];
    
    [self adjustSummaryForAwkwardScale];
    
    [questionContent addSubview:summary];
    
}

- (IBAction)displayExtendedDiagnosis {
    
    if( [summary.diagnosis.descriptionHTML length] > 0 ){
        [self performSegueWithIdentifier:@"displayDiagnosisExtended" sender:definition];
    }
    
}

- (BOOL)checkIfAllQuestionsAreAnswered {
    BOOL allQuestionsAnswered = YES;
    
    BOOL currentQuestionAnswered;
    for( Question *aQuestion in questions ){
        currentQuestionAnswered = NO;
        // For Buttons
        if( aQuestion.selectedItem != NULL ){
            currentQuestionAnswered = YES;
        }
        // For all other Items
        if( aQuestion.selectedItemIdenifier == 1 ){
            currentQuestionAnswered = YES;
        }
        // Final Analysis
        if( !currentQuestionAnswered ){
            allQuestionsAnswered = NO;
        }
    }
    
    return allQuestionsAnswered;
}

- (void)adjustSummaryForAwkwardScale {
    
    // CACH Calcium Correction
    if( [definition.name isEqualToString:@"CACH"] ){
        if( [(NSString *)[prefs objectForKey:@"cachCalciumUnits"] isEqualToString:@"mg/dL"] ){
            summary.scoreLabel.text = [summary.scoreLabel.text stringByAppendingFormat:@" %@", [prefs objectForKey:@"cachCalciumUnits"]];
        }else{
            //float
            summary.scoreLabel.text = [summary.scoreLabel.text stringByAppendingFormat:@" mg/dL (%.1f %@)", (score / 4), [prefs objectForKey:@"cachCalciumUnits"]];
        }
        
    }
    
    if( [definition.name isEqualToString:@"BCRSS"] ){
        summary.questionsIncomplete.hidden = YES;
        previousButton.hidden = YES;
        nextButton.hidden = YES;
    }
    
}

- (IBAction)displayPatientList {
    
    [self performSegueWithIdentifier:@"patientList" sender:definition];
    
}

- (IBAction)displayIncompleteQuestionsDetectedWarning {
    
    /*UIAlertController *incompleteQuestionAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Save_QuestionsUnansweredHeading", @"")
                                                                           message:NSLocalizedString(@"Save_QuestionsUnansweredMessage", @"")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    */
    UIAlertController *incompleteQuestionAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Save_QuestionsUnansweredHeading", @"") andMessage:NSLocalizedString(@"Save_QuestionsUnansweredMessage", @"") includeCancel:NO];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [incompleteQuestionAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [incompleteQuestionAlert addAction:ok];
    [self presentViewController:incompleteQuestionAlert animated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"[segue identifier]: %@", [segue identifier]);
    if([[segue identifier] isEqualToString:@"displayDiagnosisExtended"]){
        
        diagnosisExtended = (DiagnosisExtended *)segue.destinationViewController;
        diagnosisExtended.diagnosis = currentDiagnosis;
        diagnosisExtended.scaleDefinition = definition;
        diagnosisExtended.score = score;
        diagnosisExtended.resultString = summary.scoreLabel.text;
        
    }
    
    if([[segue identifier] isEqualToString:@"patientList"]){
        
        patientList = (Scores *)segue.destinationViewController;
        summary.patientListActivated = NO;
        
    }
    
    if([[segue identifier] isEqualToString:@"displayMiniInterview"]){
        
        MiniInterview *miniInterview = (MiniInterview *)segue.destinationViewController;
        [miniInterview initialiseDefinition:miniDefinition];
        [miniInterview initialiseQuestions:miniQuestions];
        
    }
    
}

- (IBAction)saveScore {
    
    // Confirm name is entered with no apostrophe
    if( ( [summary.firstName.text length] == 0 ) || ( [summary.lastName.text length] == 0 ) || ( ![Helper validNameCharacters:summary.firstName.text]  ) || ( ![Helper validNameCharacters:summary.lastName.text]  ) ){
        summary.firstName.backgroundColor = [UIColor clearColor];
        summary.lastName.backgroundColor = [UIColor clearColor];
        
        if( ![Helper validNameCharacters:summary.firstName.text] ){
            summary.firstName.text = @"";
        }
        if( ![Helper validNameCharacters:summary.lastName.text] ){
            summary.lastName.text = @"";
        }
        
        if( [summary.firstName.text length] == 0 ){
            summary.firstName.backgroundColor = [Helper getColourFromString:@"alphaRed"];
            summary.firstName.placeholder = [Helper getLocalisedString:@"Save_AplhaNumericError" withScalePrefix:NO];
        }
        if( [summary.lastName.text length] == 0 ){
            summary.lastName.backgroundColor = [Helper getColourFromString:@"alphaRed"];
            summary.lastName.placeholder = [Helper getLocalisedString:@"Save_AplhaNumericError" withScalePrefix:NO];
        }
        
        return;
    }
    
    // NB: DISABLED AS DEEMED UNNECESSARY (hence 1==2 ; block is never executed)
    // Check max number of scores has been reached
    if( ( storedScores >= storedScoresAllowed ) && (1==2) ){
    
        /*UIAlertController *scoresFullAlert = [UIAlertController alertControllerWithTitle:[Helper getLocalisedString:@"Save_ScoresFullHeading" withScalePrefix:NO]
                                                                                  message:[Helper getLocalisedString:@"Save_ScoresFullMessage" withScalePrefix:NO]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        */
        UIAlertController *scoresFullAlert = [Helper defaultAlertController:self withHeading:[Helper getLocalisedString:@"Save_ScoresFullHeading" withScalePrefix:NO] andMessage:[Helper getLocalisedString:@"Save_ScoresFullMessage" withScalePrefix:NO] includeCancel:NO];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [scoresFullAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [scoresFullAlert addAction:ok];
        [self presentViewController:scoresFullAlert animated:YES completion:nil];
        
        return;
        
    }
    
    // Check if the Patient's name has already been stored in the app
        // If so, alert the user, offering to attach the score to the Patient's history or to insert a different name
    fetchedObjects = [Helper resultsFromTable:@"Patient" forQuery:[NSString stringWithFormat:@"firstName == '%@', lastName == '%@'", summary.firstName.text, summary.lastName.text] ofType:@"AND" sortedBy:@"lastName" sortDirections:@"Ascending"];
    isNewPatient = ![self isNameAlreadyInPatientList];
    
    if( ( !isNewPatient )  && ( summary.patientListActivated ) ){
        
        /*UIAlertController *scoresFullAlert = [UIAlertController alertControllerWithTitle:[Helper getLocalisedString:@"Save_ScoresPatientExistsHeading" withScalePrefix:NO]
                                                                                     message:[Helper getLocalisedString:@"Save_ScoresPatientExistsMessage" withScalePrefix:NO]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        */
        UIAlertController *scoresFullAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Save_ScoresPatientExistsHeading", @"") andMessage:NSLocalizedString(@"Save_ScoresPatientExistsMessage", @"") includeCancel:YES];
        
        UIAlertAction* attach = [UIAlertAction actionWithTitle:@"Attach to Patient" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self saveScoreCompletion];
        }];
        [scoresFullAlert addAction:attach];
        
        /*UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [scoresFullAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [scoresFullAlert addAction:cancel];
        */
        [self presentViewController:scoresFullAlert animated:YES completion:nil];
        
    }else{
    
        // If not, carry on with the save process
        [self saveScoreCompletion];
        
    
    }
    
    
}

- (void)saveScoreCompletion {
    
    // Make the call to Doctot Plus to record the Assessment and sort out Patient also
    [self recordDTPlusAssessment];
    
    // Check for email
    NSString *emailActive = [prefs stringForKey:@"EmailScores"];
    if( [emailActive length] > 0 ){
        [self generateEmail];
    }else{
        [self saveScoreToCoreDataAndDismiss];
    }
    
}

- (void)saveScoreToCoreDataAndDismiss {
    
    /* Send the data to Firebase
    NSMutableDictionary *saveAssessmentParameters = [[NSMutableDictionary alloc]initWithCapacity:3];
    [saveAssessmentParameters setObject:definition.name forKey:@"scale"];
    [saveAssessmentParameters setObject:[NSNumber numberWithFloat:score] forKey:@"score"];
    [saveAssessmentParameters setObject:currentDiagnosis.name forKey:@"diagnosis"];
    
    [Helper postFirebaseEventForEventName:@"saveAssessment" withContent:saveAssessmentParameters];
    */
    
    // Save to Core Data
    
    if( isNewPatient ){
        // New Patient: Create New Patient, Create new Interview, Link Interview to Patient
        patientObject = [self saveAsNewPatient];
    }else{
        // Existing Patient: Retrieve Patient, Create new Interview, Link Interview to Patient
    }
    
    DataInterview *interviewObject = [[DataInterview alloc] init];
    interviewObject.scale = definition.name;
    interviewObject.score = score;
    interviewObject.scoreCategory = currentDiagnosis.name;
    [interviewObject initialiseCreationDateAndTime:[NSString stringWithFormat:@"%@%@", summary.firstName.text, summary.lastName.text]];
    [Helper createRecordinTable:@"Interview" withObject:interviewObject andParentObject:patientObject];
    
    int theIndex = 1;
    DataQuestion *questionObject;
    for( Question *aQuestion in questions ){
        questionObject = [[DataQuestion alloc] init];
        questionObject.scale = definition.name;
        questionObject.index = theIndex;
        questionObject.score = aQuestion.score;
        questionObject.item = aQuestion.selectedItemIdenifier;
        questionObject.customInformation = aQuestion.answerCustomInformation;
        questionObject.uniqueID = [NSString stringWithFormat:@"%@%@%li", interviewObject.uniqueID, questionObject.scale, (long)questionObject.item];
        [Helper createRecordinTable:@"Question" withObject:questionObject andParentObject:interviewObject];
        theIndex++;
    }
    
    // Confirm the Save & Dismiss the ViewController
    
    [summary.firstName resignFirstResponder];
    [summary.lastName resignFirstResponder];
    [[self navigationController] popViewControllerAnimated:YES];
    
    /*
    UIAlertController *dismissAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Save_ScoresPatientExistsHeading", @"") andMessage:NSLocalizedString(@"Save_ScoresPatientExistsMessage", @"") includeCancel:YES];
    [self presentViewController:dismissAlert animated:YES completion:nil];
    */
}

- (BOOL)isNameAlreadyInPatientList {
    BOOL isNameAlreadyInStored = NO;

    NSArray *fetchedPatients = fetchedObjects;
    
    if( [fetchedPatients count] > 0 ){
        isNameAlreadyInStored = YES;
        patientObject = (DataPatient *)[fetchedPatients objectAtIndex:0];
    }
    
    return isNameAlreadyInStored;
}

- (DataPatient *)saveAsNewPatient {

    DataPatient *thePatient = [[DataPatient alloc] init];
    
    thePatient.firstName = summary.firstName.text;
    thePatient.lastName = summary.lastName.text;
    thePatient.hospitalNo = @"";
    thePatient.dob = nil;
    thePatient.notes = @"";
    thePatient.dtPlusID = latestPatientDtPlusId;
    
    // Adjusted hospitalNo
    if( [thePatient.hospitalNo length] == 0 ){
        int patientIndex = 1;
        NSArray *patientCohort = [Helper resultsFromTable:@"Patient" forQuery:@"uniqueID == '*'" ofType:@"AND" sortedBy:@"" sortDirections:@""];
        //DataPatient *lastPatient = (DataPatient *)[patientCohort lastObject];
        //patientIndex = [lastPatient.hospitalNo intValue] + 1;
        NSLog(@"[patientCohort count]: %i", (int)[patientCohort count]);
        patientIndex = (int)[patientCohort count] + 1;
        [thePatient setHospitalNumberBy:patientIndex];
    }
    
    // Unique ID depends on whether a DOB is specified
    if( thePatient.dob == nil ){
        //thePatient.dob = [NSDate date];
        thePatient.uniqueID = [NSString stringWithFormat:@"%@%@%@%@", thePatient.hospitalNo, thePatient.firstName, thePatient.lastName, [NSDate date]];
    }else{
        thePatient.uniqueID = [NSString stringWithFormat:@"%@%@%@%@", thePatient.hospitalNo, thePatient.firstName, thePatient.lastName, thePatient.dob];
    }
    
    [Helper createRecordinTable:@"Patient" withObject:thePatient andParentObject:nil];
    
    return thePatient;
    
}

- (void)generateEmail {

    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    NSArray *recipients = [NSArray arrayWithObject:[prefs stringForKey:@"Email"]];
    NSString *theSubject = [NSString stringWithFormat:@"%@ %@ %@ %@", definition.displayTitle, [Helper getLocalisedString:@"Email_Subject" withScalePrefix:NO], summary.firstName.text, summary.lastName.text];
    NSString *theMessageBody = [self createEmailBody];
    
    [composeVC setToRecipients:recipients];
    [composeVC setSubject:theSubject];
    [composeVC setMessageBody:theMessageBody isHTML:NO];
    
    // Present the view controller modally.
    if( [MFMailComposeViewController canSendMail] ){
        [self presentViewController:composeVC animated:YES completion:nil];
        //[self.view.window.rootViewController presentViewController:composeVC animated:YES completion:nil];
    }
    
}

- (NSString *)createEmailBody {
    NSString *emailBody = @"";
    emailBody = [emailBody stringByAppendingFormat:@"%@: %@ (%@)\n\n", questionHeading.text, summary.scoreLabel.text, [summary.diagnosis formatDescriptionForObjectiveC]];
    
    for( Question *aQuestion in questions ){
        if( [aQuestion.answerCustomInformation length] > 0 ){
            emailBody = [emailBody stringByAppendingFormat:@"%@ = %@ \n(%@)\n", aQuestion.title, [NSString stringWithFormat:scorePrecision, aQuestion.score], aQuestion.answerCustomInformation];
        }else{
            emailBody = [emailBody stringByAppendingFormat:@"%@ = %@\n", aQuestion.title, [NSString stringWithFormat:scorePrecision, aQuestion.score]];
        }
    }
    
    return emailBody;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self saveScoreToCoreDataAndDismiss];

}

- (void)recordDTPlusAssessment {
    
    NSString *theFirstName = summary.firstName.text;
    NSString *theLastName = summary.lastName.text;
    NSString *theScore = [NSString stringWithFormat:[Helper printPrecision:definition.precision], score];
    NSString *theDescription = currentDiagnosis.name;
    
    // Check if Patient Details are on Doctot Plus
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM Patient WHERE userId = '%@' AND firstName = '%@' AND lastName = '%@'", [prefs objectForKey:@"DTPlusUserId"], summary.firstName.text, summary.lastName.text];
    NSString *sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    //NSLog(@"sqlResponse: %@", sqlResponse);
    NSString *patientId;
    NSString *assessmentId;
    
    // If there is no such Patient, create that record
    if( ![Helper isSQLResponseValid:sqlResponse] ){
        
        NSMutableDictionary *thePatientAttributes = [[NSMutableDictionary alloc] init];
        [thePatientAttributes setObject:@"Patient" forKey:@"TABLE_NAME"];
        [thePatientAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
        [thePatientAttributes setObject:[prefs objectForKey:@"DTPlusUserId"] forKey:@"userId"];
        [thePatientAttributes setObject:theFirstName forKey:@"firstName"];
        [thePatientAttributes setObject:theLastName forKey:@"lastName"];
        [Helper executeRemoteSQLFromQueryBundle:thePatientAttributes includeDelay:YES];
        
        sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM Patient WHERE userId = '%@' AND firstName = '%@' AND lastName = '%@'", [prefs objectForKey:@"DTPlusUserId"], theFirstName, theLastName];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
    }
    
    patientId = [Helper returnParameter:@"uniqueId" inJSONString:sqlResponse forRecordIndex:0];
    
    // Get the Doctot Plus AssessmentId
    sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM zReference_Assessment WHERE name = '%@'", definition.name];
    sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    assessmentId = [Helper returnParameter:@"uniqueId" inJSONString:sqlResponse forRecordIndex:0];
    
    // Create the Assessment Record
    NSMutableDictionary *theAssessmentAttributes = [[NSMutableDictionary alloc] init];
    [theAssessmentAttributes setObject:@"AssessmentSave" forKey:@"TABLE_NAME"];
    [theAssessmentAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
    [theAssessmentAttributes setObject:[prefs objectForKey:@"DTPlusUserId"] forKey:@"userId"];
    [theAssessmentAttributes setObject:patientId forKey:@"patientId"];
    [theAssessmentAttributes setObject:assessmentId forKey:@"assessmentId"];
    [theAssessmentAttributes setObject:[prefs objectForKey:@"DTPlusAppId"] forKey:@"appId"];
    [theAssessmentAttributes setObject:theScore forKey:@"score"];
    [theAssessmentAttributes setObject:theDescription forKey:@"description"];
    [Helper executeRemoteSQLFromQueryBundle:theAssessmentAttributes includeDelay:YES];
    
    // Update the dtPlus identifier in the Interview entity
    latestPatientDtPlusId = [patientId integerValue];
    
    // Update the dtPlus identifier in the Patient entity
    sqlCommand = [NSString stringWithFormat:@"SELECT * FROM AssessmentSave WHERE patientId = %li AND userId = '%@'", (long)latestPatientDtPlusId, [prefs objectForKey:@"DTPlusUserId"]];
    sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    NSData *jsonData = [sqlResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSInteger responseLength = (NSInteger)[(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] count];
    latestAssessmentDtPlusId = [[Helper returnParameter:@"uniqueId" inJSONString:sqlResponse forRecordIndex:((int)responseLength - 1)] integerValue];
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Utility methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (Scale *)parentScale {
    
    Scale *thisScale;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    thisScale = home.scale;
    
    if( thisScale.information == nil ){
        UIStoryboard *storyBoard;
        if( [Helper isiPad] ){
            storyBoard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        }else{
            storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        Information *singleAppInformation = [storyBoard instantiateViewControllerWithIdentifier:@"Information"];
        singleAppInformation.scaleDefinition = thisScale.definition;
        thisScale.information = singleAppInformation;
    }
    
    return thisScale;
    
}

- (void)clearAllData {
    
    for( Question *aQuestion in questions ){
        [aQuestion clearDetails];
    }
    
}

- (NSInteger)numberOfStoredScores {

    NSInteger theCount = 2;
    
    return theCount;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

