//
//  Summary.m
//  Doctot
//
//  Created by Fergal McDonnell on 30/03/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import "Summary.h"
#import "Helper.h"

@implementation Summary

@synthesize firstNameLabel, lastNameLabel, firstName, lastName, instructionLabel, scoreLabel, scoreExpand, scoreDetail, questionsIncomplete, saveScore, hideKeyboard, showPatients, patientListActivated, spinnerBackground;
@synthesize score, diagnosis, scaleDefinition, prefs, keyboardHeight;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)initialise {
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    firstNameLabel.text = [Helper getLocalisedString:@"Registration_FirstName" withScalePrefix:NO];
    lastNameLabel.text = [Helper getLocalisedString:@"Registration_LastName" withScalePrefix:NO];
    firstName.text = @"";
    firstName.placeholder = NSLocalizedString(@"Scale_Score_FirstNamePlaceholder", @"");
    lastName.text = @"";
    lastName.placeholder = NSLocalizedString(@"Scale_Score_LastNamePlaceholder", @"");
    instructionLabel.text = [Helper getLocalisedString:@"Scale_Score_Instruction" withScalePrefix:NO];
    NSString *precisionString = @"%.";
    precisionString = [precisionString stringByAppendingFormat:@"%lif", (long)scaleDefinition.precision];
    scoreLabel.text = [NSString stringWithFormat:precisionString, score];
    patientListActivated = NO;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    NSString *htmlString = [NSString stringWithFormat:@"<CENTER>%@%@", [Helper getLocalisedString:@"HTMLStyle_StandardWhite" withScalePrefix:NO], diagnosis.description];
    [scoreDetail loadHTMLString:htmlString baseURL:theBaseURL];
    
    [scoreExpand setTitle:[NSString stringWithFormat:@"   %@", [Helper getLocalisedString:@"Scale_Score_MoreDetails" withScalePrefix:NO]] forState:UIControlStateNormal];
    [saveScore setTitle:[Helper getLocalisedString:@"Button_Save" withScalePrefix:NO] forState:UIControlStateNormal];
    
    hideKeyboard.hidden = YES;
    
    [self endEditing:YES];
    
    [self adjustForSpecificScale];
    
    NSArray *patientCohort = [Helper resultsFromTable:@"Patient" forQuery:@"uniqueID == '*'" ofType:@"AND" sortedBy:@"" sortDirections:@""];
    if( [patientCohort count] == 0 ){
        showPatients.hidden = YES;
    }else{
        showPatients.hidden = NO;
    }
    UIImageView *showPatientsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showPatients.frame.size.height, showPatients.frame.size.height)];
    showPatientsIcon.image = [UIImage imageNamed:@"patient.png"];
    [showPatients addSubview:showPatientsIcon];
    
    if( [diagnosis.descriptionHTML length] > 0 ){
        scoreExpand.hidden = NO;
    }else{
        scoreExpand.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField {
    
    //hideKeyboard.hidden = NO;
    patientListActivated = YES;
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    NSString *tempStr;
    
    if (theTextField == firstName) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", lastName.text];
        [lastName becomeFirstResponder];
        lastName.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == lastName) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", firstName.text];
        [firstName becomeFirstResponder];
        firstName.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    
    [self checkValidity];
    
    return YES;
}

- (IBAction)hideKeyboardFromScreen {
    
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    hideKeyboard.hidden = YES;
    [self checkValidity];
    
}

- (void)checkValidity {
    
    firstName.backgroundColor = [UIColor clearColor];
    lastName.backgroundColor = [UIColor clearColor];
    if( [firstName.text length] == 0 ){
        firstName.backgroundColor = [Helper getColourFromString:@"alphaRed"];
    }
    if( [lastName.text length] == 0 ){
        lastName.backgroundColor = [Helper getColourFromString:@"alphaRed"];
    }
    
}

