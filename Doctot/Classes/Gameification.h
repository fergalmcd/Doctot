//
//  Gameification.h
//  Doctot
//
//  Created by Fergal McDonnell on 03/08/2018.
//  Copyright © 20168 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameificationRules.h"
#import "GameificationLevel.h"
#import "GameificationAppDetails.h"
#import "SQLAppAccess.h"
#import "SQLAppDownload.h"
#import "SQLApp.h"
#import "SQLAssessmentSave.h"
#import "CustomWebView.h"

@interface Gameification : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    NSUserDefaults *prefs;
    
    NSString *firstName;
    NSString *lastName;
    float doctotKarmaScore;
    float appScore;
    int level;
    NSMutableArray *appList;
    
    UIImageView *topContainer;
    UIImageView *doctotLogo;
    UILabel *name;
    UIImageView *topDivider;
    UILabel *doctotKarmaLevelTitleLabel;
    UILabel *doctotKarmaLevelLabel;
    UILabel *doctotKarmaSymbolTitleLabel;
    UILabel *doctotKarmaSymbolLabel;
    UILabel *doctotKarmaScoreTitleLabel;
    UILabel *doctotKarmaScoreLabel;
    UIImageView *doctotKarmaScoreIcon;
    
    UIButton *karmaExplained;
    
    UIImageView *baseContainer;
    UIView *appScoresView;
    UIImageView *appListIcon;
    UILabel *listOfAppsHeading;
    UIImageView *baseDivider;
    UITableView *listOfApps;
    
    GameificationRules *rules;
    
    NSMutableArray *appAccesses;
    NSMutableArray *appDownloads;
    NSMutableArray *assessmentSaves;
    NSMutableArray *allApps;
    NSMutableArray *allUsers;
    
    UIView *spinnerView;
    UIImageView *spinnerBackground;
    UILabel *spinnerLabel;
    UIActivityIndicatorView *spinner;
    
    UIView *infoView;
    CustomWebView *infoContent;
    UIButton *infoDismiss;
    BOOL infoViewVisible;
    
    UIButton *gameificationAvatar;
    UIView *gameificationStatusView;
    
}

@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property float doctotKarmaScore;
@property float appScore;
@property int level;
@property (nonatomic, retain) NSMutableArray *appList;
@property (nonatomic, retain) IBOutlet UIImageView *topContainer;
@property (nonatomic, retain) IBOutlet UIImageView *doctotLogo;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UIImageView *topDivider;
@property (nonatomic, retain) IBOutlet UILabel *doctotKarmaLevelTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *doctotKarmaLevelLabel;
@property (nonatomic, retain) IBOutlet UILabel *doctotKarmaSymbolTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *doctotKarmaSymbolLabel;
@property (nonatomic, retain) IBOutlet UILabel *doctotKarmaScoreTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *doctotKarmaScoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *doctotKarmaScoreIcon;
@property (nonatomic, retain) IBOutlet UIButton *karmaExplained;
@property (nonatomic, retain) IBOutlet UIImageView *baseContainer;
@property (nonatomic, retain) IBOutlet UIView *appScoresView;
@property (nonatomic, retain) IBOutlet UIImageView *appListIcon;
@property (nonatomic, retain) IBOutlet UILabel *listOfAppsHeading;
@property (nonatomic, retain) IBOutlet UIImageView *baseDivider;
@property (nonatomic, retain) IBOutlet UITableView *listOfApps;
@property (nonatomic, retain) GameificationRules *rules;
@property (nonatomic, retain) NSMutableArray *appAccesses;
@property (nonatomic, retain) NSMutableArray *appDownloads;
@property (nonatomic, retain) NSMutableArray *assessmentSaves;
@property (nonatomic, retain) NSMutableArray *allApps;
@property (nonatomic, retain) NSMutableArray *allUsers;
@property (nonatomic, retain) UIView *spinnerView;
@property (nonatomic, retain) UIImageView *spinnerBackground;
@property (nonatomic, retain) UILabel *spinnerLabel;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIView *infoView;
@property (nonatomic, retain) CustomWebView *infoContent;
@property (nonatomic, retain) UIButton *infoDismiss;
@property BOOL infoViewVisible;
@property (nonatomic, retain) IBOutlet UIButton *gameificationAvatar;
@property (nonatomic, retain) IBOutlet UIView *gameificationStatusView;

@end

