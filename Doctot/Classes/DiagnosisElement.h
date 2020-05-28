//
//  DiagnosisElement.h
//  Doctot
//
//  Created by Fergal McDonnell on 20/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiagnosisElement : NSObject {
    
    NSInteger index;
    NSString *scale;
    NSString *name;
    float minScore;
    float outputScore;
    BOOL outputScoreRelevant;
    NSString *colourString;
    UIColor *colour;
    NSString *description;
    NSString *descriptionSubtext;
    NSString *descriptionHTML;
    
    NSUserDefaults *prefs;
    
}

@property NSInteger index;
@property (nonatomic, retain) NSString *scale;
@property (nonatomic, retain) NSString *name;
@property float minScore;
@property float outputScore;
@property BOOL outputScoreRelevant;
@property (nonatomic, retain) NSString *colourString;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *descriptionSubtext;
@property (nonatomic, retain) NSString *descriptionHTML;
@property (nonatomic, retain) NSUserDefaults *prefs;

- (void)initialiseWithObject:(id)initialItem forScale:(NSString *)theScale;
- (void)makeScaleSpecificAdjustments;
- (NSString *)formatDescriptionForHTML;
- (NSString *)formatDescriptionForObjectiveC;


@end
