//
//  ViewController.m
//  Doctot
//
//  Created by Fergal McDonnell on 06/10/2015.
//  Copyright © 2015 Fergal McDonnell. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "Helper.h"
#import "ScaleDefinition.h"
#import "DataPatient.h"
#import "DataInterview.h"
#import "DataQuestion.h"
#import "IPadLandingCell.h"
#import <LocalAuthentication/LocalAuthentication.h>

//@import Firebase;

@interface ViewController ()

@end

@implementation ViewController

@synthesize startView, signUp, activateView, touchIDFail, disclaimer, password;
@synthesize prefs, applicationID, applicationDisplayName, userName, userFirstName, userLastName, userPassword;
@synthesize isTouchIDSupported, isTouchIDSelected, isPINActivated, isDisclaimerAgreed, isUserActivated, isReloggingIn, isLegacyApp, isDeviceAlreadyRegisteredOnDTPlus, isUserNameEntered;
@synthesize isSingleAppOptionActivated, isSingleAppOptionLoaded, isSettingsActivated, isInformationActivated;
@synthesize leftBarButtonItem, rightBarButtonItem, settingsBarButton, hamburgerBarButton, infoBarButton, shareBarButton;
@synthesize about, settings, singleAppMenu, scale, book, storyBoard, storyBoardiPad, singleAppInterview;
@synthesize hamburgerView, hamburgerToggle, hamburgerFacebook, hamburgerTwitter, hamburgerSettings, hamburgerSharing, hamburgerNews, hamburgerDoximity, hamburgerGameification;
@synthesize gameificationAvatar, gameificationStatusView, gameification, gameificationRules, banner, sponsorFireButton, middleSlot, welcomeLabel, welcomeSublabel, scalesTable, scalesCollection, scalesList, isViewLoadedPreviously;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configurePreferences];
    [startView initialise];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    gameificationRules = [[GameificationRules alloc] init];
    [gameificationRules constructRules];
    [gameificationRules constructAppSettings:[prefs objectForKey:@"appName"]];
    
    [self determinStartState];
    //[self performSelectorInBackground:@selector(determinStartState) withObject:nil];
    
    // Loading the Landing Screen
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    UIColor *navBarTitleColour = [Helper getColourFromString:(NSString *)[Helper returnValueForKey:@"HomeNavbarTitleColour"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navBarTitleColour, NSFontAttributeName:[UIFont fontWithName:@"helvetica" size:20]}];
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.title = applicationDisplayName;
    
    hamburgerBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 43)];
    [hamburgerBarButton setBackgroundImage:[UIImage imageNamed:@"smToggleOff.png"] forState:UIControlStateNormal];
    [hamburgerBarButton addTarget:self action:@selector(toggleHamburgerPanel) forControlEvents:UIControlEventTouchUpInside];
    
    settingsBarButton = [[UIButton alloc] initWithFrame:CGRectMake(49, 0, 49, 43)];
    [settingsBarButton setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [settingsBarButton addTarget:self action:@selector(navigate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (settingsBarButton.frame.size.width + hamburgerBarButton.frame.size.width), 44)];
    [leftView addSubview:hamburgerBarButton];
    leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    shareBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 43)];
    [shareBarButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareBarButton addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
    
    infoBarButton = [[UIButton alloc] initWithFrame:CGRectMake(49, 0, 49, 43)];
    [infoBarButton setBackgroundImage:[UIImage imageNamed:@"info_home.png"] forState:UIControlStateNormal];
    [infoBarButton addTarget:self action:@selector(navigate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (shareBarButton.frame.size.width + infoBarButton.frame.size.width), 44)];
    [rightView addSubview:infoBarButton];
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self performSelectorInBackground:@selector(writeSponsorshipImageFromOnlineToDocumentsDirectory:) withObject:@"homeScreen"];
    [self performSelectorInBackground:@selector(writeSponsorshipImageFromOnlineToDocumentsDirectory:) withObject:@"sponsor_logo"];
    [self performSelectorInBackground:@selector(writeSponsorshipImageFromOnlineToDocumentsDirectory:) withObject:@"startHeader"];
    
    //[Helper saveOnlineResourcesToDocuments];
    [self performSelectorInBackground:@selector(saveOnlineResourcesToDocuments) withObject:nil];
     
    [self performSelectorInBackground:@selector(configureDTPlusSettingsAndAppAccess) withObject:nil];
    [self performSelectorInBackground:@selector(resubmitPreviouslyBlockedSQLQueries) withObject:nil];
    
    scalesList = [Helper sortedArray:[Helper generateScaleDefinitionsArray] byIndex:@"identifier" andAscending:YES];
    
    [self.scalesTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ScalesCell"];
    [self.scalesCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ScalesCollectionCell"];
    
    [Helper requestAppStoreReview];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [password configurePINFields];
    [password configurePINNumberPad];
    
    NSString *theFirstName = [prefs stringForKey:@"FirstName"];
    if( ([theFirstName length] == 0) || ([theFirstName isEqualToString:@"(null)"]) ){
        welcomeLabel.text = [Helper getLocalisedString:@"Welcome_Message" withScalePrefix:NO];
    }else{
        welcomeLabel.text = [NSString stringWithFormat:@"%@, %@", [Helper getLocalisedString:@"Welcome_Message_Greeting" withScalePrefix:NO], theFirstName];
    }
    welcomeSublabel.text = [Helper getLocalisedString:@"Welcome_SelectScale" withScalePrefix:NO];
    
    welcomeLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    welcomeSublabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    
    UILabel *newWelcomeLabel;
    if( ( [Helper isConnectedToInternet] ) && ( gameificationRules.active ) ){
        [gameificationAvatar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"kungfuLevel%i.png", (int)[prefs integerForKey:@"DTPlusLevel"]]] forState:UIControlStateNormal];
        [gameificationAvatar addTarget:self action:@selector(describeGameificationStatus) forControlEvents:UIControlEventTouchUpInside];
    }else{
        newWelcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake( welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y, welcomeLabel.frame.size.width, ( scalesTable.frame.origin.y - welcomeLabel.frame.origin. y ) )];
        newWelcomeLabel.text = welcomeLabel.text;
        newWelcomeLabel.textColor = [UIColor whiteColor];
        newWelcomeLabel.textAlignment = NSTextAlignmentCenter;
        newWelcomeLabel.font = [UIFont boldSystemFontOfSize:24.0];
        if( isDisclaimerAgreed ){
            [self.view addSubview:newWelcomeLabel];
        }
        
        welcomeLabel.hidden = YES;
        gameificationAvatar.hidden = YES;
    }
    
    banner.image = [Helper readSponsorshipImageFromDocuments:@"homeScreen"];
    
    [self determineSingleOrMultiAssessmentMenu];
    
    [self constructHamburgerPanel];
    
    [self realignCollectionSize];
    
    isSettingsActivated = NO;
    isInformationActivated = NO;
    isViewLoadedPreviously = YES;
    
    if( [Helper isiPad] ){
        newWelcomeLabel.frame = CGRectMake( welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y + 50, welcomeLabel.frame.size.width, ( scalesTable.frame.origin.y - welcomeLabel.frame.origin. y ) );
    }
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Startup Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Executes each time the app is opened
- (void)configurePreferences {
    
    prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] forKey:@"appID"];
    [prefs setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] forKey:@"appName"];
    applicationID = (NSString *)[prefs stringForKey:@"appID"];
    userName = (NSString *)[prefs stringForKey:@"RegistrationID"];
    userFirstName = (NSString *)[prefs stringForKey:@"FirstName"];
    userLastName = (NSString *)[prefs stringForKey:@"LastName"];
    userPassword = (NSString *)[prefs stringForKey:@"Password"];
    
    // If 'Bundle display name' is specified in Info.plist, use that. Otherwise, just use 'Bundle name'
    applicationDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if( [applicationDisplayName length] == 0 ){
        applicationDisplayName = (NSString *)[prefs stringForKey:@"appName"];
    }
    
    if ([userName isEqual:@"(null)"]) {
        userName = @"";
    }
    if ([userFirstName isEqual:@"(null)"]) {
        userFirstName = @"";
    }
    if ([userLastName isEqual:@"(null)"]) {
        userLastName = @"";
    }
    if ([userPassword isEqual:@"(null)"]) {
        userPassword = @"";
    }
    
    [prefs synchronize];
}

