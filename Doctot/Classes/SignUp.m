//
//  SignUp.m
//  DoctotDepression
//
//  Created by Fergal McDonnell on 12/11/2009.
//  Copyright Doctot 2014. All rights reserved.
//

#import "SignUp.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Helper.h"


@implementation SignUp

@synthesize prefs, signup_content, welcome_message, welcome_submessage, firstName_label, lastName_label, email_label, warning_label, warningImage, firstName, lastName, email, registerApp;
@synthesize logoBand, logo, logoDoctot;
@synthesize isFirstNameAccessed, isLastNameAccessed, isEmailAccessed;

BOOL repositioned;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)initialise {
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowSignup:) name:UIKeyboardDidShowNotification object:nil];
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    signup_content.layer.cornerRadius = 30.0;
    
    welcome_message.text = [Helper getLocalisedString:@"Registration_Message" withScalePrefix:NO];
    welcome_submessage.text = [Helper getLocalisedString:@"Registration_Submessage" withScalePrefix:NO];
    firstName_label.text = [Helper getLocalisedString:@"Registration_FirstName" withScalePrefix:NO];
    lastName_label.text = [Helper getLocalisedString:@"Registration_LastName" withScalePrefix:NO];
    email_label.text = [Helper getLocalisedString:@"Registration_Email" withScalePrefix:NO];
	warning_label.text = @"";
	[warningImage setImage:[UIImage imageNamed:@""]];
    
    welcome_message.textColor = [Helper getColourFromString:(NSString *)[Helper returnValueForKey:@"RegistrationTextColour"]];
    welcome_submessage.textColor = [Helper getColourFromString:(NSString *)[Helper returnValueForKey:@"RegistrationTextColour"]];
    
	[registerApp setTitle:[Helper getLocalisedString:@"Button_Submit" withScalePrefix:NO] forState:UIControlStateNormal];
    registerApp.layer.cornerRadius = 10.0;
    
    /*
    UIImage *updatedSponsorImage = [Helper getSponsorshipImageFor:@"sponsor_logo"];
    if( updatedSponsorImage != nil ){
        logo.image = updatedSponsorImage;
    }
     */
    logo.image = [Helper readSponsorshipImageFromDocuments:@"homeScreen"];
    
	repositioned = NO;
    isFirstNameAccessed = NO;
    isLastNameAccessed = NO;
    isEmailAccessed = NO;
    
}


- (void)keyboardWillShowSignup:(NSNotification *)note {
    [self moveScreen];
}

- (void)moveScreen {
    if(!repositioned){
        
        CGRect rect;
        
        rect = self.frame;
        rect.origin.y -= regPageRaiseObjectsBy;
        self.frame = rect;
        
    }
    repositioned = YES;
}

- (IBAction)hitSubmit:(NSNotification *)noteButton {
	[firstName resignFirstResponder];
	[lastName resignFirstResponder];
	[email resignFirstResponder];
}

- (BOOL)canProceedFromRegistration {
    BOOL isValid = YES;
    
    if( ![Helper isConnectedToInternet] ){
        isValid = NO;
        warning_label.text = [Helper getLocalisedString:@"Welcome_NoConnection" withScalePrefix:NO];
    }
    
    if( ![self checkDataValidity] || ([firstName.text length] == 0) || ([lastName.text length] == 0) || ([email.text length] == 0) ){
        isValid = NO;
        warning_label.text = [Helper getLocalisedString:@"Welcome_Error" withScalePrefix:NO];
    }
    
    return isValid;
}

- (BOOL)checkDataValidity {
    BOOL isValid = YES;
    BOOL isFirstNameValid = YES;
    BOOL isLastNameValid = YES;
    BOOL isEmailValid = YES;
    
    if( ( isFirstNameAccessed ) && ( [firstName.text length] == 0 ) ){
        isFirstNameValid = NO;
    }
    if( ( isLastNameAccessed ) && ( [lastName.text length] == 0 ) ){
        isLastNameValid = NO;
    }
    if( isEmailAccessed ){
        if( [email.text length] == 0 ){
            isEmailValid = NO;
        }
        if( ![email.text containsString:@"@"] || ![email.text containsString:@"."] || !([email.text length] > 7 ) ){
            isEmailValid = NO;
        }
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
    
    if( !isValid ){
        warning_label.text = [Helper getLocalisedString:@"Welcome_Error" withScalePrefix:NO];
        //[warningImage setImage:[UIImage imageNamed:@"alert.png"]];
    }
    
    return isValid;
}

- (BOOL)isEmailCurrentlyConfiguredCorrectly {
    BOOL configuredCorrectly = YES;
    
    if( [email.text length] == 0 ){
        configuredCorrectly = NO;
    }
    if( ![email.text containsString:@"@"] || ![email.text containsString:@"."] || !([email.text length] > 7 ) ){
        configuredCorrectly = NO;
    }
    
    return configuredCorrectly;
}


///////////////////////////////////////////////////////////////////////////////////////////
// Text Field Methods
///////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	NSString *tempStr;
	
	if (theTextField == email) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", firstName.text];
		[firstName becomeFirstResponder];
		firstName.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
        isEmailAccessed = YES;
    }
	if (theTextField == firstName) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", lastName.text];
		[lastName becomeFirstResponder];
		lastName.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
        isFirstNameAccessed = YES;
    }
	if (theTextField == lastName) {
		tempStr = [[NSString alloc] initWithFormat:@"%@", email.text];
		[email becomeFirstResponder];
		email.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
        isLastNameAccessed = YES;
    }
    
    [self checkDataValidity];
    //repositioned = NO;
    //[self moveScreen];
	
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    warning_label.text = @"";
    [warningImage setImage:[UIImage imageNamed:@""]];
    
    return YES;
}


@end
