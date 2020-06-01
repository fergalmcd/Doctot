//
//  ItemRotator.m
//  Doctot
//
//  Created by Fergal McDonnell on 10/07/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "ItemRotator.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Helper.h"


@implementation ItemRotator

@synthesize rotatorDelegate, itemStructure, questionStructure, index, scaleName, status, actualValue, score, diagnosisElements, itemReference;
@synthesize type, currentLargeValue, currentSmallValue, previousSmallValue, currentMinute, currentPercent, adjustedAngle;
@synthesize minValue, maxValue, defaultPosition, singleRotationSize, precision;
@synthesize progressRadius, progressCentrePoint, progressStartAngle;
@synthesize theContent, displayValueBackground, displayValue, displayInterpreation, progressArc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/***************************************************************************************************************************
 
 - (void)configureWithItemStructure:(ItemStructure *)theStructure
 
 ***************************************************************************************************************************/

- (void)configureWithItemStructure:(ItemStructure *)theStructure {
    
    itemStructure = theStructure;
    status = BUTTON_STATE_DEFAULT;
    
    index = itemStructure.index;
    score = itemStructure.defaultScore;
    
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    self.frame = CGRectMake( ((questionDimensions.width - ROTATOR_ACTIVE_REGION_SIDE) / 2), (index * ROTATOR_ACTIVE_REGION_SIDE), ROTATOR_ACTIVE_REGION_SIDE, ROTATOR_ACTIVE_REGION_SIDE);
    self.backgroundColor = [UIColor clearColor];
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] || [itemStructure.subtype isEqualToString:@"Time"] ){
        
        // Setup the dementsions of the Rotator (gathered from the scaleDefinitions.json settings via itemStructure [ItemStructure])
        [self defineDementions];
        
        // UI initialisation of all elements
        [self configureInterface];
        
    }
    
}

/***************************************************************************************************************************
 
 - (void)defineDementions
 
 ***************************************************************************************************************************/

- (void)defineDementions {
    
    type = itemStructure.subtype;
    actualValue = itemStructure.defaultScore;
    minValue = itemStructure.offScore;
    maxValue = itemStructure.onScore;
    defaultPosition = itemStructure.defaultPosition;
    singleRotationSize = itemStructure.singleRotationSize;
    precision = [Helper printPrecision:itemStructure.precision];
    
    // Cut-off Ranges ////////////////////////////////////////////////////////////////////////////////////////////
    diagnosisElements = [[NSMutableArray alloc] init];
    DiagnosisElement *diagnosisElement;
    NSString *diagnosisData;
    for(id key in itemStructure.scoreRanges ){
        diagnosisElement = [[DiagnosisElement alloc] init];
        
        diagnosisData = (NSString *)key;
        NSArray *diagnosisDataDelimited = [diagnosisData componentsSeparatedByString:@" "];
        
        diagnosisElement.name = key;
        diagnosisElement.index = [[diagnosisDataDelimited objectAtIndex:0] integerValue];
        diagnosisElement.colourString = (NSString *)[diagnosisDataDelimited objectAtIndex:1];
        diagnosisElement.colour = [Helper getColourFromString:diagnosisElement.colourString];
        diagnosisElement.minScore = [[itemStructure.scoreRanges objectForKey:key] floatValue];
        if( [diagnosisDataDelimited count] > 2 ){
            diagnosisElement.outputScoreRelevant = YES;
            diagnosisElement.outputScore = [[diagnosisDataDelimited objectAtIndex:2] floatValue];
        }else{
            diagnosisElement.outputScoreRelevant = NO;
            diagnosisElement.outputScore = DIAGNOSIS_ELEMENT_NO_OUTPUT;
        }
        
        [diagnosisElements addObject:diagnosisElement];
    }
    
    diagnosisElements = [Helper sortedArray:diagnosisElements byIndex:@"index" andAscending:YES];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

/***************************************************************************************************************************
 
 - (void)configureInterface
 
 ***************************************************************************************************************************/

- (void)configureInterface {
    
    itemReference = [NSString stringWithFormat:@"%@_Q%li_Item%li", scaleName, questionStructure.index, index];
    //previousMinute = 0;
    
    UIImage *theBackground;
    theBackground = [UIImage imageNamed:@"rotator.png"];
    theContent = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    theContent.image = theBackground;
    theContent.backgroundColor = [UIColor clearColor];
    
    float displayValueUnitsRatio = 0.5;
    displayValue = [[UILabel alloc] initWithFrame:CGRectMake(0, ROTATOR_ACTIVE_REGION_SIDE, self.frame.size.width, ((ROTATOR_HEIGHT - ROTATOR_ACTIVE_REGION_SIDE) * displayValueUnitsRatio) )];
    displayValue.text = @"-";
    displayValue.textColor = [UIColor whiteColor];
    displayValue.textAlignment = NSTextAlignmentCenter;
    displayValue.backgroundColor = [UIColor clearColor];
    displayValue.font = [UIFont fontWithName:@"Helvetica" size:24.0];
    
    displayValueBackground = [[UIView alloc] initWithFrame:CGRectMake( (displayValue.frame.size.width / 3), displayValue.frame.origin.y, (displayValue.frame.size.width / 3), displayValue.frame.size.height)];
    displayValueBackground.layer.cornerRadius = displayValueBackground.frame.size.height / 2;
    displayValueBackground.backgroundColor = [Helper getBackgroundColourForText:displayValue.textColor givenBackground:@"Dark"];
    
    displayInterpreation = [[UILabel alloc] initWithFrame:CGRectMake(0, (displayValue.frame.origin.y + displayValue.frame.size.height), self.frame.size.width, ((ROTATOR_HEIGHT - ROTATOR_ACTIVE_REGION_SIDE) * (1 -displayValueUnitsRatio)) )];
    displayInterpreation.text = @"";
    displayInterpreation.textColor = [UIColor whiteColor];
    displayInterpreation.textAlignment = NSTextAlignmentCenter;
    displayInterpreation.backgroundColor = [UIColor clearColor];
    displayInterpreation.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [self addSubview:theContent];
    [self addSubview:displayValueBackground];
    [self addSubview:displayValue];
    [self addSubview:displayInterpreation];
    
    // Setting up the Progress Circle in the centre
    progressRadius = (theContent.frame.size.width / 8);
    progressCentrePoint = CGPointMake(theContent.center.x, theContent.center.y);
    progressStartAngle = 3 * M_PI / 2;
    
    [self jumpToValue:itemStructure.defaultScore];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self getPositionHitOnCircle:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self getPositionHitOnCircle:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self getPositionHitOnCircle:touches];
}

