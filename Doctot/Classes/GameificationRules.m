//
//  GameificationRules.m
//  Doctot
//
//  Created by Fergal McDonnell on 16/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "GameificationRules.h"
#import "Helper.h"
#import "Constants.h"


@implementation GameificationRules

@synthesize prefs, active, levels;
@synthesize maxScore, minScore, scoreDownload, scoreAccess, scoreSave, scoreSocialMediaShare, scoreUserDemographics, factorWithinLastDay, factorWithinLastWeek, factorWithinLastMonth, factorWithinLastYear, factorOverOneYear;
@synthesize scoreDownloadDefault, scoreAccessDefault, scoreSaveDefault, scoreSocialMediaShareDefault, scoreUserDemographicsDefault, withinLastDayDefault, withinLastWeekDefault, withinLastMonthDefault, withinLastYearDefault, overOneYearDefault;

- (void)constructRules {
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *rulesJSON = [Helper determineMostUpToDateResource:@"rules"];
    
    GameificationLevel *selectedLevel;
    
    scoreDownloadDefault = 0.0; scoreAccessDefault = 0.0; scoreSaveDefault = 0.0; scoreSocialMediaShareDefault = 0.0; scoreUserDemographicsDefault = 0.0;
    withinLastDayDefault = 0.0; withinLastWeekDefault = 0.0; withinLastMonthDefault = 0.0; withinLastYearDefault = 0.0; overOneYearDefault = 0.0;
    
    for (NSString *key in rulesJSON){
        id rulesObject = rulesJSON[key];
        
        if( [key isEqualToString:@"range"] ){
            minScore = [[rulesObject objectForKey:@"minimum"] floatValue];
            maxScore = [[rulesObject objectForKey:@"maximum"] floatValue];
        }
        
        if( [key isEqualToString:@"maxLevels"] ){
            
            NSString *theLevel;
            id maxLevelsObject = [rulesJSON objectForKey:@"maxLevels"];
            int numberOfLevels = (int)[maxLevelsObject count];
            levels = [[NSMutableArray alloc] init];
            NSMutableArray *tempLevels = [[NSMutableArray alloc] init];
            
            for( int i = 0; i < numberOfLevels; i++ ) {
                theLevel = [NSString stringWithFormat:@"Level%i", (i + 1)];
                id aLevel = [maxLevelsObject valueForKey:theLevel];
                
                selectedLevel = [[GameificationLevel alloc] init];
                selectedLevel.index = [[aLevel valueForKey:@"index"] floatValue];
                selectedLevel.name = (NSString *)[aLevel valueForKey:@"name"];
                selectedLevel.alternateName = (NSString *)[aLevel valueForKey:@"alternateName"];
                selectedLevel.sublevel = (NSString *)[aLevel valueForKey:@"sublevel"];
                selectedLevel.maximumScore = [[aLevel valueForKey:@"maximumScore"] floatValue];;
                selectedLevel.minimumScore = [[aLevel valueForKey:@"minimumScore"] floatValue];;
                
                [tempLevels addObject:selectedLevel];
            }
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            levels = (NSMutableArray *)[(NSArray *)tempLevels sortedArrayUsingDescriptors:sortDescriptors];
            
        }
     
        if( [key isEqualToString:@"scoring"] ){
            scoreDownloadDefault = [[rulesObject objectForKey:@"download"] floatValue];
            scoreAccessDefault = [[rulesObject objectForKey:@"open"] floatValue];
            scoreSaveDefault = [[rulesObject objectForKey:@"save"] floatValue];
            scoreSocialMediaShareDefault = [[rulesObject objectForKey:@"socialMediaShare"] floatValue];
            scoreUserDemographicsDefault = [[rulesObject objectForKey:@"userDemographics"] floatValue];
        }
        
        if( [key isEqualToString:@"weights"] ){
            withinLastDayDefault = [[rulesObject objectForKey:@"withinLastDay"] floatValue];
            withinLastWeekDefault = [[rulesObject objectForKey:@"withinLastWeek"] floatValue];
            withinLastMonthDefault = [[rulesObject objectForKey:@"withinLastMonth"] floatValue];
            withinLastYearDefault = [[rulesObject objectForKey:@"withinLastYear"] floatValue];
            overOneYearDefault = [[rulesObject objectForKey:@"overOneYear"] floatValue];
        }
        
    }
    
}

