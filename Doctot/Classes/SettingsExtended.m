//
//  SettingsExtended.m
//  Doctot
//
//  Created by Fergal McDonnell on 30/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsExtended.h"
#import "Constants.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface SettingsExtended ()

@end

@implementation SettingsExtended

@synthesize prefs, leftNavBarButton, rightNavBarButton;
@synthesize ownerDetails, ownerScrollView, ownerDetailsContentView, firstNameLabel, firstName, lastNameLabel, lastName, emailLabel, email, descriptionLabel, description, professionLabel, profession, professionActivate, professionPicker, professionOptions, specialtyLabel, specialty, specialtyActivate, specialtyPicker, specialtyOptions, dobLabel, dob, dobActivate, dobPicker, allowEmailLabel, allowEmail, photoLinkLabel, photoLink, submitOwnerDetails, logoutButton;
@synthesize pinUpdateView, pinHeading, pinSubheading, pinWarning, pinNumbers, pinField1, pinField2, pinField3, pinField4, pin0, pin1, pin2, pin3, pin4, pin5, pin6, pin7, pin8, pin9, reversePINEntry, pinToDate, pinUpdateState;
@synthesize maxSavesView, maxSaves, maxSavesInstructionLabel, maxSavesCounterLabel;
@synthesize mtsSpecificView, mtsAddressLabel, mtsAddress, mtsAddressCurrentLabel, mtsAddressCurrent, mtsHistoricalEventLabel, mtsHistoricalEventQuestionLabel, mtsHistoricalEventQuestion, mtsHistoricalEventAnswerLabel, mtsHistoricalEventAnswer, mtsHeadOfStateLabel, mtsHeadOfState;
@synthesize cachSpecificView, cachCalciumLabel, cachCalciumControl, cachAlbuminLabel, cachAlbuminControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"SettingsTitle" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [rightNavBarButton setTitle:@"Save" forState:UIControlStateNormal];
    rightNavBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [rightNavBarButton addTarget:self action:@selector(updateOwnerDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    firstNameLabel.text = [Helper getLocalisedString:@"Registration_FirstName" withScalePrefix:NO];
    lastNameLabel.text = [Helper getLocalisedString:@"Registration_LastName" withScalePrefix:NO];
    emailLabel.text = [Helper getLocalisedString:@"Registration_Email" withScalePrefix:NO];
    firstName.text = (NSString *)[prefs objectForKey:@"FirstName"];
    lastName.text = (NSString *)[prefs objectForKey:@"LastName"];
    email.text = (NSString *)[prefs objectForKey:@"Email"];
    dobLabel.text = [Helper getLocalisedString:@"Registration_DOB" withScalePrefix:NO];
    professionLabel.text = [Helper getLocalisedString:@"Registration_Profession" withScalePrefix:NO];
    specialtyLabel.text = [Helper getLocalisedString:@"Registration_Specialty" withScalePrefix:NO];
    description.placeholder = [Helper getLocalisedString:@"Registration_Description" withScalePrefix:NO];
    allowEmailLabel.text = [Helper getLocalisedString:@"Registration_AllowEmail" withScalePrefix:NO];
    [self showAppropriatePicker:nil];
    [submitOwnerDetails setTitle:[Helper getLocalisedString:@"Button_Save" withScalePrefix:NO] forState:UIControlStateNormal];
    [logoutButton setTitle:[Helper getLocalisedString:@"Button_Logout" withScalePrefix:NO] forState:UIControlStateNormal];
    ownerDetails.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    ownerScrollView.frame = CGRectMake(0, 0, ownerDetails.frame.size.width, ownerDetails.frame.size.height / 2);
    ownerDetailsContentView.frame = CGRectMake(0, 0, ownerScrollView.frame.size.width, ownerDetailsContentView.frame.size.height);
    ownerScrollView.contentSize = CGSizeMake(ownerDetailsContentView.frame.size.width, ownerDetailsContentView.frame.size.height);
    [ownerScrollView addSubview:ownerDetailsContentView];
    
    pinWarning.text = @"";
    pinToDate = @"";
    pinUpdateView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    maxSavesInstructionLabel.text = [Helper getLocalisedString:@"Settings_MaxSave" withScalePrefix:NO];
    maxSavesCounterLabel.text = [NSString stringWithFormat:@"%li", (long)[prefs integerForKey:@"MaxSaves"]];
    maxSaves.value = (float)[prefs integerForKey:@"MaxSaves"];
    maxSavesView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    mtsSpecificView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    mtsAddressLabel.text = [Helper getLocalisedString:@"Settings_MTS_Address" withScalePrefix:NO];
    mtsAddress.placeholder = [Helper getLocalisedString:@"Settings_MTS_Address" withScalePrefix:NO];
    mtsAddress.text = [prefs objectForKey:@"mtsAddress"];
    [mtsAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    mtsAddressCurrentLabel.text = [Helper getLocalisedString:@"Settings_MTS_AddressCurrent" withScalePrefix:NO];
    mtsAddressCurrent.placeholder = [Helper getLocalisedString:@"Settings_MTS_AddressCurrent" withScalePrefix:NO];
    mtsAddressCurrent.text = [prefs objectForKey:@"mtsAddressCurrent"];
    [mtsAddressCurrent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    mtsHistoricalEventLabel.text = [Helper getLocalisedString:@"Settings_MTS_HistoricalEventHeader" withScalePrefix:NO];
    mtsHistoricalEventQuestionLabel.text = [Helper getLocalisedString:@"Settings_MTS_HistoricalEventQuestion" withScalePrefix:NO];
    mtsHistoricalEventQuestion.placeholder = [Helper getLocalisedString:@"Settings_MTS_HistoricalEventQuestion" withScalePrefix:NO];
    mtsHistoricalEventQuestion.text = [prefs objectForKey:@"mtsHistoricalEventQuestion"];
    [mtsHistoricalEventQuestion addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    mtsHistoricalEventAnswerLabel.text = [Helper getLocalisedString:@"Settings_MTS_HistoricalEventAnswer" withScalePrefix:NO];
    mtsHistoricalEventAnswer.placeholder = [Helper getLocalisedString:@"Settings_MTS_HistoricalEventAnswer" withScalePrefix:NO];
    mtsHistoricalEventAnswer.text = [prefs objectForKey:@"mtsHistoricalEventAnswer"];
    [mtsHistoricalEventAnswer addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    mtsHeadOfStateLabel.text = [Helper getLocalisedString:@"Settings_MTS_HeadOfState" withScalePrefix:NO];
    mtsHeadOfState.placeholder = [Helper getLocalisedString:@"Settings_MTS_HeadOfState" withScalePrefix:NO];
    mtsHeadOfState.text = [prefs objectForKey:@"mtsHeadOfState"];
    [mtsHeadOfState addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    cachSpecificView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    cachCalciumLabel.text = [Helper getLocalisedString:@"Settings_CACH_CalciumUnits" withScalePrefix:NO];
    [cachCalciumControl setTitle:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice0" withScalePrefix:NO] forSegmentAtIndex:0];
    [cachCalciumControl setTitle:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice1" withScalePrefix:NO] forSegmentAtIndex:1];
    [cachCalciumControl addTarget:self action:@selector(performSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    if( [[prefs objectForKey:@"cachCalciumUnits"] isEqualToString:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice0" withScalePrefix:NO]] ){
        cachCalciumControl.selectedSegmentIndex = 0;
    }
    if( [[prefs objectForKey:@"cachCalciumUnits"] isEqualToString:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice1" withScalePrefix:NO]] ){
        cachCalciumControl.selectedSegmentIndex = 1;
    }
    cachAlbuminLabel.text = [Helper getLocalisedString:@"Settings_CACH_AlbuminUnits" withScalePrefix:NO];
    [cachAlbuminControl setTitle:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice0" withScalePrefix:NO] forSegmentAtIndex:0];
    [cachAlbuminControl setTitle:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice1" withScalePrefix:NO] forSegmentAtIndex:1];
    [cachAlbuminControl addTarget:self action:@selector(performSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    if( [[prefs objectForKey:@"cachAlbuminUnits"] isEqualToString:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice0" withScalePrefix:NO]] ){
        cachAlbuminControl.selectedSegmentIndex = 0;
    }
    if( [[prefs objectForKey:@"cachAlbuminUnits"] isEqualToString:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice1" withScalePrefix:NO]] ){
        cachAlbuminControl.selectedSegmentIndex = 1;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self configurePINFields];
    [self configurePINNumberPad];
    NSString *oldPIN = (NSString *)[prefs objectForKey:@"Password"];
    if( (oldPIN == nil) || ([oldPIN length] == 0) ){
        pinUpdateState = @"NEW";
        pinHeading.text = [Helper getLocalisedString:@"Settings_UpdatePINHeading" withScalePrefix:NO];
        pinSubheading.text = [Helper getLocalisedString:@"Settings_UpdatePINNew" withScalePrefix:NO];
    }else{
        pinUpdateState = @"OLD";
        pinHeading.text = [Helper getLocalisedString:@"Settings_UpdatePINHeading" withScalePrefix:NO];
        pinSubheading.text = [Helper getLocalisedString:@"Settings_UpdatePINOld" withScalePrefix:NO];
    }
    
}

- (void)setup:(UIView *)viewToDisplay {
    [self.view addSubview:viewToDisplay];
    
    if( viewToDisplay == ownerDetails ){
        
        professionOptions = [Helper returnPickerValueList:@"Profession"];
        specialtyOptions = [Helper returnPickerValueList:@"Specialty"];
        
        NSUserDefaults *helperPrefs = [NSUserDefaults standardUserDefaults];
        NSString *sqlCommand = [NSString stringWithFormat:@"SELECT description,profession,specialty,dob,emailsAllowed,photoLink FROM User WHERE uniqueId = '%@'", [helperPrefs objectForKey:@"DTPlusUserId"]];
        NSString *sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        NSError *err;
        NSArray *userData = [NSJSONSerialization JSONObjectWithData:[sqlResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
        NSString *descriptionAsText, *professionAsText, *specialtyAsText, *dobAsText, *allowEmailAsText, *photoLinkAsText;
        NSDate *dobAsDate;
        for (NSMutableDictionary *aDictionaryNewsItem in userData) {
            descriptionAsText = (NSString *)[aDictionaryNewsItem valueForKey:@"description"];
            professionAsText = (NSString *)[aDictionaryNewsItem valueForKey:@"profession"];
            specialtyAsText = (NSString *)[aDictionaryNewsItem valueForKey:@"specialty"];
            dobAsText = (NSString *)[aDictionaryNewsItem valueForKey:@"dob"];
            allowEmailAsText = (NSString *)[aDictionaryNewsItem valueForKey:@"emailsAllowed"];
            photoLinkAsText = (NSString *)[aDictionaryNewsItem valueForKey:@"photoLink"];
        }
        
        dobAsDate = [Helper convertStringToDate:dobAsText withFormat:@"yyyy-MM-dd"];
        [dobPicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
        
        [prefs setObject:descriptionAsText forKey:@"userDescription"];
        description.text = [prefs objectForKey:@"userDescription"];

        [prefs setObject:professionAsText forKey:@"userProfession"];
        profession.text = [prefs objectForKey:@"userProfession"];
        [self setIndexOnPicker:professionPicker forValueList:professionOptions withOption:profession.text];

        [prefs setObject:specialtyAsText forKey:@"userSpecialty"];
        specialty.text = [prefs objectForKey:@"userSpecialty"];
        [self setIndexOnPicker:specialtyPicker forValueList:specialtyOptions withOption:specialty.text];
        
        dobAsText = [Helper convertDateToString:dobAsDate forStyle:@"Numeric"];
        if( [dobAsText containsString:@"0000"] || (dobAsText == nil) ){
            dobAsText = @"01-01-1900";
        }
        [prefs setObject:dobAsText forKey:@"userDOB"];
        dob.text = [prefs objectForKey:@"userDOB"];
        [dobPicker setDate:[Helper convertStringToDate:dob.text withFormat:@"dd-MM-yyyy"]];

        if( [allowEmailAsText isEqualToString:@"YES"] ){
            [prefs setBool:YES forKey:@"userAllowEmail"];
            [allowEmail setOn:YES];
        }else{
            [prefs setBool:NO forKey:@"userAllowEmail"];
            [allowEmail setOn:NO];
        }
        
        [firstName becomeFirstResponder];
    
    }else{
    
        self.navigationItem.rightBarButtonItem = nil;
    
    }
    
    if( viewToDisplay == pinUpdateView ){
        //[pinField1 becomeFirstResponder];
    }
}

- (void)setIndexOnPicker:(UIPickerView *)thePickerView forValueList:(NSMutableArray *)valueList withOption:(NSString *)currentOption {
    
    NSInteger matchingRow = 0;
    
    for( int i = 0 ; i < [valueList count] ; i++ ){
        if( [currentOption isEqualToString:[valueList objectAtIndex:i]] ){
            matchingRow = i;
            i = (int)[valueList count];
        }
    }
    
    [thePickerView selectRow:matchingRow inComponent:0 animated:YES];
    
}

- (void)keyboardWillChange:(NSNotification *)notification {
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    ownerScrollView.frame = CGRectMake(ownerScrollView.frame.origin.x, ownerScrollView.frame.origin.y, ownerScrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height - keyboardRect.size.height );
    
}

////////////////////////////////////////////////////////////////////////////////
// Owner Details
////////////////////////////////////////////////////////////////////////////////

- (IBAction)updateOwnerDetails {
    
    if( [self checkDataValidity] ){
     
        NSString *sqlCommand = @"";
        NSString *sqlResponse;
        
        if( ![firstName.text isEqualToString:[prefs objectForKey:@"FirstName"]] ){
            [prefs setObject:firstName.text forKey:@"FirstName"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET firstName = '%@' WHERE uniqueId = '%@'", [prefs objectForKey:@"FirstName"], [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( ![lastName.text isEqualToString:[prefs objectForKey:@"LastName"]] ){
            [prefs setObject:lastName.text forKey:@"LastName"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET lastName = '%@' WHERE uniqueId = '%@'", [prefs objectForKey:@"LastName"], [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( ![email.text isEqualToString:[prefs objectForKey:@"Email"]] ){
            [prefs setObject:email.text forKey:@"Email"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET email = '%@' WHERE uniqueId = '%@'", [prefs objectForKey:@"Email"], [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( ![dob.text isEqualToString:[prefs objectForKey:@"userDOB"]] ){
            [prefs setObject:dob.text forKey:@"userDOB"];
            NSString *dobAsString = [Helper convertDateToString:[dobPicker date] forStyle:@"Numeric Reversed"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET dob = '%@' WHERE uniqueId = '%@'", dobAsString, [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( ![profession.text isEqualToString:[prefs objectForKey:@"userProfession"]] ){
            [prefs setObject:profession.text forKey:@"userProfession"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET profession = '%@' WHERE uniqueId = '%@'", [prefs objectForKey:@"userProfession"], [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( ![specialty.text isEqualToString:[prefs objectForKey:@"userSpecialty"]] ){
            [prefs setObject:specialty.text forKey:@"userSpecialty"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET specialty = '%@' WHERE uniqueId = '%@'", [prefs objectForKey:@"userSpecialty"], [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( ![description.text isEqualToString:[prefs objectForKey:@"userDescription"]] ){
            [prefs setObject:description.text forKey:@"userDescription"];
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET description = '%@' WHERE uniqueId = '%@'", [prefs objectForKey:@"userDescription"], [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }
        if( !( allowEmail.on == [prefs boolForKey:@"userAllowEmail"] ) ){
            [prefs setBool:allowEmail.on forKey:@"userAllowEmail"];
            NSString *allowEmailAsString = @"NO";
            if( allowEmail.on ){
                allowEmailAsString = @"YES";
            }
            sqlCommand = [NSString stringWithFormat:@"UPDATE User SET emailsAllowed = '%@' WHERE uniqueId = '%@'", allowEmailAsString, [prefs objectForKey:@"DTPlusUserId"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        }

        [prefs synchronize];
        [self dismiss];
    
    }else{
        
        
        
    }
    
}


- (void)textFieldDidChange:(UITextField *)theTextField {
    
    if (theTextField == mtsAddress) {
        [prefs setObject:mtsAddress.text forKey:@"mtsAddress"];
    }
    if (theTextField == mtsAddressCurrent) {
        [prefs setObject:mtsAddressCurrent.text forKey:@"mtsAddressCurrent"];
    }
    if (theTextField == mtsHistoricalEventQuestion) {
        [prefs setObject:mtsHistoricalEventQuestion.text forKey:@"mtsHistoricalEventQuestion"];
    }
    if (theTextField == mtsHistoricalEventAnswer) {
        [prefs setObject:mtsHistoricalEventAnswer.text forKey:@"mtsHistoricalEventAnswer"];
    }
    if (theTextField == mtsHeadOfState) {
        [prefs setObject:mtsHeadOfState.text forKey:@"mtsHeadOfState"];
    }
    [prefs synchronize];
}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField {
    
    // Owner Details
    if (theTextField == email) {
        //[self animateView:ownerDetails toLabelPosition:emailLabel.frame.origin.y];
    }
    if (theTextField == firstName) {
        //[self animateView:ownerDetails toLabelPosition:firstNameLabel.frame.origin.y];
    }
    if (theTextField == lastName) {
        //[self animateView:ownerDetails toLabelPosition:lastNameLabel.frame.origin.y];
    }
    
    // MTS Specific
    if (theTextField == mtsAddress) {
        [self animateView:mtsSpecificView toLabelPosition:mtsAddressLabel.frame.origin.y];
    }
    if (theTextField == mtsAddressCurrent) {
        [self animateView:mtsSpecificView toLabelPosition:mtsAddressCurrentLabel.frame.origin.y];
    }
    if (theTextField == mtsHistoricalEventQuestion) {
        [self animateView:mtsSpecificView toLabelPosition:mtsHistoricalEventLabel.frame.origin.y];
    }
    if (theTextField == mtsHistoricalEventAnswer) {
        [self animateView:mtsSpecificView toLabelPosition:mtsHistoricalEventLabel.frame.origin.y];
    }
    if (theTextField == mtsHeadOfState) {
        [self animateView:mtsSpecificView toLabelPosition:mtsHeadOfStateLabel.frame.origin.y];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    NSString *tempStr;
    
    // Owner Details
    if (theTextField == email) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", firstName.text];
        [firstName becomeFirstResponder];
        firstName.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == firstName) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", lastName.text];
        [lastName becomeFirstResponder];
        lastName.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == lastName) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", email.text];
        [email becomeFirstResponder];
        email.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    
    // MTS Specific
    if (theTextField == mtsAddress) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", mtsAddressCurrent.text];
        [mtsAddressCurrent becomeFirstResponder];
        mtsAddressCurrent.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == mtsAddressCurrent) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", mtsHistoricalEventQuestion.text];
        [mtsHistoricalEventQuestion becomeFirstResponder];
        mtsHistoricalEventQuestion.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == mtsHistoricalEventQuestion) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", mtsHistoricalEventAnswer.text];
        [mtsHistoricalEventAnswer becomeFirstResponder];
        mtsHistoricalEventAnswer.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == mtsHistoricalEventAnswer) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", mtsHeadOfState.text];
        [mtsHeadOfState becomeFirstResponder];
        mtsHeadOfState.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == mtsHeadOfState) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", mtsAddress.text];
        [mtsAddress becomeFirstResponder];
        mtsAddress.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    
    [self checkDataValidity];
    
    return YES;
}

- (BOOL)checkDataValidity {
    BOOL isValid = YES;
    BOOL isFirstNameValid = YES;
    BOOL isLastNameValid = YES;
    BOOL isEmailValid = YES;
    
    if( [firstName.text length] == 0 ){
        isFirstNameValid = NO;
    }
    if( [lastName.text length] == 0 ){
        isLastNameValid = NO;
    }
    if( [email.text length] == 0 ){
        isEmailValid = NO;
    }
    if( ![email.text containsString:@"@"] || ![email.text containsString:@"."] || !([email.text length] > 7 ) ){
        isEmailValid = NO;
    }
    
    firstName.backgroundColor = [UIColor clearColor];
    lastName.backgroundColor = [UIColor clearColor];
    email.backgroundColor = [UIColor clearColor];
    
    if( !isFirstNameValid || !isLastNameValid || !isEmailValid ){
        isValid = NO;
        if( !isFirstNameValid ){ firstName.backgroundColor = [Helper getColourFromString:@"alphaRed"];   }
        if( !isLastNameValid ){  lastName.backgroundColor = [Helper getColourFromString:@"alphaRed"];   }
        if( !isEmailValid ){     email.backgroundColor = [Helper getColourFromString:@"alphaRed"];   }
    }
    
    return isValid;
}

-(void)performSegmentedControl:(UISegmentedControl *)sender {
    
    if( sender == cachCalciumControl ){
        if( sender.selectedSegmentIndex == 0 ) {
            [prefs setObject:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice0" withScalePrefix:NO] forKey:@"cachCalciumUnits"];
        }
        if (sender.selectedSegmentIndex == 1) {
            [prefs setObject:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice1" withScalePrefix:NO] forKey:@"cachCalciumUnits"];
        }
    }
    
    if( sender == cachAlbuminControl ){
        if( sender.selectedSegmentIndex == 0 ) {
            [prefs setObject:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice0" withScalePrefix:NO] forKey:@"cachAlbuminUnits"];
        }
        if (sender.selectedSegmentIndex == 1) {
            [prefs setObject:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice1" withScalePrefix:NO] forKey:@"cachAlbuminUnits"];
        }
    }
    
    [prefs synchronize];
    
}

- (void)animateView:(UIView *)theView toLabelPosition:(float)yPosition {
    
    [UIView beginAnimations:@"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration:1.0];
    theView.frame = CGRectMake(self.view.frame.origin.x, -yPosition + 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (IBAction)showAppropriatePicker:(UIButton *)source {

    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [email resignFirstResponder];
    [description resignFirstResponder];
    
    professionPicker.hidden = YES;
    specialtyPicker.hidden = YES;
    dobPicker.hidden = YES;
    
    if( source == professionActivate ){
        professionPicker.hidden = NO;
    }
    
    if( source == specialtyActivate ){
        specialtyPicker.hidden = NO;
    }
    
    if( source == dobActivate ){
        dobPicker.hidden = NO;
    }
    
}

- (IBAction)updateDateOfBirth {

    dob.text = [Helper convertDateToString:[dobPicker date] forStyle:@"Text"];
    
}

- (IBAction)logout {
    
    [prefs setObject:@"" forKey:@"DTPlusUserId"];
    [prefs setObject:@"" forKey:@"DTPlusDeviceId"];
    [prefs setObject:@"" forKey:@"DTPlusEmail"];
    [prefs setObject:@"" forKey:@"DTPlusUserActivated"];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    [home goToSignUp];
    [Helper showNavigationBar:NO];
    
}

////////////////////////////////////////////////////////////////////////////////
// PIN
////////////////////////////////////////////////////////////////////////////////

- (void)configurePINFields {
    float padding = 0;
    float commonWidth = [[UIScreen mainScreen] bounds].size.width / 9;
    float commonHeight = pinField1.frame.size.height;
    float commonYPos = 150;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return;
    }
    
    
    pinField1.frame = CGRectMake( (padding + (commonWidth * 1)) , commonYPos, commonWidth, commonHeight);
    pinField2.frame = CGRectMake( (padding + (commonWidth * 3)) , commonYPos, commonWidth, commonHeight);
    pinField3.frame = CGRectMake( (padding + (commonWidth * 5)) , commonYPos, commonWidth, commonHeight);
    pinField4.frame = CGRectMake( (padding + (commonWidth * 7)) , commonYPos, commonWidth, commonHeight);
}

- (void)configurePINNumberPad {
    [self placeKeyButton:pin1 atGridX:0 andY:0];
    [self placeKeyButton:pin2 atGridX:1 andY:0];
    [self placeKeyButton:pin3 atGridX:2 andY:0];
    [self placeKeyButton:pin4 atGridX:0 andY:1];
    [self placeKeyButton:pin5 atGridX:1 andY:1];
    [self placeKeyButton:pin6 atGridX:2 andY:1];
    [self placeKeyButton:pin7 atGridX:0 andY:2];
    [self placeKeyButton:pin8 atGridX:1 andY:2];
    [self placeKeyButton:pin9 atGridX:2 andY:2];
    [self placeKeyButton:pin0 atGridX:1 andY:3];
    [self placeKeyButton:reversePINEntry atGridX:2 andY:3];
}

- (void)placeKeyButton:(UIButton *)keyButton atGridX:(int)positionX andY:(int)positionY {
    keyButton.frame = CGRectMake( ( pinNumbers.frame.origin.x + ( (pinNumbers.frame.size.width / 3) * positionX ) ),
                                  ( pinNumbers.frame.origin.y + ( (pinNumbers.frame.size.height / 4) * positionY ) ),
                                  ( pinNumbers.frame.size.height / 3 ),
                                  ( pinNumbers.frame.size.height / 4 ));
}

- (IBAction)press:(UIButton *)keyButton {
    
    NSString *oldPIN =(NSString *)[prefs objectForKey:@"Password"];
    pinWarning.text = @"";
    
    if( keyButton == reversePINEntry ){
    
        int reducedLength = (int)[pinToDate length] - 1;
        if( reducedLength >= 0 ){
            pinToDate = [pinToDate substringToIndex:reducedLength];
            if( [pinToDate length] < 1 ) pinField1.text = @"";
            if( [pinToDate length] < 2 ) pinField2.text = @"";
            if( [pinToDate length] < 3 ) pinField3.text = @"";
            if( [pinToDate length] < 4 ) pinField4.text = @"";
        }
        
    }else{
        
        pinToDate = [NSString stringWithFormat:@"%@%li", pinToDate, (long)keyButton.tag];
    
        if([pinToDate length] >= 4){
            
            if( [pinUpdateState isEqualToString:@"OLD"] ){
                if( [pinToDate isEqualToString:oldPIN] ){
                    pinHeading.text = [Helper getLocalisedString:@"Settings_UpdatePINNew" withScalePrefix:NO];
                    pinUpdateState = @"NEW";
                }else{
                    pinWarning.text = [Helper getLocalisedString:@"Settings_Password_Error" withScalePrefix:NO];
                }
                pinField1.text = @"";
                pinField2.text = @"";
                pinField3.text = @"";
                pinField4.text = @"";
                pinToDate = @"";
            }else{
                
                [prefs setObject:pinToDate forKey:@"Password"];
                [self dismiss];
                
            }
            
        }else{
            
            if([pinField1.text length] == 0){
                pinField1.text = [NSString stringWithFormat:@"%li", (long)keyButton.tag];
            }else{
                if([pinField2.text length] == 0){
                    pinField2.text = [NSString stringWithFormat:@"%li", (long)keyButton.tag];
                }else{
                    if([pinField3.text length] == 0){
                        pinField3.text = [NSString stringWithFormat:@"%li", (long)keyButton.tag];
                    }else{
                        if([pinField4.text length] == 0)
                            pinField4.text = [NSString stringWithFormat:@"%li", (long)keyButton.tag];
                    }
                }
            }
            
        }
        
    }
    
}

////////////////////////////////////////////////////////////////////////////////
// Slider
////////////////////////////////////////////////////////////////////////////////

- (IBAction)updateMaxSaves {
    NSInteger savesCount = (NSInteger)maxSaves.value;
    maxSavesCounterLabel.text = [NSString stringWithFormat:@"%li", (long)savesCount];
    [prefs setInteger:savesCount forKey:@"MaxSaves"];
    [prefs synchronize];
}

/***************************************************************************************************************************
 
 PickerView Delegate Methods
 
 ***************************************************************************************************************************/

-(NSInteger)numberOfComponentsInPickerView:(CustomPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(CustomPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger pickerCount = 0;
    
    if( pickerView == professionPicker ){
        pickerCount = [professionOptions count];
    }
    if( pickerView == specialtyPicker ){
        pickerCount = [specialtyOptions count];
    }
    
    return pickerCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:aView.frame];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
    if( pickerView == professionPicker ){
        aLabel.text = [professionOptions objectAtIndex:row];
    }
    if( pickerView == specialtyPicker ){
        aLabel.text = [specialtyOptions objectAtIndex:row];
    }
    
    [aView addSubview:aLabel];
    
    return aView;
    
}

- (void)pickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if( pickerView == professionPicker ){
        profession.text = [professionOptions objectAtIndex:row];
    }
    if( pickerView == specialtyPicker ){
        specialty.text = [specialtyOptions objectAtIndex:row];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
