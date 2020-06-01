//
//  ItemSwiper.h
//  Doctot
//
//  Created by Fergal McDonnell on 19/06/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"
#import "DiagnosisElement.h"

/***************************************************************************************************************************
 
 Delegate
 
 ***************************************************************************************************************************/

@protocol ItemSwiperDelegate

- (void)updateItemSwiper:(id)theSwiper;

@end

/***************************************************************************************************************************
 
 Header
 
 ***************************************************************************************************************************/

@interface ItemSwiper : UIView <UIScrollViewDelegate> {
    
    id <NSObject, ItemSwiperDelegate> delegate;
    ItemStructure *itemStructure;
    QuestionStructure *questionStructure;
    NSUserDefaults *prefs;
    NSInteger index;
    NSString *scaleName;
    NSInteger status;
    float actualValue;
    float score;
    NSInteger precision;
    DiagnosisElement *selectedElement;
    NSMutableArray *diagnosisElements;
    
    UILabel *heading;
    UIImageView *contactAreaBackground;
    UIScrollView *contactArea;
    UIView *entireSpan;
    UIView *dialAdjuster;
    UIImageView *scorePin;
    UIImageView *scoreBackground;
    UILabel *scoreLabel;
    UILabel *unitsLabel;
    
    float startScore;
    float minScore;
    float maxScore;
    float startLeftScore;
    float startRightScore;
    float range;
    float numberOfSegments;
    float distanceInPixelsBetweenUnits;
    float singleTapGapinPixels;
    float doubleTapGapInPixels;
    float fullWidthInPixels;
    float activeWidthInPixels;
    
    UITapGestureRecognizer *singleTapGestureRecognizer;
    UITapGestureRecognizer *doubleTapGestureRecognizer;

}

@property (retain) id <NSObject, ItemSwiperDelegate> delegate;
@property (nonatomic, retain) ItemStructure *itemStructure;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property NSInteger index;
@property (nonatomic, retain) NSString *scaleName;
@property NSInteger status;
@property float actualValue;
@property float score;
@property NSInteger precision;
@property (nonatomic, retain) DiagnosisElement *selectedElement;
@property (nonatomic, retain) NSMutableArray *diagnosisElements;

@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UIImageView *contactAreaBackground;
@property (nonatomic, retain) IBOutlet UIScrollView *contactArea;
@property (nonatomic, retain) IBOutlet UIView *entireSpan;
@property (nonatomic, retain) IBOutlet UIView *dialAdjuster;
@property (nonatomic, retain) IBOutlet UIImageView *scorePin;
@property (nonatomic, retain) IBOutlet UIImageView *scoreBackground;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *unitsLabel;

@property float startScore;
@property float minScore;
@property float maxScore;
@property float startLeftScore;
@property float startRightScore;
@property float range;
@property float numberOfSegments;
@property float distanceInPixelsBetweenUnits;
@property float singleTapGapinPixels;
@property float doubleTapGapInPixels;
@property float fullWidthInPixels;
@property float activeWidthInPixels;

@property (nonatomic, retain) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGestureRecognizer;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)resetSwiper;


@end