// Only set up when user first logs onto the app
- (void)initialisePreferences {

    [prefs setObject:@"" forKey:@"TouchID"];
    [prefs setObject:@"" forKey:@"EmailScores"];
    [prefs setObject:@"Activated" forKey:@"ShakeToReset"];
    [prefs setInteger:10 forKey:@"MaxSaves"];
    [prefs setObject:@"Grid" forKey:@"PatientVisualContext"];
    [prefs setInteger:0 forKey:@"appStoreReviewSkipCount"];
    [prefs setInteger:0 forKey:@"activationAttemptsCount"];
    
    // Additional User Details
    [prefs setObject:@"" forKey:@"userDescription"];
    [prefs setObject:@"" forKey:@"userProfession"];
    [prefs setObject:@"" forKey:@"userSpeciality"];
    [prefs setObject:@"" forKey:@"userDOB"];
    [prefs setBool:FALSE forKey:@"userAllowEmail"];
    
    // Geriatric: MTS
    [prefs setObject:[Helper getLocalisedString:@"Settings_MTS_AddressDefault" withScalePrefix:NO] forKey:@"mtsAddress"];
    [prefs setObject:[Helper getLocalisedString:@"Settings_MTS_AddressCurrentDefault" withScalePrefix:NO] forKey:@"mtsAddressCurrent"];
    [prefs setObject:[Helper getLocalisedString:@"Settings_MTS_HistoricalEventQuestionDefault" withScalePrefix:NO] forKey:@"mtsHistoricalEventQuestion"];
    [prefs setObject:[Helper getLocalisedString:@"Settings_MTS_HistoricalEventAnswerDefault" withScalePrefix:NO] forKey:@"mtsHistoricalEventAnswer"];
    [prefs setObject:[Helper getLocalisedString:@"Settings_MTS_HeadOfStateDefault" withScalePrefix:NO] forKey:@"mtsHeadOfState"];
    
    // CalciumCorrection: CACH
    [prefs setObject:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice0" withScalePrefix:NO] forKey:@"cachCalciumUnits"];
    [prefs setObject:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice0" withScalePrefix:NO] forKey:@"cachAlbuminUnits"];
    
    [self configurePreferences];
    
    [prefs synchronize];
}

- (void)determinStartState {
    
    [self retrieveDTPlusSettings];
    //[self performSelectorInBackground:@selector(retrieveDTPlusSettings) withObject:nil];
    
    isTouchIDSupported = [Helper checkIfTouchIDSupported];
    
    if( [[prefs stringForKey:@"TouchID"] isEqualToString:@"Activated"] ){
        isTouchIDSelected = YES;
    }
    
    if( !( [userPassword isEqualToString:@"(null)"] || ( [userPassword length] == 0 ) ) ){
        isPINActivated = YES;
    }
    
    /************************************************************************************************************************************************************************************************************
     
     isUserNameEntered   isUserActivated isDisclaimerAgreed  isReloggingIn  isLegacyApp   isPINActivated  isTouchIDSupported  isTouchIDSelected   isDeviceAlreadyRegisteredOnDTPlus
     Sign Up                               N                   -            -                   -                N               -               -                  -                           -
     Sign Up                               N                   -            -                   -                Y               -               -                  -                           N
     Sign Up                               N                   -            -                   -                N               -               -                  -                           N
     Ask User to use DTPlus Device         N                   -            -                   -                Y               -               -                  -                           Y
     data as the User's data
     Ask User to use DTPlus Device         N                   -            -                   -                N               -               -                  -                           Y
     data as the User's data
     Home Screen                           Y                   Y            Y                   -                -               N               Y                  N                           -
     Home Screen                           Y                   Y            Y                   -                -               N               N                  Y                           -
     PIN Entry ±                           Y                   Y            Y                   -                -               Y               -                  -                           -
     Touch ID ±                            Y                   Y            Y                   -                -               -               Y                  Y                           -
     Disclaimer                            Y                   Y            N                   -                -               -               -                  -                           -
     Activate DTPlus User                  Y                   N            -                   -                -               -               -                  -                           -
     
     ± Both PIN Entry & Touch ID can be implemented, so both modes can be used for 'double' security
     
     ************************************************************************************************************************************************************************************************************/
    
    // Check if the User has already been recorded on DTPlus: DTPlusUserID
    if( isUserNameEntered ){
        
        if( ![prefs boolForKey:@"RegisterCompletionStatus"] ){
            //[self uploadUserToFirebaseWithFirstName:[prefs stringForKey:@"FirstName"] AndLastName:[prefs stringForKey:@"LastName"] AndEmail:[prefs stringForKey:@"Email"] ];
        }
        
        if( isUserActivated ){
            
            if( isDisclaimerAgreed ){
                
                if( isPINActivated ){
                    [self proceedToPINOrHome];
                }
                
                if( isTouchIDSelected && isTouchIDSupported ){
                    //[self tryTouchID];
                    [self touchIDVerificationFails];
                }
                
                if( !( isPINActivated || (isTouchIDSelected && isTouchIDSupported) ) ){
                    [self goToSplashScreen];
                    [self constructSponsorLink];
                }
                
            }else{
                [self goToDisclaimer];
            }
            
        }else{
            
            [self goToActivateView];
            
        }
        
    }else{
        
        // Same Logic whether legacy app or not
        if( isLegacyApp ){
            
            if( isDeviceAlreadyRegisteredOnDTPlus ){
                [self askUserIfFoundDTPlusDeviceDataIsToBeUsed:[prefs objectForKey:@"DTPlusEmail"]];
            }else{
                [self goToSignUp];
            }
            
        }else{
            
            if( isDeviceAlreadyRegisteredOnDTPlus ){
                [self askUserIfFoundDTPlusDeviceDataIsToBeUsed:[prefs objectForKey:@"DTPlusEmail"]];
            }else{
                [self goToSignUp];
            }
            
        }
        
    }
    
}

- (IBAction)registerApp {
    
    signUp.warning_label.text = @"";
    
    if( ![signUp isEmailCurrentlyConfiguredCorrectly] ){
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        signUp.warning_label.text = NSLocalizedString(@"Welcome_InvalidEmail", @"");
        return;
        
    }
    
    if( ![signUp canProceedFromRegistration] ){
        
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        
    }else{
        
        [prefs setObject:signUp.firstName.text forKey:@"FirstName"];
        [prefs setObject:signUp.lastName.text forKey:@"LastName"];
        [prefs setObject:signUp.email.text forKey:@"Email"];
        [prefs synchronize];
        
        NSDate *today = [NSDate date];
        [prefs setObject:today forKey:@"RegistrationDate"];
        
        NSString *registration_id = [[NSString alloc] initWithFormat:@"%@%@%@", applicationID, signUp.email.text, today];
        [prefs setObject:registration_id forKey:@"RegistrationID"];
        
        //[self uploadUserToFirebaseWithFirstName:[prefs stringForKey:@"FirstName"] AndLastName:[prefs stringForKey:@"LastName"] AndEmail:[prefs stringForKey:@"Email"] ];
        
        [self initialisePreferences];
        [signUp removeFromSuperview];
        
        /*********************************************************************************************************************************************************************************************
         
         Check if username exists on DTPlus
         If YES, set DTPlusUserId and DTPlusUserActivated
         If YES, check if the User has already been activated
         If YES, check if AppDownlads referenceAppId, userId & deviceId match is present
         If YES, then the user must be re-logging in. Increment numberOfLogins and proceed to 6 Disclaimer
         If NO, insert new AppDownload record. 6 Disclaimer
         If NO, then send activation link email and alert User. Move to 5 Hit Proceed Option
         If NO, create User record on DTPlus. Send activation link email and alert User. 5 Hit Proceed Option
         
         *********************************************************************************************************************************************************************************************/
        
        [self retrieveDTPlusSettings];
        //[self performSelectorInBackground:@selector(retrieveDTPlusSettings) withObject:nil];
        
        // Check if a record for this email exists on the User table of DTPlus
        if( isUserNameEntered ){
            
            // Check if the User has already been activated
            if( isUserActivated ){
                
                // Check if AppDownlads referenceAppId, userId & deviceId match is present
                if( isReloggingIn ){
                    // DTPlus: Increment numberOfLogins
                    [self manageDTPlusAppDownloadsRecord];
                    
                    [self goToSplashScreen];
                    [self constructSponsorLink];
                }else{
                    // DTPlus: Insert new AppDownload record
                    [self manageDTPlusAppDownloadsRecord];
                    
                    [self goToDisclaimer];
                }
                
            }else{
                
                // If the User has not been activated, ask them to activate it by email
                [self performSelectorInBackground:@selector(configureDTPlusSettingsAndAppDownload) withObject:nil];
                [Helper sendAppActivationEmail];
                [self goToActivateView];
                
            }
            
        }else{
            
            // If the email has not already been used on DoctotPlus,
            //      1) Insert the details in DoctotPlus and
            //      2) Send Activation Email
            //      3) Go to the Activation Screen
            
            [self performSelectorInBackground:@selector(configureDTPlusSettingsAndAppDownload) withObject:nil];
            [Helper sendAppActivationEmail];
            [self goToActivateView];
            
        }
        
        /******************************************************************************************************************************************************************************************/
        
    }
    
}

- (void)askUserIfFoundDTPlusDeviceDataIsToBeUsed:(NSString *)newEmail {
    
    [self goToSignUp];
    
    /*UIAlertController *useDTPlusDeviceDataAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DTPlusDeviceDataUsedHeading", @"")
                                                                                      message:NSLocalizedString(@"DTPlusDeviceDataUsedMessage", @"")
                                                                               preferredStyle:UIAlertControllerStyleActionSheet];
    */
    UIAlertController *useDTPlusDeviceDataAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"DTPlusDeviceDataUsedHeading", @"") andMessage:NSLocalizedString(@"DTPlusDeviceDataUsedMessage", @"") includeCancel:YES];
    
    [useDTPlusDeviceDataAlert addAction:[UIAlertAction actionWithTitle:newEmail style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.signUp.firstName.text = [self.prefs objectForKey:@"DTPlusFirstName"];
        self.signUp.lastName.text = [self.prefs objectForKey:@"DTPlusLastName"];
        self.signUp.email.text = [self.prefs objectForKey:@"DTPlusEmail"];
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    /*[useDTPlusDeviceDataAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    */
    
    [self.navigationController presentViewController:useDTPlusDeviceDataAlert animated:YES completion:nil];
    
}
    
-(void)determineSingleOrMultiAssessmentMenu {
    
    if( [scalesList count] > 1 ){
        singleAppMenu.hidden = YES;
        scalesTable.hidden = NO;
        scalesCollection.hidden = NO;
    }else{
        isSingleAppOptionActivated = NO;
        
        if( !isSingleAppOptionLoaded ){
            
            singleAppMenu.hidden = NO;
            singleAppMenu.frame = scalesTable.frame;
            if( singleAppMenu.frame.size.width == 0 ){
                singleAppMenu.frame = CGRectMake( (self.view.frame.size.width / 3), (self.view.frame.size.height / 4), (self.view.frame.size.width / 3), (self.view.frame.size.height / 2));
            }
            singleAppMenu.scaleDefinition = (ScaleDefinition *)[scalesList objectAtIndex:0];
            [singleAppMenu initialise];
            
            welcomeSublabel.hidden = YES;
            scalesTable.hidden = YES;
            scalesCollection.hidden = YES;
            
            isSingleAppOptionLoaded = YES;
            
        }
        
        if( [Helper isiPad] ){
            storyBoard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        }else{
            storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        scale = [storyBoard instantiateViewControllerWithIdentifier:@"Scale"];
        scale.definition = singleAppMenu.scaleDefinition;
        scale.singleApp = YES;
        [scale viewDidLoad];
        
    }
    
}


- (void)uploadUserToFirebaseWithFirstName:(NSString *)first_name AndLastName:(NSString *)last_name AndEmail:(NSString *)e_mail {
    
    BOOL connectionAvailable = [Helper isConnectedToInternet];
    [prefs setBool:connectionAvailable forKey:@"RegisterCompletionStatus"];
    
    /* Send the data to Firebase ///////////////////////////////////////////////////////////////////////////////////////////////
    
    NSMutableDictionary *registerParameters = [[NSMutableDictionary alloc]initWithCapacity:10];
    
    userName = (NSString *)[prefs stringForKey:@"RegistrationID"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    
    [registerParameters setObject:userName forKey:@"userId"];
    [registerParameters setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceUUID"];
    [registerParameters setObject:[[UIDevice currentDevice] model] forKey:@"deviceModel"];
    [registerParameters setObject:[[UIDevice currentDevice] name] forKey:@"deviceName"];
    [registerParameters setObject:[[UIDevice currentDevice] systemName] forKey:@"deviceSystemName"];
    [registerParameters setObject:[[UIDevice currentDevice] systemVersion] forKey:@"deviceSystemVersion"];
    [registerParameters setObject:[[UIDevice currentDevice] localizedModel] forKey:@"deviceSystemModel"];
    [registerParameters setObject:country forKey:@"country"];
    [registerParameters setObject:countryCode forKey:@"countryCode"];
    [registerParameters setObject:language forKey:@"language"];
    
    [Helper postFirebaseEventForEventName:@"register" withContent:registerParameters];
    
    *//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}

- (void)realignCollectionSize {
    float noOfCellsPerRow = 0;
    float newXposition = 0;
    float newYposition = 0;
    float newHeight = 0;
    
    if( !isViewLoadedPreviously ){
        
        if( [scalesList count] == 1 )   noOfCellsPerRow = 1;
        if( [scalesList count] == 2 )   noOfCellsPerRow = 1;
        if( [scalesList count] == 3 )   noOfCellsPerRow = 1;
        if( [scalesList count] == 4 )   noOfCellsPerRow = 2;
        if( [scalesList count] == 5 )   noOfCellsPerRow = 5;
        if( [scalesList count] == 6 )   noOfCellsPerRow = 3;
        if( [scalesList count] == 7 )   noOfCellsPerRow = 3;
        if( [scalesList count] == 8 )   noOfCellsPerRow = 4;
        if( [scalesList count] == 9 )   noOfCellsPerRow = 3;
        if( [scalesList count] == 10 )   noOfCellsPerRow = 5;
        if( [scalesList count] == 11 )   noOfCellsPerRow = 5;
        if( [scalesList count] == 12 )   noOfCellsPerRow = 4;
        
        newXposition = ( self.view.frame.size.width - (noOfCellsPerRow * SCALE_CELL_WIDTH) ) / 2;
        newYposition = welcomeSublabel.frame.origin.y + welcomeSublabel.frame.size.height + 44;
        newHeight = self.view.frame.size.height - newYposition - banner.frame.size.height;
        
        if( ( [scalesList count] / noOfCellsPerRow ) <= 1 ){
            newYposition += 100;
            newHeight -= 100;
        }else{
            if( ( [scalesList count] / noOfCellsPerRow ) <= 2 ){
                newYposition += 50;
                newHeight -= 50;
            }
        }
        
        scalesCollection.frame = CGRectMake(newXposition, newYposition, (noOfCellsPerRow * ( SCALE_CELL_WIDTH + 10 ) ), newHeight);
        
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Navigations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)goToSignUp {
    
    [self.view addSubview:signUp];
    [signUp initialise];
    
}

- (void)goToActivateView {
    
    if( ![prefs boolForKey:@"DTPlusDisclaimerAgreed"] ) {
        
        disclaimer = [[Disclaimer alloc] init];
        [disclaimer initialise];
        [self.view addSubview:disclaimer];
        
    }
    
    [self.view addSubview:activateView];
    [activateView initialise];
    [Helper showNavigationBar:NO];
    
}

- (void)goToDisclaimer {
    
    if( ![prefs boolForKey:@"DTPlusDisclaimerAgreed"] ) {
        
        disclaimer = [[Disclaimer alloc] init];
        [disclaimer initialise];
        [self.view addSubview:disclaimer];
        
    }else{
        
        [self goToSplashScreen];
        
    }
    
}

- (void)goToSplashScreen {
    
    [self.view addSubview:startView];
    [startView dismissViewAfterPause];
    
}

- (void)proceedToPINOrHome {
    
    if( [userPassword length] > 0 ){
        password.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        [self.view addSubview:password];
        [password setup];
    }
    else{
        [self goToDisclaimer];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)touchIDVerificationFails {
    if( [userPassword length] > 0 ){
        touchIDFail.passwordAlsoRequired = YES;
    }else{
        touchIDFail.passwordAlsoRequired = NO;
    }
    [Helper showNavigationBar:NO];
    touchIDFail.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:touchIDFail];
}

- (IBAction)tryTouchID {
    
    if( [[prefs stringForKey:@"TouchID"] isEqualToString:@"Activated"] ){
        
        //[self proceedToPINOrHome];
        
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:NSLocalizedString(@"Settings_TouchIDRequest", @"")
                              reply:^(BOOL success, NSError *error) {
                                  if (success) {
                                      [Helper showNavigationBar:YES];
                                      NSLog(@"Auth was OK");
                                  }
                                  else {
                                      //NSLog(@"Error received: %d", error);
                                      dispatch_async(dispatch_get_main_queue(), ^(void){
                                          [self touchIDVerificationFails];
                                      });
                                  }
                              }];
        }else {
            
            // If Touch ID is not available to this device
            //[self proceedToPINOrHome];
            
        }
        
    }else{
        
        //[self proceedToPINOrHome];
        
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Doctot Plus methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureDTPlusSettingsAndAppDownload {
    
    [self retrieveDTPlusSettings];
    [self recordDTPlusAppDownload];
    
}

- (void)configureDTPlusSettingsAndAppAccess {
    
    [self retrieveDTPlusSettings];
    [self recordDTPlusAppAccess];
    
}

- (void)resubmitPreviouslyBlockedSQLQueries {
    
    [Helper resubmitStoredSQLQueries];
    
}

- (void)writeSponsorshipImageFromOnlineToDocumentsDirectory:(NSString *)imageName {
    
    [Helper writeSponsorshipImageFromOnlineToDocumentsDirectory:imageName];
    
}

- (void)saveOnlineResourcesToDocuments {
    [Helper saveOnlineResourcesToDocuments];
}

- (void)retrieveDTPlusSettings {
    
    isUserNameEntered = NO;
    isPINActivated = NO;
    isUserActivated = NO;
    isDisclaimerAgreed = NO;
    isReloggingIn = NO;
    isLegacyApp = NO;
    isTouchIDSupported = NO;
    isTouchIDSelected = NO;
    isDeviceAlreadyRegisteredOnDTPlus = NO;
    
    NSString *sqlCommand;
    NSString *sqlResponse;
    NSString *sqlResultItem;
    
    // Get zReference_App.appId from Doctot Plus
    if( [[prefs objectForKey:@"DTPlusAppId"] length] == 0 ){
        
        sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM zReference_App WHERE appstoreIdentifier = '%@'", [prefs objectForKey:@"appID"]];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        sqlResultItem = [Helper returnParameter:@"uniqueId" inJSONString:sqlResponse forRecordIndex:0];
        [prefs setObject:sqlResultItem forKey:@"DTPlusAppId"];
        
    }
    
    // Skip userId and deviceId if the email has not been set
    NSString *theEmailAddress = (NSString *)[prefs objectForKey:@"Email"];
    if( ( [theEmailAddress length] == 0 ) || ( [theEmailAddress isEqualToString:@"(null)"] ) ){
        
        [self determineDTPlusEmailBasedOnDeviceUUID];
        
        return;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Get User.email from Doctot Plus (based on the app's email)
    if( [[prefs objectForKey:@"DTPlusUserId"] length] == 0 ){
        
        sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM User WHERE email = '%@'", [prefs objectForKey:@"Email"]];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
        if( ![Helper isSQLResponseValid:sqlResponse]  ){
            
            NSMutableDictionary *theAttributes = [[NSMutableDictionary alloc] init];
            [theAttributes setObject:@"User" forKey:@"TABLE_NAME"];
            [theAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
            [theAttributes setObject:[prefs objectForKey:@"Email"] forKey:@"email"];
            [theAttributes setObject:[prefs objectForKey:@"FirstName"] forKey:@"firstName"];
            [theAttributes setObject:[prefs objectForKey:@"LastName"] forKey:@"lastName"];
            [Helper executeRemoteSQLFromQueryBundle:theAttributes includeDelay:YES];
            
            sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM User WHERE email = '%@'", [prefs objectForKey:@"Email"]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
            
        }
        
        sqlResultItem = [Helper returnParameter:@"uniqueId" inJSONString:sqlResponse forRecordIndex:0];
        [prefs setObject:sqlResultItem forKey:@"DTPlusUserId"];
        
        if( [[prefs objectForKey:@"DTPlusUserId"] length] > 0 ){
            isUserNameEntered = YES;
        }
        
    }else{
        
        isUserNameEntered = YES;
        
    }
    
    // Get Device.uniqueId from Doctot Plus
    if( [[prefs objectForKey:@"DTPlusDeviceId"] length] == 0 ){
        
        sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM Device WHERE uuid = '%@'", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
        if( ![Helper isSQLResponseValid:sqlResponse] ){
            
            NSMutableDictionary *theAttributes = [[NSMutableDictionary alloc] init];
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            NSLocale *currentLocale = [NSLocale currentLocale];
            [theAttributes setObject:@"Device" forKey:@"TABLE_NAME"];
            [theAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
            [theAttributes setObject:[prefs objectForKey:@"DTPlusUserId"] forKey:@"userId"];
            [theAttributes setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"uuid"];
            [theAttributes setObject:[[UIDevice currentDevice] model] forKey:@"model"];
            [theAttributes setObject:[[UIDevice currentDevice] name] forKey:@"name"];
            [theAttributes setObject:[[UIDevice currentDevice] systemName] forKey:@"systemName"];
            [theAttributes setObject:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
            [theAttributes setObject:[[UIDevice currentDevice] localizedModel] forKey:@"systemModel"];
            [theAttributes setObject:[usLocale displayNameForKey:NSLocaleCountryCode value:[currentLocale objectForKey:NSLocaleCountryCode]] forKey:@"country"];
            [theAttributes setObject:[currentLocale objectForKey:NSLocaleCountryCode] forKey:@"countryCode"];
            [theAttributes setObject:[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] forKey:@"language"];
            [Helper executeRemoteSQLFromQueryBundle:theAttributes includeDelay:YES];
            
            sqlCommand = [NSString stringWithFormat:@"SELECT uniqueId FROM Device WHERE uuid = '%@'", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
            
        }
        
        sqlResultItem = [Helper returnParameter:@"uniqueId" inJSONString:sqlResponse forRecordIndex:0];
        [prefs setObject:sqlResultItem forKey:@"DTPlusDeviceId"];
        
    }
    
    // Get User.email for this Device.uuid from Doctot Plus
    if( [[prefs objectForKey:@"DTPlusEmail"] length] == 0 ){
    
        [self determineDTPlusEmailBasedOnDeviceUUID];
        
    }
    
    // Get User.activated from Doctot Plus
    if( ![prefs boolForKey:@"DTPlusUserActivated"] ){
        
        NSString *emailToQuery = [prefs objectForKey:@"Email"];
        if( emailToQuery == nil ){
            emailToQuery = [prefs objectForKey:@"DTPlusEmail"];
        }
        
        // Check if User - with email=signUp.email.text - exists on DTPlus
        sqlCommand = [NSString stringWithFormat:@"SELECT * FROM User WHERE email = '%@'", emailToQuery];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
        if( [Helper isSQLResponseValid:sqlResponse] ){
            // Get Activation Status
            sqlResultItem = [Helper returnParameter:@"activated" inJSONString:sqlResponse forRecordIndex:0];
            if( [sqlResultItem containsString:@"1"] ){
                isUserActivated = YES;
            }else{
                isUserActivated = NO;
            }
        }
        [prefs setBool:isUserActivated forKey:@"DTPlusUserActivated"];
        
    }else{
        
        isUserActivated = YES;
    
    }
    
    // Get AppDownload.disclaimerAccepted from Doctot Plus
    if( ![prefs objectForKey:@"DTPlusDisclaimerAgreed"] ){
        
        sqlCommand = [NSString stringWithFormat:@"SELECT * FROM AppDownload WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", [prefs objectForKey:@"DTPlusAppId"], [prefs objectForKey:@"DTPlusUserId"], [prefs objectForKey:@"DTPlusDeviceId"]];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
        if( [Helper isSQLResponseValid:sqlResponse] ){
            isReloggingIn = YES;
            
            // Get Activation Status
            sqlResultItem = [Helper returnParameter:@"disclaimerAccepted" inJSONString:sqlResponse forRecordIndex:0];
            if( [sqlResultItem containsString:@"1"] ){
                isDisclaimerAgreed = YES;
            }else{
                isDisclaimerAgreed = NO;
            }
            [prefs setBool:isDisclaimerAgreed forKey:@"DTPlusDisclaimerAgreed"];
        }
    }else{
        
        isDisclaimerAgreed = YES;
        
    }
    
    // isLegacyApp
    if( ( [userName length] > 0 ) && ( [[prefs objectForKey:@"DTPlusUserId"] length] == 0 ) ){
        isLegacyApp = YES;
    }

}

- (void)determineDTPlusEmailBasedOnDeviceUUID {
    
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT userId FROM Device WHERE uuid = '%@'", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSString *sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    
    if( [Helper isSQLResponseValid:sqlResponse] ){
        NSString *sqlResultItem = [Helper returnParameter:@"userId" inJSONString:sqlResponse forRecordIndex:0];
        sqlCommand = [NSString stringWithFormat:@"SELECT * FROM User WHERE uniqueId = %@", sqlResultItem];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        isDeviceAlreadyRegisteredOnDTPlus = YES;
        NSString *firstNameForThisDeviceAlreadyInUseonDTPlus = [Helper returnParameter:@"firstName" inJSONString:sqlResponse forRecordIndex:0];
        NSString *lastNameForThisDeviceAlreadyInUseonDTPlus = [Helper returnParameter:@"lastName" inJSONString:sqlResponse forRecordIndex:0];
        NSString *emailForThisDeviceAlreadyInUseonDTPlus = [Helper returnParameter:@"email" inJSONString:sqlResponse forRecordIndex:0];
        [prefs setObject:firstNameForThisDeviceAlreadyInUseonDTPlus forKey:@"DTPlusFirstName"];
        [prefs setObject:lastNameForThisDeviceAlreadyInUseonDTPlus forKey:@"DTPlusLastName"];
        [prefs setObject:emailForThisDeviceAlreadyInUseonDTPlus forKey:@"DTPlusEmail"];
    }
    
}

- (void)recordDTPlusAppDownload {
    
    NSString *theUserId = (NSString *)[prefs objectForKey:@"DTPlusUserId"];
    if( ( [theUserId length] == 0 ) || ( [theUserId isEqualToString:@"(null)"] ) ){
        return;
    }
    
    [self performSelectorInBackground:@selector(manageDTPlusAppDownloadsRecord) withObject:nil];
    
}

- (void)recordDTPlusAppAccess {
    
    NSString *theUserId = (NSString *)[prefs objectForKey:@"DTPlusUserId"];
    if( ( [theUserId length] == 0 ) || ( [theUserId isEqualToString:@"(null)"] ) ){
        return;
    }
        
    NSMutableDictionary *theAttributes = [[NSMutableDictionary alloc] init];
    [theAttributes setObject:@"AppAccess" forKey:@"TABLE_NAME"];
    [theAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
    [theAttributes setObject:[prefs objectForKey:@"DTPlusAppId"] forKey:@"referenceAppId"];
    [theAttributes setObject:[prefs objectForKey:@"DTPlusUserId"] forKey:@"userId"];
    [theAttributes setObject:[prefs objectForKey:@"DTPlusDeviceId"] forKey:@"deviceId"];
    [Helper executeRemoteSQLFromQueryBundle:theAttributes includeDelay:NO];
    
}

- (void)manageDTPlusAppDownloadsRecord {
    
    /*******************************************************************************************************************
     RE-LOGIN
     If the User has already downloaded this App on this Device, then just UPDATE the numberOfLogins by incrementing it
     RECORD DOWNLOAD
     If not previously downloaded, create the initial AppDownload record
    *******************************************************************************************************************/
    
    [self retrieveDTPlusSettings];
    //[self performSelectorInBackground:@selector(retrieveDTPlusSettings) withObject:nil];
    
    // Check for a corresponding AppDownload record
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT numberOfLogins FROM AppDownload WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", [prefs objectForKey:@"DTPlusAppId"], [prefs objectForKey:@"DTPlusUserId"], [prefs objectForKey:@"DTPlusDeviceId"]];
    NSString *sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    
    // If no record was found at all, RECORD DOWNLOAD
    
    if( ![Helper isSQLResponseValid:sqlResponse] ){
        
        NSMutableDictionary *theAttributes = [[NSMutableDictionary alloc] init];
        [theAttributes setObject:@"AppDownload" forKey:@"TABLE_NAME"];
        [theAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];
        [theAttributes setObject:[prefs objectForKey:@"DTPlusAppId"] forKey:@"referenceAppId"];
        [theAttributes setObject:[prefs objectForKey:@"DTPlusUserId"] forKey:@"userId"];
        [theAttributes setObject:[prefs objectForKey:@"DTPlusDeviceId"] forKey:@"deviceId"];
        [Helper executeRemoteSQLFromQueryBundle:theAttributes includeDelay:NO];
        
    }else{
      
        // If no record was found at all, RE-LOGIN
        
        // Get the current count
        NSString *sqlResultItem = [Helper returnParameter:@"numberOfLogins" inJSONString:sqlResponse forRecordIndex:0];
        
        // increment the current count
        int incrementedValue = (int)[sqlResultItem integerValue] + 1;
        
        // update with the incremented count
        sqlCommand = [NSString stringWithFormat:@"UPDATE AppDownload SET numberOfLogins = %i WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", incrementedValue, [prefs objectForKey:@"DTPlusAppId"], [prefs objectForKey:@"DTPlusUserId"], [prefs objectForKey:@"DTPlusDeviceId"]];
        sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
    }
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Landing Screen Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)navigate:(UIButton *)sender {

    if( ( sender == settingsBarButton ) || ( sender == hamburgerSettings ) ){
        if( !isSettingsActivated ){
            isSettingsActivated = YES;
            [self performSegueWithIdentifier:@"settings" sender:nil];
        }
    }
    if( sender == infoBarButton ){
        if( !isSettingsActivated ){
            isSettingsActivated = YES;
        [self performSegueWithIdentifier:@"about" sender:nil];
        }
    }
    
    [self dismissHamburgerPanel];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"about"]){
        about = (About *)segue.destinationViewController;
        //[self recordScreenVisit:@"about"];
    }
    if([[segue identifier] isEqualToString:@"settings"]){
        settings = (Settings *)segue.destinationViewController;
        settings.scalesList = [[NSMutableArray alloc] init];
        settings.scalesList = scalesList;
    }
    if([[segue identifier] isEqualToString:@"scale"]){
        scale = (Scale *)segue.destinationViewController;
        ScaleDefinition *theDefinition = (ScaleDefinition *)sender;
        scale.definition = theDefinition;
        //[self recordScreenVisit:[NSString stringWithFormat:@"scale:%@", theDefinition.name]];
    }
    
    if([[segue identifier] isEqualToString:@"gameification"]){
        
        // The User must be activated on DTPlus (User.activated) to access the Gameification section
        if( [prefs boolForKey:@"DTPlusUserActivated"] ){
            
            gameification = (Gameification *)segue.destinationViewController;
            
        }else{
            
            //
            // Check if the User has been activated since the User has 'continued without activation' in this session
            //
            NSString *emailToQuery = [prefs objectForKey:@"Email"];
            if( emailToQuery == nil ){
                emailToQuery = [prefs objectForKey:@"DTPlusEmail"];
            }
            
            // Check if User - with email=signUp.email.text - exists on DTPlus
            NSString *sqlCommand = [NSString stringWithFormat:@"SELECT * FROM User WHERE email = '%@'", emailToQuery];
            NSString *sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
            NSString *sqlResultItem;
            bool isUserActivated = NO;
            
            if( [Helper isSQLResponseValid:sqlResponse] ){
                // Get Activation Status
                sqlResultItem = [Helper returnParameter:@"activated" inJSONString:sqlResponse forRecordIndex:0];
                if( [sqlResultItem containsString:@"1"] ){
                    isUserActivated = YES;
                }else{
                    isUserActivated = NO;
                }
            }
            [prefs setBool:isUserActivated forKey:@"DTPlusUserActivated"];
            
            //
            // If the User has been activated since, then go to the Gameification section. Otherwise, send the dialog informing that the User needs to be activated
            //
            if( isUserActivated ){
                
                gameification = (Gameification *)segue.destinationViewController;
                
            }else{
                
                UIAlertController *activateUserAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Settings_ActivateUser", @"") andMessage:NSLocalizedString(@"Settings_ActivateUserMessage", @"") includeCancel:NO];
                
                [activateUserAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }]];
                
                [self presentViewController:activateUserAlert animated:YES completion:nil];
                
            }
            
        }
        
    }
    
    if([[segue identifier] isEqualToString:@"book"]){
        book = (Book *)segue.destinationViewController;
        ScaleDefinition *theDefinition = (ScaleDefinition *)sender;
        Book *aBook = [Helper generateBook:theDefinition.name];
        book.name = theDefinition.name;
        book.definition = theDefinition;
        NSLog(@"book.name: %@", book.name);
        NSLog(@"book.definition: %@", book.definition);
        NSLog(@"aBook.name: %@", aBook.name);
    }
    
}

- (void)shareApp {
    [Helper shareApp:self];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  HamburgerPanel methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)constructHamburgerPanel {
    
    hamburgerView = [[UIView alloc] initWithFrame:CGRectMake( (self.view.frame.size.width * -1), 0, self.view.frame.size.width, self.view.frame.size.height)];
    hamburgerView.backgroundColor = [UIColor clearColor];
    hamburgerView.layer.cornerRadius = 10;
    hamburgerView.layer.masksToBounds = true;
    
    UIImageView *hamburgerBackgroundPanel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HAMBURGER_PANEL_WIDTH, hamburgerView.frame.size.height)];
    hamburgerBackgroundPanel.image = [UIImage imageNamed:@"background.png"];
    
    UIButton *hamburgerDismiss = [[UIButton alloc] initWithFrame:CGRectMake(hamburgerBackgroundPanel.frame.size.width, hamburgerView.frame.origin.y, (hamburgerView.frame.size.width - hamburgerBackgroundPanel.frame.size.width), hamburgerView.frame.size.height)];
    [hamburgerDismiss addTarget:self action:@selector(dismissHamburgerPanel) forControlEvents:UIControlEventTouchUpInside];
    
    [hamburgerView addSubview:hamburgerBackgroundPanel];
    [hamburgerView addSubview:hamburgerDismiss];
    
    int yOffset = 2;
    hamburgerSettings = [[UIButton alloc] initWithFrame:CGRectMake( 0, (yOffset * HAMBURGER_BUTTON_SIDE), hamburgerBackgroundPanel.frame.size.width, HAMBURGER_BUTTON_SIDE)];
    [hamburgerSettings addTarget:self action:@selector(navigate:) forControlEvents:UIControlEventTouchUpInside];
    [self insertHamburgerButtonUI:@"SettingsTitle" andYOffset:yOffset];
    
    yOffset++;
    hamburgerNews = [[UIButton alloc] initWithFrame:CGRectMake( 0, (yOffset * HAMBURGER_BUTTON_SIDE), hamburgerBackgroundPanel.frame.size.width, HAMBURGER_BUTTON_SIDE)];
    [hamburgerNews addTarget:self action:@selector(goToHamburger:) forControlEvents:UIControlEventTouchUpInside];
    [self insertHamburgerButtonUI:@"Scale_News_Shortened" andYOffset:yOffset];
    /*
    yOffset++;
    hamburgerDoximity = [[UIButton alloc] initWithFrame:CGRectMake( 0, (yOffset * HAMBURGER_BUTTON_SIDE), hamburgerBackgroundPanel.frame.size.width, HAMBURGER_BUTTON_SIDE)];
    [hamburgerDoximity addTarget:self action:@selector(goToHamburger:) forControlEvents:UIControlEventTouchUpInside];
    [self insertHamburgerButtonUI:@"Hamburger_Doximity" andYOffset:yOffset];
    */
    yOffset++;
    NSString *appSharingEnabled = (NSString *)[Helper returnValueForKey:@"DoctotAppSharingEnabled"];
    if( [appSharingEnabled isEqualToString:@"Yes"]  ){
        hamburgerSharing = [[UIButton alloc] initWithFrame:CGRectMake( 0, (yOffset * HAMBURGER_BUTTON_SIDE), hamburgerBackgroundPanel.frame.size.width, HAMBURGER_BUTTON_SIDE)];
        [hamburgerSharing addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
        [self insertHamburgerButtonUI:@"Hamburger_Sharing" andYOffset:yOffset];
    }
    
    yOffset++;
    if( ( [Helper isConnectedToInternet] ) && ( gameificationRules.active ) ){
        hamburgerGameification = [[UIButton alloc] initWithFrame:CGRectMake( 0, (yOffset * HAMBURGER_BUTTON_SIDE), hamburgerBackgroundPanel.frame.size.width, HAMBURGER_BUTTON_SIDE)];
        [hamburgerGameification addTarget:self action:@selector(describeGameificationStatus) forControlEvents:UIControlEventTouchUpInside];
        [self insertHamburgerButtonUI:@"Gameification_Title" andYOffset:yOffset];
    }
    
    hamburgerTwitter = [[UIButton alloc] initWithFrame:CGRectMake( (0 * HAMBURGER_BUTTON_SIDE), (hamburgerView.frame.size.height - HAMBURGER_BUTTON_SIDE), HAMBURGER_BUTTON_SIDE, HAMBURGER_BUTTON_SIDE)];
    [hamburgerTwitter setBackgroundImage:[UIImage imageNamed:@"smTwitter.png"] forState:UIControlStateNormal];
    [hamburgerTwitter addTarget:self action:@selector(goToHamburger:) forControlEvents:UIControlEventTouchUpInside];
    
    hamburgerFacebook = [[UIButton alloc] initWithFrame:CGRectMake( (1 * HAMBURGER_BUTTON_SIDE), (hamburgerView.frame.size.height - HAMBURGER_BUTTON_SIDE), HAMBURGER_BUTTON_SIDE, HAMBURGER_BUTTON_SIDE)];
    [hamburgerFacebook setBackgroundImage:[UIImage imageNamed:@"smFacebook.png"] forState:UIControlStateNormal];
    [hamburgerFacebook addTarget:self action:@selector(goToHamburger:) forControlEvents:UIControlEventTouchUpInside];
    
    [hamburgerView addSubview:hamburgerSettings];
    [hamburgerView addSubview:hamburgerNews];
    //[hamburgerView addSubview:hamburgerDoximity];
    [hamburgerView addSubview:hamburgerSharing];
    [hamburgerView addSubview:hamburgerGameification];
    
    NSString *soialMediaEnabled = (NSString *)[Helper returnValueForKey:@"DoctotSocialMediaEnabled"];
    if( [soialMediaEnabled isEqualToString:@"Yes"]  ){
        [hamburgerView addSubview:hamburgerTwitter];
        [hamburgerView addSubview:hamburgerFacebook];
    }
    
    
    [self.view addSubview:hamburgerView];
    
}

- (void)insertHamburgerButtonUI:(NSString *)type andYOffset:(int)yOffset {
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake( 0, (yOffset * HAMBURGER_BUTTON_SIDE), HAMBURGER_BUTTON_SIDE, HAMBURGER_BUTTON_SIDE)];
    UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake( HAMBURGER_BUTTON_SIDE, (yOffset * HAMBURGER_BUTTON_SIDE), HAMBURGER_PANEL_WIDTH - HAMBURGER_BUTTON_SIDE, HAMBURGER_BUTTON_SIDE)];
    
    buttonText.text = [Helper getLocalisedString:type withScalePrefix:NO];
    buttonText.textColor = [UIColor whiteColor];
    
    NSString *iconImageName;
    if( [type containsString:@"Settings"] ){    iconImageName = @"settings.png";    }
    if( [type containsString:@"Hamburger_Sharing"] ){    iconImageName = @"share.png";    }
    if( [type containsString:@"Scale_News_Shortened"] ){    iconImageName = @"smNews.png";    }
    if( [type containsString:@"Hamburger_Doximity"] ){    iconImageName = @"smDoximity.png";    }
    if( [type containsString:@"Gameification_Title"] ){    iconImageName = @"smKungFu.png";    }
    iconImage.image = [UIImage imageNamed:iconImageName];
    
    [hamburgerView addSubview:iconImage];
    [hamburgerView addSubview:buttonText];
    
}

- (void)dismissHamburgerPanel {
    
    hamburgerView.frame = CGRectMake( 10, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self toggleHamburgerPanel];
    
}

- (void)toggleHamburgerPanel {
    
    [UIView beginAnimations:@"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration:1.0];
    
    if( hamburgerView.frame.origin.x < 0 ){
        hamburgerView.frame = CGRectMake( 0, 0, hamburgerView.frame.size.width, hamburgerView.frame.size.height);
        [hamburgerToggle setBackgroundImage:[UIImage imageNamed:@"smToggleOn.png"] forState:UIControlStateNormal];
    }else{
        hamburgerView.frame = CGRectMake( ( hamburgerView.frame.size.width * -1 ), 0, hamburgerView.frame.size.width, hamburgerView.frame.size.height);
        [hamburgerToggle setBackgroundImage:[UIImage imageNamed:@"smToggleOff.png"] forState:UIControlStateNormal];
    }
    
    [UIView commitAnimations];
    
}

- (void)goToHamburger:(id)sender {
    
    NSURL *smURL;
    NSString *smURLString;
    NSString *smURLBrowserString;
    
    if( ( sender == hamburgerFacebook ) || ( sender == hamburgerTwitter ) ){
        
        if( sender == hamburgerFacebook ){
            smURLString = HAMBURGER_FACEBOOK_APP;
            smURLBrowserString = HAMBURGER_FACEBOOK_BROWSER;
        }
        if( sender == hamburgerTwitter ){
            smURLString = HAMBURGER_TWITTER_APP;
            smURLBrowserString = HAMBURGER_TWITTER_BROWSER;
        }
        
        smURL = [NSURL URLWithString:smURLString];
        if ( ![[UIApplication sharedApplication] canOpenURL:smURL] && ![smURLString hasPrefix:@"fb://"] ){
            smURL = [NSURL URLWithString:smURLBrowserString];
        }
        [[UIApplication sharedApplication] openURL:smURL options:@{} completionHandler:^(BOOL success){}];
        
    }
    
    if( sender == hamburgerNews ){
        [self performSegueWithIdentifier:@"smNews" sender:nil];
    }
    
    if( sender == hamburgerDoximity ){
        smURL = [NSURL URLWithString:HAMBURGER_DOXIMITY_URL];
        [[UIApplication sharedApplication] openURL:smURL options:@{} completionHandler:^(BOOL success){}];
    }
    
    [hamburgerView addSubview:hamburgerSettings];
    [hamburgerView addSubview:hamburgerSharing];
    [hamburgerView addSubview:hamburgerNews];
    [hamburgerView addSubview:hamburgerDoximity];
    if( ( [Helper isConnectedToInternet] ) && ( gameificationRules.active ) ){
        [hamburgerView addSubview:hamburgerGameification];
    }
    
    [self toggleHamburgerPanel];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)constructSponsorLink {
    
    NSString *sponsorsLink = (NSString *)[Helper returnValueForKey:@"SponsorsLink"];
    
    if( !( ([sponsorsLink length] == 0) || [sponsorsLink isEqualToString:@"None"] || [sponsorsLink isEqualToString:@"No"] ) ){
        
        sponsorFireButton.hidden = NO;
        
    }else{
        sponsorFireButton.hidden = YES;
    }
    
}

- (IBAction)fireSponsorLink {
    
    NSString *sponsorsLink = (NSString *)[Helper returnValueForKey:@"SponsorsLink"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sponsorsLink] options:@{} completionHandler:^(BOOL success){}];
    
}

- (IBAction)describeGameificationStatus {
    
    [self dismissHamburgerPanel];
    
    [self performSegueWithIdentifier:@"gameification" sender:nil];

}

- (void)recordScreenVisit:(NSString *)screenVisited {
    
    /* Send the data to Firebase ///////////////////////////////////////////////////////////////////////////////////////////////
    
    NSMutableDictionary *screenVisitParameters = [[NSMutableDictionary alloc] initWithCapacity:2];
    [screenVisitParameters setObject:userName forKey:(NSString *)[prefs stringForKey:@"RegistrationID"]];
    [screenVisitParameters setObject:screenVisited forKey:@"screenName"];
    
    [Helper postFirebaseEventForEventName:@"screenVisit" withContent:screenVisitParameters];
    */
}

    
// Single Assessment App menu methods
-(IBAction)goDirectToSingleAppMenuCommand:(id)sender {
    
    // Avoids double clicking
    if( isSingleAppOptionActivated ){
        return;
    }
    
    // Firebase record
    //[self recordScreenVisit:[NSString stringWithFormat:@"scale:%@", scale.definition.name]];
    
    // 3 Options
    if( sender == singleAppMenu.startInterview ){
        
        singleAppInterview = [storyBoard instantiateViewControllerWithIdentifier:@"Interview"];
        singleAppInterview.definition = scale.definition;
        singleAppInterview.questions = scale.questions;
        singleAppInterview.singleApp = YES;
        [[self navigationController] pushViewController:singleAppInterview animated:YES];
        
    }
        
    if( sender == singleAppMenu.viewInformation ){
        
        Information *information = [storyBoard instantiateViewControllerWithIdentifier:@"Information"];
        information.scaleDefinition = scale.definition;
        information.singleApp = YES;
        [[self navigationController] pushViewController:information animated:YES];
        
    }
        
    if( sender == singleAppMenu.viewScores ){
        
        Scores *scores = [storyBoard instantiateViewControllerWithIdentifier:@"Scores"];
        scores.scaleDefinition = scale.definition;
        scores.questions = scale.questions;
        scores.singleApp = YES;
        [[self navigationController] pushViewController:scores animated:YES];
        
    }
    
    isSingleAppOptionActivated = YES;
    
}

///////////////////////////////////////////////////////////////////////////////////////////
// Collection View Methods
///////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sections = 1;
    
    if( collectionView == scalesCollection ){
        sections = 1;
    }
    
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rowsInSection = 0;
    
    if( collectionView == scalesCollection ){
        rowsInSection = [scalesList count];
    }
    
    return rowsInSection;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCALE_CELL_WIDTH, SCALE_CELL_HEIGHT);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ScaleCollectionCellIdentifier = @"ScalesCollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScaleCollectionCellIdentifier forIndexPath:indexPath];
    
    IPadLandingCell *scaleCell;
    ScaleDefinition *thisScaleDefinition;
    
    if( collectionView == scalesCollection ){
        
        scaleCell = [[IPadLandingCell alloc] initWithFrame:CGRectMake(0, 0, SCALE_CELL_WIDTH, SCALE_CELL_HEIGHT)];
        thisScaleDefinition = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
        [scaleCell setupForScaleDefinition:thisScaleDefinition];
        [cell addSubview:scaleCell];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScaleDefinition *thisScale = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
    
    if( thisScale.isScale ){
        [self performSegueWithIdentifier:@"scale" sender:thisScale];
    }else{
        if( [thisScale.parentApp isEqualToString:@"GOLD"] && [thisScale.name isEqualToString:@"GOLD Guidelines"] ){
            [self performSegueWithIdentifier:@"book" sender:thisScale];
        }
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////
// Table View Methods
///////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [scalesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *scalesCellIdentifier = @"ScalesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scalesCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:scalesCellIdentifier];
    }
    // To keep the list refreshed when scrolling
    for(UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }
    
    ScaleDefinition *thisScale = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
    
    UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, cell.frame.size.width - 50, cell.frame.size.height)];
    scaleLabel.text = (NSString *)thisScale.displayTitle;
    scaleLabel.textAlignment = NSTextAlignmentLeft;
    scaleLabel.textColor = [UIColor whiteColor];
    scaleLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 70, 0, 50, cell.frame.size.height)];
    chevron.image = [UIImage imageNamed:@"chevron_white_right.png"];
    chevron.contentMode = UIViewContentModeCenter;
    
    UIImageView *underline = [[UIImageView alloc] initWithFrame:CGRectMake(scaleLabel.frame.origin.x - 5, cell.frame.size.height - 2, scaleLabel.frame.size.width + 10, 2)];
    underline.image = [UIImage imageNamed:@"content_divider.png"];
    
    if( indexPath.row == 0 ){
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(scaleLabel.frame.origin.x - 5, 0, scaleLabel.frame.size.width + 10, 2)];
        topLine.image = [UIImage imageNamed:@"content_divider.png"];
        [cell.contentView addSubview:topLine];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = myBackView;
    
    [cell.contentView addSubview:scaleLabel];
    [cell.contentView addSubview:chevron];
    [cell.contentView addSubview:underline];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScaleDefinition *thisScale = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
    
    if( thisScale.isScale ){
        [self performSegueWithIdentifier:@"scale" sender:thisScale];
    }else{
        if( [thisScale.parentApp isEqualToString:@"GOLD"] && [thisScale.name isEqualToString:@"GOLD Guidelines"] ){
            [self performSegueWithIdentifier:@"book" sender:thisScale];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
