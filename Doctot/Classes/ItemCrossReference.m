//
//  ItemCrossReference.m
//  Doctot
//
//  Created by Fergal McDonnell on 28/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "ItemCrossReference.h"
#import "CrossReferenceOutputItem.h"
#import "Helper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"

/***************************************************************************************************************************

 
***************************************************************************************************************************/

@implementation ItemCrossReference

@synthesize crossReferenceDelegate, itemStructure, questionStructure, index, scaleName, status, actualValue, score, parentQuestionReference, diagnosisElements, outputItems, pickers;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    self.frame = CGRectMake(0, (index * CROSSREFERENCE_HEIGHT), questionDimensions.width, CROSSREFERENCE_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    parentQuestionReference = [NSString stringWithFormat:@"Q%i_CrossReference%i", (int)questionStructure.index, (int)itemStructure.index];
    
    if( [itemStructure.subtype isEqualToString:@"Normal"] ){
        
        // Setup the demensions of the CrossReference (gathered from the scaleDefinitions.json settings via itemStructure [ItemStructure])
        [self defineDementions];
        
        [self makeQuestionSpecificAdjustments];
        
    }
    
}


/***************************************************************************************************************************
 
 - (void)defineDementions
 
***************************************************************************************************************************/

- (void)defineDementions {
    
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
    
    [self createOutputItem];
    
    [self createPickerItem];

}

- (void)createOutputItem {
    
    // Generate the items to be displayed
    int inc = 0;
    int totalOutputHeightFactor = 0;
    outputItems = [[NSMutableArray alloc] init];
    while( [outputItems count] != [itemStructure.outputItems count] ){
        inc++;
        for( NSString *aKey in itemStructure.outputItems ){
            NSDictionary *anOutputItem = [itemStructure.outputItems objectForKey:aKey];
            CrossReferenceOutputItem *outputItem = [[CrossReferenceOutputItem alloc] init];
            [outputItem setupWithDictionaryData:anOutputItem];
            int currentIndex = (int)[[anOutputItem valueForKey:@"index"] integerValue];
            if( currentIndex == inc ){
                totalOutputHeightFactor += (int)[[anOutputItem valueForKey:@"heightRatio"] integerValue];
                [outputItems addObject:outputItem];
            }
        }
    }
    
    // Display the items
    float combinedItemsHeight = self.frame.size.height - CROSSREFERENCE_PICKER_HEIGHT;
    float currentYPosition = 0;
    for( CrossReferenceOutputItem *outputItem in outputItems ){
        outputItem.frame = CGRectMake(0, currentYPosition, outputItem.frame.size.width, (outputItem.heightRatio * (combinedItemsHeight / totalOutputHeightFactor)) );
        [outputItem alignLabelHeights];
        currentYPosition += outputItem.frame.size.height;
        [self addSubview:outputItem];
    }
    
}

- (void)createPickerItem {
    
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    float pickerWidth = questionDimensions.width / itemStructure.numberOfPickers;
    pickers = [[NSMutableArray alloc] init];
    CustomPickerView *thePickerView;
    NSDictionary *thisPickerInfo;

    for( int i = 0; i < itemStructure.numberOfPickers; i++ ){
        thisPickerInfo = [itemStructure.pickers objectForKey:[NSString stringWithFormat:@"Picker %i", (i + 1)]];
        thePickerView = [[CustomPickerView alloc] initWithFrame:CGRectMake( 0, 0, pickerWidth, CROSSREFERENCE_PICKER_HEIGHT)];
        [thePickerView setup:thisPickerInfo];
        thePickerView.frame = CGRectMake( (pickerWidth * i), (self.frame.size.height - thePickerView.frame.size.height) , pickerWidth, thePickerView.frame.size.height);
        thePickerView.tag = i;
        thePickerView.delegate = self;
        //thePickerView.dataSource = self;
        
        [pickers addObject:thePickerView];
        [self addSubview:thePickerView];
        
        [thePickerView selectRow:0 inComponent:0 animated:YES];
        [self pickerView:thePickerView didSelectRow:0 inComponent:0];
    }
    
}


