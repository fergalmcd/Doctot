//
//  SelectorBundle.m
//  Doctot
//
//  Created by Fergal McDonnell on 26/06/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "SelectorBundle.h"
#import "Helper.h"
#import "Constants.h"

@interface SelectorBundle ()

@end

@implementation SelectorBundle

@synthesize prefs, scaleName, parentType, questionIndex, parentIndex;
@synthesize key, order, positionOnScreen, receiverScore, dictionary;
@synthesize heading, subHeading, displayImage, selectorButtons;

// Sample call: "TopBundle01": {"order":1, "positionOnScreen": "Top", "receiverScore":0, "image":"bundle_top"},

- (void)setupWithKey:(id)theKey andDictionary:(NSDictionary *)sourceDictionaryData andParentType:(NSString *)theParentType {
    
    parentType = theParentType;
    dictionary = sourceDictionaryData;
    
    key = (NSString *)theKey;
    order = [[dictionary valueForKey:@"order"] integerValue];
    positionOnScreen = [dictionary valueForKey:@"positionOnScreen"];
    receiverScore = [[dictionary valueForKey:@"receiverScore"] floatValue];
    
    selectorButtons = [[NSMutableArray alloc] init];
    
}

- (void)configureInterface {
    
    UIRectCorner theCornersToCurve = UIRectCornerTopRight|UIRectCornerBottomRight;
    if( [positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_TOP] ){
        theCornersToCurve = UIRectCornerBottomLeft|UIRectCornerBottomRight;
    }
    if( [positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_LEFT] ){
        theCornersToCurve = UIRectCornerTopRight|UIRectCornerBottomRight;
    }
    if( [positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
        theCornersToCurve = UIRectCornerTopLeft|UIRectCornerBottomLeft;
    }
    [self setMaskByRoundingCorners:theCornersToCurve];
    
    displayImage = [[UIImageView alloc] init];
    heading = [[UILabel alloc] init];
    subHeading = [[UILabel alloc] init];
    
    NSString *reference;
    reference = [NSString stringWithFormat:@"%@.png", [dictionary valueForKey:@"image"]];
    displayImage.image = [UIImage imageNamed:reference];
    displayImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    reference = [NSString stringWithFormat:@"Q%i_Item%i_SelectorBundle%@%li_Title", questionIndex, parentIndex, positionOnScreen, (order - 1)];
    heading.text = [Helper getLocalisedString:reference withScalePrefix:YES];
    heading.textColor = [UIColor blackColor];
    heading.textAlignment = NSTextAlignmentCenter;
    if( self.frame.size.width > self.frame.size.height ){
        heading.frame = CGRectMake( 0, 0, ( self.frame.size.width * SELECTOR_BUNDLE_HEADING_RATIO ), self.frame.size.height);
    }else{
        heading.frame = CGRectMake(0, 0, self.frame.size.width, ( self.frame.size.height * SELECTOR_BUNDLE_HEADING_RATIO ) );
    }
    reference = [NSString stringWithFormat:@"Q%i_Item%i_SelectorBundle%li_Subtitle", questionIndex, parentIndex, (order - 1)];
    subHeading.text = [Helper getLocalisedString:reference withScalePrefix:YES];
    subHeading.textAlignment = NSTextAlignmentCenter;
    subHeading.frame = CGRectMake(0, (self.frame.size.height / 2), self.frame.size.width, (self.frame.size.height / 2));
    
    [self addSubview:displayImage];
    [self addSubview:heading];
    [self addSubview:subHeading];
    
}

- (void)addSelectorButton:(SelectorButton *)newSelectorButton {
    
    // Right Swipe on a SelectorButton from the Centre to a right SelectorBundle (Needed for the animation which follows)
    if( [positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
        newSelectorButton.frame = CGRectMake((newSelectorButton.frame.size.width * -1), newSelectorButton.frame.origin.y, newSelectorButton.frame.size.width, newSelectorButton.frame.size.height);
    }
    
    // Animate
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    newSelectorButton.canvas = positionOnScreen;
    newSelectorButton.canvasIndex = order;
    [selectorButtons addObject:newSelectorButton];
    [self displayAllSelectorButtons];
    
    [UIView commitAnimations];
    
}

- (void)removeSelectorButton:(SelectorButton *)newSelectorButton {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for( SelectorButton *aButton in selectorButtons ){
        if( [aButton isKindOfClass:[SelectorButton class]] ){
            if( aButton != newSelectorButton ){
                [tempArray addObject:aButton];
            }
        }
    }
    selectorButtons = tempArray;
    
    [self displayAllSelectorButtons];
    
}

- (void)displayAllSelectorButtons {
    
    // Animate
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    [self clearAllSelectorButtons];
    
    float xPosition = 0.0, yPosition = 0.0, buttonWidth = 0.0, buttonHeight = 0.0;
    float minimisedButtonHeight = 0.0, minimisedButtonWidth = 0.0;
    
    int i = 0;
    for( SelectorButton *aButton in selectorButtons ){
        
        if( [positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_TOP] ){
            minimisedButtonWidth = (self.frame.size.width - heading.frame.size.width) / [selectorButtons count];
            xPosition = heading.frame.size.width + (i * minimisedButtonWidth);
            yPosition = 0.0;
            buttonWidth = minimisedButtonWidth;
            buttonHeight = self.frame.size.height;
        }else{
            minimisedButtonHeight = (self.frame.size.height - heading.frame.size.height) / [selectorButtons count];
            xPosition = 0.0;
            yPosition = heading.frame.size.height + (i * minimisedButtonHeight);
            buttonWidth = self.frame.size.width;
            buttonHeight = minimisedButtonHeight;
        }
        
        aButton.frame = CGRectMake(xPosition, yPosition, buttonWidth, buttonHeight);
        //aButton.frame = CGRectMake(0, heading.frame.size.height + (i * minimisedButtonHeight), self.frame.size.width, minimisedButtonHeight);
        [aButton minimiseForBundle];
        [self addSubview:aButton];
        i++;
        
    }
    
    [UIView commitAnimations];
    
}

- (void)clearAllSelectorButtons {
    
    for( SelectorButton *aButton in self.subviews ){
        if( [aButton isKindOfClass:[SelectorButton class]] ){
            [aButton removeFromSuperview];
        }
    }
    
}

- (void)resetSelectorButtons {
    
    [self clearAllSelectorButtons];
    selectorButtons = [[NSMutableArray alloc] init];
    
}

- (void)setMaskByRoundingCorners:(UIRectCorner)corners {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(20.0, 20.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}


@end
