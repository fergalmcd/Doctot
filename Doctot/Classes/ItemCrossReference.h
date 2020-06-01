//
//  ItemCrossReference.h
//  Doctot
//
//  Created by Fergal McDonnell on 28/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"
#import "DiagnosisElement.h"
#import "CustomPickerView.h"

/***************************************************************************************************************************
 
 Delegate
 
 ***************************************************************************************************************************/

@protocol ItemCrossReferenceDelegate

- (void)updateItemCrossReference:(id)theSelector;

@end

/***************************************************************************************************************************
 
 Header
 
 ***************************************************************************************************************************/

@interface ItemCrossReference : UIView <UIPickerViewDelegate> {
    
    id <NSObject, ItemCrossReferenceDelegate> crossReferenceDelegate;
    ItemStructure *itemStructure;
    QuestionStructure *questionStructure;
    NSInteger index;
    NSString *scaleName;
    NSInteger status;
    float actualValue;
    float score;
    NSString *parentQuestionReference;
    NSMutableArray *diagnosisElements;
    NSMutableArray *outputItems;
    NSMutableArray *pickers;
    
}

@property (retain) id <NSObject, ItemCrossReferenceDelegate> crossReferenceDelegate;
@property (nonatomic, retain) ItemStructure *itemStructure;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property NSInteger index;
@property (nonatomic, retain) NSString *scaleName;
@property NSInteger status;
@property float actualValue;
@property float score;
@property (nonatomic, retain) NSString *parentQuestionReference;
@property (nonatomic, retain) NSMutableArray *diagnosisElements;
@property (nonatomic, retain) NSMutableArray *outputItems;
@property (nonatomic, retain) NSMutableArray *pickers;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)resetCrossReference;


@end
