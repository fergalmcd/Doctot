//
//  ItemEnergyBar.m
//  Doctot
//
//  Created by Fergal McDonnell on 10/07/2018.
//  Copyright Doctot 2018. All rights reserved.
//
//

#import "ItemEnergyBar.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Constants.h"

@implementation ItemEnergyBar

@synthesize energyBarDelegate, itemStructure, questionStructure, index, scaleName, status, actualValue, score, diagnosisElements, itemReference;
@synthesize type, minScore, maxScore, defaultPosition, precision, groupSize;
@synthesize heading, scrollView, backgroundImage, theGrip, displayValueBackground, displayValue, displayInterpreation, singleTapGestureRecognizer, scrollableContentRange, scrollableHeight;

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
    self.frame = CGRectMake( ((questionDimensions.width / itemStructure.groupSize) * index), 0, (questionDimensions.width / itemStructure.groupSize), itemStructure.height);
    self.backgroundColor = [UIColor clearColor];
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] ){
        
        // Setup the dementsions of the EnergyBar (gathered from the scaleDefinitions.json settings via itemStructure [ItemStructure])
        [self defineDementions];
        
        // UI initialisation of all elements
        [self configureInterface];
     
        [self makeQuestionSpecificAdjustments];
    }
    
}

/***************************************************************************************************************************
 
 - (void)defineDementions
 
 ***************************************************************************************************************************/

- (void)defineDementions {
    
    type = itemStructure.subtype;
    minScore = itemStructure.offScore;
    maxScore = itemStructure.onScore;
    defaultPosition = itemStructure.defaultPosition;
    precision = [Helper printPrecision:itemStructure.precision];
    groupSize = itemStructure.groupSize;
    
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
    score = itemStructure.defaultScore;
    
    heading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
    heading.text = [Helper getLocalisedString:itemReference withScalePrefix:NO];
    heading.textColor = [UIColor whiteColor];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.backgroundColor = [UIColor clearColor];
    heading.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height * ENERGYBAR_SCROLL_HEIGHT_RATIO) )];
    scrollView.delegate = self;
    
    scrollableHeight = self.frame.size.height - (2 * ENERGYBAR_GRIP_HEIGHT);
    scrollableContentRange = (scrollView.frame.size.height * 2) - ENERGYBAR_GRIP_HEIGHT;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, scrollableContentRange);
    
    // Single Tap
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectScrollViewTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake( ((self.frame.size.width - itemStructure.width) / 2), scrollView.frame.origin.y, itemStructure.width, scrollView.frame.size.height)];
    if( [itemStructure.backgroundImageName length] > 0 ){
        backgroundImage.image = [UIImage imageNamed:itemStructure.backgroundImageName];
    }else{
        backgroundImage.image = [UIImage imageNamed:@""];
    }
    
    theGrip = [[UIImageView alloc] initWithFrame:CGRectMake(0, (scrollView.frame.size.height - ENERGYBAR_GRIP_HEIGHT), scrollView.frame.size.width, scrollView.frame.size.height)];
    if( [itemStructure.backgroundImageName length] > 0 ){
        theGrip.image = [UIImage imageNamed:itemStructure.gripImageName];
    }else{
        theGrip.image = [UIImage imageNamed:@"energybar_grip.png"];
    }
    // Circle portion of the grip
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    float gripDiametre = ENERGYBAR_GRIP_HEIGHT * 0.66;
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake( (theGrip.frame.size.width - gripDiametre), 0, gripDiametre, gripDiametre)] CGPath]];
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.lineWidth = 1;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    [theGrip.layer addSublayer:circleLayer];
    // Line portion of the grip
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    [lineLayer setPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, (gripDiametre / 2), theGrip.frame.size.width - gripDiametre, 1)] CGPath]];
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.lineWidth = 1;
    lineLayer.fillColor = [UIColor whiteColor].CGColor;
    [theGrip.layer addSublayer:lineLayer];
    
    displayValue = [[UILabel alloc] initWithFrame:CGRectMake(0, ( scrollView.frame.origin.y + scrollView.frame.size.height ), self.frame.size.width, ( ((1 - ENERGYBAR_SCROLL_HEIGHT_RATIO) / 2) * self.frame.size.height ) )];
    displayValue.text = @"-";
    displayValue.textColor = [UIColor whiteColor];
    displayValue.textAlignment = NSTextAlignmentCenter;
    displayValue.backgroundColor = [UIColor clearColor];
    displayValue.font = [UIFont fontWithName:@"Helvetica" size:ENERGYBAR_DISPLAYVALUE_FONT];
    
    displayValueBackground = [[UIView alloc] initWithFrame:CGRectMake( (displayValue.frame.size.width / 3), displayValue.frame.origin.y, (displayValue.frame.size.width / 3), displayValue.frame.size.height)];
    displayValueBackground.layer.cornerRadius = displayValueBackground.frame.size.height / 2;
    displayValueBackground.backgroundColor = [Helper getBackgroundColourForText:displayValue.textColor givenBackground:@"Dark"];
    
    displayInterpreation = [[UILabel alloc] initWithFrame:CGRectMake(0, (displayValue.frame.origin.y + displayValue.frame.size.height), self.frame.size.width, ( self.frame.size.height - ( displayValue.frame.origin.y + displayValue.frame.size.height ) ) )];
    displayInterpreation.text = @"";
    displayInterpreation.textColor = [UIColor whiteColor];
    displayInterpreation.textAlignment = NSTextAlignmentCenter;
    displayInterpreation.backgroundColor = [UIColor clearColor];
    displayInterpreation.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    [self addSubview:heading];
    [self addSubview:backgroundImage];
    [scrollView addSubview:theGrip];
    [self addSubview:scrollView];
    [self addSubview:displayValueBackground];
    [self addSubview:displayValue];
    [self addSubview:displayInterpreation];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    if( [itemStructure.backgroundImageName length] == 0 ){
     
        [self generateBackgroundVisual];
        
    }
    
}

