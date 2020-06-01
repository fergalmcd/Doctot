//
//  GameificationRules.h
//  Doctot
//
//  Created by Fergal McDonnell on 16/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameificationLevel.h"

@interface GameificationRules : NSObject {
    
    NSUserDefaults *prefs;
    
    BOOL active;
    NSMutableArray *levels;
    float maxScore;
    float minScore;
    float scoreDownload;
    float scoreAccess;
    float scoreSave;
    float scoreSocialMediaShare;
    float scoreUserDemographics;
    float factorWithinLastDay;
    float factorWithinLastWeek;
    float factorWithinLastMonth;
    float factorWithinLastYear;
    float factorOverOneYear;
    
    // Defaults
    float scoreDownloadDefault;
    float scoreAccessDefault;
    float scoreSaveDefault;
    float scoreSocialMediaShareDefault;
    float scoreUserDemographicsDefault;
    float withinLastDayDefault;
    float withinLastWeekDefault;
    float withinLastMonthDefault;
    float withinLastYearDefault;
    float overOneYearDefault;
    
}

@property BOOL active;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSMutableArray *levels;
@property float maxScore;
@property float minScore;
@property float scoreDownload;
@property float scoreAccess;
@property float scoreSave;
@property float scoreSocialMediaShare;
@property float scoreUserDemographics;
@property float factorWithinLastDay;
@property float factorWithinLastWeek;
@property float factorWithinLastMonth;
@property float factorWithinLastYear;
@property float factorOverOneYear;
@property float scoreDownloadDefault;
@property float scoreAccessDefault;
@property float scoreSaveDefault;
@property float scoreSocialMediaShareDefault;
@property float scoreUserDemographicsDefault;
@property float withinLastDayDefault;
@property float withinLastWeekDefault;
@property float withinLastMonthDefault;
@property float withinLastYearDefault;
@property float overOneYearDefault;

- (void)constructRules;
- (void)constructAppSettings:(NSString *)theAppName;


@end
