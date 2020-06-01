//
//  Gameification.m
//  Doctot
//
//  Created by Fergal McDonnell on 03/08/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "Gameification.h"
#import "Constants.h"
#import "Helper.h"
#import "SQLUser.h"

@interface Gameification ()

@end

@implementation Gameification

@synthesize leftNavBarButton, rightNavBarButton, prefs;
@synthesize firstName, lastName, doctotKarmaScore, appScore, level, appList;
@synthesize topContainer, doctotLogo, name, topDivider, doctotKarmaLevelTitleLabel, doctotKarmaLevelLabel ,doctotKarmaSymbolTitleLabel, doctotKarmaSymbolLabel, doctotKarmaScoreTitleLabel, doctotKarmaScoreLabel, doctotKarmaScoreIcon;
@synthesize karmaExplained;
@synthesize baseContainer, appScoresView, appListIcon, listOfAppsHeading, baseDivider, listOfApps;
@synthesize rules, appAccesses, appDownloads, assessmentSaves, allApps, allUsers;
@synthesize spinnerView, spinnerBackground, spinnerLabel, spinner;
@synthesize infoView, infoContent, infoDismiss, infoViewVisible;
@synthesize gameificationAvatar, gameificationStatusView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Gameification_Title" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    appList = [[NSMutableArray alloc] init];
    firstName = (NSString *)[prefs objectForKey:@"FirstName"];
    lastName = (NSString *)[prefs objectForKey:@"LastName"];
    doctotKarmaScore = 0;
    appScore = 0;
    
    [self setUIElementsVisibility:NO];
    
    [doctotLogo setImage:[UIImage imageNamed:@"doctot_logo_karma.png"]];
    name.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    [doctotKarmaScoreIcon setImage:[UIImage imageNamed:@""]];
    doctotKarmaLevelTitleLabel.text = [Helper getLocalisedString:@"Gameification_KungfuBelt" withScalePrefix:NO];
    doctotKarmaLevelLabel.text = @"-";
    doctotKarmaSymbolTitleLabel.text = [Helper getLocalisedString:@"Gameification_KungfuSymbol" withScalePrefix:NO];
    doctotKarmaSymbolLabel.text = @"-";
    doctotKarmaScoreTitleLabel.text = [Helper getLocalisedString:@"Gameification_KungfuScore" withScalePrefix:NO];
    doctotKarmaScoreLabel.text = @"-";
    
    [karmaExplained setTitle:[Helper getLocalisedString:@"Gameification_KungfuExplanation" withScalePrefix:NO] forState:UIControlStateNormal];
    karmaExplained.layer.borderWidth = 2.0f;
    karmaExplained.layer.borderColor = [UIColor whiteColor].CGColor;
    karmaExplained.layer.cornerRadius = 3.0;
    [karmaExplained addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
    listOfAppsHeading.text = [Helper getLocalisedString:@"Gameification_AppList" withScalePrefix:NO];
    
    [self constructInfoView];
    [self displaySpinnerView:YES];
    
    if( ![Helper isConnectedToInternet] ){
        [self dismiss];
        [self errorAlertView:NSLocalizedString(@"Gameification_NoConnection", @"")];
    }
    
    rules = [[GameificationRules alloc] init];
    [rules constructRules];
    [rules constructAppSettings:[prefs objectForKey:@"appName"]];
    
    if( !rules.active ){
        [self dismiss];
        [self errorAlertView:NSLocalizedString(@"Gameification_NotAvailable", @"")];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {

    NSString *sqlStatement;
    id sqlResponse;
    
    // Get AppAccess data for this User
    sqlStatement = [NSString stringWithFormat:@"SELECT * FROM AppAccess WHERE userId = %@", [prefs objectForKey:@"DTPlusUserId"]];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlStatement includeDelay:YES];
    appAccesses = [Helper returnArrayOfType:@"AppAccess" FromJSONStringResult:sqlResponse];
    
    // Get AppDownload data for this User
    sqlStatement = [NSString stringWithFormat:@"SELECT * FROM AppDownload WHERE userId = %@", [prefs objectForKey:@"DTPlusUserId"]];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlStatement includeDelay:YES];
    appDownloads = [Helper returnArrayOfType:@"AppDownload" FromJSONStringResult:sqlResponse];
    
    // Get AssessmentSave data for this User
    sqlStatement = [NSString stringWithFormat:@"SELECT * FROM AssessmentSave WHERE userId = %@", [prefs objectForKey:@"DTPlusUserId"]];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlStatement includeDelay:YES];
    assessmentSaves = [Helper returnArrayOfType:@"AssessmentSave" FromJSONStringResult:sqlResponse];
    
    // Get all possible apps available for iOS platform
    sqlStatement = [NSString stringWithFormat:@"SELECT * FROM zReference_App WHERE platform = 'Apple'"];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlStatement includeDelay:YES];
    allApps = [Helper returnArrayOfType:@"zReference_App" FromJSONStringResult:sqlResponse];
    
    // Get all User Demograhic dataentered (i.e. in the Owner Details section of Settings - excluding First Name, Last Name and Email)
    sqlStatement = [NSString stringWithFormat:@"SELECT * FROM User WHERE uniqueId = '%@'", [prefs objectForKey:@"DTPlusUserId"]];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlStatement includeDelay:YES];
    allUsers = [Helper returnArrayOfType:@"User" FromJSONStringResult:sqlResponse];
    
    [self checkForDuplicateDownloads];
    [self generateAppList];
    [self calculateScores];
    
    [listOfApps registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [listOfApps reloadData];
    
    [self displaySpinnerView:NO];
    
    if( [appList count] <= 1 ){
        appScoresView.hidden = YES;
        [self constructSingleAppProfileView];
    }else{
        appScoresView.hidden = NO;
        karmaExplained.frame = CGRectMake(karmaExplained.frame.origin.x, (baseContainer.frame.origin.y - (topContainer.frame.origin.y + topContainer.frame.size.height)), karmaExplained.frame.size.width, karmaExplained.frame.size.height);
    }
    
    [self setUIElementsVisibility:YES];
    
}