- (void)constructAppSettings:(NSString *)theAppName {
    
    prefs = [NSUserDefaults standardUserDefaults];
    /*
    NSString *appSettingsFilePath = [[NSBundle mainBundle] pathForResource:@"appSettings" ofType:@"json"];
    NSData *appSettingsContent = [[NSData alloc] initWithContentsOfFile:appSettingsFilePath];
    NSMutableDictionary *appSettingsJSON = [NSJSONSerialization JSONObjectWithData:appSettingsContent options:kNilOptions error:nil];
    */
    
    NSDictionary *appSettingsJSON = [Helper determineMostUpToDateResource:@"appSettings"];
    
    for (NSString *key in appSettingsJSON){
        
        // [prefs objectForKey:@"appName"]
        if( [key isEqualToString:theAppName] ){
            id appSettingsObject = appSettingsJSON[key];
            
            if( [(NSString *)[appSettingsObject objectForKey:@"active"] isEqualToString:@"Yes"] ){
                active = YES;
            }else{
                active = NO;
            }
            
            NSString *scoringStyle = (NSString *)[[appSettingsObject objectForKey:@"scoring"] valueForKey:@"style"];
            if( [scoringStyle isEqualToString:@"generic"] ){
                scoreDownload = scoreDownloadDefault;
                scoreAccess = scoreAccessDefault;
                scoreSave = scoreSaveDefault;
                scoreSocialMediaShare = scoreSocialMediaShareDefault;
                scoreUserDemographics = scoreUserDemographicsDefault;
            }else{
                scoreDownload = [[[appSettingsObject objectForKey:@"scoring"] valueForKey:@"download"] floatValue];
                scoreAccess = [[[appSettingsObject objectForKey:@"scoring"] valueForKey:@"open"] floatValue];
                scoreSave = [[[appSettingsObject objectForKey:@"scoring"] valueForKey:@"save"] floatValue];
                scoreSocialMediaShare = [[[appSettingsObject objectForKey:@"scoring"] valueForKey:@"socialMediaShare"] floatValue];
                scoreUserDemographics = [[[appSettingsObject objectForKey:@"scoring"] valueForKey:@"userDemographics"] floatValue];
            }
            
            NSString *weightsStyle = (NSString *)[[appSettingsObject objectForKey:@"weights"] valueForKey:@"style"];
            if( [weightsStyle isEqualToString:@"generic"] ){
                factorWithinLastDay = withinLastDayDefault;
                factorWithinLastWeek = withinLastWeekDefault;
                factorWithinLastMonth = withinLastMonthDefault;
                factorWithinLastYear = withinLastYearDefault;
                factorOverOneYear = overOneYearDefault;
            }else{
                factorWithinLastDay = [[[appSettingsObject objectForKey:@"weights"] valueForKey:@"withinLastDay"] floatValue];
                factorWithinLastWeek = [[[appSettingsObject objectForKey:@"weights"] valueForKey:@"withinLastWeek"] floatValue];
                factorWithinLastMonth = [[[appSettingsObject objectForKey:@"weights"] valueForKey:@"withinLastMonth"] floatValue];
                factorWithinLastYear = [[[appSettingsObject objectForKey:@"weights"] valueForKey:@"withinLastYear"] floatValue];
                factorOverOneYear = [[[appSettingsObject objectForKey:@"weights"] valueForKey:@"overOneYear"] floatValue];
            }
            
        }
        
    }
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
