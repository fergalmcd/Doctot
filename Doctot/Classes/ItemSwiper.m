//
//  ItemSwiper.m
//  Doctot
//
//  Created by Fergal McDonnell on 18/06/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "ItemSwiper.h"
#import "Helper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"

/***************************************************************************************************************************
 
 Sample Setups in ScaleDefinitions.json
 "item0" : { "index": 0, "type": "Swiper", "subtype": "Normal", "defaultScore": -1, "minScore": 0, "maxScore": 100, "startLeftScore": 40, "startRightScore": 90, "singleTapSpaces": 1, "doubleTapSpaces": 10 , "direction": "ascending", "scoreRanges" : { "1 Green": 80, "2 White": 50, "3 Blue": 30 , "4 Red": -1 } },
 "item1" : { "index": 1, "type": "Swiper", "subtype": "Normal", "defaultScore": -1, "minScore": 2.4, "maxScore": 10.3, "startLeftScore": 4.2, "startRightScore": 7.2, "singleTapSpaces": 0.1, "doubleTapSpaces": 1 }
 
 NNB:   If you only want to use individual jumps (e.g. for small scales like 0-5 with unit jumps of 1),
 then set singleTapSpaces & doubleTapSpaces values in scaleDefinition to the same numeric value (e.g. 1)
 
***************************************************************************************************************************/

@implementation ItemSwiper

@synthesize delegate, itemStructure, questionStructure, prefs, index, scaleName, status, actualValue, score, precision, selectedElement, diagnosisElements;
@synthesize heading, contactAreaBackground, contactArea, entireSpan, dialAdjuster, scorePin, scoreBackground, scoreLabel, unitsLabel;
@synthesize startScore, minScore, maxScore, startLeftScore, startRightScore, range, numberOfSegments, distanceInPixelsBetweenUnits, singleTapGapinPixels, doubleTapGapInPixels, fullWidthInPixels, activeWidthInPixels;
@synthesize singleTapGestureRecognizer, doubleTapGestureRecognizer;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

/***************************************************************************************************************************
 
- (void)configureWithItemStructure:(ItemStructure *)theStructure
 
Initial Configuration of the Swiper
 1. Sets the size of the Swiper widget
 2. Sets the attributes as defined in scaleDefinitions.json
 3. Position the main elements of the Swiper
 4. Set up the Contact Area specifically
 5. Make adjustments for assessment/question-specific Swipers
 
***************************************************************************************************************************/

- (void)configureWithItemStructure:(ItemStructure *)theStructure {
    
    prefs = [NSUserDefaults standardUserDefaults];
    itemStructure = theStructure;
    index = itemStructure.index;
    
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    self.frame = CGRectMake(0, (index * SWIPER_HEIGHT), questionDimensions.width, SWIPER_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] ){
        
        // Setup the dementsions of the Swiper (gathered from the scaleDefinitions.json settings via itemStructure [ItemStructure])
        [self defineDementions];
        
        // UI initialisation of all elements
        [self configureElementPositioning];
        
        // Setup the UI elements of the Contact Area (contentSize, canvas view, line markers, numeric labels)
        [self configureContactArea];
        
        // Setup dial adjuster
        [self configureDialAdjuster];
        
        [self makeQuestionSpecificAdjustmentsPostSetup];
        
    }
    
}