- (void)generateBackgroundVisual {
    
    float paddingAtTop = 15;
    float paddingAtBottom = 25;
    float paddingAtLeft = 40;
    float paddingAtRight = 40;
    float bottomFlatnessFactor = 2.0;   // Determines how flat the bottom of the shape should be. Relates to the width of the top compared to the base, so the higher the value, the flatter/wider the base. (For a Point at the base (i.e. triangle), then bottomFlatnessFactor = 1.0)
    
    float numberOfLines = scrollView.frame.size.height - ( paddingAtTop + paddingAtBottom );
    float adjustedWidth = scrollView.frame.size.width - ( paddingAtLeft + paddingAtRight );
    float deltaDropToNextLine = (numberOfLines / adjustedWidth) / 2;
    float deltaMoveInEachLine = (adjustedWidth/ numberOfLines) / 2;
    CGFloat redComponent, greenComponent, blueComponent;
    UIColor *fadingColour;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for( int i = 0; i < numberOfLines; i++ ){
        
        if( ( i % (int)(numberOfLines / maxScore) ) > 1 ){
            redComponent = ((numberOfLines - i) * deltaDropToNextLine) / 255.0; // Red goes from full to zero
            greenComponent = ((i * deltaDropToNextLine) / 1.0) / 255.0; // Green goes from zero to half full
            blueComponent = 0.0; // Blue is always zero
        }else{
            // White marker lines
            redComponent = 255.0;
            greenComponent = 255.0;
            blueComponent = 255.0;
        }
        fadingColour = [UIColor colorWithRed:redComponent green:greenComponent blue:blueComponent alpha:0.75];
        CGContextSetStrokeColorWithColor(context, fadingColour.CGColor);
        
        CGPoint startPoint = CGPointMake( ( paddingAtLeft + (i * (deltaMoveInEachLine / bottomFlatnessFactor)) ), (paddingAtTop + i) );
        CGPoint endPoint = CGPointMake( ( ( paddingAtLeft + adjustedWidth - (i * (deltaMoveInEachLine / bottomFlatnessFactor))) ), (paddingAtTop + i) );
        
        CGContextSetLineWidth(context, deltaDropToNextLine);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y ); // Start at this point
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y ); // Draws to this point
        
        CGContextStrokePath(context);
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self calculateScore];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self snapToNearestUnit];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self snapToNearestUnit];
}

- (void)detectScrollViewTap:(UITapGestureRecognizer *)gesture {
    
    CGPoint position = [gesture locationInView:self];
    
    float reversedPointTapped = scrollableHeight - position.y;
    if( reversedPointTapped < 0 ){
        reversedPointTapped = 0;
    }
    if( reversedPointTapped > scrollableHeight ){
        reversedPointTapped = scrollableHeight;
    }
    scrollView.contentOffset = CGPointMake(0, reversedPointTapped);
    
    [self calculateScore];
    
    [self snapToNearestUnit];

}

- (void)resetEnergyBar {
    
}

/***************************************************************************************************************************
 
 SCORING
 
 ***************************************************************************************************************************/

- (void)calculateScore {
    
    float rangeInPixels = scrollView.frame.size.height - ENERGYBAR_GRIP_HEIGHT;
    actualValue = (scrollView.contentOffset.y / rangeInPixels) * maxScore;
    
    if( ( actualValue <= maxScore ) && ( actualValue >= minScore ) ){
        
        displayValue.text = [NSString stringWithFormat:precision, actualValue];
        displayValue.text = [displayValue.text stringByAppendingFormat:@" %@", [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Units", itemReference] withScalePrefix:NO]];
        displayValue.font = [UIFont fontWithName:@"Helvetica" size:ENERGYBAR_DISPLAYVALUE_FONT];
        displayValueBackground.backgroundColor = [Helper getBackgroundColourForText:displayValue.textColor givenBackground:@"Dark"];
        
    }else{
        
        if( actualValue > maxScore ){
            displayValue.font = [UIFont fontWithName:@"Helvetica" size:ENERGYBAR_DISPLAYVALUE_FONT + (2 * fabsf(actualValue - maxScore))];
        }else{
            displayValue.font = [UIFont fontWithName:@"Helvetica" size:ENERGYBAR_DISPLAYVALUE_FONT + (2 * fabsf(actualValue - minScore))];
        }
        
    }
    
    [self determineCutoffCategory];
    
    [energyBarDelegate updateItemEnergyBar:self]; // ItemEnergyBarDelegate calls - (void)updateItemEnergyBar:(ItemEnergyBar *)theEnergyBar in Question class
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
    
    NSString *reference = [NSString stringWithFormat:@"%@_Score%.0f", itemReference, score];
    displayInterpreation.text = [Helper getLocalisedString:reference withScalePrefix:NO];
    
}

- (void)snapToNearestUnit {
    
    float rangeInPixels = scrollView.frame.size.height - ENERGYBAR_GRIP_HEIGHT;
    float snapYPosition = ([displayValue.text floatValue] * rangeInPixels) / maxScore;
    
    [scrollView setContentOffset:CGPointMake(0, snapYPosition)];
    
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


@end
