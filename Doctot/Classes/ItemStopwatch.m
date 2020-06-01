//
//  ItemStopwatch.m
//  Doctot
//
//  Created by Fergal McDonnell on 24/07/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "ItemStopwatch.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Helper.h"

/***************************************************************************************************************************
 
 Sample Setups in ScaleDefinitions.json
 "item0" : { "index": 0, "type": "Stopwatch", "subtype": "Normal", "startSeconds": 20, "endSeconds": 0,
            "timingRanges" : { "1 Red 2.0": 10, "2 Black 1.0": -1 }
 
 subType: Only "Normal"
 "startSeconds": float which defines when the Stopwatch starts
 "endSeconds": float which defines when the Stopwatch starts
 "timingRanges": defines the ranges [Example: "1 Red 2.0": 10
                                            1 is the order the items are stored,
                                            Red is the colour for that part of the range,
                                            2.0 is the score which is relevant to the Question score but does not have an effect for Stopwatch. This should be done by defining it in the delegate method in Question.m
                                            10 is the minimum value for this part of the range
                                    ]
 
 Derived values:
    countdown - The Stopwatch counts down if startSeconds > endSeconds   =>   countdown = YES
    limitedEnd - means that the Stopwatch does / doesn't go on endlesly. If endSeconds < 0   =>   limitedEnd = NO
 
 ***************************************************************************************************************************/

@implementation ItemStopwatch

@synthesize stopwatchDelegate, itemStructure, questionStructure, index, scaleName, status, actualValue, score, diagnosisElements, itemReference;
@synthesize type, startSeconds, endSeconds, countdown, limitedEnd, timer;
@synthesize theBackgroundImage, triggerButton, theIconImage, currenTime, seconds, command, onImage, offImage, progressArc;

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
    status = BUTTON_STATE_OFF;
    
    index = itemStructure.index;
    //score = itemStructure.defaultScore;
    
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    self.frame = CGRectMake( 0, 0, questionDimensions.width, STOPWATCH_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] ){
        
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
    
    startSeconds = itemStructure.startSeconds;
    endSeconds = itemStructure.endSeconds;
    actualValue = startSeconds;
    
    if( endSeconds < 0 ){
        limitedEnd = NO;
        countdown = NO;
    }else{
        if( endSeconds > startSeconds ){
            countdown = NO;
        }else{
            countdown = YES;
        }
        limitedEnd = YES;
    }
    
    // Cut-off Ranges ////////////////////////////////////////////////////////////////////////////////////////////
    diagnosisElements = [[NSMutableArray alloc] init];
    DiagnosisElement *diagnosisElement;
    NSString *diagnosisData;
    for(id key in itemStructure.timingRanges ){
        diagnosisElement = [[DiagnosisElement alloc] init];
        
        diagnosisData = (NSString *)key;
        NSArray *diagnosisDataDelimited = [diagnosisData componentsSeparatedByString:@" "];
        
        diagnosisElement.name = key;
        diagnosisElement.index = [[diagnosisDataDelimited objectAtIndex:0] integerValue];
        diagnosisElement.colourString = (NSString *)[diagnosisDataDelimited objectAtIndex:1];
        diagnosisElement.colour = [Helper getColourFromString:diagnosisElement.colourString];
        diagnosisElement.minScore = [[itemStructure.timingRanges objectForKey:key] floatValue];
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
    
    float padding = 15;
    float adjustedWidth = self.frame.size.width - (2 * padding);
    onImage = [UIImage imageNamed:@"stopwatch_stop.png"];
    offImage = [UIImage imageNamed:@"stopwatch_start.png"];
    
    UIImage *theBackground;
    //theBackground = [UIImage imageNamed:@"content.png"];
    theBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    theBackgroundImage.image = theBackground;
    theBackgroundImage.backgroundColor = [UIColor clearColor];
    
    theIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    theIconImage.image = offImage;
    theIconImage.backgroundColor = [UIColor clearColor];
    
    triggerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [triggerButton addTarget:self action:@selector(triggerStopwatch) forControlEvents:UIControlEventTouchUpInside];
    
    currenTime = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, ( adjustedWidth * 0.6 ), self.frame.size.height)];
    currenTime.text = @"-";
    currenTime.textColor = [UIColor blackColor];
    currenTime.textAlignment = NSTextAlignmentCenter;
    currenTime.backgroundColor = [UIColor clearColor];
    currenTime.font = [UIFont fontWithName:@"Helvetica" size:36.0];
    
    seconds = [[UILabel alloc] initWithFrame:CGRectMake( (currenTime.frame.origin.x + currenTime.frame.size.width), 0, ( adjustedWidth * 0.0 ), self.frame.size.height)];
    seconds.text = [Helper getLocalisedString:@"Scale_Stopwatch_Seconds" withScalePrefix:NO];
    seconds.textColor = [UIColor lightGrayColor];
    seconds.textAlignment = NSTextAlignmentLeft;
    seconds.backgroundColor = [UIColor clearColor];
    seconds.layer.shadowRadius = 5.0;
    seconds.layer.shadowOpacity = 0.5;
    seconds.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    command = [[UILabel alloc] initWithFrame:CGRectMake( (seconds.frame.origin.x + seconds.frame.size.width), 0, ( adjustedWidth * 0.4 ), self.frame.size.height)];
    command.text = [Helper getLocalisedString:@"Scale_Stopwatch_Stopped" withScalePrefix:NO];
    command.textColor = [UIColor whiteColor];
    command.textAlignment = NSTextAlignmentCenter;
    command.backgroundColor = [UIColor clearColor];
    command.layer.shadowRadius = 5.0;
    command.layer.shadowOpacity = 0.5;
    command.font = [UIFont fontWithName:@"Helvetica" size:24.0];
    
    [self addSubview:theBackgroundImage];
    [self addSubview:theIconImage];
    [self addSubview:triggerButton];
    [self addSubview:currenTime];
    [self addSubview:seconds];
    [self addSubview:command];

}


