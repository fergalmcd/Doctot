//
//  ItemSelector.h
//  Doctot
//
//  Created by Fergal McDonnell on 25/06/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"
#import "DiagnosisElement.h"
#import "SelectorBundle.h"
#import "SelectorButton.h"

/***************************************************************************************************************************
 
 Delegate
 
 ***************************************************************************************************************************/

@protocol ItemSelectorDelegate

- (void)updateItemSelector:(id)theSelector;

@end

/***************************************************************************************************************************
 
 Header
 
 ***************************************************************************************************************************/

@interface ItemSelector : UIView {
    
    id <NSObject, ItemSelectorDelegate> delegate;
    ItemStructure *itemStructure;
    QuestionStructure *questionStructure;
    NSInteger index;
    NSString *scaleName;
    NSInteger status;
    float actualValue;
    float score;
    NSMutableArray *diagnosisElements;
    NSMutableArray *selectorButtons;
    NSMutableArray *receiverBundles;
    
    UILabel *heading;
    UIImageView *iconImage;
    SelectorBundle *firstTopBundle;
    SelectorBundle *firstLeftBundle;
    SelectorBundle *firstRightBundle;
    NSInteger numberOfTopBundles;
    NSInteger numberOfLeftBundles;
    NSInteger numberOfRightBundles;
    NSInteger maxColumns;
    NSInteger maxRows;
    
}

@property (retain) id <NSObject, ItemSelectorDelegate> delegate;
@property (nonatomic, retain) ItemStructure *itemStructure;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property NSInteger index;
@property (nonatomic, retain) NSString *scaleName;
@property NSInteger status;
@property float actualValue;
@property float score;
@property (nonatomic, retain) NSMutableArray *diagnosisElements;
@property (nonatomic, retain) NSMutableArray *selectorButtons;
@property (nonatomic, retain) NSMutableArray *receiverBundles;

@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UIImageView *iconImage;
@property (nonatomic, retain) IBOutlet SelectorBundle *firstTopBundle;
@property (nonatomic, retain) IBOutlet SelectorBundle *firstLeftBundle;
@property (nonatomic, retain) IBOutlet SelectorBundle *firstRightBundle;
@property NSInteger numberOfTopBundles;
@property NSInteger numberOfLeftBundles;
@property NSInteger numberOfRightBundles;
@property NSInteger maxColumns;
@property NSInteger maxRows;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)resetSelector;


@end