/***************************************************************************************************************************
 
 - (void)defineDementions
 
Defines numeric values for the Swiper Contact Area
 
 status: not particulary relevant to Swiper
 score:                         defaultScore (if -1, that means that the user will have to interact with the Swiper to set a score)
 minScore:                      the lower end score ; itemStructure.offScore
 maxScore:                      the upper end score ; itemStructure.onScore;
 startLeftScore:                initial window presented on the Swiper (left hand value) ; itemStructure.startLeftScore
 startRightScore:               initial window presented on the Swiper (right hand value) ; itemStructure.startRightScore
 precision:                     allows decimals to be supported using itemStructure.singleTapSpaces (e.g. if itemStructure.singleTapSpaces = 0.01, precision = 2)
 startScore:                    initial positioning of the Swiper pin point, midpoint between startLeftScore and startRightScore
 range:                         span from the lowest possible score to the largest, difference between maxScore - minScore
 numberOfSegments:              uses a combination of range and precision to determine the number of segments on the Swiper ruler
 distanceInPixelsBetweenUnits:  number of pixels between each unit (width)
 singleTapGapinPixels:          number of pixels between each singleTapSpaces gap (width)
 doubleTapGapInPixels:          number of pixels between each doubleTapSpaces gap (width)
 activeWidthInPixels:           number of pixels from entire range of Swiper, 'active' does not count the run-off areas at start & end (width)
 fullWidthInPixels:             number of pixels from entire span view, 'full' does count the run-off areas at start & end (width)
 
 NNB:   If you only want to use individual jumps (e.g. for small scales like 0-5 with unit jumps of 1),
 then set singleTapSpaces & doubleTapSpaces values in scaleDefinition to the same numeric value (e.g. 1)
 
***************************************************************************************************************************/

