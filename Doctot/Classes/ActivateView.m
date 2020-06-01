//
//  ActivateView.m
//  Doctot
//
//  Created by Fergal McDonnell on 03/01/2019.
//  Copyright Doctot 2019. All rights reserved.
//

#import "ActivateView.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Helper.h"
#import "Constants.h"


@implementation ActivateView

@synthesize unactivatedMessage, activate_button, continueWithoutActivation_button, resendEmail_button;
@synthesize activatePrefs;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)initialise {

    activatePrefs = [NSUserDefaults standardUserDefaults];
    
    NSString *unactivatedMessageString = @"";
    unactivatedMessageString = [unactivatedMessageString stringByAppendingFormat:@"%@\n%@", NSLocalizedString(@"Email_ActivationText", @""), [activatePrefs objectForKey:@"Email"]];
    
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    unactivatedMessage.text = unactivatedMessageString;
    [activate_button setTitle:NSLocalizedString(@"Email_ActivationButton", @"") forState:UIControlStateNormal];
    [continueWithoutActivation_button setTitle:NSLocalizedString(@"Email_ContinueWithoutActivationButton", @"") forState:UIControlStateNormal];
    [resendEmail_button setTitle:NSLocalizedString(@"Email_ActivationResendButton", @"") forState:UIControlStateNormal];
    
}

- (IBAction)executeActivate {
    
    NSString *recipientEmail = [activatePrefs objectForKey:@"Email"];
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT activated FROM User WHERE email = '%@'", recipientEmail];
    NSString *sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    NSString *sqlResultItem = [Helper returnParameter:@"activated" inJSONString:sqlResponse forRecordIndex:0];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    
    if( [sqlResultItem containsString:@"1"] ){
    
        [activatePrefs setBool:YES forKey:@"DTPlusUserActivated"];
        [[home navigationController] setNavigationBarHidden:NO animated:YES];
        [self removeFromSuperview];
    
    }else{
        
        NSString *activationMessage = @"";
        activationMessage = [activationMessage stringByAppendingFormat:@"%@\n%@", NSLocalizedString(@"Email_ActivationMessage", @""), recipientEmail];
        /*
        UIAlertController *notActivatedAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email_ActivationHeading", @"") message:activationMessage preferredStyle:UIAlertControllerStyleAlert];
        */
        UIAlertController *notActivatedAlert = [Helper defaultAlertController:home withHeading:NSLocalizedString(@"Email_ActivationHeading", @"") andMessage:activationMessage includeCancel:NO];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [notActivatedAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [notActivatedAlert addAction:ok];
        [home presentViewController:notActivatedAlert animated:YES completion:nil];
        
        [activatePrefs setBool:NO forKey:@"DTPlusUserActivated"];
    
    }
    
}

- (IBAction)continueWithoutActivation {
    //[Helper sendAppActivationEmail];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    
    UIAlertController *continueWithoutActivationAlert;
    
    if( ![Helper isConnectedToInternet] ){
        
        //continueWithoutActivationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email_ContinueWithoutActivationNoInternetHeading", @"") message:NSLocalizedString(@"Email_ContinueWithoutActivationNoInternetMessage", @"") preferredStyle:UIAlertControllerStyleAlert];
        continueWithoutActivationAlert = [Helper defaultAlertController:home withHeading:NSLocalizedString(@"Email_ContinueWithoutActivationNoInternetHeading", @"") andMessage:NSLocalizedString(@"Email_ContinueWithoutActivationNoInternetMessage", @"") includeCancel:NO];
        
        
    }else{
        
        // Check for the number of Unregistered Accesses for this User, using this App on this Device
        NSString *sqlCommand = [NSString stringWithFormat:@"SELECT COUNT(uniqueId) as NumberOfRows FROM AppUnregisteredAccess WHERE userId = '%@' AND appId = '%@' AND deviceId = '%@'", [activatePrefs objectForKey:@"DTPlusUserId"], [activatePrefs objectForKey:@"DTPlusAppId"], [activatePrefs objectForKey:@"DTPlusDeviceId"]];
        NSString *sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        NSString *sqlResultItem = [Helper returnParameter:@"NumberOfRows" inJSONString:sqlResponse forRecordIndex:0];
        int numberOfUnregisteredUserAccessesRemaining = CONTINUEWITHOUTACTIVATION_MAX - (int)[sqlResultItem integerValue];
        
        // Record the Unregistered Access
        if( numberOfUnregisteredUserAccessesRemaining > 0 ){
            NSMutableDictionary *theAttributes = [[NSMutableDictionary alloc] init];
            [theAttributes setObject:@"AppUnregisteredAccess" forKey:@"TABLE_NAME"];
            [theAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
            [theAttributes setObject:[activatePrefs objectForKey:@"DTPlusUserId"] forKey:@"userId"];
            [theAttributes setObject:[activatePrefs objectForKey:@"DTPlusAppId"] forKey:@"appId"];
            [theAttributes setObject:[activatePrefs objectForKey:@"DTPlusDeviceId"] forKey:@"deviceId"];
            [Helper executeRemoteSQLFromQueryBundle:theAttributes includeDelay:NO];
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        NSString *continueWithoutActivationMessageFormat = NSLocalizedString(@"Email_ContinueWithoutActivationMessage", @"");
        NSString *continueWithoutActivationMessage = [NSString stringWithFormat:continueWithoutActivationMessageFormat, CONTINUEWITHOUTACTIVATION_MAX, numberOfUnregisteredUserAccessesRemaining];
        if( numberOfUnregisteredUserAccessesRemaining == 0 ){
            continueWithoutActivationMessageFormat = NSLocalizedString(@"Email_ContinueWithoutActivationExpiredMessage", @"");
            continueWithoutActivationMessage = [NSString stringWithFormat:continueWithoutActivationMessageFormat, CONTINUEWITHOUTACTIVATION_MAX];
        }
        
        //continueWithoutActivationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email_ContinueWithoutActivationHeading", @"") message:continueWithoutActivationMessage preferredStyle:UIAlertControllerStyleAlert];
        continueWithoutActivationAlert = [Helper defaultAlertController:home withHeading:NSLocalizedString(@"Email_ContinueWithoutActivationHeading", @"") andMessage:continueWithoutActivationMessage includeCancel:NO];
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if( numberOfUnregisteredUserAccessesRemaining > 0 ){
            [home goToDisclaimer];
            [self removeFromSuperview];
        }
        
    }
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [continueWithoutActivationAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [continueWithoutActivationAlert addAction:ok];
    [home presentViewController:continueWithoutActivationAlert animated:YES completion:nil];
    
}

- (IBAction)resendEmail {
    [Helper sendAppActivationEmail];
    
    int inc = (int)[activatePrefs integerForKey:@"activationAttemptsCount"] + 1;
    [activatePrefs setInteger:inc forKey:@"activationAttemptsCount"];
    
    // Message for additional support in case the email doesn't send for some reason
    if( inc >= 3 ){
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
        ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
        
        //UIAlertController *requestSupportAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email_ActivationSupportHeading", @"") message:NSLocalizedString(@"Email_ActivationSupportMessage", @"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertController *requestSupportAlert = [Helper defaultAlertController:home withHeading:NSLocalizedString(@"Email_ActivationSupportHeading", @"") andMessage:NSLocalizedString(@"Email_ActivationSupportMessage", @"") includeCancel:NO];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [requestSupportAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [requestSupportAlert addAction:ok];
        [home presentViewController:requestSupportAlert animated:YES completion:nil];
        
    }
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