- (void)setUIElementsVisibility:(BOOL)visible {
    
    topContainer.hidden = !visible;
    name.hidden = !visible;
    topDivider.hidden = !visible;
    doctotKarmaLevelTitleLabel.hidden = !visible;
    doctotKarmaLevelLabel.hidden = !visible;
    doctotKarmaSymbolTitleLabel.hidden = !visible;
    doctotKarmaSymbolLabel.hidden = !visible;
    doctotKarmaScoreTitleLabel.hidden = !visible;
    doctotKarmaScoreLabel.hidden = !visible;
    karmaExplained.hidden = !visible;
    baseContainer.hidden = !visible;
    appListIcon.hidden = !visible;
    listOfAppsHeading.hidden = !visible;
    baseDivider.hidden = !visible;
    
}

- (void)showInfo {
    
    if( !infoViewVisible ){
        
        infoViewVisible = YES;
        [self.view addSubview:infoView];
        
        [UIView beginAnimations:@"infoAnimation" context: nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:1.0];
        
        infoView.frame = CGRectMake(0, infoView.frame.origin.y, self.view.frame.size.width, infoView.frame.size.height);
        
        [UIView commitAnimations];
        
    }
    
}

- (void)errorAlertView:(NSString *)theMessage {
    
    /*UIAlertController *errorlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Gameification_MessageTitle", @"")
                                                                                         message:theMessage
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    */
    UIAlertController *errorAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Gameification_MessageTitle", @"") andMessage:theMessage includeCancel:NO];
    
    [errorAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

- (void)displaySpinnerView:(BOOL)show {
    
    if( show ){
        
        [self performSelector:@selector(constructSpinnerView) withObject:nil afterDelay:0.05];
        
    }else{
        
        [spinner stopAnimating];
        [spinnerView removeFromSuperview];
        
    }
    
}

- (void)constructSpinnerView {
    
    float spinnerViewWidth = 200, spinnerViewHeight = 200;
    float spinnerWidth = 50, spinnerHeight = 50;
    float spinnerLabelHeight = 75;
    
    CGSize questionDimensions = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height); // [Helper getInterviewQuestionDimensions];
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake( ( (questionDimensions.width - spinnerViewWidth) / 2 ) ,
                                                           ( (questionDimensions.height - spinnerViewHeight) / 2 ),
                                                           spinnerViewWidth, spinnerViewHeight)];
    
    spinnerBackground = [Helper returnAnimatedImage:[NSArray arrayWithObjects:
                                                    [UIImage imageNamed:@"loader1.png"],
                                                     [UIImage imageNamed:@"loader2.png"],
                                                     [UIImage imageNamed:@"loader3.png"],
                                                     [UIImage imageNamed:@"loader4.png"],
                                                     [UIImage imageNamed:@"loader5.png"],
                                                     nil]];
    spinnerBackground.frame = CGRectMake( 0, 0, spinnerViewWidth, spinnerViewHeight);
    [self.view addSubview:spinnerBackground];
    //spinnerBackground = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, spinnerViewWidth, spinnerViewHeight)];
    //spinnerBackground.image = [UIImage imageNamed:@"content.png"];
    //spinnerBackground.layer.cornerRadius = 20.0;
    //spinnerBackground.alpha = 0.95;
    
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( ( (spinnerView.frame.size.width - spinnerWidth) / 2 ),
                                                                        ( (spinnerView.frame.size.height - spinnerHeight) / 2 ),
                                                                        spinnerWidth, spinnerHeight)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    spinner.backgroundColor = [UIColor clearColor];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    
    //spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (spinnerView.frame.size.height - spinnerLabelHeight), spinnerView.frame.size.width, spinnerLabelHeight)];
    spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake( (spinnerBackground.frame.origin.x + (spinnerBackground.frame.size.width * 0.25)),
                                                             (spinnerBackground.frame.origin.y + (spinnerBackground.frame.size.height * 0.25)),
                                                             (spinnerBackground.frame.size.width * 0.5),
                                                             (spinnerBackground.frame.size.height * 0.5))];
    spinnerLabel.text = [Helper getLocalisedString:@"Gameification_PleaseWait" withScalePrefix:NO];
    spinnerLabel.textColor = [UIColor whiteColor];
    spinnerLabel.textAlignment = NSTextAlignmentCenter;
    spinnerLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    spinnerLabel.backgroundColor = [UIColor clearColor];
    spinnerLabel.numberOfLines = 3;
    
    [spinnerView addSubview:spinnerBackground];
    //[spinnerView addSubview:spinner];
    [spinnerView addSubview:spinnerLabel];
    
    [self.view addSubview:spinnerView];
    
}