- (void)getPositionHitOnCircle:(NSSet *)theTouches {
    
    UITouch *touch = [theTouches anyObject];
	CGPoint tap_location = [touch locationInView:self];
    CGPoint centrePoint = CGPointMake( (self.frame.size.width / 2) , (self.frame.size.height / 2) );
	
    float rawAngle = (((atan2((tap_location.x - centrePoint.x) , (tap_location.y - centrePoint.y)))*180)/M_PI);
    adjustedAngle = (rawAngle * -1) + 180;
    
    previousSmallValue = currentSmallValue;
    currentSmallValue = singleRotationSize * (adjustedAngle / 360);
    currentPercent = adjustedAngle / 3.6;
    currentMinute = adjustedAngle / 6;
    
    //NSLog(@"adjustedAngle: %f   currentLargeValue: %f   currentSmallValue: %f   previousSmallValue: %f", adjustedAngle, currentLargeValue, currentSmallValue, previousSmallValue);
    
    // TICK UP: Passing the 12 o'clock point from 11 o'clock forward towards 1 o'clock
    if( (previousSmallValue - currentSmallValue ) > ( singleRotationSize / 2 ) ){
        if( previousSmallValue != 0 ){
            currentLargeValue += singleRotationSize;
            currentSmallValue = 0;
            currentPercent = 0;
            currentMinute = 0;
        }
    }
    // TICK DOWN: Passing the 12 o'clock point from 1 o'clock back towards 11 o'clock
    if( (currentSmallValue - previousSmallValue) > ( (singleRotationSize) / 2 ) ){
        if( actualValue != minValue ){
            currentLargeValue -= singleRotationSize;
            currentSmallValue = singleRotationSize * 0.99;
            currentPercent = 0;
            currentMinute = 0;
        }
    }
    
    actualValue = currentLargeValue + currentSmallValue;
    
    // Dragging back through Min Value: returns the Rotator to the end max value
    if( actualValue <= minValue ){
        actualValue = minValue;
        currentLargeValue = maxValue - singleRotationSize;
        currentSmallValue = 0;
        adjustedAngle = 0;
    }
    // Dragging forward through Max Value: returns the Rotator to the start
    if( actualValue >= maxValue ){
        actualValue = maxValue;
        currentLargeValue = minValue;
        currentSmallValue = 0;
        adjustedAngle = 0;
   }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    // type = Normal
    
    displayValue.text = [NSString stringWithFormat:precision, actualValue];
    displayValue.text = [displayValue.text stringByAppendingFormat:@" %@", [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Units", itemReference] withScalePrefix:NO]];
    displayValueBackground.backgroundColor = [Helper getBackgroundColourForText:displayValue.textColor givenBackground:@"Dark"];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Specific for type = TIME
    if( [type isEqualToString:@"Time"] ){
        int hour = actualValue / singleRotationSize;    // singleRotationSize should be set to 60
        if( currentMinute == 60 ){
            currentMinute = 59;
        }
        if( ( hour < 10 ) || ( currentMinute < 10 ) ){
            if( ( hour < 10 ) && ( currentMinute < 10 ) ){
                displayValue.text = [NSString stringWithFormat:@"0%i : 0%.0f", hour, currentMinute];
            }else{
                if( hour < 10 ){
                    displayValue.text = [NSString stringWithFormat:@"0%i : %.0f", hour, currentMinute];
                }
                if( currentMinute < 10 ){
                    displayValue.text = [NSString stringWithFormat:@"%i : 0%.0f", hour, currentMinute];
                }
            }
        }else{
            displayValue.text = [NSString stringWithFormat:@"%i : %.0f", hour, currentMinute];
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self drawCirclePointerPostion];
    [self drawCompletionCircle];
    [self calculateScore];
    
}

- (void)drawCirclePointerPostion {

    theContent.transform = CGAffineTransformMakeRotation( adjustedAngle * (M_PI / 180) );
    
}

- (void)drawCompletionCircle {
    
    float percentage_complete = (float)(actualValue - minValue) / (float)(maxValue - minValue);
    float ending_angle = (2 * M_PI * percentage_complete) + progressStartAngle;
    UIColor *arcLineColour = displayValue.textColor;
    
    for (CALayer *layer in self.layer.sublayers) {
        if( layer == progressArc ){
            [layer removeFromSuperlayer];
        }
    }
    
    progressArc = [CAShapeLayer layer];
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(progressCentrePoint.x, progressCentrePoint.y) radius:progressRadius startAngle:progressStartAngle endAngle:ending_angle clockwise:YES];
    
    progressArc.path = piePath.CGPath;
    progressArc.fillColor = [UIColor clearColor].CGColor;
    progressArc.strokeColor = arcLineColour.CGColor;
    progressArc.lineWidth = 10;
    progressArc.opacity = 0.5;
    
    [self.layer addSublayer:progressArc];
    
}

/***************************************************************************************************************************
 
 SCORING
 
 ***************************************************************************************************************************/

- (void)calculateScore {
    
    [rotatorDelegate updateItemRotator:self]; // ItemRotatorDelegate calls - (void)updateRotatorBar:(ItemRotator *)theRotator in Question class
    
    [self determineCutoffCategory];
    
}

- (void)determineCutoffCategory {
    
    if( [diagnosisElements count] > 0 ){
        
        BOOL levelFound = NO;
        float delta = 0.5 / powf(10, itemStructure.precision);
        DiagnosisElement *selectedElement;
        for( DiagnosisElement *dElement in diagnosisElements ){
            if( ( ( actualValue + delta ) > dElement.minScore) && (!levelFound) ){
                selectedElement = dElement;
                levelFound = YES;
            }
        }
        
        displayValue.textColor = selectedElement.colour;
        if( selectedElement.outputScoreRelevant ){
            score = selectedElement.outputScore;
        }else{
            score = actualValue;
        }
        
    }else{
        
        score = actualValue;
        
    }
    
}

- (void)jumpToValue:(float)newValue{
    
    actualValue = newValue;
    
    currentLargeValue = minValue;
    float segmentValue = actualValue;
    while( segmentValue > ( singleRotationSize - minValue )  ){
        segmentValue -= singleRotationSize;
        currentLargeValue += singleRotationSize;
    }
    currentSmallValue = actualValue - currentLargeValue;
    
    adjustedAngle = ( segmentValue / singleRotationSize ) * 360;
    
    displayValue.text = [NSString stringWithFormat:precision, actualValue];
    displayValue.text = [displayValue.text stringByAppendingFormat:@" %@", [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Units", itemReference] withScalePrefix:NO]];
    
    [self drawCirclePointerPostion];
}

- (void)resetRotator {
    
    [self jumpToValue:itemStructure.defaultScore];
    
    // Remove Progress Circle
    for (CALayer *layer in self.layer.sublayers) {
        if( layer == progressArc ){
            [layer removeFromSuperlayer];
        }
    }
    
    // Clear labels
    displayValue.text = @"";
    displayInterpreation.text = @"";
    
}

- (void)makeQuestionSpecificAdjustments {
    
    if( [scaleName isEqualToString:@""] ){
        
    }
    
}


/***************************************************************************************************************************
 
 Parent Interview
 
 ***************************************************************************************************************************/

- (Interview *)parentInterview {
    
    Interview *thisInterview;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    Scale *thisScale = home.scale;
    thisInterview = thisScale.interview;
    
    return thisInterview;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
