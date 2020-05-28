//
//  Settings.m
//  Doctot
//
//  Created by Fergal McDonnell on 29/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "Settings.h"
#import "Constants.h"
#import "Helper.h"

@interface Settings ()

@end

@implementation Settings

@synthesize leftNavBarButton, rightNavBarButton, prefs, scrollView, settingsView;
@synthesize section1HeadingTitle, section1Label1, section1Value1, section1Button1, section1Label2, section1Value2, section1Label3, section1Value3;
@synthesize section2HeadingTitle, section2Label1, section2Value1, section2Button1, section2Label2, section2Value2, section2Label3, section2Value3, section2Label4, section2Value4, section2Value4Switch, section2Button4;
@synthesize section3HeadingTitle, section3Label1, section3Value1, section3Icon1, section3Button1;
@synthesize scaleSpecificHeadingTitle, scaleSpecificTable, scaleSpecificLabel1, scaleSpecificValue1, scaleSpecificLabel2, scaleSpecificValue2, scalesList;
@synthesize disclaimer;
@synthesize settingsExtended, gameification, gameificationRules;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"SettingsTitle" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 5, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"disclaimer.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(showDisclaimer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    disclaimer.isCurrentlyVisible = NO;
    
    section1HeadingTitle.text = [Helper getLocalisedString:@"Settings_Heading1" withScalePrefix:NO];   // User Details
    section1Label1.text = [Helper getLocalisedString:@"Settings_OwnerDetails" withScalePrefix:NO];
    section1Label2.text = [Helper getLocalisedString:@"Settings_TouchID" withScalePrefix:NO];
    section1Label3.text = [Helper getLocalisedString:@"Settings_Password_Label" withScalePrefix:NO];
    
    if( ![Helper checkIfTouchIDSupported] ){
        section1Label2.textColor = [UIColor grayColor];
        section1Value2.enabled = NO;
    }
    
    section2HeadingTitle.text = [Helper getLocalisedString:@"Settings_Heading2" withScalePrefix:NO];   // Scale Options
    section2Label1.text = [Helper getLocalisedString:@"Settings_MaxSave_Label" withScalePrefix:NO];
    section2Label2.text = [Helper getLocalisedString:@"Settings_AutomaticEmail" withScalePrefix:NO];
    section2Label3.text = [Helper getLocalisedString:@"Settings_ShakeReset" withScalePrefix:NO];
    section2Label4.text = [Helper getLocalisedString:@"Settings_PatientManagerDisplay" withScalePrefix:NO];
    
    section3HeadingTitle.text = [Helper getLocalisedString:@"Settings_Heading3" withScalePrefix:NO];   // Collaboration
    section3Label1.text = [Helper getLocalisedString:@"Gameification_Title" withScalePrefix:NO]; 
    section3Value1.text = (NSString *)[prefs objectForKey:@"DTPlusLevelTitle"];
    [section3Icon1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kungfuLevel%i.png", (int)[prefs integerForKey:@"DTPlusLevel"]]]];
    //section3Button1;
    
    scaleSpecificHeadingTitle.text = [Helper getLocalisedString:@"Settings_Heading4" withScalePrefix:NO];   // Scale Specific
    // Scale Specific Settings may not be relevant for this app
    [self.scaleSpecificTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    NSString *scaleSpecificSettings = (NSString *)[Helper returnValueForKey:@"SettingsScaleSpecificOption"];
    if( [scaleSpecificSettings isEqualToString:@"No"] ){
        scaleSpecificHeadingTitle.hidden = YES;
        scaleSpecificTable.hidden = YES;
        scaleSpecificLabel1.hidden = YES;
        scaleSpecificValue1.hidden = YES;
        scaleSpecificLabel2.hidden = YES;
        scaleSpecificValue2.hidden = YES;
    }else{
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for( ScaleDefinition *aScale in scalesList ){
            if( aScale.allowsSettingsConfiguration ){
                [tempArray addObject:aScale];
            }
        }
        scalesList = tempArray;
        scaleSpecificTable.backgroundColor = [UIColor clearColor];
    }
    
    settingsView.frame = CGRectMake(settingsView.frame.origin.x, settingsView.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, settingsView.frame.size.height);
    [scrollView addSubview:settingsView];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, (settingsView.frame.size.height + scaleSpecificTable.frame.size.height));
    
    section1Value1.text = [NSString stringWithFormat:@"%@ %@ (%@)", [prefs objectForKey:@"FirstName"], [prefs objectForKey:@"LastName"], [prefs objectForKey:@"Email"]];
    
    BOOL touchIDAccessActivated = NO;
    if( [[prefs stringForKey:@"TouchID"] length] > 0 ) {
        touchIDAccessActivated = YES;
    }
    if( touchIDAccessActivated ){
        [section1Value2 setOn:YES animated:YES];
    }else{
        [section1Value2 setOn:NO animated:YES];
    }
    
    BOOL pinAccessActivated = NO;
    if( [[prefs stringForKey:@"Password"] length] > 0 ) {
        pinAccessActivated = YES;
    }
    if( pinAccessActivated ){
        [section1Value3 setOn:YES animated:YES];
    }else{
        [section1Value3 setOn:NO animated:YES];
    }
    
    section2Value1.text = [NSString stringWithFormat:@"%li", (long)[prefs integerForKey:@"MaxSaves"] ];
    
    BOOL emailScoresActivated = NO;
    if( [[prefs stringForKey:@"EmailScores"] length] > 0 ) {
        emailScoresActivated = YES;
    }
    if( emailScoresActivated ){
        [section2Value2 setOn:YES animated:YES];
    }else{
        [section2Value2 setOn:NO animated:YES];
    }
    
    BOOL shakeToResetActivated = NO;
    if( [[prefs stringForKey:@"ShakeToReset"] length] > 0 ) {
        shakeToResetActivated = YES;
    }
    if( shakeToResetActivated ){
        [section2Value3 setOn:YES animated:YES];
    }else{
        [section2Value3 setOn:NO animated:YES];
    }
    
    BOOL patientVisualContext = YES;
    if( [[prefs stringForKey:@"PatientVisualContext"] isEqualToString:VISUALCONTEXT_GRID] ) {
        patientVisualContext = NO;
    }
    [section2Value4Switch setOn:patientVisualContext animated:YES];
    section2Value4.text = [prefs stringForKey:@"PatientVisualContext"];
    
    gameificationRules = [[GameificationRules alloc] init];
    [gameificationRules constructRules];
    [gameificationRules constructAppSettings:[prefs objectForKey:@"appName"]];
    if( !gameificationRules.active ){
        section3HeadingTitle.hidden = YES;
        section3Label1.hidden = YES;
        section3Value1.hidden = YES;
        section3Icon1.hidden = YES;
        for( UIImageView *anImageView in [settingsView subviews] ){
            if( anImageView.tag > 0 ){
                anImageView.hidden = YES;
            }
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)dismiss {
    
    if( disclaimer.isCurrentlyVisible ){
        disclaimer.isCurrentlyVisible = NO;
        [disclaimer removeFromSuperview];
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
    
}

- (void)showDisclaimer {
    
    if( disclaimer.isCurrentlyVisible ){
        return;
    }
    
    disclaimer = [[Disclaimer alloc] init];
    [disclaimer initialise];
    disclaimer.content.frame = CGRectMake(disclaimer.content.frame.origin.x, disclaimer.content.frame.origin.y, disclaimer.content.frame.size.width, disclaimer.content.frame.size.height + disclaimer.agree.frame.size.height);
    disclaimer.agree.hidden = YES;
    disclaimer.isCurrentlyVisible = YES;
    [self.view addSubview:disclaimer];
    
}

- (IBAction)goToSettingsExtended:(id)theSender {
    [self performSegueWithIdentifier:@"settingsExtended" sender:theSender];
}

- (IBAction)goToGameification:(id)theSender {
    [self performSegueWithIdentifier:@"gameification" sender:theSender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"settingsExtended"]){
        settingsExtended = (SettingsExtended *)segue.destinationViewController;
        if( sender == section1Button1 ){
            [settingsExtended setup:settingsExtended.ownerDetails];
        }
        if( sender == section1Value2 ){
            //[settingsExtended setup:settingsExtended.pinUpdateView];
        }
        if( sender == section1Value3 ){
            [settingsExtended setup:settingsExtended.pinUpdateView];
        }
        if( sender == section2Button1 ){
            [settingsExtended setup:settingsExtended.maxSavesView];
        }
        // scale Specific
        if( [sender isKindOfClass:[NSString class]] ){
            NSString *scaleToUpdate = (NSString *)sender;
            if( [scaleToUpdate isEqualToString:@"MTS"] ){
                [settingsExtended setup:settingsExtended.mtsSpecificView];
            }
            if( [scaleToUpdate isEqualToString:@"CACH"] ){
                [settingsExtended setup:settingsExtended.cachSpecificView];
            }
        }
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
            
                /*UIAlertController *activateUserAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Settings_ActivateUser", @"")
                                                                                           message:NSLocalizedString(@"Settings_ActivateUserMessage", @"")
                                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
                */
                UIAlertController *activateUserAlert = [Helper defaultAlertController:self withHeading:NSLocalizedString(@"Settings_ActivateUser", @"") andMessage:NSLocalizedString(@"Settings_ActivateUserMessage", @"") includeCancel:NO];
                
                [activateUserAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_OK", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }]];
                
                [self presentViewController:activateUserAlert animated:YES completion:nil];
                
            }
            
        }
        
    }
    
}

- (IBAction)toggleSwitch:(UISwitch *)theSwitch {
    
    if( theSwitch == section1Value2 ){
        if( theSwitch.on ){
            [prefs setObject:@"Activated" forKey:@"TouchID"];
        }else{
            [prefs setObject:@"" forKey:@"TouchID"];
        }
    }
    if( theSwitch == section1Value3 ){
        if( theSwitch.on ){
            [self goToSettingsExtended:theSwitch];
         }else{
            [prefs setObject:@"" forKey:@"Password"];
         }
    }
    if( theSwitch == section2Value2 ){
        if( theSwitch.on ){
            [prefs setObject:@"Activated" forKey:@"EmailScores"];
        }else{
            [prefs setObject:@"" forKey:@"EmailScores"];
        }
    }
    if( theSwitch == section2Value3 ){
        if( theSwitch.on ){
            [prefs setObject:@"Activated" forKey:@"ShakeToReset"];
        }else{
            [prefs setObject:@"" forKey:@"ShakeToReset"];
        }
    }
    if( theSwitch == section2Value4Switch ){
        if( theSwitch.on ){
            [prefs setObject:VISUALCONTEXT_LIST forKey:@"PatientVisualContext"];
        }else{
            [prefs setObject:VISUALCONTEXT_GRID forKey:@"PatientVisualContext"];
        }
    }
    [prefs synchronize];
    
}

- (IBAction)togglePatientDisplayMode {
    
    UIAlertController *defaultPlayerViewScaleAlert = [Helper defaultAlertController:self withHeading:[Helper getLocalisedString:@"Settings_DefaultPatientView" withScalePrefix:NO] andMessage:[Helper getLocalisedString:@"Settings_DefaultPatientViewMessage" withScalePrefix:NO] includeCancel:YES];
     
    [defaultPlayerViewScaleAlert addAction:[UIAlertAction actionWithTitle:VISUALCONTEXT_LIST style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.prefs setObject:VISUALCONTEXT_LIST forKey:@"PatientVisualContext"];
        self.section2Value4.text = VISUALCONTEXT_LIST;
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [defaultPlayerViewScaleAlert addAction:[UIAlertAction actionWithTitle:VISUALCONTEXT_GRID style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.prefs setObject:VISUALCONTEXT_GRID forKey:@"PatientVisualContext"];
        self.section2Value4.text = VISUALCONTEXT_GRID;
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [self presentViewController:defaultPlayerViewScaleAlert animated:YES completion:nil];
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Table Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [scalesList count];
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
    cell.backgroundColor = [UIColor clearColor];
    
    ScaleDefinition *thisScale = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
    
    UIImageView *cellBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    if( [scalesList count] == 1 ){
        cellBackground.image = [UIImage imageNamed:@"table_row_rounded.png"];
    }else{
        if( indexPath.row == 0 ){
            cellBackground.image = [UIImage imageNamed:@"table_row_top.png"];
        }else{
            if( indexPath.row == ([scalesList count] - 1) ){
                cellBackground.image = [UIImage imageNamed:@"table_row_bottom.png"];
            }
        }
    }
    
    UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    scaleLabel.text = thisScale.displayTitle;
    scaleLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:cellBackground];
    [cell.contentView addSubview:scaleLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ScaleDefinition *thisScale = (ScaleDefinition *)[scalesList objectAtIndex:indexPath.row];
    
    [self goToSettingsExtended:thisScale.name];
    
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
