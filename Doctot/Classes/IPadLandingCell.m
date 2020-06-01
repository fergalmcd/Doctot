//
//  IPadLandingCell.m
//  Doctot
//
//  Created by Fergal McDonnell on 03/05/2019.
//  Copyright © 2019 Fergal McDonnell. All rights reserved.
//

#import "IPadLandingCell.h"
#import "Helper.h"
#import "Constants.h"

@interface IPadLandingCell ()

@end

@implementation IPadLandingCell

@synthesize prefs, scaleDefinition;
@synthesize background, title;

/** Degrees to Radian **/
#define degreesToRadians(degrees) (( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees(radians) (( radians ) * ( 180.0 / M_PI ) )

- (void)setupForScaleDefinition:(ScaleDefinition *)theScaleDefinition {
    
    scaleDefinition = theScaleDefinition;
    
    NSString *fullTitle = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_FullTitle", theScaleDefinition.name] withScalePrefix:NO];
    NSMutableAttributedString *fullTitleCurved = [[NSMutableAttributedString alloc] initWithString:fullTitle];
    [fullTitleCurved addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16.0]
                  range:NSMakeRange(0, [fullTitleCurved length])];
    [fullTitleCurved addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [fullTitleCurved length])];
    [self drawCurvedStringOnLayer:self.layer withAttributedText:fullTitleCurved atAngle:3.0 withRadius:(SCALE_CELL_HEIGHT / 2) - 10]; // Bottom Up
    
    UIColor *arcLineColour = [self generateAppropriateArcColour];
    CAShapeLayer *progressArc = [CAShapeLayer layer];
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, self.center.y) radius:(self.frame.size.height / 3) startAngle:0 endAngle:360 clockwise:YES];
    progressArc.path = piePath.CGPath;
    progressArc.position = CGPointMake(0, 0);
    progressArc.fillColor = arcLineColour.CGColor;
    progressArc.strokeColor = arcLineColour.CGColor;
    progressArc.lineWidth = 3;
    [self.layer addSublayer:progressArc];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height / 3), self.frame.size.width, (self.frame.size.height / 3))];
    titleLabel.text = theScaleDefinition.name;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    titleLabel.numberOfLines = 3;
    [self addSubview:titleLabel];
    
}

- (void)drawCurvedStringOnLayer:(CALayer *)layer
             withAttributedText:(NSAttributedString *)text
                        atAngle:(float)angle
                     withRadius:(float)radius {
    
    // angle in radians
    
    CGSize textSize = CGRectIntegral([text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                        context:nil]).size;
    
    float perimeter = 2 * M_PI * radius;
    float textAngle = (textSize.width / perimeter * 2 * M_PI);
    
    float textRotation;
    float textDirection;
    if (angle > degreesToRadians(10) && angle < degreesToRadians(170)) {
        //bottom string
        textRotation = 0.5 * M_PI ;
        textDirection = - 2 * M_PI;
        angle += textAngle / 2;
    } else {
        //top string
        textRotation = 1.5 * M_PI ;
        textDirection = 2 * M_PI;
        angle -= textAngle / 2;
    }
    
    for (int c = 0; c < text.length; c++) {
        NSRange range = {c, 1};
        NSAttributedString* letter = [text attributedSubstringFromRange:range];
        CGSize charSize = CGRectIntegral([letter boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                              context:nil]).size;
        
        float letterAngle = ( (charSize.width / perimeter) * textDirection );
        
        float x = radius * cos(angle + (letterAngle/2));
        float y = radius * sin(angle + (letterAngle/2));
        
        CATextLayer *singleChar = [self drawTextOnLayer:layer
                                               withText:letter
                                                  frame:CGRectMake(layer.frame.size.width/2 - charSize.width/2 + x,
                                                                   layer.frame.size.height/2 - charSize.height/2 + y,
                                                                   charSize.width, charSize.height)
                                                bgColor:nil
                                                opacity:1];
        
        singleChar.transform = CATransform3DMakeAffineTransform( CGAffineTransformMakeRotation(angle - textRotation) );
        
        angle += letterAngle;
    }
}


- (CATextLayer *)drawTextOnLayer:(CALayer *)layer
                        withText:(NSAttributedString *)text
                           frame:(CGRect)frame
                         bgColor:(UIColor *)bgColor
                         opacity:(float)opacity {
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setFrame:frame];
    [textLayer setString:text];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setBackgroundColor:bgColor.CGColor];
    [textLayer setContentsScale:[UIScreen mainScreen].scale];
    [textLayer setOpacity:opacity];
    [layer addSublayer:textLayer];
    return textLayer;
}

