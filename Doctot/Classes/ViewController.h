//
//  ViewController.h
//  Doctot
//
//  Created by Fergal McDonnell on 06/10/2015.
//  Copyright © 2015 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartView.h"
#import "SignUp.h"
#import "ActivateView.h"
#import "Password.h"
#import "TouchIDFail.h"
#import "Disclaimer.h"
#import "About.h"
#import "Settings.h"
#import "SingleAppMenu.h"
#import "Scale.h"
#import "Book.h"

@interface ViewController : UIViewController <NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource> {
    
    StartView *startView;
    SignUp *signUp;
    ActivateView *activateView;
    TouchIDFail *touchIDFail;
    Password *password;
    Disclaimer *disclaimer;
    
    NSUserDefaults *prefs;
    NSString *applicationID;
    NSString *applicationDisplayName;
    NSString *userName;
    NSString *userFirstName;
    NSString *userLastName;
    NSString *userPassword;
    
    BOOL isTouchIDSupported;
    BOOL isTouchIDSelected;
    BOOL isPINActivated;
    BOOL isDisclaimerAgreed;
    BOOL isUserActivated;
    BOOL isReloggingIn;
    BOOL isLegacyApp;
    BOOL isDeviceAlreadyRegisteredOnDTPlus;
    BOOL isUserNameEntered;
    
    BOOL isSingleAppOptionActivated;
    BOOL isSingleAppOptionLoaded;
    BOOL isSettingsActivated;
    BOOL isInformationActivated;
    
    UIButton *settingsBarButton;
    UIButton *hamburgerBarButton;
    UIButton *infoBarButton;
    UIButton *shareBarButton;
    UIBarButtonItem *leftBarButtonItem;
    UIBarButtonItem *rightBarButtonItem;
    
    About *about;
    Settings *settings;
    SingleAppMenu *singleAppMenu;
    Scale *scale;
    Book *book;
    UIStoryboard *storyBoard;
    UIStoryboard *storyBoardiPad;
    Interview *singleAppInterview;
    
    UIView *hamburgerView;
    UIButton *hamburgerToggle;
    UIButton *hamburgerFacebook;
    UIButton *hamburgerTwitter;
    UIButton *hamburgerSettings;
    UIButton *hamburgerSharing;
    UIButton *hamburgerNews;
    UIButton *hamburgerDoximity;
    UIButton *hamburgerGameification;
    
    UIButton *gameificationAvatar;
    UIView *gameificationStatusView;
    Gameification *gameification;
    GameificationRules *gameificationRules;
    UIImageView *banner;
    UIButton *sponsorFireButton;
    UIImageView *middleSlot;
    UILabel *welcomeLabel;
    UILabel *welcomeSublabel;
    UITableView *scalesTable;
    UICollectionView *scalesCollection;
    NSMutableArray *scalesList;
    BOOL isViewLoadedPreviously;
    
}

@property (nonatomic, retain) IBOutlet StartView *startView;
@property (nonatomic, retain) IBOutlet SignUp *signUp;
@property (nonatomic, retain) IBOutlet ActivateView *activateView;
@property (nonatomic, retain) IBOutlet TouchIDFail *touchIDFail;
@property (nonatomic, retain) IBOutlet Password *password;
@property (nonatomic, retain) IBOutlet Disclaimer *disclaimer;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *applicationID;
@property (nonatomic, retain) NSString *applicationDisplayName;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userFirstName;
@property (nonatomic, retain) NSString *userLastName;
@property (nonatomic, retain) NSString *userPassword;
@property BOOL isTouchIDSupported;
@property BOOL isTouchIDSelected;
@property BOOL isPINActivated;
@property BOOL isDisclaimerAgreed;
@property BOOL isUserActivated;
@property BOOL isReloggingIn;
@property BOOL isLegacyApp;
@property BOOL isDeviceAlreadyRegisteredOnDTPlus;
@property BOOL isUserNameEntered;
@property BOOL isSingleAppOptionActivated;
@property BOOL isSingleAppOptionLoaded;
@property BOOL isSettingsActivated;
@property BOOL isInformationActivated;
@property (nonatomic, retain) IBOutlet UIButton *settingsBarButton;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerBarButton;
@property (nonatomic, retain) IBOutlet UIButton *infoBarButton;
@property (nonatomic, retain) IBOutlet UIButton *shareBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, retain) IBOutlet About *about;
@property (nonatomic, retain) IBOutlet Settings *settings;
@property (nonatomic, retain) IBOutlet SingleAppMenu *singleAppMenu;
@property (nonatomic, retain) IBOutlet Scale *scale;
@property (nonatomic, retain) IBOutlet Book *book;
@property (nonatomic, retain) IBOutlet UIStoryboard *storyBoard;
@property (nonatomic, retain) IBOutlet UIStoryboard *storyBoardiPad;
@property (nonatomic, retain) IBOutlet Interview *singleAppInterview;
@property (nonatomic, retain) IBOutlet UIView *hamburgerView;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerToggle;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerFacebook;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerTwitter;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerSettings;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerSharing;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerNews;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerDoximity;
@property (nonatomic, retain) IBOutlet UIButton *hamburgerGameification;
@property (nonatomic, retain) IBOutlet UIButton *gameificationAvatar;
@property (nonatomic, retain) IBOutlet UIView *gameificationStatusView;
@property (nonatomic, retain) IBOutlet Gameification *gameification;
@property (nonatomic, retain) GameificationRules *gameificationRules;
@property (nonatomic, retain) IBOutlet UIImageView *banner;
@property (nonatomic, retain) IBOutlet UIButton *sponsorFireButton;
@property (nonatomic, retain) IBOutlet UIImageView *middleSlot;
@property (nonatomic, retain) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, retain) IBOutlet UILabel *welcomeSublabel;
@property (nonatomic, retain) IBOutlet UITableView *scalesTable;
@property (nonatomic, retain) IBOutlet UICollectionView *scalesCollection;
@property (nonatomic, retain) IBOutlet NSMutableArray *scalesList;
@property BOOL isViewLoadedPreviously;

- (void)determinStartState;
- (void)goToSignUp;
- (void)goToDisclaimer;
- (void)goToSplashScreen;


@end