/***************************************************************************************************************************/
 
- (void)triggerStopwatch {
 
    // If the Stopwatch is already in action
    if( status == BUTTON_STATE_ON ){
        [self turnOffStopwatch];
        return;
    }
    
    // If the Stopwatch has already counted up to reach the upper limit allowed
    if( limitedEnd && !countdown && ( actualValue >= endSeconds ) ){
        [self turnOffStopwatch];
        return;
    }
    
    // If the Stopwatch has already counted down to reach the lower limit allowed
    if( limitedEnd && countdown && ( actualValue <= endSeconds ) ){
        [self turnOffStopwatch];
        return;
    }
    
    [self executeStopwatchCount];
    
}

- (void)executeStopwatchCount {
    
    status = BUTTON_STATE_ON;
    theIconImage.image = onImage;
    command.text = [Helper getLocalisedString:@"Scale_Stopwatch_Started" withScalePrefix:NO];
    
    timer = [self createTimer];
    
}

- (void)tick {
    
    if( countdown ){
        
        if( actualValue <= endSeconds ){
            actualValue = endSeconds;
            [self turnOffStopwatch];
        }else{
            actualValue--;
        }
        
    }else{
        
        if( limitedEnd ){
            if( actualValue >= endSeconds ){
                actualValue = endSeconds;
                [self turnOffStopwatch];
            }else{
                actualValue++;
            }
        }else{
            actualValue++;
        }
        
    }
    
    [self calculateScore];
    
}

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(tick)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)turnOffStopwatch {
    
    [timer invalidate];
    theIconImage.image = offImage;
    status = BUTTON_STATE_OFF;
    
    if( actualValue == endSeconds ){
        command.text = [Helper getLocalisedString:@"Scale_Stopwatch_Ended" withScalePrefix:NO];
    }else{
        command.text = [Helper getLocalisedString:@"Scale_Stopwatch_Stopped" withScalePrefix:NO];
    }

}

- (void)drawCompletionCircle {
    
    if( endSeconds < 0 ){
        return;
    }
    
    float progressRadius = self.frame.size.height * 0.4;
    float progressStartAngle = 3 * M_PI / 2;
    float maxValue = endSeconds;
    float minValue = startSeconds;
    if( maxValue ){
        maxValue = startSeconds;
        minValue = endSeconds;
    }
    float percentage_complete = (float)(actualValue - minValue) / (float)(maxValue - minValue);
    float ending_angle = (2 * M_PI * percentage_complete) + progressStartAngle;
    UIColor *arcLineColour = currenTime.textColor;
    
    for (CALayer *layer in self.layer.sublayers) {
        if( layer == progressArc ){
            [layer removeFromSuperlayer];
        }
    }
    
    progressArc = [CAShapeLayer layer];
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(currenTime.center.x, currenTime.center.y) radius:progressRadius startAngle:progressStartAngle endAngle:ending_angle clockwise:YES];
    
    progressArc.path = piePath.CGPath;
    progressArc.fillColor = [UIColor clearColor].CGColor;
    progressArc.strokeColor = arcLineColour.CGColor;
    progressArc.lineWidth = 5;
    progressArc.opacity = 0.5;
    
    [self.layer addSublayer:progressArc];
    
}

/***************************************************************************************************************************
 
 SCORING
 
 ***************************************************************************************************************************/

- (void)calculateScore {
    
    currenTime.text = [NSString stringWithFormat:@"%.0f", actualValue];
    
    [stopwatchDelegate updateItemStopwatch:self]; // ItemStopwatchDelegate calls - (void)updateStopwatchBar:(ItemStopwatch *)theRotator in Question class
    
    [self drawCompletionCircle];
    
    [self determineCutoffCategory];
    
}

- (void)determineCutoffCategory {
    
    if( [diagnosisElements count] > 0 ){
        
        BOOL levelFound = NO;
        float delta = 0.0;
        DiagnosisElement *selectedElement;
        for( DiagnosisElement *dElement in diagnosisElements ){
            if( ( ( actualValue + delta ) > dElement.minScore) && (!levelFound) ){
                selectedElement = dElement;
                levelFound = YES;
            }
        }
        
        currenTime.textColor = selectedElement.colour;
        [self drawCompletionCircle];
        
        if( selectedElement.outputScoreRelevant ){
            score = selectedElement.outputScore;
        }else{
            score = actualValue;
        }
        
    }else{
        
        score = actualValue;
        
    }
    
}

- (void)resetStopwatch {
    
    [timer invalidate];
    
    actualValue = startSeconds;
    [self calculateScore];
    
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