- (void)adjustForSpecificScale {
    
    // CGI
    if( [scaleDefinition.name isEqualToString:@"CGI"] ){
        BOOL isScoreInvalid = YES;
        NSInteger severityScore = -1, improvementScore = -1, efficacyScore = -1;
        
        if( [scoreLabel.text length] == 4 ){
            severityScore = [[scoreLabel.text substringWithRange:NSMakeRange(0, 1)] integerValue];
            improvementScore = [[scoreLabel.text substringWithRange:NSMakeRange(1, 1)] integerValue];
            efficacyScore = [[scoreLabel.text substringWithRange:NSMakeRange(2, 2)] integerValue];
            scoreLabel.text = [NSString stringWithFormat:@"%li  -  %li  -  %li", severityScore, improvementScore, efficacyScore];
        }
        if( ( severityScore == -1 ) || ( improvementScore == -1 ) || ( efficacyScore == -1 ) ){
            isScoreInvalid = NO;
        }
        if( !isScoreInvalid ){
            scoreLabel.text = [Helper getLocalisedString:@"Scale_Score_Invalid" withScalePrefix:NO];
        }
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *theBaseURL = [NSURL fileURLWithPath:path];
        NSString *scoreKey = [NSString stringWithFormat:@"<CENTER><p style='font: 10pt Helvetica;color:#FFFFFF;'>%@ - %@ - %@</CENTER>", NSLocalizedString(@"CGI_Q1_Short", @""), NSLocalizedString(@"CGI_Q2_Short", @""), NSLocalizedString(@"CGI_Q3_Short", @"")];
        [scoreDetail loadHTMLString:scoreKey baseURL:theBaseURL];
    }
    
    // GDS
    if( [scaleDefinition.name isEqualToString:@"GDS"] ){
        if( score == -1 ){
            scoreLabel.text = @"--";
        }
    }
    
    // GOLD Combined Assessment
    if( [scaleDefinition.name isEqualToString:@"COM"] ){
        NSString *reference = [NSString stringWithFormat:@"Therapeutic_Group%li", diagnosis.index];
        scoreLabel.text = [Helper getLocalisedString:reference withScalePrefix:YES];
        scoreLabel.textColor = diagnosis.colour;
    }
    
    // AINT
    if( [scaleDefinition.name isEqualToString:@"AINT"] ){
        scoreLabel.text = diagnosis.description;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *theBaseURL = [NSURL fileURLWithPath:path];
        [scoreDetail loadHTMLString:@"" baseURL:theBaseURL];
    }
    
    // BCRSS
    if( [scaleDefinition.name isEqualToString:@"BCRSS"] ){
        if( score == 10 ){
            scoreLabel.text = @"0";
        }
        scoreLabel.text = [NSString stringWithFormat:@"%@ %@", [Helper getLocalisedString:@"Units" withScalePrefix:YES], scoreLabel.text];
    }
    
    // HORW
    if( [scaleDefinition.name isEqualToString:@"HORW"] ){
            scoreLabel.text = [scoreLabel.text stringByAppendingFormat:@" %@", [Helper getLocalisedString:@"Units" withScalePrefix:YES]];
    }
    
}

- (void)showSpinner {
    
    spinnerBackground = [Helper returnAnimatedImage:[NSArray arrayWithObjects:
                                                    [UIImage imageNamed:@"loader1.png"],
                                                     [UIImage imageNamed:@"loader2.png"],
                                                     [UIImage imageNamed:@"loader3.png"],
                                                     [UIImage imageNamed:@"loader4.png"],
                                                     [UIImage imageNamed:@"loader5.png"],
                                                     nil]];
    spinnerBackground.frame = CGRectMake( 0, 0, saveScore.frame.size.height, saveScore.frame.size.height);
    spinnerBackground.center = saveScore.center;
    [self addSubview:spinnerBackground];
    
}

- (void)hideSpinner {
    
    [spinnerBackground removeFromSuperview];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    float keyboardHeight = 50;
    float keyboardYPos = 0;
    if( [Helper isiPad] ){
        // iPad
        keyboardYPos = scoreLabel.frame.origin.y;
    }else{
        // iPhone
        keyboardYPos = self.frame.size.height - keyboardHeight - keyboardHeight;
    }
    hideKeyboard.frame = CGRectMake(0, keyboardYPos, self.frame.size.width, keyboardHeight);
    [self checkValidity];
}


@end
