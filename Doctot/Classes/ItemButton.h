//
//  Question.h
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemStructure.h"
#import "QuestionStructure.h"

@interface ItemButton : UIButton {
    
    ItemStructure *itemStructure;
    QuestionStructure *questionStructure;
    NSInteger index;
    NSString *scaleName;
    NSInteger status;
    float score;
    NSInteger precision;
    BOOL showScore;
    
    UILabel *scoreLabel;
    UILabel *titleLabel;
    UIImage *offImage;
    UIImage *onImage;
    UIColor *labelTextOnColour;
    UIColor *labelTextOffColour;
    
}

@property (nonatomic, retain) ItemStructure *itemStructure;
@property (nonatomic, retain) QuestionStructure *questionStructure;
@property NSInteger index;
@property (nonatomic, retain) NSString *scaleName;
@property NSInteger status;
@property float score;
@property NSInteger precision;
@property BOOL showScore;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, retain) IBOutlet UIImage *offImage;
@property (nonatomic, retain) IBOutlet UIImage *onImage;
@property (nonatomic, retain) UIColor *labelTextOnColour;
@property (nonatomic, retain) UIColor *labelTextOffColour;

- (void)configureWithItemStructure:(ItemStructure *)theStructure;
- (void)setItemStatus:(NSInteger)theStatus;
- (UIView *)roundCornersOnViewOnTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;


@end