/***************************************************************************************************************************
 
 SCORING
 
***************************************************************************************************************************/

- (void)calculateScore {

    score = 0;
    
    [crossReferenceDelegate updateItemCrossReference:self]; // updateItemCrossReference calls - (void)updateItemCrossReference:(ItemCrossReference *)theCrossReference in Question class
}

- (void)makeQuestionSpecificAdjustments {
    
    if( [scaleName isEqualToString:@""] ){
        
    }
    
}

- (void)resetCrossReference {
    
}

/***************************************************************************************************************************
 
 PickerView Delegate Methods
 
 ***************************************************************************************************************************/

-(NSInteger)numberOfComponentsInPickerView:(CustomPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(CustomPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerView.elements count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
/*
- (NSString *)pickerView:(CustomPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *theTitle;
    
    if( [[pickerView.elements objectAtIndex:row] isKindOfClass:[NSString class]] ){
        theTitle = (NSString *)[pickerView.elements objectAtIndex:row];
    }
    
    return theTitle;
}
 */

- (UIView *)pickerView:(CustomPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    return [self generateRowView:[pickerView.elements objectAtIndex:row]];
    
}

- (void)pickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    pickerView.selectedIndex = (int)row;
    
    NSString *outputResultReference = @"";
    for( CustomPickerView *aPicker in pickers ){
        outputResultReference = [outputResultReference stringByAppendingFormat:@"_%@%i", [aPicker.sourceDictionary valueForKey:@"title"], aPicker.selectedIndex];
    }
    
    NSString *thisItemReference = @"";
    for( CrossReferenceOutputItem *anItem in outputItems ){
        thisItemReference = (NSString *)[anItem.sourceDictionary valueForKey:@"description"];
        thisItemReference = [thisItemReference stringByAppendingFormat:@"%@", outputResultReference];
        anItem.result.text = (NSString *)[itemStructure.outputResults valueForKey:thisItemReference];
        
        // Check if there is a localised version
        // For example: Localizable.strings file may contain:
        // TEST_Q1_CrossReference0_number_Sport1_County0_Position0
        // parentQuestionReference = TEST_Q1_CrossReference0 AND thisItemReference = number_Sport1_County0_Position0
        NSString *localisedReference = [parentQuestionReference stringByAppendingFormat:@"_%@", thisItemReference];
        if( [[Helper getLocalisedString:localisedReference withScalePrefix:YES] length] > 0 ){
            anItem.result.text = [Helper getLocalisedString:localisedReference withScalePrefix:YES];
        }
        
    }
    
}

- (UIView *)generateRowView:(UIView *)sourceView {
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    theView.frame = sourceView.frame;
    
    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theView.frame.size.width, theView.frame.size.height)];
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, theView.frame.size.width, theView.frame.size.height)];
    
    for( UILabel *bLabel in sourceView.subviews ){
        if( [bLabel isKindOfClass:[UILabel class]] ){
            // titleLabel
            if( bLabel.tag == 2 ){
                aLabel.frame = bLabel.frame;
                aLabel.text = bLabel.text;
                aLabel.textAlignment = bLabel.textAlignment;
                aLabel.textColor = bLabel.textColor;
                aLabel.backgroundColor = bLabel.backgroundColor;
            }
        }
    }
    
    for( UIImageView *bImageView in sourceView.subviews ){
        if( [bImageView isKindOfClass:[UIImageView class]] ){
            if( bImageView.tag == 1 ){
                anImageView.frame = bImageView.frame;
                anImageView.image = bImageView.image;
            }
        }
    }
    
    [theView addSubview:anImageView];
    [theView addSubview:aLabel];
    
    return theView;
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
