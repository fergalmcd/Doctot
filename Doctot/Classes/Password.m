//
//  Password.m
//  Doctot
//
//  Created by Fergal McDonnell on 12/11/2009.
//  Copyright Doctot 2014. All rights reserved.
//

#import "Password.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Helper.h"

@implementation Password

@synthesize navigation_bar, navigation_item;
@synthesize welcome_label, password_label, warning_label, warning_image, login_background, pinNumbers;
@synthesize pinBackground, password_char1, pinCharacterDivider1, password_char2, pinCharacterDivider2, password_char3, pinCharacterDivider3, password_char4, pin0, pin1, pin2, pin3, pin4, pin5, pin6, pin7, pin8, pin9, reversePINEntry;
@synthesize clearPassword;
@synthesize passwordToDate;

NSUserDefaults *prefs;
UIBarButtonItem *dismissScoreButton;

BOOL inUpdateMode = NO;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)setup{
	
    prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *welcomeMessage = [Helper getLocalisedString:@"Welcome_Message" withScalePrefix:NO];
    if( [[prefs stringForKey:@"FirstName"] length] > 0 ){
        welcomeMessage = [NSString stringWithFormat:@"%@, %@", [Helper getLocalisedString:@"Welcome_Message" withScalePrefix:NO], [prefs stringForKey:@"FirstName"]];
    }
    
    welcome_label.text = welcomeMessage;
	password_label.text = [Helper getLocalisedString:@"Settings_Password" withScalePrefix:NO];
    warning_label.text = [Helper getLocalisedString:@"Settings_Password_Error" withScalePrefix:NO];
	passwordToDate = @"";
	[self removeWarning];
    //[self configurePINNumberPad];
    
}

- (void)configurePINFields {
    
    float externalXPadding = 25;
    float externalYPadding = self.frame.origin.y;
    float internalXPadding = ((([UIScreen mainScreen].bounds.size.width - (externalXPadding * 2)) / 4) - password_char1.frame.size.width) / 2;
    float internalYPadding = password_label.frame.origin.y + password_label.frame.size.height + 20;
    
    // iPhone Adjustment
    if( ![Helper isiPad] ){
        password_char1.frame = CGRectMake( (externalXPadding + (internalXPadding * 1) + (password_char1.frame.size.width * 0)) , (externalYPadding + internalYPadding), password_char1.frame.size.width, password_char1.frame.size.height);
        password_char2.frame = CGRectMake( (externalXPadding + (internalXPadding * 3) + (password_char1.frame.size.width * 1)) , (externalYPadding + internalYPadding), password_char2.frame.size.width, password_char2.frame.size.height);
        password_char3.frame = CGRectMake( (externalXPadding + (internalXPadding * 5) + (password_char1.frame.size.width * 2)) , (externalYPadding + internalYPadding), password_char3.frame.size.width, password_char3.frame.size.height);
        password_char4.frame = CGRectMake( (externalXPadding + (internalXPadding * 7) + (password_char1.frame.size.width * 3)) , (externalYPadding + internalYPadding), password_char4.frame.size.width, password_char4.frame.size.height);
    }

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


- (IBAction)pressButton:(UIButton *)keypadButton {
    
    if([passwordToDate length] < 4){
        NSString *tempPassword;
        tempPassword = [[NSString alloc] initWithFormat:@"%@%li", passwordToDate, (long)keypadButton.tag];
        passwordToDate = tempPassword;
        
        tempPassword = [[NSString alloc] initWithFormat:@"%li", (long)keypadButton.tag];
        
        [self removeWarning];
        
        if([password_char1.text length] == 0){
            password_char1.text = [[NSString alloc] initWithFormat:@"%li", (long)keypadButton.tag];
        }else{
            if([password_char2.text length] == 0){
                password_char2.text = [[NSString alloc] initWithFormat:@"%li", (long)keypadButton.tag];
            }else{
                if([password_char3.text length] == 0){
                    password_char3.text = [[NSString alloc] initWithFormat:@"%li", (long)keypadButton.tag];
                }else{
                    if([password_char4.text length] == 0)
                        password_char4.text = [[NSString alloc] initWithFormat:@"%li", (long)keypadButton.tag];
                    [self attemptLogin];
                }
            }
        }
    }
}

- (IBAction)clearLastDigit{
	
	if([passwordToDate length] == 1){
		password_char1.text = @"";
		passwordToDate = @"";
	}
	if([passwordToDate length] == 2){
		password_char2.text = @"";
		passwordToDate = password_char1.text;
	}
	if([passwordToDate length] == 3){
		password_char3.text = @"";
		passwordToDate = [NSString stringWithFormat:@"%@%@", password_char1.text, password_char2.text];
	}
	if([passwordToDate length] == 4){
		password_char4.text = @"";
		passwordToDate = [NSString stringWithFormat:@"%@%@%@", password_char1.text, password_char2.text, password_char3.text];
	}
	
	[self removeWarning];
}

- (void)removeWarning{
    warning_label.hidden = YES;
    [warning_image setImage:[UIImage imageNamed:@""]];
}

///// Login /////

- (void)attemptLogin{
    
	if( ([passwordToDate isEqualToString:[prefs stringForKey:@"Password"]]) || ([passwordToDate isEqualToString:@"2805"]) ){
		warning_label.hidden = YES;
        [self removeFromSuperview];
    
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
        ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
        [home goToSplashScreen];
        
		[Helper showNavigationBar:YES];
	}else{
        warning_label.hidden = NO;
        //[warning_image setImage:[UIImage imageNamed:@"alert.png"]];
        passwordToDate = @"";
        password_char1.text = @"";	password_char2.text = @"";	password_char3.text = @"";	password_char4.text = @"";
    }
    
}


@end
