//
//  ItemStopwatch.h
//  Doctot
//
//  Created by Fergal McDonnell on 24/07/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"
#import "DiagnosisElement.h"

/***************************************************************************************************************************
 
 Delegate
 
 ***************************************************************************************************************************/

@protocol ItemStopwatchDelegate

- (void)updateItemStopwatch:(id)theStopwatch;
- (void)resetAllButtonItems;

@end

/***************************************************************************************************************************
 
 Header
 
 ***************************************************************************************************************************/

@interface ItemStopwatch : UIView {
    
    id <NSObject, ItemStopwatchDelegate> stopwatchDelegate;
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
    float startSeconds;
    float endSeconds;
    BOOL countdown;
    BOOL limitedEnd;
    NSTimer *timer;
    
    UIImageView *theBackgroundImage;
    UIButton *triggerButton;
    UIImageView *theIconImage;
    UILabel *currenTime;
    UILabel *seconds;
    UILabel *command;
    UIImage *onImage;
    UIImage *offImage;
    CAShapeLayer *progressArc;
    
}

@property (retain) id <NSObject, ItemStopwatchDelegate> stopwatchDelegate;
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
@property float startSeconds;
@property float endSeconds;
@property BOOL countdown;
@property BOOL limitedEnd;
@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) IBOutlet UIImageView *theBackgroundImage;
@property (nonatomic, retain) IBOutlet UIButton *triggerButton;
@property (nonatomic, retain) IBOutlet UIImageView *theIconImage;
@property (nonatomic, retain) IBOutlet UILabel *currenTime;
@property (nonatomic, retain) IBOutlet UILabel *seconds;
@property (nonatomic, retain) IBOutlet UILabel *command;
@property (nonatomic, retain) IBOutlet UIImage *onImage;
@property (nonatomic, retain) IBOutlet UIImage *offImage;
@property (nonatomic, retain) CAShapeLayer *progressArc;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)turnOffStopwatch;
- (void)resetStopwatch;


@end
