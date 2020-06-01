//
//  Summary.h
//  Doctot
//
//  Created by Fergal McDonnell on 30/03/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "DiagnosisElement.h"
#import "ScaleDefinition.h"

@interface Summary : UIView <UITextFieldDelegate> {
    
    UILabel *firstNameLabel;
    UILabel *lastNameLabel;
    UITextField *firstName;
    UITextField *lastName;
    UILabel *instructionLabel;
    
    UILabel *scoreLabel;
    UIButton *scoreExpand;
    WKWebView *scoreDetail;
    UIButton *questionsIncomplete;
    
    UIButton *saveScore;
    UIButton *hideKeyboard;
    UIButton *showPatients;
    BOOL patientListActivated;
    UIImageView *spinnerBackground;
    
    float score;
    DiagnosisElement *diagnosis;
    ScaleDefinition *scaleDefinition;
    NSUserDefaults *prefs;
    float keyboardHeight;
    
}

@property (nonatomic, retain) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UILabel *instructionLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UIButton *scoreExpand;
@property (nonatomic, retain) IBOutlet WKWebView *scoreDetail;
@property (nonatomic, retain) IBOutlet UIButton *questionsIncomplete;
@property (nonatomic, retain) IBOutlet UIButton *saveScore;
@property (nonatomic, retain) IBOutlet UIButton *hideKeyboard;
@property (nonatomic, retain) IBOutlet UIButton *showPatients;
@property BOOL patientListActivated;
@property (nonatomic, retain) IBOutlet UIImageView *spinnerBackground;

@property float score;
@property DiagnosisElement *diagnosis;
@property ScaleDefinition *scaleDefinition;
@property NSUserDefaults *prefs;
@property float keyboardHeight;

- (void)initialise;
- (void)showSpinner;
- (void)hideSpinner;


@end
