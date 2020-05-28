//
//  Settings.h
//  Doctot
//
//  Created by Fergal McDonnell on 29/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsExtended.h"
#import "Gameification.h"
#import "Disclaimer.h"
#import "ScaleDefinition.h"

@interface Settings : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    NSUserDefaults *prefs;
    
    UIScrollView *scrollView;
    UIView *settingsView;
    
    UILabel *section1HeadingTitle;
    UILabel *section1Label1;
    UILabel *section1Value1;
    UIButton *section1Button1;
    UILabel *section1Label2;
    UISwitch *section1Value2;
    UILabel *section1Label3;
    UISwitch *section1Value3;
    
    UILabel *section2HeadingTitle;
    UILabel *section2Label1;
    UILabel *section2Value1;
    UIButton *section2Button1;
    UILabel *section2Label2;
    UISwitch *section2Value2;
    UILabel *section2Label3;
    UISwitch *section2Value3;
    UILabel *section2Label4;
    UILabel *section2Value4;
    UISwitch *section2Value4Switch;
    UIButton *section2Button4;
    
    UILabel *section3HeadingTitle;
    UILabel *section3Label1;
    UILabel *section3Value1;
    UIImageView *section3Icon1;
    UIButton *section3Button1;
    
    UILabel *scaleSpecificHeadingTitle;
    UITableView *scaleSpecificTable;
    UILabel *scaleSpecificLabel1;
    UILabel *scaleSpecificValue1;
    UILabel *scaleSpecificLabel2;
    UILabel *scaleSpecificValue2;
    NSMutableArray *scalesList;
    
    Disclaimer *disclaimer;
    
    SettingsExtended *settingsExtended;
    Gameification *gameification;
    GameificationRules *gameificationRules;
    
}

@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *settingsView;
@property (nonatomic, retain) IBOutlet UILabel *section1HeadingTitle;
@property (nonatomic, retain) IBOutlet UILabel *section1Label1;
@property (nonatomic, retain) IBOutlet UILabel *section1Value1;
@property (nonatomic, retain) IBOutlet UIButton *section1Button1;
@property (nonatomic, retain) IBOutlet UILabel *section1Label2;
@property (nonatomic, retain) IBOutlet UISwitch *section1Value2;
@property (nonatomic, retain) IBOutlet UILabel *section1Label3;
@property (nonatomic, retain) IBOutlet UISwitch *section1Value3;
@property (nonatomic, retain) IBOutlet UILabel *section2HeadingTitle;
@property (nonatomic, retain) IBOutlet UILabel *section2Label1;
@property (nonatomic, retain) IBOutlet UILabel *section2Value1;
@property (nonatomic, retain) IBOutlet UIButton *section2Button1;
@property (nonatomic, retain) IBOutlet UILabel *section2Label2;
@property (nonatomic, retain) IBOutlet UISwitch *section2Value2;
@property (nonatomic, retain) IBOutlet UILabel *section2Label3;
@property (nonatomic, retain) IBOutlet UISwitch *section2Value3;
@property (nonatomic, retain) IBOutlet UILabel *section2Label4;
@property (nonatomic, retain) IBOutlet UILabel *section2Value4;
@property (nonatomic, retain) IBOutlet UISwitch *section2Value4Switch;
@property (nonatomic, retain) IBOutlet UIButton *section2Button4;
@property (nonatomic, retain) IBOutlet UILabel *section3HeadingTitle;
@property (nonatomic, retain) IBOutlet UILabel *section3Label1;
@property (nonatomic, retain) IBOutlet UILabel *section3Value1;
@property (nonatomic, retain) IBOutlet UIImageView *section3Icon1;
@property (nonatomic, retain) IBOutlet UIButton *section3Button1;
@property (nonatomic, retain) IBOutlet UILabel *scaleSpecificHeadingTitle;
@property (nonatomic, retain) IBOutlet UITableView *scaleSpecificTable;
@property (nonatomic, retain) IBOutlet UILabel *scaleSpecificLabel1;
@property (nonatomic, retain) IBOutlet UILabel *scaleSpecificValue1;
@property (nonatomic, retain) IBOutlet UILabel *scaleSpecificLabel2;
@property (nonatomic, retain) IBOutlet UILabel *scaleSpecificValue2;
@property (nonatomic, retain) NSMutableArray *scalesList;
@property (nonatomic, retain) IBOutlet Disclaimer *disclaimer;
@property (nonatomic, retain) IBOutlet SettingsExtended *settingsExtended;
@property (nonatomic, retain) IBOutlet Gameification *gameification;
@property (nonatomic, retain) GameificationRules *gameificationRules;

@end