- (void)defineDementions {
    
    status = BUTTON_STATE_DEFAULT;
    score = itemStructure.defaultScore;

    minScore = itemStructure.offScore;
    maxScore = itemStructure.onScore;
    startLeftScore = itemStructure.startLeftScore;
    startRightScore = itemStructure.startRightScore;
    
    
    // Score Precision ///////////////////////////////////////////////////////////////////////////////////////////
    if( itemStructure.singleTapSpaces < 0.1 ){
        precision = 2;
    }else{
        if( itemStructure.singleTapSpaces < 1 ){
            precision = 1;
        }else{
            precision = 0;
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // Derived Attributes ////////////////////////////////////////////////////////////////////////////////////////
    startScore = startLeftScore + fabsf( ( ( startRightScore - startLeftScore ) / 2 ) );
    //score = startScore;
    range = maxScore - minScore;
    numberOfSegments = range * powf(10, precision);
    distanceInPixelsBetweenUnits = fabsf( self.frame.size.width / ( itemStructure.startRightScore - itemStructure.startLeftScore ) );
    singleTapGapinPixels = distanceInPixelsBetweenUnits * itemStructure.singleTapSpaces;
    doubleTapGapInPixels = distanceInPixelsBetweenUnits * itemStructure.doubleTapSpaces;
    activeWidthInPixels = numberOfSegments * distanceInPixelsBetweenUnits;
    fullWidthInPixels = activeWidthInPixels + self.frame.size.width + (fabsf(minScore) * numberOfSegments * distanceInPixelsBetweenUnits);
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
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
        
        [diagnosisElements addObject:diagnosisElement];
    }
    
    diagnosisElements = [Helper sortedArray:diagnosisElements byIndex:@"index" andAscending:YES];
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // Check for Invalid Settings ////////////////////////////////////////////////////////////////////////////////
    NSString *anError = @"";
    if( minScore >= maxScore ){
        anError = [anError stringByAppendingString:@"The minimum score is not smaller than the maximum score"];
    }
    if( startLeftScore >= startRightScore ){
        anError = [anError stringByAppendingString:@"The left-side score is not smaller than the right-side score"];
    }
    if( minScore >= startLeftScore ){
        anError = [anError stringByAppendingString:@"The minimum score is not smaller than the left-side score"];
    }
    if( startRightScore >= maxScore ){
        anError = [anError stringByAppendingString:@"The right-side score is not smaller than the maximum score"];
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self makeQuestionSpecificAdjustmentsPreSetup];
    
}


/***************************************************************************************************************************
 
- (void)configureElementPositioning
 
Elements Layout for Swiper
1. heading label
2. contactAreaBackground & contactArea
     contactArea frame matches contactAreaBackground frame
     contactArea is the UIScrollview which does the heavy lifting
3. scorePin
4. dialAdjuster
5. scoreBackground & scoreLabel & unitsLabel
     scoreBackground is a rectangle image (2:1), centred underneath the dialAdjuster
     scoreLabel is full width of Swiper & centred text, same height as scoreBackground
     unitsLabel is full width of Swiper & centred text, 1/3 height of scoreBackground and fixed to the bottom of scoreBackground
 
***************************************************************************************************************************/

- (void)configureElementPositioning {
    
    NSString *itemReference = [NSString stringWithFormat:@"%@_Q%li_Item%li", scaleName, questionStructure.index, index];
    
    // Initialisation of Objects
    heading = [[UILabel alloc] init];
    contactAreaBackground = [[UIImageView alloc] init];
    contactArea = [[UIScrollView alloc] init];
    entireSpan = [[UIView alloc] init];
    dialAdjuster = [[UIView alloc] init];
    scorePin = [[UIImageView alloc] init];
    scoreBackground = [[UIImageView alloc] init];
    scoreLabel = [[UILabel alloc] init];
    unitsLabel = [[UILabel alloc] init];
    
    float basicBlockHeight = self.frame.size.height / SWIPER_VERTICAL_BLOCKS;
    
    // 1. headingLabel
    float headingHeight = basicBlockHeight * 2;   // 2 Blocks High
    heading.frame = CGRectMake(0, 0, self.frame.size.width, headingHeight);
    
    heading.text = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Heading", itemReference] withScalePrefix:NO];
    heading.textColor = [UIColor whiteColor];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    // 2. scoreBackground & scoreLabel & unitsLabel
    float scoreBackgroundHeight = basicBlockHeight * 4;     // 2 Blocks High
    scoreLabel.frame = CGRectMake(0, (heading.frame.origin.y + heading.frame.size.height), self.frame.size.width, scoreBackgroundHeight);
    scoreLabel.text = @"-";
    scoreLabel.textColor = [UIColor blackColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:36.0];
    
    scoreBackground.frame = CGRectMake( ((self.frame.size.width - (scoreBackgroundHeight * 2)) / 2), scoreLabel.frame.origin.y, (scoreBackgroundHeight * 2), scoreBackgroundHeight);
    scoreBackground.image = [UIImage imageNamed:@"swiperScoreBackground"];
    
    float unitLabelHeight = basicBlockHeight * 1;
    unitsLabel.frame = CGRectMake( scoreLabel.frame.origin.x, (scoreLabel.frame.origin.y + scoreLabel.frame.size.height - unitLabelHeight), scoreLabel.frame.size.width, unitLabelHeight);
    unitsLabel.text = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Units", itemReference] withScalePrefix:NO];
    unitsLabel.textColor = [UIColor blackColor];
    unitsLabel.textAlignment = NSTextAlignmentCenter;
    unitsLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    // 3. contactAreaBackground & contactArea
    float contactAreaHeight = basicBlockHeight * 5;   // 5 Blocks High
    contactAreaBackground.frame = CGRectMake(0, (scoreBackground.frame.origin.y + scoreBackground.frame.size.height + basicBlockHeight), self.frame.size.width, contactAreaHeight);
    contactAreaBackground.backgroundColor = [UIColor whiteColor];
    [contactArea setShowsHorizontalScrollIndicator:NO];
    [contactArea setShowsVerticalScrollIndicator:NO];
    
    contactArea.frame = CGRectMake( contactAreaBackground.frame.origin.x, contactAreaBackground.frame.origin.y, contactAreaBackground.frame.size.width, contactAreaBackground.frame.size.height);
    
    // 4. scorePin
    scorePin.frame = CGRectMake(0, 0, 25, 75);
    scorePin.center = self.center;
    scorePin.frame = CGRectMake(scorePin.frame.origin.x, (contactArea.frame.origin.y + contactArea.frame.size.height - (scorePin.frame.size.height * 0.9)), scorePin.frame.size.width, scorePin.frame.size.height);
    scorePin.image = [UIImage imageNamed:@"swiperScorePin.png"];
    
    // 5. Dial Adjuster
    float dialAdjusterHeight = basicBlockHeight * 2;   // 2 Blocks High
    dialAdjuster.frame = CGRectMake(0, (contactArea.frame.origin.y + contactArea.frame.size.height), self.frame.size.width, dialAdjusterHeight);
    dialAdjuster.backgroundColor = [UIColor clearColor];
    
    // Add the elements in the correct order
    [self addSubview:heading];
    [self addSubview:contactAreaBackground];
    [self addSubview:contactArea];
    [self addSubview:scoreBackground];
    [self addSubview:dialAdjuster];
    [self addSubview:scorePin];
    [self addSubview:scoreLabel];
    [self addSubview:unitsLabel];
    
}


/***************************************************************************************************************************
 
- (void)configureContactArea
 
***************************************************************************************************************************/

- (void)configureContactArea {
    
    contactArea.delegate = self;
    contactArea.contentSize = CGSizeMake(fullWidthInPixels, contactArea.frame.size.height);
    entireSpan.frame = CGRectMake(0, 0, fullWidthInPixels, contactArea.frame.size.height);
    entireSpan.backgroundColor = [UIColor clearColor];
    [contactArea addSubview:entireSpan];
    contactArea.contentOffset = CGPointMake( ((score * distanceInPixelsBetweenUnits) + (self.frame.size.width)), 0);
    
    // Configure the markers and numeric labels
    
    float unitMarkerHeight = 10, unitMarkerThickness = 3;
    float milestoneMarkerHeight = 25, milestoneMarkerThickness = 5;
    UIImageView *unitTopMarker, *unitBottomMarker;
    UIImageView *milestoneTopMarker, *milestoneBottomMarker;
    UILabel *numericLabel;
    
    float adjustmentForMinScore = 0.0;
    if( minScore > 0 ){
        adjustmentForMinScore = minScore * powf(10, precision);
    }
    
    for( int i = 0; i <= numberOfSegments; i++){
        
        float centreXPosition = (self.frame.size.width / 2) + ( (i + adjustmentForMinScore) * singleTapGapinPixels);
        
        unitTopMarker = [[UIImageView alloc] initWithFrame:CGRectMake( (centreXPosition - (unitMarkerThickness / 2)), 0, unitMarkerThickness, unitMarkerHeight)];
        unitBottomMarker = [[UIImageView alloc] initWithFrame:CGRectMake( unitTopMarker.frame.origin.x, (entireSpan.frame.size.height - unitMarkerHeight), unitMarkerThickness, unitMarkerHeight)];
        milestoneTopMarker = [[UIImageView alloc] initWithFrame:CGRectMake( (centreXPosition - (milestoneMarkerThickness / 2)), 0, milestoneMarkerThickness, milestoneMarkerHeight)];
        milestoneBottomMarker = [[UIImageView alloc] initWithFrame:CGRectMake( milestoneTopMarker.frame.origin.x, (entireSpan.frame.size.height - milestoneMarkerHeight), milestoneMarkerThickness, milestoneMarkerHeight)];
        
        unitTopMarker.backgroundColor = [UIColor blackColor];
        unitBottomMarker.backgroundColor = [UIColor blackColor];
        milestoneTopMarker.backgroundColor = [UIColor blackColor];
        milestoneBottomMarker.backgroundColor = [UIColor blackColor];
        
        numericLabel = [[UILabel alloc] initWithFrame:CGRectMake( (centreXPosition - (distanceInPixelsBetweenUnits / 2)),
                                                                 (entireSpan.frame.size.height / 3),
                                                                 distanceInPixelsBetweenUnits,
                                                                 (entireSpan.frame.size.height / 3))];
        numericLabel.text = [NSString stringWithFormat:[self ourPrecision], (minScore + (i * itemStructure.singleTapSpaces))];
        numericLabel.textColor = [UIColor blackColor];
        numericLabel.textAlignment = NSTextAlignmentCenter;
        numericLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        //if( fmodf((float)i, (itemStructure.doubleTapSpaces * powf(10, precision))) == 0 ){
        if( [[numericLabel.text substringFromIndex:([numericLabel.text length] - 1)] isEqualToString:@"0"] ){
            [entireSpan addSubview:milestoneTopMarker];
            if( numericLabel.intrinsicContentSize.width > distanceInPixelsBetweenUnits ){
                numericLabel.frame = CGRectMake( ( numericLabel.frame.origin.x - ((numericLabel.intrinsicContentSize.width - distanceInPixelsBetweenUnits) / 2) ),
                                                numericLabel.frame.origin.y,
                                                numericLabel.intrinsicContentSize.width,
                                                numericLabel.frame.size.height);
            }
            [entireSpan addSubview:numericLabel];
            [entireSpan addSubview:milestoneBottomMarker];
        }else{
            [entireSpan addSubview:unitTopMarker];
            numericLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
            if( singleTapGapinPixels > (3 * numericLabel.intrinsicContentSize.width) ){
                [entireSpan addSubview:numericLabel];
            }
            [entireSpan addSubview:unitBottomMarker];
        }
    }
    
    // Tap Gestures
    
    // Single Tap
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectContactAreaTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [contactArea addGestureRecognizer:singleTapGestureRecognizer];
    
    // Double Tap
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectContactAreaTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.enabled = YES;
    doubleTapGestureRecognizer.cancelsTouchesInView = NO;
    [contactArea addGestureRecognizer:doubleTapGestureRecognizer];
    
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    // Set the initial pin position
    float offsetPosition;
    if( startScore < 0 ){
        offsetPosition = (distanceInPixelsBetweenUnits * (startScore - minScore));
    }else{
        offsetPosition = (distanceInPixelsBetweenUnits * startScore);
    }
    contactArea.contentOffset = CGPointMake(offsetPosition, 0);
    [self snapToNearestUnit:contactArea.contentOffset.x];
    
}


/***************************************************************************************************************************
 
 - (void)configureDialAdjuster
 
 ***************************************************************************************************************************/

- (void)configureDialAdjuster {
    
    UITapGestureRecognizer *dialAdjusterGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateScoreFromDialAdjuster:)];
    dialAdjusterGestureRecognizer.numberOfTapsRequired = 1;
    dialAdjusterGestureRecognizer.enabled = YES;
    dialAdjusterGestureRecognizer.cancelsTouchesInView = NO;
    [dialAdjuster addGestureRecognizer:dialAdjusterGestureRecognizer];
    
    int numberOfDialAdjusterMarkers = 5;
    UILabel *dialMarker;
    for(int i = 0; i <= numberOfDialAdjusterMarkers; i++){
        float seperationDistance = dialAdjuster.frame.size.width / numberOfDialAdjusterMarkers;
        float markerPosition = i * seperationDistance;
        float markerValue = minScore + ( i * ( (maxScore - minScore) / numberOfDialAdjusterMarkers ) );
        
        dialMarker = [[UILabel alloc] initWithFrame:CGRectMake( markerPosition, 0, seperationDistance, dialAdjuster.frame.size.height)];
        if( i == numberOfDialAdjusterMarkers ){
            dialMarker = [[UILabel alloc] initWithFrame:CGRectMake( (dialAdjuster.frame.size.width - seperationDistance) , dialMarker.frame.origin.y, dialMarker.frame.size.width, dialMarker.frame.size.height)];
            dialMarker.textAlignment = NSTextAlignmentRight;
        }
        
        dialMarker.text = [NSString stringWithFormat:[self ourPrecision], markerValue];
        dialMarker.textColor = [UIColor lightGrayColor];
        dialMarker.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        [dialAdjuster addSubview:dialMarker];
    }
    
}

