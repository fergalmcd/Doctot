//
//  Question.h
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleDefinition.h"
#import "QuestionStructure.h"
#import "ItemStructure.h"
#import "ItemButton.h"
#import "ItemSlider.h"
#import "ItemSwiper.h"
#import "ItemSelector.h"
#import "ItemEnergyBar.h"
#import "ItemRotator.h"
#import "ItemStopwatch.h"
#import "ItemCrossReference.h"

@interface Question : UIView <ItemSelectorDelegate, ItemSwiperDelegate, ItemEnergyBarDelegate, ItemRotatorDelegate, ItemStopwatchDelegate, ItemCrossReferenceDelegate> {
    
    ScaleDefinition *scaleDefinition;
    NSInteger index;
    NSInteger defaultScore;
    NSMutableArray *items;
    QuestionStructure *questionStructure;
    NSUserDefaults *prefs;
    CGSize questionDimensions;
    
    NSString *qReference;
    NSString *title;
    NSString *subTitle;
    float score;
    float scoreLevel;
    NSString *answerCustomInformation;
    BOOL isInMiniInterview;
    UIViewController *miniInterviewPlain;
    UIImageView *backgroundImage;
    
    ItemButton *selectedItem;
    NSInteger selectedItemIdenifier;
    NSInteger previousSelectedItemIdenifier;
    float cumulativeItemHeights;
    
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    
    // Assessment Specific
    NSString *hdrsLossOfWeightOption;
    UIButton *hdrsLossOfWeightButton;
    
}

@property (nonatomic, retain) ScaleDefinition *scaleDefinition;
@property NSInteger index;
@property NSInteger defaultScore;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property CGSize questionDimensions;
@property (nonatomic, retain) NSString *qReference;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property float score;
@property float scoreLevel;
@property (nonatomic, retain) NSString *answerCustomInformation;
@property BOOL isInMiniInterview;
@property (nonatomic, retain) UIViewController *miniInterviewPlain;
@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) ItemButton *selectedItem;
@property NSInteger selectedItemIdenifier;
@property NSInteger previousSelectedItemIdenifier;
@property float cumulativeItemHeights;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, retain) NSString *hdrsLossOfWeightOption;
@property (nonatomic, retain) UIButton *hdrsLossOfWeightButton;

- (void)initialise;
- (void)clearDetails;
- (void)tidyQuestionUponLeaving;


@end
