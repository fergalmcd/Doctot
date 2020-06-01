//
//  Question.m
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import "ItemButton.h"
#import "Helper.h"
#import "Constants.h"


@implementation ItemButton

@synthesize itemStructure, questionStructure, index, scaleName, status, score, precision, showScore;
@synthesize titleLabel, subtitleLabel, offImage, onImage, labelTextOnColour, labelTextOffColour;

float SCORE_X_OFFSET = 10;
float SCORE_WIDTH = 50;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)configureWithItemStructure:(ItemStructure *)theStructure {
    
    itemStructure = theStructure;
    index = itemStructure.index;
    showScore = questionStructure.showItemScores;
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] || [itemStructure.subtype isEqualToString:@"Toggle"] || [itemStructure.subtype isEqualToString:@"Recurring"] ){
        
        status = BUTTON_STATE_DEFAULT;
        score = itemStructure.defaultScore;
        
        offImage = [UIImage imageNamed:@"answer_off.png"];
        onImage = [UIImage imageNamed:@"answer_click.png"];
        
        labelTextOffColour = [Helper getColourFromString:[Helper returnValueForKey:@"ItemOffTextColour"]];
        labelTextOnColour = [Helper getColourFromString:[Helper returnValueForKey:@"ItemOnTextColour"]];
        
        NSString *precisionForamt = @"%.";
        precisionForamt = [precisionForamt stringByAppendingFormat:@"%lif", (long)precision];
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCORE_X_OFFSET, 0, SCORE_WIDTH, self.frame.size.height)];
        scoreLabel.text = [NSString stringWithFormat:precisionForamt, itemStructure.onScore];
        if( showScore ){
            [self addSubview:scoreLabel];
        }
        
        float titleStartingX = SCORE_X_OFFSET;
        if( showScore ){
            titleStartingX = scoreLabel.frame.origin.x + scoreLabel.frame.size.width;
        }
        NSString *titleReference = [NSString stringWithFormat:@"%@_Q%li_Item%li", scaleName, (long)questionStructure.index, (long)index];
        if( [itemStructure.subtype isEqualToString:@"Recurring"] ){
            titleReference = [NSString stringWithFormat:@"%@_Item%li", scaleName, (long)index];
        }
        float textRightPadding = 10;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleStartingX, 0, (self.frame.size.width - titleStartingX - textRightPadding), self.frame.size.height)];
        titleLabel.text = NSLocalizedString(titleReference, @"");
        titleLabel.font = [Helper getScaleItemFont:scaleName];
        titleLabel.numberOfLines = 5;
        [self addSubview:titleLabel];
        
        [self displayOnOffState];
        
        if( [itemStructure.subtype isEqualToString:@"Normal"] || [itemStructure.subtype isEqualToString:@"Recurring"] ){
            [self addTarget:self action:@selector(updateStatus) forControlEvents:UIControlEventTouchUpInside];
        }
        if( [itemStructure.subtype isEqualToString:@"Toggle"] ){
            [self addTarget:self action:@selector(toggleStatus) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self makeQuestionSpecificAdjustments];
        
    }
    
    if( [itemStructure.subtype isEqualToString:@"YES"] || [itemStructure.subtype isEqualToString:@"NO"] ){
        
        status = BUTTON_STATE_DEFAULT;
        score = itemStructure.defaultScore;
        
        offImage = [UIImage imageNamed:[NSString stringWithFormat:@"answer_off_%@.png", [itemStructure.subtype lowercaseString]]];
        onImage = [UIImage imageNamed:[NSString stringWithFormat:@"answer_confirm_%@.png", [itemStructure.subtype lowercaseString]]];
        float heightRatio = offImage.size.height / offImage.size.width;
        
        CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
        if( itemStructure.index == 0 ){
            self.frame = CGRectMake(0, 0, (questionDimensions.width / 2), ((questionDimensions.width / 2) * heightRatio));
        }
        if( itemStructure.index == 1 ){
            self.frame = CGRectMake((questionDimensions.width / 2), 0, (questionDimensions.width / 2), ((questionDimensions.width / 2) * heightRatio));
        }

        NSString *titleReference = [NSString stringWithFormat:@"%@_Item%li", scaleName, (long)index];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 50), self.frame.size.width, 50)];
        titleLabel.text = NSLocalizedString(titleReference, @"");
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [Helper getScaleItemFont:scaleName];
        titleLabel.numberOfLines = 5;
        [self addSubview:titleLabel];
        
        [self displayOnOffState];
        
        [self addTarget:self action:@selector(updateStatus) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)updateStatus {
    
    if( (status == BUTTON_STATE_ON) || (status = BUTTON_STATE_CONFIRMED) ){
        status = BUTTON_STATE_CONFIRMED;
    }else{
        status = BUTTON_STATE_ON;
    }
    
    [self displayOnOffState];
    
}

- (void)toggleStatus {
    
    if( status == BUTTON_STATE_ON ){
        status = BUTTON_STATE_OFF;
    }else{
        status = BUTTON_STATE_ON;
    }
    
    [self displayOnOffState];
    
}

- (void)displayOnOffState {
    
    if( (status == BUTTON_STATE_ON) || (status == BUTTON_STATE_CONFIRMED) ){
        score = itemStructure.onScore;
        [self setBackgroundImage:onImage forState:UIControlStateNormal];
        titleLabel.textColor = labelTextOnColour;
        scoreLabel.textColor = labelTextOnColour;
    }
    if( (status == BUTTON_STATE_DEFAULT) || (status == BUTTON_STATE_OFF) ){
        score = itemStructure.offScore;
        [self setBackgroundImage:offImage forState:UIControlStateNormal];
        titleLabel.textColor = labelTextOffColour;
        scoreLabel.textColor = labelTextOffColour;
    }
}

- (void)setItemStatus:(NSInteger)theStatus {
    
    status = theStatus;
    [self displayOnOffState];

}

- (void)makeQuestionSpecificAdjustments {
    
    if( [scaleName isEqualToString:@"COM"] && (questionStructure.index == 3) && (index == 1) ){
        self.hidden = YES;
    }
    
}

- (UIView *)roundCornersOnViewOnTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    UIRectCorner corner; //holds the corner
    
    
    //Determine which corner(s) should be changed
    if (tl) {
        corner = UIRectCornerTopLeft;
    }
    if (tr) {
        corner = UIRectCornerTopRight;
    }
    if (bl) {
        corner = UIRectCornerBottomLeft;
    }
    if (br) {
        corner = UIRectCornerBottomRight;
    }
    if (tl && tr) { //top
        corner = UIRectCornerTopRight | UIRectCornerTopLeft;
    }
    if (bl && br) { //bottom
        corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }
    if (tl && bl) { //left
        corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    }
    if (tr && br) { //right
        corner = UIRectCornerTopRight | UIRectCornerBottomRight;
    }
    
    if (tl & tr & bl & br) {
        corner = UIRectCornerAllCorners;
    }
    
    UIView *roundedView = self;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = roundedView.bounds;
    maskLayer.path = maskPath.CGPath;
    roundedView.layer.mask = maskLayer;
    
    return roundedView;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
