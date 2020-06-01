//
//  ItemSlider.m
//  Doctot
//
//  Created by Fergal McDonnell on 26/05/2017.
//  Copyright Doctot 2017. All rights reserved.
//

#import "ItemSlider.h"
#import "Helper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"


@implementation ItemSlider

@synthesize itemStructure, questionStructure, index, scaleName, status, actualValue, score, precision, showScore;
@synthesize valueBackground, valueTitleLabel, valueLabel, scoreBackground, scoreTitleLabel, scoreLabel, pointerBackground, markerLabels, sliderTitles, diagnosisElements;
@synthesize scoreFontSize;
@synthesize catSmall, catLarge;

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
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] || [itemStructure.subtype isEqualToString:@"Multiple"] ){
        
        status = BUTTON_STATE_DEFAULT;
        score = itemStructure.defaultScore;
        actualValue = score;
        self.value = score;
        self.minimumValue = itemStructure.offScore;
        self.maximumValue = itemStructure.onScore;
        [self addTarget:self action:@selector(updateState) forControlEvents:UIControlEventValueChanged];
        
        //"COM_Q1_Item0" = "FEV1 %|GOLD Grade";
        NSString *itemReference = [NSString stringWithFormat:@"%@_Q%li_Item%li", scaleName, questionStructure.index, index];
        NSString *itemSetupData = [Helper getLocalisedString:itemReference withScalePrefix:NO];
        sliderTitles = [itemSetupData componentsSeparatedByString:@"|"];
        
        NSInteger numberOfOutputs = [sliderTitles count];
        
        scoreBackground = [[UIImageView alloc] init];
        valueBackground = [[UIImageView alloc] init];
        pointerBackground = [[UIImageView alloc] init];
        scoreLabel = [[UILabel alloc] init];
        valueLabel = [[UILabel alloc] init];
        scoreTitleLabel = [[UILabel alloc] init];
        valueTitleLabel = [[UILabel alloc] init];
        
        valueTitleLabel.text = (NSString *)[sliderTitles objectAtIndex:0];
        if( numberOfOutputs >= 2 ){
            scoreTitleLabel.text = (NSString *)[sliderTitles objectAtIndex:1];
        }
        
        // Positioning //////////////////////////////////
        
        float valueBackgroundHeight = 0.0;
        if( [itemStructure.subtype isEqualToString:@"Normal"] ){
            valueBackgroundHeight = ((2 * SLIDER_Y_OFFSET) / 3);
            scoreFontSize = 36.0;
        }
        if( [itemStructure.subtype isEqualToString:@"Multiple"] ){
            valueBackgroundHeight = ((2 * SLIDER_Y_OFFSET) / 5);
            scoreFontSize = 24.0;
        }
        
        // Background Images
        CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
        self.frame = CGRectMake(SLIDER_X_OFFSET, (SLIDER_Y_OFFSET + (SLIDER_HEIGHT * index)), (questionDimensions.width - (numberOfOutputs * SLIDER_X_OFFSET)), self.frame.size.height);
        [self setMaximumTrackImage:[UIImage imageNamed:@"slider_track.png"] forState:UIControlStateNormal];
        [self setMinimumTrackImage:[UIImage imageNamed:@"slider_track.png"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"slider_thumb.png"] forState:UIControlStateNormal];
        
        valueBackground.frame = CGRectMake(self.frame.origin.x, ((self.frame.origin.y * -1) + (SLIDER_HEIGHT * index)) + SLIDER_Y_OFFSET_VALUELABEL , self.frame.size.width / numberOfOutputs, valueBackgroundHeight);
        scoreBackground.frame = CGRectMake(valueBackground.frame.size.width, valueBackground.frame.origin.y, self.frame.size.width / numberOfOutputs, valueBackground.frame.size.height);
        pointerBackground.frame = CGRectMake(valueBackground.frame.size.width - 6.25, valueBackground.frame.origin.y + (valueBackground.frame.size.height / 2) - 12.5, 25, 25);
        scoreBackground.contentMode = UIViewContentModeScaleAspectFit;
        [scoreBackground setImage:[UIImage imageNamed:@"slider_score.png"]];
        valueBackground.contentMode = UIViewContentModeScaleAspectFit;
        [valueBackground setImage:[UIImage imageNamed:@"slider_value.png"]];
        pointerBackground.contentMode = UIViewContentModeScaleAspectFit;
        [pointerBackground setImage:[UIImage imageNamed:@"slider_triangle.png"]];
        
        // Numeric Lables
        valueLabel.frame = CGRectMake(valueBackground.frame.origin.x, valueBackground.frame.origin.y, valueBackground.frame.size.width, valueBackground.frame.size.height);
        scoreLabel.frame = CGRectMake(scoreBackground.frame.size.width, scoreBackground.frame.origin.y, scoreBackground.frame.size.width, scoreBackground.frame.size.height);
        [self centreLabel:valueLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
        [self centreLabel:scoreLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
        scoreLabel.text = @"-";
        valueLabel.text = @"-";
        
        // Heading Labels
        valueTitleLabel.frame = CGRectMake(valueBackground.frame.origin.x, (valueBackground.frame.origin.y + valueBackground.frame.size.height), valueBackground.frame.size.width, (SLIDER_Y_OFFSET / 3));
        scoreTitleLabel.frame = CGRectMake(valueTitleLabel.frame.size.width, valueTitleLabel.frame.origin.y, scoreBackground.frame.size.width, valueTitleLabel.frame.size.height);
        [self centreLabel:valueTitleLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
        [self centreLabel:scoreTitleLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
        valueTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        scoreTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        // Displaying the relevant elements - depending on how many elements are required
        [self addSubview:valueBackground];
        [self addSubview:valueLabel];
        [self addSubview:valueTitleLabel];
        
        if( numberOfOutputs >= 2 ){
            [self addSubview:pointerBackground];
            [self addSubview:scoreBackground];
            [self addSubview:scoreLabel];
            [self addSubview:scoreTitleLabel];
        }
        
        NSMutableArray *markerLabelTexts = [self generateMarkerLabelTexts];

        // Adding the marker points
        markerLabels = [[NSMutableArray alloc] init];
        float fullRange = self.maximumValue - self.minimumValue;
        float interMarkerGapValue = fullRange / (float)itemStructure.markerSpaces;
        float markerGap = self.frame.size.width / (float)itemStructure.markerSpaces;
        UILabel *markerLabel;
        UILabel *markerLabelText;
        float markerLabelValue;
        for( int i = 0; i <= itemStructure.markerSpaces; i++ ){
            markerLabel = [[UILabel alloc] init];
            [self centreLabel:markerLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
            markerLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            
            markerLabelValue = self.minimumValue + (interMarkerGapValue * i);
            markerLabel.text = [NSString stringWithFormat:@"%.0f", markerLabelValue];
            
            if( [itemStructure.direction isEqualToString:@"descending"] ){
                markerLabel.frame = CGRectMake((self.frame.origin.x + ((markerGap - (SLIDER_MARKER_WIDTH / 2)) * (itemStructure.markerSpaces - i))), (self.frame.size.height + (SLIDER_MARKER_WIDTH / 2)), SLIDER_MARKER_WIDTH, SLIDER_MARKER_HEIGHT);
            }else{
                markerLabel.frame = CGRectMake((self.frame.origin.x + ((markerGap - (SLIDER_MARKER_WIDTH / 2)) * i)), (self.frame.size.height + (SLIDER_MARKER_WIDTH / 2)), SLIDER_MARKER_WIDTH, SLIDER_MARKER_HEIGHT);
            }
            
            [self addSubview:markerLabel];
            [markerLabels addObject:markerLabel];
            
            if( [markerLabelTexts count] > 0 ){
                markerLabelText = [markerLabelTexts objectAtIndex:i];
                markerLabelText.frame = CGRectMake(markerLabelText.frame.origin.x, (markerLabel.frame.origin.y + markerLabel.frame.size.height), markerLabelText.frame.size.width, markerLabelText.frame.size.height);
                [self addSubview:markerLabelText];
            }
            
        }
        
        diagnosisElements = [[NSMutableArray alloc] init];
        DiagnosisElement *diagnosisElement;
        NSString *diagnosisData;
        for(id key in itemStructure.scoreRanges ){
            diagnosisElement = [[DiagnosisElement alloc] init];
            
            //NSLog(@"Key: %@   Value: %@", key, [itemStructure.scoreRanges objectForKey:key]);
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
        
        [self makeQuestionSpecificAdjustments];
        
    }
    
}

- (void)updateState {

    if( [itemStructure.direction isEqualToString:@"descending"] ){
        actualValue = self.maximumValue - self.value;
    }else{
        actualValue = self.value;
    }
    
    Interview *theParentInterview = [self parentInterview];
    
    valueLabel.text = [NSString stringWithFormat:theParentInterview.scorePrecision, actualValue];
    
    if( [diagnosisElements count] == 0 ){
        
        score = [valueLabel.text floatValue];
    
    }else{
        
        BOOL levelFound = NO;
        DiagnosisElement *selectedElement;
        for( DiagnosisElement *dElement in diagnosisElements ){
            if( ( (actualValue + 0.5) > dElement.minScore) && (!levelFound) ){
                selectedElement = dElement;
                levelFound = YES;
            }
        }
        
        score = selectedElement.index;
        scoreLabel.text = [NSString stringWithFormat:@"%li", (long)score];
        scoreLabel.textColor = selectedElement.colour;
        
        if( [sliderTitles count] < 2 ){
            valueLabel.textColor = selectedElement.colour;
        }
    }
    
    [self makerSliderSpecificAdjustments];

}

- (void)centreLabel:(UILabel *)theLabel withTextColour:(UIColor *)theTextColour onBackground:(NSString *)theBackground {

    theLabel.textAlignment = NSTextAlignmentCenter;
    theLabel.font = [UIFont fontWithName:@"Helvetica" size:scoreFontSize];
    theLabel.textColor = theTextColour;
    theLabel.backgroundColor = [Helper getBackgroundColourForText:theTextColour givenBackground:theBackground];
    
}
/*
- (void)setItemStatus:(NSInteger)theStatus {
}
*/

- (NSMutableArray *)generateMarkerLabelTexts {
    NSMutableArray *labelTexts = [[NSMutableArray alloc] init];
    UILabel *labelText;
    
    for( int i = 0; i <= itemStructure.markerSpaces; i++ ){
        labelText = [[UILabel alloc] init];
        
        NSString *theTextReference = [NSString stringWithFormat:@"Q%li_Item%li_Level%i", questionStructure.index, index, i];
        if( [[Helper getLocalisedString:theTextReference withScalePrefix:YES] length] == 0 ){
            theTextReference = [NSString stringWithFormat:@"Item%li_Level%i", index, i];
        }
        
        labelText.frame = CGRectMake( (i * (self.frame.size.width / (itemStructure.markerSpaces + 1))) , 0, (self.frame.size.width / (itemStructure.markerSpaces + 1)), 20);
        labelText.text = [Helper getLocalisedString:theTextReference withScalePrefix:YES];
        labelText.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        labelText.textAlignment = NSTextAlignmentCenter;
        labelText.font = [UIFont fontWithName:@"Helvetica" size:8.0];
        
        if( [labelText.text length] > 0 ){
            [labelTexts addObject:labelText];
        }
    }
    
    return labelTexts;
}

- (void)resetSlider {

    status = BUTTON_STATE_DEFAULT;
    score = itemStructure.defaultScore;
    actualValue = score;
    self.value = score;
    
    [self centreLabel:valueLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
    [self centreLabel:scoreLabel withTextColour:[UIColor whiteColor] onBackground:@"Dark"];
    scoreLabel.text = @"-";
    valueLabel.text = @"-";
    
}

- (void)makeQuestionSpecificAdjustments {
    
    if( [scaleName isEqualToString:@"CAT"] ){
        valueTitleLabel.hidden = YES;
        NSString *itemReference;
        
        float catY = SLIDER_Y_OFFSET + SLIDER_MARKER_HEIGHT;
        NSLog(@"%f", catY);
        
        catSmall = [[UILabel alloc] init];
        catSmall.frame = CGRectMake(0, catY, (self.frame.size.width / 2), 50);
        catSmall.textColor = [UIColor greenColor];
        //catSmall.textAlignment = NSTextAlignmentLeft;
        catSmall.textAlignment = NSTextAlignmentCenter;
        catSmall.numberOfLines = 10;
        itemReference = [NSString stringWithFormat:@"%@_Q%li_Item0", scaleName, (long)questionStructure.index];
        catSmall.text = [Helper getLocalisedString:itemReference withScalePrefix:NO];
        
        catLarge = [[UILabel alloc] init];
        catLarge.frame = CGRectMake((self.frame.size.width / 2), catY, (self.frame.size.width / 2), 50);
        catLarge.textColor = [UIColor redColor];
        //catLarge.textAlignment = NSTextAlignmentRight;
        catLarge.textAlignment = NSTextAlignmentCenter;
        catLarge.numberOfLines = 10;
        itemReference = [NSString stringWithFormat:@"%@_Q%li_Item1", scaleName, (long)questionStructure.index];
        catLarge.text = [Helper getLocalisedString:itemReference withScalePrefix:NO];
        
        UIImageView *topEdge = [[UIImageView alloc] initWithFrame:CGRectMake(0, catSmall.frame.origin.y, self.frame.size.width, 2)];
        [topEdge setImage:[UIImage imageNamed:@"content.png"]];
        UIImageView *bottomEdge = [[UIImageView alloc] initWithFrame:CGRectMake(0, catSmall.frame.origin.y + catSmall.frame.size.height, self.frame.size.width, 2)];
        [bottomEdge setImage:[UIImage imageNamed:@"content.png"]];
        
        [self addSubview:catSmall];
        [self addSubview:catLarge];
        [self addSubview:topEdge];
        [self addSubview:bottomEdge];
    }

    if( [scaleName isEqualToString:@"MSRS"] ){
        NSString *itemReference = [NSString stringWithFormat:@"Item%i", (int)index];
        valueTitleLabel.text = [Helper getLocalisedString:itemReference withScalePrefix:YES];
    }
    
}

- (void)makerSliderSpecificAdjustments {

    if( [scaleName isEqualToString:@"CAT"] ){
        
        float floatingPoint = self.value / self.maximumValue;
        float dividingPoint = self.frame.size.width * (1 - floatingPoint);
        
        catSmall.frame = CGRectMake(0, catLarge.frame.origin.y, dividingPoint, 50);
        catLarge.frame = CGRectMake(dividingPoint, catSmall.frame.origin.y, self.frame.size.width - dividingPoint, 50);
        
        float MAX_FONT = 20;
        
        catSmall.font = [UIFont fontWithName:@"Helvetica" size:(MAX_FONT * (1 - floatingPoint))];
        catLarge.font = [UIFont fontWithName:@"Helvetica" size:(MAX_FONT * floatingPoint)];
        
    }
    
}

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