- (void)constructInfoView {
    
    infoViewVisible = NO;
    
    // Adjustment for iPhone X, XS, 11 Pro / XS Max, 11 Pro Max / XR, 11: prevents the view from appearing in the header titlebar
    float yInfoViewOffset = GAMEIFICATION_INFO_Y_OFFSET + [Helper adjustYShiftDownwards];
    
    infoView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, yInfoViewOffset, self.view.frame.size.width, self.view.frame.size.height - yInfoViewOffset)];
    infoView.backgroundColor = [UIColor clearColor];
    
    infoDismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, (infoView.frame.size.height - 50), infoView.frame.size.width, 50)];
    [infoDismiss setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [infoDismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    float offset = 25;
    infoContent = [[CustomWebView alloc] initWithFrame:CGRectMake(offset, offset, (infoView.frame.size.width - (offset * 2)), (infoView.frame.size.height - (offset * 2)))];
    //infoContent = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, (infoView.frame.size.height - infoDismiss.frame.size.height) )];
    [infoContent setup:@"GameificationInfo"];
    infoContent.backgroundColor = [UIColor clearColor];
    [infoContent.content reload];
    
    UIImageView *infoBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, infoView.frame.size.height)];
    //UIView *infoBackground = [[UIView alloc] initWithFrame:CGRectMake(infoContent.frame.origin.x, GAMEIFICATION_INFO_Y_OFFSET, infoContent.frame.size.width, infoContent.frame.size.height - GAMEIFICATION_INFO_Y_OFFSET)];
    infoBackground.backgroundColor = [UIColor whiteColor];
    infoBackground.layer.cornerRadius = 5.0;
    infoBackground.layer.borderWidth = 5.0;
    infoBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if( ![Helper isiPad] ){
        [infoView addSubview:infoBackground];
    }
    [infoView addSubview:infoContent];
    //[infoView addSubview:infoDismiss];
    
}