- (void)updateScoreFromDialAdjuster:(UITapGestureRecognizer *)gesture {

    CGPoint position = [gesture locationInView:self];
    float percentageXTap = position.x / dialAdjuster.frame.size.width;
    float dialadjustedScore = minScore + ((maxScore - minScore) * percentageXTap);
    
    [self forceScoreTo:dialadjustedScore];

}


/***************************************************************************************************************************
 
SCORING
 
***************************************************************************************************************************/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self setScoreTo:scrollView.contentOffset.x withSnap:NO];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self setScoreTo:scrollView.contentOffset.x withSnap:YES];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self setScoreTo:scrollView.contentOffset.x withSnap:YES];
    
}

- (void)detectContactAreaTap:(UITapGestureRecognizer *)gesture {
    
    CGPoint position = [gesture locationInView:self];
    NSString *adjustmentDirection;
    float newXPosition = 0.0;
    float adjustmentAmount = 0.0;
    
    if( position.x <= (self.frame.size.width / 2) ){
        adjustmentDirection = @"DOWN";
    }else{
        adjustmentDirection = @"UP";
    }
    
    if( gesture == singleTapGestureRecognizer ){
        if( [adjustmentDirection isEqualToString:@"DOWN"] ){
            adjustmentAmount = (distanceInPixelsBetweenUnits * itemStructure.singleTapSpaces) * -1;
        }
        if( [adjustmentDirection isEqualToString:@"UP"] ){
            adjustmentAmount = (distanceInPixelsBetweenUnits * itemStructure.singleTapSpaces) * 1;
        }
    }
    
    if( gesture == doubleTapGestureRecognizer ){
        if( [adjustmentDirection isEqualToString:@"DOWN"] ){
            adjustmentAmount = (distanceInPixelsBetweenUnits * itemStructure.doubleTapSpaces) * -1;
        }
        if( [adjustmentDirection isEqualToString:@"UP"] ){
            adjustmentAmount = (distanceInPixelsBetweenUnits * itemStructure.doubleTapSpaces) * 1;
        }
    }
    
    // Animate
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    newXPosition = contactArea.contentOffset.x + adjustmentAmount;
    contactArea.contentOffset = CGPointMake( newXPosition, contactArea.contentOffset.y);
    
    [UIView commitAnimations];
    
}