- (UIColor *)generateAppropriateArcColour {
    UIColor *arcColour;
    
    NSString *baseColourString = [Helper returnValueForKey:@"ThemeColour"];
    UIColor *baseColour = [Helper getColourFromString:baseColourString];
    arcColour = baseColour;
    
    float arcAlpha = 0.8;
    if( [baseColourString containsString:@"Green"] ){
        if( ( scaleDefinition.identifier % 10 ) == 0 )  arcColour = [UIColor colorWithRed:0 green:0.39 blue:0 alpha:arcAlpha];  // Dark Green: 006400
        if( ( scaleDefinition.identifier % 10 ) == 1 )  arcColour = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:arcAlpha];  // Green: 008000
        if( ( scaleDefinition.identifier % 10 ) == 2 )  arcColour = [UIColor colorWithRed:0.13 green:0.55 blue:0.13 alpha:arcAlpha];  // Forrest Green: 228B22
        if( ( scaleDefinition.identifier % 10 ) == 3 )  arcColour = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:arcAlpha];  // Lime Green: 32CD32
        if( ( scaleDefinition.identifier % 10 ) == 4 )  arcColour = [UIColor colorWithRed:0.18 green:0.55 blue:0.34 alpha:arcAlpha];  // Sea Green: 2E8B57
        if( ( scaleDefinition.identifier % 10 ) == 5 )  arcColour = [UIColor colorWithRed:0.24 green:0.7 blue:0.44 alpha:arcAlpha];  // Medium Sea Green: 3CB371
    }
    if( [baseColourString containsString:@"Blue"] ){
        if( ( scaleDefinition.identifier % 10 ) == 0 )  arcColour = [UIColor colorWithRed:0.1 green:0.1 blue:0.44 alpha:arcAlpha];  // Midnight Blue: 191970
        if( ( scaleDefinition.identifier % 10 ) == 1 )  arcColour = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:arcAlpha];  // Navy: 000080
        if( ( scaleDefinition.identifier % 10 ) == 2 )  arcColour = [UIColor colorWithRed:0 green:0 blue:0.55 alpha:arcAlpha];  // Dark Blue: 00008B
        if( ( scaleDefinition.identifier % 10 ) == 3 )  arcColour = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:arcAlpha];  // Medium Blue: 0000CD
        if( ( scaleDefinition.identifier % 10 ) == 4 )  arcColour = [UIColor colorWithRed:0 green:0 blue:1 alpha:arcAlpha];  // Blue: 0000FF
        if( ( scaleDefinition.identifier % 10 ) == 5 )  arcColour = [UIColor colorWithRed:0.25 green:0.41 blue:0.88 alpha:arcAlpha];  // Royal Blue: 4169E1
    }
    if( [baseColourString containsString:@"Purple"] ){
        if( ( scaleDefinition.identifier % 10 ) == 0 )  arcColour = [UIColor colorWithRed:0.29 green:0 blue:0.51 alpha:arcAlpha];  // indigo: 4B0082    rgb(75,0,130)
        if( ( scaleDefinition.identifier % 10 ) == 1 )  arcColour = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:arcAlpha];  // Purple: 800080    rgb(128,0,128)
        if( ( scaleDefinition.identifier % 10 ) == 2 )  arcColour = [UIColor colorWithRed:0.55 green:0 blue:0.55 alpha:arcAlpha];  // Darkmagenta: 8B008B    rgb(139,0,139)
        if( ( scaleDefinition.identifier % 10 ) == 3 )  arcColour = [UIColor colorWithRed:0.6 green:0.2 blue:0.8 alpha:arcAlpha];  // Darkorchid: 9932CC    rgb(153,50,204)
        if( ( scaleDefinition.identifier % 10 ) == 4 )  arcColour = [UIColor colorWithRed:0.58 green:0 blue:0.83 alpha:arcAlpha];  // Darkviolet: 9400D3    rgb(148,0,211)
        if( ( scaleDefinition.identifier % 10 ) == 5 )  arcColour = [UIColor colorWithRed:0.54 green:0.17 blue:0.89 alpha:arcAlpha];  // Blueviolet: 8A2BE2    rgb(138,43,226)
    }
    
    return arcColour;
}


@end