- (void)constructSingleAppProfileView {
    
    //CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    UIView *singleAppView = [[UIView alloc] initWithFrame:CGRectMake( karmaExplained.frame.origin.x, ( baseContainer.frame.origin.y + 5 ), karmaExplained.frame.size.width, ( baseContainer.frame.size.height - 10 ) ) ];
    singleAppView.backgroundColor = [UIColor clearColor];
    singleAppView.center = CGPointMake( (self.view.frame.size.width / 2), singleAppView.center.y);
    
    UILabel *singleAppHeading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, singleAppView.frame.size.width, 75)];
    singleAppHeading.text = [Helper getLocalisedString:@"Gameification_GetOtherApps" withScalePrefix:NO];
    singleAppHeading.textColor = [UIColor whiteColor];
    singleAppHeading.textAlignment = NSTextAlignmentCenter;
    singleAppHeading.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    singleAppHeading.backgroundColor = [UIColor clearColor];
    singleAppHeading.numberOfLines = 3;
    
    WKWebView *appsWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, (singleAppHeading.frame.origin.y + singleAppHeading.frame.size.height), singleAppView.frame.size.width, ( singleAppView.frame.size.height - singleAppHeading.frame.size.height ) )];
    NSString* htmlString= [Helper getLocalisedString:@"Loading" withScalePrefix:NO];
    [appsWebview loadHTMLString:htmlString baseURL:nil];
    [appsWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@availableapps.html", RESOURCE_URL_BASE]]]];
    appsWebview.backgroundColor = [UIColor clearColor];
    appsWebview.opaque = NO;
    
    [singleAppView addSubview:singleAppHeading];
    [singleAppView addSubview:appsWebview];
    
    [self.view addSubview:singleAppView];
    
}

- (void)checkForDuplicateDownloads {
    
    NSString *appIdListUniques = @"";
    NSString *appIdListDuplicatesFound = @"";
    
    // Locate Duplicates: 1) Mark Duplicates for deletion 2) Add the Duplicate to a list
    for( SQLAppDownload *aDownload in appDownloads ){
        if( [appIdListUniques containsString:[NSString stringWithFormat:@"-%i-", aDownload.referenceAppId]] ){
            aDownload.isDuplicate = YES;
            appIdListDuplicatesFound = [appIdListDuplicatesFound stringByAppendingFormat:@"-%i-", aDownload.referenceAppId];
        }else{
            aDownload.isDuplicate = NO;
            appIdListUniques = [appIdListUniques stringByAppendingFormat:@"-%i-", aDownload.referenceAppId];
        }
    }
    
    // Delete the Duplicates from the downloads array
    SQLAppDownload *checkDownload;
    for( int i = (int)([appDownloads count] - 1) ; i >= 0 ; i-- ){
        checkDownload = (SQLAppDownload *)[appDownloads objectAtIndex:i];
        if( checkDownload.isDuplicate ){
            [appDownloads removeObjectAtIndex:i];
        }
    }
    
    // Set the number of downloads found for each app (Duplicates + 1), by iterating through the appIdListDuplicatesFound string to see how many duplicaters there were for each app
    NSString *searchString = appIdListDuplicatesFound;
    for( SQLAppDownload *aDownload in appDownloads ){
        for( int i = 0; i < [searchString length] ; i++ ){
            searchString = [searchString substringFromIndex:i];
            if( [searchString hasPrefix:[NSString stringWithFormat:@"-%i-", aDownload.referenceAppId]] ){
                aDownload.numberOfDuplicates++;
            }
        }
    }
    
}

- (void)generateAppList {
    
    GameificationAppDetails *newApp;
    for( SQLAppDownload *aDownload in appDownloads ){
        
        newApp = [[GameificationAppDetails alloc] init];
        [newApp configureWith:aDownload];
        
        // Set up the app details (e.g. name)
        for( SQLApp *anApp in allApps ){
            if( newApp.dtPlusIdentifier == anApp.uniqueId ){
                newApp.name = anApp.name;
            }
        }
        
        // Populate the Access details for this specific app
        for( SQLAppAccess *anAccess in appAccesses ){
            if( newApp.dtPlusIdentifier == anAccess.referenceAppId ){
                [newApp.accesses addObject:anAccess];
            }
        }
        
        // Populate the Save details for this specific app
        for( SQLAssessmentSave *aSave in assessmentSaves ){
            if( newApp.dtPlusIdentifier == aSave.appId ){
                [newApp.saves addObject:aSave];
            }
        }
        
        // Set the generic app rules
        newApp.rules = rules;
        
        // Set the app-specific rules
        [newApp.rules constructAppSettings:newApp.name];
        
        // Create the score given all these inputs
        [newApp calculateScore];
        
        [appList addObject:newApp];
    }
    
}