- (void)setScoreTo:(float)newScrollPosition withSnap:(BOOL)snap {
    
    if( snap ){
        [self snapToNearestUnit:newScrollPosition];
    }
    
    score = contactArea.contentOffset.x / distanceInPixelsBetweenUnits;
    
    // Min and Max adjustments for 2 scenarios of minScore >= 0 and minScore is negative ///////////////////////////////////////////
    
    float adjustedXPositionMin = 0.0;
    float adjustedXPositionMax = 0.0;
    
    if( minScore < 0 ){
        score = minScore + (contactArea.contentOffset.x / distanceInPixelsBetweenUnits);
        adjustedXPositionMin = 0.0 * distanceInPixelsBetweenUnits;
        adjustedXPositionMax = range * distanceInPixelsBetweenUnits;
    }else{
        adjustedXPositionMin = minScore * distanceInPixelsBetweenUnits;
        adjustedXPositionMax = maxScore * distanceInPixelsBetweenUnits;
    }
    
    if( score < minScore ){
        score = minScore;
        contactArea.contentOffset = CGPointMake( adjustedXPositionMin, contactArea.contentOffset.y);
    }
    
    if( score > maxScore ){
        score = maxScore;
        contactArea.contentOffset = CGPointMake( adjustedXPositionMax, contactArea.contentOffset.y);
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    scoreLabel.text = [NSString stringWithFormat:[self ourPrecision], score];
    [self determineCutoffCategory];
    
    [delegate updateItemSwiper:self];
    
}

- (void)forceScoreTo:(float)newScore {
    
    float offsetPosition;
    offsetPosition = (distanceInPixelsBetweenUnits * newScore);
    contactArea.contentOffset = CGPointMake(offsetPosition, 0);
    
    score = newScore;
    scoreLabel.text = [NSString stringWithFormat:[self ourPrecision], score];
    [self determineCutoffCategory];
    
}

- (void)snapToNearestUnit:(float)unadjustedScrollPosition {
    
    float roughScore = (contactArea.contentOffset.x / distanceInPixelsBetweenUnits);
    roughScore *= powf(10, precision);
    float roundedScore = roundf( roughScore ) / powf(10, precision);
    float roundedPosition = roundedScore * distanceInPixelsBetweenUnits;
    contactArea.contentOffset = CGPointMake(roundedPosition, 0);
    
}

- (void)determineCutoffCategory {
    
    if( [diagnosisElements count] > 0 ){
        
        BOOL levelFound = NO;
        float delta = 0.5 / powf(10, itemStructure.precision);
        
        for( DiagnosisElement *dElement in diagnosisElements ){
            if( ( (score + delta) > dElement.minScore) && (!levelFound) ){
                selectedElement = dElement;
                levelFound = YES;
            }
        }
        
        scoreLabel.textColor = selectedElement.colour;
        
    }
    
}

- (NSString *)ourPrecision {
    return [NSString stringWithFormat:@"%%.%lif", precision];
}

- (void)resetSwiper {

    score = itemStructure.defaultScore;
    actualValue = score;
    
    scoreLabel.text = @"-";
    
}

/***************************************************************************************************************************
 
 Scale Specific methods
 
 ***************************************************************************************************************************/

-(void)makeQuestionSpecificAdjustmentsPreSetup {
    
    if( [scaleName isEqualToString:@"CACH"] ){
        
        NSString *currentCalciumUnits = [prefs objectForKey:@"cachCalciumUnits"];
        NSString *currentAlbuminUnits = [prefs objectForKey:@"cachAlbuminUnits"];
        
        if( questionStructure.index == 1 ){
            if( ( index == 0 ) && ( [currentCalciumUnits isEqualToString:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice1" withScalePrefix:NO]]  ) ){
                self.hidden = YES;
            }
            if( ( index == 1 ) && ( [currentCalciumUnits isEqualToString:[Helper getLocalisedString:@"Settings_CACH_CalciumUnits_Choice0" withScalePrefix:NO]]  ) ){
                self.hidden = YES;
            }
        }
        
        if( ( questionStructure.index == 2 ) || ( questionStructure.index == 3 ) ){
            if( ( index == 0 ) && ( [currentAlbuminUnits isEqualToString:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice1" withScalePrefix:NO]]  ) ){
                self.hidden = YES;
            }
            if( ( index == 1 ) && ( [currentAlbuminUnits isEqualToString:[Helper getLocalisedString:@"Settings_CACH_AlbuminUnits_Choice0" withScalePrefix:NO]]  ) ){
                self.hidden = YES;
            }
        }
        
    }
    
}

- (void)makeQuestionSpecificAdjustmentsPostSetup {
        
    if( [scaleName isEqualToString:@"CACH"] ){
        
        CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
        self.frame = CGRectMake(0, 0, questionDimensions.width, SWIPER_HEIGHT);
        scoreLabel.text = @"-";
        
        NSString *unitsReference;
        if( questionStructure.index == 1 ){
            unitsReference = [NSString stringWithFormat:@"Settings_CACH_CalciumUnits_Choice%li", index];
        }
        if( ( questionStructure.index == 2 ) || ( questionStructure.index == 3 ) ){
            unitsReference = [NSString stringWithFormat:@"Settings_CACH_AlbuminUnits_Choice%li", index];
        }
        unitsLabel.text = [Helper getLocalisedString:unitsReference withScalePrefix:NO];
        
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
