//
//  GameificationAppDetails.h
//  Doctot
//
//  Created by Fergal McDonnell on 21/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameificationRules.h"
#import "SQLAppAccess.h"
#import "SQLAppDownload.h"
#import "SQLApp.h"
#import "SQLAssessmentSave.h"

@interface GameificationAppDetails : NSObject {
    
    int dtPlusIdentifier;
    NSString *name;
    int downloads;
    NSMutableArray *accesses;
    NSMutableArray *saves;
    int socialMediaShareCount;
    
    GameificationRules *rules;
    
    float score;
    float recencyScore;
    NSString *scoreLevel;
    NSString *recencyScoreLevel;
    
}

@property int dtPlusIdentifier;
@property (nonatomic, retain) NSString *name;
@property int downloads;
@property (nonatomic, retain) NSMutableArray *accesses;
@property (nonatomic, retain) NSMutableArray *saves;
@property int socialMediaShareCount;
@property (nonatomic, retain) GameificationRules *rules;
@property float score;
@property (nonatomic, retain) NSString *scoreLevel;

- (void)configureWith:(SQLAppDownload *)appDownload;
- (void)calculateScore;


@end