- (void)calculateScores {
    
    doctotKarmaScore = 0.0;
    appScore = 0.0;
    
    for( GameificationAppDetails *anApp in appList ){
        
        doctotKarmaScore += anApp.score;
        
        if( [anApp.name isEqualToString:[prefs objectForKey:@"appName"]] ){
            appScore += anApp.score;
        }
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Add the completion of their User Profile (in Settings) to the score
    
    SQLUser *sqlUser = [allUsers objectAtIndex:0];
    if ( [sqlUser.dobAsString length] > 0 ) {   doctotKarmaScore += rules.scoreUserDemographics;    }
    if ( [sqlUser.profession length] > 0 ) {   doctotKarmaScore += rules.scoreUserDemographics;    }
    if ( [sqlUser.specialty length] > 0 ) {   doctotKarmaScore += rules.scoreUserDemographics;    }
    if ( [sqlUser.description length] > 0 ) {   doctotKarmaScore += rules.scoreUserDemographics;    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    doctotKarmaScoreLabel.text = [NSString stringWithFormat:@"%.0f", doctotKarmaScore];
    
    // Get the Level
    for( GameificationLevel *aLevel in rules.levels ){
        if( ( doctotKarmaScore >= aLevel.minimumScore ) && ( doctotKarmaScore <= aLevel.maximumScore ) ){
            //NSLog(@"aLevel %.0f   %@ - %@", aLevel.index, aLevel.name, aLevel.alternateName);
            
            level = aLevel.index;
            [prefs setInteger:level forKey:@"DTPlusLevel"];
            
            doctotKarmaLevelLabel.text = aLevel.name;
            doctotKarmaSymbolLabel.text = aLevel.sublevel;
            [prefs setObject:aLevel.name forKey:@"DTPlusLevelTitle"];
            
            NSString *theLevelString = [NSString stringWithFormat:@"kungfuLevel%i.png", level];
            [doctotKarmaScoreIcon setImage:[UIImage imageNamed:theLevelString]];
            [gameificationAvatar setBackgroundImage:[UIImage imageNamed:theLevelString] forState:UIControlStateNormal];
            
        }
    }
    
    
}

- (IBAction)describeGameificationStatus {
    
    gameificationStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIButton *gsvDismiss = [[UIButton alloc] initWithFrame:gameificationStatusView.frame];
    [gsvDismiss addTarget:self action:@selector(dismissGameificationStatus) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *gsvBackground = [[UIImageView alloc] initWithFrame:CGRectMake( (gameificationAvatar.frame.origin.x + gameificationAvatar.frame.size.width),
                                                                               gameificationAvatar.frame.origin.y,
                                                                               300, 540)];
    //gsvBackground.image = [UIImage imageNamed:@"content.png"];
    gsvBackground.backgroundColor = [UIColor whiteColor];
    gsvBackground.alpha = 0.8;
    gsvBackground.layer.cornerRadius = 5.0;
    
    GameificationRules *theRules = [[GameificationRules alloc] init];
    [theRules constructRules];
    
    float gsvLevelPaddingX = 10;
    float gsvLevelPaddingY = 5;
    float gsvLevelWidth = gsvBackground.frame.size.width - (gsvLevelPaddingX * 2);
    float gsvLevelHeight = ( gsvBackground.frame.size.height / [theRules.levels count] ) - (gsvLevelPaddingY * 2);
    float gsvLevelX = gsvLevelPaddingX;
    float gsvLevelY = 0;
    
    UIView *gsvLevel = [[UIView alloc] init];
    for( GameificationLevel *aLevel in theRules.levels ){
        gsvLevelY = ( ( gsvBackground.frame.size.height / [theRules.levels count] ) * ( aLevel.index - 1 ) ) + gsvLevelPaddingY;
        
        gsvLevel = [[UIView alloc] initWithFrame:CGRectMake(gsvLevelX, gsvLevelY, gsvLevelWidth, gsvLevelHeight)];
        
        UIImageView *levelImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gsvLevel.frame.size.height, gsvLevel.frame.size.height)];
        levelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"kungfuLevel%.0f.png", aLevel.index]];
        
        UILabel *levelName = [[UILabel alloc] initWithFrame:CGRectMake( (levelImage.frame.origin.x + levelImage.frame.size.width), levelImage.frame.origin.y, (gsvLevel.frame.size.width / 2), gsvLevel.frame.size.height)];
        levelName.text = aLevel.name;
        levelName.textAlignment = NSTextAlignmentCenter;
        
        UILabel *sublevelName = [[UILabel alloc] initWithFrame:CGRectMake( (levelName.frame.origin.x + levelName.frame.size.width), levelImage.frame.origin.y, (gsvLevel.frame.size.width / 4), gsvLevel.frame.size.height)];
        sublevelName.text = aLevel.sublevel;
        sublevelName.textColor = [UIColor darkGrayColor];
        sublevelName.textAlignment = NSTextAlignmentRight;
        sublevelName.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        
        NSInteger beltLevel = (NSInteger)[prefs integerForKey:@"DTPlusLevel"];
        if( aLevel.index == beltLevel ){
            //gsvLevel.backgroundColor = [UIColor greenColor];
            gsvLevel.layer.cornerRadius = 5.0;
            gsvLevel.layer.borderWidth = 2.0;
            gsvLevel.layer.borderColor = [Helper getColourFromString:@"Green"].CGColor;
        }
        
        [gsvLevel addSubview:levelImage];
        [gsvLevel addSubview:levelName];
        [gsvLevel addSubview:sublevelName];
        
        [gsvBackground addSubview:gsvLevel];
    }
    
    [gameificationStatusView addSubview:gsvBackground];
    [gameificationStatusView addSubview:gsvDismiss];
    
    [self.view addSubview:gameificationStatusView];
    
}

