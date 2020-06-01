//
//  ItemRotator.h
//  Doctot
//
//  Created by Fergal McDonnell on 10/07/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"
#import "DiagnosisElement.h"

/***************************************************************************************************************************
 
 Delegate
 
 ***************************************************************************************************************************/

@protocol ItemRotatorDelegate

- (void)updateItemRotator:(id)theRotator;

@end

/***************************************************************************************************************************
 
 Header
 
 ***************************************************************************************************************************/

@interface ItemRotator : UIView {
    
    id <NSObject, ItemRotatorDelegate> rotatorDelegate;
    ItemStructure *itemStructure;
    QuestionStructure *questionStructure;
    NSInteger index;
    NSString *scaleName;
    NSInteger status;
    float actualValue;
    float score;
    NSMutableArray *diagnosisElements;
    NSString *itemReference;
    
    NSString *type;
    float currentLargeValue;
    float currentSmallValue;
    float previousSmallValue;
    float currentMinute;
    float currentPercent;
    float adjustedAngle;
    
    float minValue;
    float maxValue;
    float defaultPosition;
    float singleRotationSize;
    NSString *precision;
    
    float progressRadius;
    CGPoint progressCentrePoint;
    float progressStartAngle;
    
    UIImageView *theContent;
    UIView *displayValueBackground;
    UILabel *displayValue;
    UILabel *displayInterpreation;
    CAShapeLayer *progressArc;
    
}

@property (retain) id <NSObject, ItemRotatorDelegate> rotatorDelegate;
@property (nonatomic, retain) ItemStructure *itemStructure;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property NSInteger index;
@property (nonatomic, retain) NSString *scaleName;
@property NSInteger status;
@property float actualValue;
@property float score;
@property (nonatomic, retain) NSMutableArray *diagnosisElements;
@property (nonatomic, retain) NSString *itemReference;

@property (nonatomic, retain) NSString *type;
@property float currentLargeValue;
@property float currentSmallValue;
@property float previousSmallValue;
@property float currentMinute;
@property float currentPercent;
@property float adjustedAngle;
@property float minValue;
@property float maxValue;
@property float defaultPosition;
@property float singleRotationSize;
@property (nonatomic, retain) NSString *precision;
@property float progressRadius;
@property CGPoint progressCentrePoint;
@property float progressStartAngle;
@property (nonatomic, retain) IBOutlet UIImageView *theContent;
@property (nonatomic, retain) IBOutlet UIView *displayValueBackground;
@property (nonatomic, retain) IBOutlet UILabel *displayValue;
@property (nonatomic, retain) IBOutlet UILabel *displayInterpreation;
@property (nonatomic, retain) CAShapeLayer *progressArc;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)jumpToValue:(float)newValue;
- (void)resetRotator;

@end
