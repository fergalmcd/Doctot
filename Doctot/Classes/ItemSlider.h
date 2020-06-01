//
//  ItemSlider.h
//  Doctot
//
//  Created by Fergal McDonnell on 26/05/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"
#import "DiagnosisElement.h"

@interface ItemSlider : UISlider {
    
    ItemStructure *itemStructure;
    QuestionStructure *questionStructure;
    NSInteger index;
    NSString *scaleName;
    NSInteger status;
    float actualValue;
    float score;
    NSInteger precision;
    BOOL showScore;
    
    UIImageView *valueBackground;
    UILabel *valueTitleLabel;
    UILabel *valueLabel;
    UIImageView *scoreBackground;
    UILabel *scoreTitleLabel;
    UILabel *scoreLabel;
    UIImageView *pointerBackground;
    
    NSMutableArray *markerLabels;
    NSArray *sliderTitles;
    NSMutableArray *diagnosisElements;
    
    UILabel *catSmall;
    UILabel *catLarge;
    
    float scoreFontSize;
}

@property (nonatomic, retain) ItemStructure *itemStructure;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property NSInteger index;
@property (nonatomic, retain) NSString *scaleName;
@property NSInteger status;
@property float actualValue;
@property float score;
@property NSInteger precision;
@property BOOL showScore;
@property (nonatomic, retain) IBOutlet UIImageView *valueBackground;
@property (nonatomic, retain) IBOutlet UILabel *valueTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;
@property (nonatomic, retain) IBOutlet UIImageView *scoreBackground;
@property (nonatomic, retain) IBOutlet UILabel *scoreTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *pointerBackground;
@property (nonatomic, retain) NSMutableArray *markerLabels;
@property (nonatomic, retain) NSArray *sliderTitles;
@property (nonatomic, retain) NSMutableArray *diagnosisElements;
@property (nonatomic, retain) IBOutlet UILabel *catSmall;
@property (nonatomic, retain) IBOutlet UILabel *catLarge;
@property float scoreFontSize;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)resetSlider;


@end