- (IBAction)dismissGameificationStatus {
    [gameificationStatusView removeFromSuperview];
}

- (void)dismiss {
    
    if( infoViewVisible ){
        
        [UIView beginAnimations:@"infoAnimation" context: nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:1.0];
        
        infoView.frame = CGRectMake(self.view.frame.size.width, infoView.frame.origin.y, self.view.frame.size.width, infoView.frame.size.height);
        
        [UIView commitAnimations];
        
        infoViewVisible = NO;
        
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Table Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // To keep the list refreshed when scrolling
    for(UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }
    
    [cell layoutSubviews];
    
    GameificationAppDetails *thisApp = (GameificationAppDetails *)[appList objectAtIndex:indexPath.row];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(baseDivider.frame.origin.x, 5, cell.frame.size.height - 10, cell.frame.size.height - 10)];
    NSString *theURLString = [NSString stringWithFormat:@"%@logos/%@.png", RESOURCE_URL_BASE, [thisApp.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
    UIImage *icon = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theURLString]]];
    logo.image = icon;
    
    UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake( (logo.frame.origin.x + logo.frame.size.width + 10 ), 0, (baseDivider.frame.size.width * 0.6), cell.frame.size.height)];
    appLabel.text = thisApp.name;
    appLabel.textColor = [UIColor whiteColor];
    appLabel.backgroundColor = [UIColor clearColor];
    appLabel.textAlignment = NSTextAlignmentLeft;
    appLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    UILabel *appScore = [[UILabel alloc] initWithFrame:CGRectMake( (appLabel.frame.origin.x + appLabel.frame.size.width), 0, ( (baseDivider.frame.origin.x + baseDivider.frame.size.width) - (appLabel.frame.origin.x + appLabel.frame.size.width) ), cell.frame.size.height)];
    appScore.text = [NSString stringWithFormat:@"%.0f", thisApp.score];
    appScore.textColor = [UIColor whiteColor];
    appScore.backgroundColor = [UIColor clearColor];
    appScore.textAlignment = NSTextAlignmentRight;
    appScore.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell addSubview:logo];
    [cell addSubview:appLabel];
    [cell addSubview:appScore];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //ScaleDefinition *thisScale = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
    
    //[self goToSettingsExtended:thisScale.name];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
