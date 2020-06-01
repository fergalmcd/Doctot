//
//  GameificationAppDetails.m
//  Doctot
//
//  Created by Fergal McDonnell on 21/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "GameificationAppDetails.h"


@implementation GameificationAppDetails

@synthesize dtPlusIdentifier, name, downloads, accesses, saves, socialMediaShareCount;
@synthesize rules, score, scoreLevel;

- (void)configureWith:(SQLAppDownload *)appDownload {
    
    dtPlusIdentifier = appDownload.referenceAppId;
    downloads = appDownload.numberOfDuplicates + 1;
    accesses = [[NSMutableArray alloc] init];
    saves = [[NSMutableArray alloc] init];
    socialMediaShareCount = appDownload.numberOfSocialMediaShares;
    
}

- (void)calculateScore {
    
    int accessesWithinLastDay = 0, accessesWithinLastWeek = 0, accessesWithinLastMonth = 0, accessesWithinLastYear = 0, accessesOverOneYear = 0;
    int savesWithinLastDay = 0, savesWithinLastWeek = 0, savesWithinLastMonth = 0, savesWithinLastYear = 0, savesOverOneYear = 0;
    
    float daysAgo;
    
    // Access Metrics
    for( SQLAppAccess *anAccess in accesses ){
        daysAgo = (float)( [[NSDate date] timeIntervalSinceDate:anAccess.creationTimeStamp] / 86400 );
        if( daysAgo < 1 ){
            accessesWithinLastDay++;
        }else{
            if( daysAgo < 7 ){
                accessesWithinLastWeek++;
            }else{
                if( daysAgo < 30 ){
                    accessesWithinLastMonth++;
                }else{
                    if( daysAgo < 365 ){
                        accessesWithinLastYear++;
                    }else{
                        if( daysAgo > 365 ){
                            accessesOverOneYear++;
                        }
                    }
                }
            }
        }
    }
    
    // Assessment Saves Metrics
    for( SQLAssessmentSave *aSave in saves ){
        daysAgo = (float)( [[NSDate date] timeIntervalSinceDate:aSave.creationTimeStamp] / 86400 );
        if( daysAgo < 1 ){
            savesWithinLastDay++;
        }else{
            if( daysAgo < 7 ){
                savesWithinLastWeek++;
            }else{
                if( daysAgo < 30 ){
                    savesWithinLastMonth++;
                }else{
                    if( daysAgo < 365 ){
                        savesWithinLastYear++;
                    }else{
                        if( daysAgo > 365 ){
                            savesOverOneYear++;
                        }
                    }
                }
            }
        }
    }
    
    score =
    ( rules.scoreDownload * downloads ) +
    ( ( (accessesWithinLastDay * rules.factorWithinLastDay) + (accessesWithinLastWeek * rules.factorWithinLastWeek) + (accessesWithinLastMonth * rules.factorWithinLastMonth)  + (accessesWithinLastYear * rules.factorWithinLastYear) + (accessesOverOneYear * rules.factorOverOneYear) ) * rules.scoreAccess ) +
    ( ( (savesWithinLastDay * rules.factorWithinLastDay) + (savesWithinLastWeek * rules.factorWithinLastWeek) + (savesWithinLastMonth * rules.factorWithinLastMonth)  + (savesWithinLastYear * rules.factorWithinLastYear) + (savesOverOneYear * rules.factorOverOneYear) ) * rules.scoreSave ) +
    ( socialMediaShareCount * rules.scoreSocialMediaShare );
    
    recencyScore = score - ( ( (accessesOverOneYear * rules.factorOverOneYear) * rules.scoreAccess ) + ( (savesOverOneYear * rules.factorOverOneYear) * rules.scoreSave ) );
    
    NSLog(@"scoreDownload: %f (%f * %i)", ( rules.scoreDownload * downloads ), rules.scoreDownload, downloads);
    NSLog(@"scoreAccess: %f   (%i * %f)   (%i * %f)   (%i * %f)   (%i * %f)   (%i * %f)   *   %f",
          ( ( (accessesWithinLastDay * rules.factorWithinLastDay) + (accessesWithinLastWeek * rules.factorWithinLastWeek) + (accessesWithinLastMonth * rules.factorWithinLastMonth)  + (accessesWithinLastYear * rules.factorWithinLastYear) + (accessesOverOneYear * rules.factorOverOneYear) ) * rules.scoreAccess ),
          accessesWithinLastDay, rules.factorWithinLastDay, accessesWithinLastWeek, rules.factorWithinLastWeek, accessesWithinLastMonth, rules.factorWithinLastMonth, accessesWithinLastYear, rules.factorWithinLastYear, accessesOverOneYear, rules.factorOverOneYear, rules.scoreAccess
    );
    NSLog(@"scoreSave: %f   (%i * %f)   (%i * %f)   (%i * %f)   (%i * %f)   (%i * %f)   *   %f",
          ( ( (savesWithinLastDay * rules.factorWithinLastDay) + (savesWithinLastWeek * rules.factorWithinLastWeek) + (savesWithinLastMonth * rules.factorWithinLastMonth)  + (savesWithinLastYear * rules.factorWithinLastYear) + (savesOverOneYear * rules.factorOverOneYear) ) * rules.scoreSave ),
          savesWithinLastDay, rules.factorWithinLastDay, savesWithinLastWeek, rules.factorWithinLastWeek, savesWithinLastMonth, rules.factorWithinLastMonth, savesWithinLastYear, rules.factorWithinLastYear, savesOverOneYear, rules.factorOverOneYear, rules.scoreSave
          );
    NSLog(@"scoreSocialMediaShare: %f (%i * %f)", ( socialMediaShareCount * rules.scoreSocialMediaShare ), socialMediaShareCount, rules.scoreSocialMediaShare );
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
