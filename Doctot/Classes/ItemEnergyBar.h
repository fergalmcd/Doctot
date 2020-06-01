//
//  ItemEnergyBar.h
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

@protocol ItemEnergyBarDelegate

- (void)updateItemEnergyBar:(id)theEnergyBar;

@end

/***************************************************************************************************************************
 
 Header
 
 ***************************************************************************************************************************/

@interface ItemEnergyBar : UIView <UIScrollViewDelegate> {
   
    id <NSObject, ItemEnergyBarDelegate> energyBarDelegate;
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
    float minScore;
    float maxScore;
    float defaultPosition;
    NSString *precision;
    float groupSize;
    
    UILabel *heading;
    UIScrollView *scrollView;
    UIImageView *backgroundImage;
    UIImageView *theGrip;
    UIView *displayValueBackground;
    UILabel *displayValue;
    UILabel *displayInterpreation;
    float scrollableContentRange;
    float scrollableHeight;
    
    UITapGestureRecognizer *singleTapGestureRecognizer;

}

@property (retain) id <NSObject, ItemEnergyBarDelegate> energyBarDelegate;
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
@property float minScore;
@property float maxScore;
@property float defaultPosition;
@property (nonatomic, retain) NSString *precision;
@property float groupSize;
@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *theGrip;
@property (nonatomic, retain) IBOutlet UIView *displayValueBackground;
@property (nonatomic, retain) IBOutlet UILabel *displayValue;
@property (nonatomic, retain) IBOutlet UILabel *displayInterpreation;
@property (nonatomic, retain) UITapGestureRecognizer *singleTapGestureRecognizer;
@property float scrollableContentRange;
@property float scrollableHeight;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)resetEnergyBar;


@end
