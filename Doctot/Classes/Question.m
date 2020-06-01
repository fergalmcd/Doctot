//
//  Question.m
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import "Question.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"
#import "MiniInterview.h"
#import "Helper.h"
#import "ItemStructure.h"
#import "Constants.h"


@implementation Question

@synthesize scaleDefinition, index, defaultScore, items, questionStructure, prefs, questionDimensions, isInMiniInterview, miniInterviewPlain, backgroundImage;
@synthesize qReference, title, subTitle, score, scoreLevel, answerCustomInformation, selectedItem, selectedItemIdenifier, previousSelectedItemIdenifier, cumulativeItemHeights;
@synthesize titleLabel, subtitleLabel;
// Asssessment Specific
@synthesize hdrsLossOfWeightOption, hdrsLossOfWeightButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)initialise {
    
    qReference = [NSString stringWithFormat:@"Q%li", (long)index];
    title = [Helper getLocalisedString:qReference withScalePrefix:YES];
    NSString *reference = [NSString stringWithFormat:@"%@_Subheading", qReference];
    subTitle = [Helper getLocalisedString:reference withScalePrefix:YES];
    cumulativeItemHeights = 0;
    previousSelectedItemIdenifier = -1;
    isInMiniInterview = NO;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    questionDimensions = [Helper getInterviewQuestionDimensions];
    self.frame = CGRectMake(0, 0, questionDimensions.width, questionDimensions.height);
    self.backgroundColor = [UIColor clearColor];
    backgroundImage = [[UIImageView alloc] initWithFrame:self.frame];
    if( index == [scaleDefinition.questions count] ){
        backgroundImage.image = [UIImage imageNamed:@"background.png"];
    }
    [self addSubview:backgroundImage];
    
    questionStructure = (QuestionStructure *)[scaleDefinition.questions objectAtIndex:(index - 1)];
    score = (float)questionStructure.defaultScore;
    
    ItemButton *button;
    ItemSlider *slider;
    ItemSwiper *swiper;
    ItemSelector *selector;
    ItemEnergyBar *energyBar;
    ItemRotator *rotator;
    ItemStopwatch *stopwatch;
    ItemCrossReference *crossReference;
    items = [[NSMutableArray alloc] init];
    for( ItemStructure *itemStructure in questionStructure.items ){
        
        if( [itemStructure.type isEqualToString:@"Button"] ){
            button = [[ItemButton alloc] init];
            button.scaleName = scaleDefinition.name;
            button.precision = scaleDefinition.precision;
            button.questionStructure = questionStructure;
            [self setHeightForNormalItem:button ofItemStructure:itemStructure];
            [button configureWithItemStructure:itemStructure];
            
            if( [button.itemStructure.subtype isEqualToString:@"Normal"] || [button.itemStructure.subtype isEqualToString:@"Recurring"] || [button.itemStructure.subtype isEqualToString:@"YES"] || [button.itemStructure.subtype isEqualToString:@"NO"] ){
                [button addTarget:self action:@selector(updateButtons:) forControlEvents:UIControlEventTouchUpInside];
                
                // Rounded button for bottom Normal / Recurring button
                if( [button.itemStructure.subtype isEqualToString:@"Normal"] || [button.itemStructure.subtype isEqualToString:@"Recurring"] ){
                    if( itemStructure.index == ( [questionStructure.items count] - 1 ) ){
                        [button roundCornersOnViewOnTopLeft:NO topRight:NO bottomLeft:YES bottomRight:YES radius:10.0];
                    }
                }
                // Rounded button for bottom YES / NO button
                if( [button.itemStructure.subtype isEqualToString:@"YES"] || [button.itemStructure.subtype isEqualToString:@"NO"] ){
                    if( button.itemStructure.index == 0 ){
                        //[button roundCornersOnViewOnTopLeft:NO topRight:NO bottomLeft:YES bottomRight:NO radius:50.0];
                    }else{
                        //[button roundCornersOnViewOnTopLeft:NO topRight:NO bottomLeft:NO bottomRight:YES radius:50.0];
                    }
                }
            }
            
            if( [button.itemStructure.subtype isEqualToString:@"Toggle"] ){
                [button addTarget:self action:@selector(updateToggleButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [items addObject:button];
            [self addSubview:button];
        }
        
        if( [itemStructure.type isEqualToString:@"Slider"] ){
            slider = [[ItemSlider alloc] init];
            slider.scaleName = scaleDefinition.name;
            slider.precision = scaleDefinition.precision;
            slider.questionStructure = questionStructure;
            cumulativeItemHeights += (SLIDER_Y_OFFSET + slider.frame.size.height + (3 * SLIDER_MARKER_HEIGHT));
            [slider configureWithItemStructure:itemStructure];
            [slider addTarget:self action:@selector(updateSliders:) forControlEvents:UIControlEventValueChanged];
            
            [items addObject:slider];
            [self addSubview:slider];
        }
        
        if( [itemStructure.type isEqualToString:@"Swiper"] ){
            swiper = [[ItemSwiper alloc] init];
            swiper.scaleName = scaleDefinition.name;
            swiper.precision = scaleDefinition.precision;
            swiper.questionStructure = questionStructure;
            cumulativeItemHeights += SWIPER_HEIGHT;
            [swiper configureWithItemStructure:itemStructure];
            swiper.delegate = self;
            
            [items addObject:swiper];
            [self addSubview:swiper];
        }
        
        if( [itemStructure.type isEqualToString:@"Selector"] ){
            selector = [[ItemSelector alloc] init];
            selector.scaleName = scaleDefinition.name;
            selector.questionStructure = questionStructure;
            cumulativeItemHeights += SELECTOR_HEIGHT;
            [selector configureWithItemStructure:itemStructure];
            selector.delegate = self;
            
            [items addObject:selector];
            [self addSubview:selector];
        }
        
        if( [itemStructure.type isEqualToString:@"EnergyBar"] ){
            energyBar = [[ItemEnergyBar alloc] init];
            energyBar.scaleName = scaleDefinition.name;
            energyBar.questionStructure = questionStructure;
            [energyBar configureWithItemStructure:itemStructure];
            if( energyBar.index == (energyBar.groupSize - 1) ){
                cumulativeItemHeights += energyBar.frame.size.height;
            }
            energyBar.energyBarDelegate = self;
            
            [items addObject:energyBar];
            [self addSubview:energyBar];
        }
        
        if( [itemStructure.type isEqualToString:@"Rotator"] ){
            rotator = [[ItemRotator alloc] init];
            rotator.scaleName = scaleDefinition.name;
            rotator.questionStructure = questionStructure;
            cumulativeItemHeights += ROTATOR_HEIGHT;
            [rotator configureWithItemStructure:itemStructure];
            rotator.rotatorDelegate = self;
            
            [items addObject:rotator];
            [self addSubview:rotator];
        }
        
        if( [itemStructure.type isEqualToString:@"Stopwatch"] ){
            stopwatch = [[ItemStopwatch alloc] init];
            stopwatch.scaleName = scaleDefinition.name;
            stopwatch.questionStructure = questionStructure;
            cumulativeItemHeights += STOPWATCH_HEIGHT;
            [stopwatch configureWithItemStructure:itemStructure];
            stopwatch.stopwatchDelegate = self;
            
            [items addObject:stopwatch];
            [self addSubview:stopwatch];
        }
        
        if( [itemStructure.type isEqualToString:@"CrossReference"] ){
            crossReference = [[ItemCrossReference alloc] init];
            crossReference.scaleName = scaleDefinition.name;
            crossReference.questionStructure = questionStructure;
            cumulativeItemHeights += CROSSREFERENCE_HEIGHT;
            [crossReference configureWithItemStructure:itemStructure];
            crossReference.crossReferenceDelegate = self;
            
            [items addObject:crossReference];
            [self addSubview:crossReference];
        }
        
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cumulativeItemHeights + QUESTION_BASE_PADDING);
    
    // Check if there are layout considerations for this particular scale
    [self adjustQuestionForAwkwardScale];
    
}

- (void)updateButtons:(ItemButton *)theButton {
    BOOL alreadySelected = NO;
    
    for( ItemButton *aButton in items ){
        if( [aButton isKindOfClass:[ItemButton class]] ){
        
            if( !(aButton == theButton) ){
                [aButton setItemStatus:BUTTON_STATE_OFF];
            }else{
                if( selectedItem == aButton ){
                    alreadySelected = YES;
                }
                selectedItemIdenifier = aButton.index;
                selectedItem = aButton;
            }
            
        }
    }
    score = theButton.score;
    [self adjustButtonForAwkwardScale:theButton];
    [self insertAnswerCustomInformation];
    [self updateParentInterviewScore];
    
    Interview *interview = nil;
    MiniInterview *miniInterview = nil;
    
    if( previousSelectedItemIdenifier == selectedItemIdenifier ){
        if( isInMiniInterview ){
            [miniInterview navigateNext];
        }else{
            [interview navigateNext];
        }
    }
    previousSelectedItemIdenifier = selectedItemIdenifier;
    
    if( alreadySelected ){
        Interview *interview = [self parentInterview];
        [interview navigateNext];
    }
    
}

- (void)updateToggleButton:(ItemButton *)theButton {
    
    selectedItemIdenifier = theButton.index;
    selectedItem = theButton;
    [self adjustButtonForAwkwardScale:theButton];
    [self insertAnswerCustomInformation];
    
    Interview *interview = [self parentInterview];
    [interview updateScore];
    
    previousSelectedItemIdenifier = selectedItemIdenifier;
    
}

- (void)updateSliders:(ItemSlider *)theSlider {

    score = theSlider.score;
    
    selectedItemIdenifier = 1;
    previousSelectedItemIdenifier = selectedItemIdenifier;
    
    [self makeSpecificAdjustmentsForScale];
    [self insertAnswerCustomInformation];
    [self updateParentInterviewScore];
    
}

// Delegate method from ItemSwiper
- (void)updateItemSwiper:(ItemSwiper *)theSwiper {
    
    score = theSwiper.score;
    scoreLevel = theSwiper.selectedElement.index;
    [self adjustScoreFromItemAdjustment];
    [self insertAnswerCustomInformation];
    
}

// Delegate method from ItemSelector
- (void)updateItemSelector:(ItemSelector *)theSelector {

    score = theSelector.score;
    [self adjustScoreFromItemAdjustment];
    [self insertAnswerCustomInformation];
    
}

// Delegate method from ItemEnergyBar
- (void)updateItemEnergyBar:(ItemEnergyBar *)theEnergyBar {
    
    score = theEnergyBar.score;
    [self adjustScoreFromItemAdjustment];
    
}

// Delegate method from ItemRotator
- (void)updateItemRotator:(ItemRotator *)theRotator {
    
    score = theRotator.score;
    [self adjustScoreFromItemAdjustment];
    
}

// Delegate method from ItemStopwatch
- (void)updateItemStopwatch:(ItemStopwatch *)theStopwatch {
    
    if( [scaleDefinition.name isEqualToString:@"TEST"] || [scaleDefinition.name isEqualToString:@"EMS"] || [scaleDefinition.name isEqualToString:@"BERG"] ){
        
        for( ItemButton *aButton in items ){
            if( [aButton isKindOfClass:[ItemButton class]] ){
                [aButton setItemStatus:BUTTON_STATE_OFF];
                if( aButton.itemStructure.onScore == theStopwatch.score ){
                    [aButton setItemStatus:BUTTON_STATE_CONFIRMED];
                    score = aButton.score;
                }
            }
        }
        
    }
    
    [self adjustScoreFromItemAdjustment];
    
}

// Delegate method from ItemCrossReference
- (void)updateItemCrossReference:(ItemCrossReference *)theCrossReference {
    
    score = theCrossReference.score;
    [self adjustScoreFromItemAdjustment];
    
}

- (void)adjustScoreFromItemAdjustment {
    
    selectedItemIdenifier = 1;
    previousSelectedItemIdenifier = selectedItemIdenifier;
    
    [self updateParentInterviewScore];
    
}

- (Interview *)parentInterview {

    Interview *thisInterview;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    Scale *thisScale = home.scale;
    thisInterview = thisScale.interview;
    
    // Adjustment for apps which have only one scale
    if( thisInterview == nil ){
        NSInteger stackSize = [nav.viewControllers count];
        thisInterview = [nav.viewControllers objectAtIndex:(stackSize - 1)];
    }
    
    return thisInterview;
}

- (void)updateParentInterviewScore {

    Interview *interview = nil;
    MiniInterview *miniInterview = nil;
    if( isInMiniInterview ){
        miniInterview = (MiniInterview *)miniInterviewPlain;
        [miniInterview updateScore];
    }else{
        interview = [self parentInterview];
        [interview updateScore];
    }
    
}

- (void)setHeightForNormalItem:(UIButton *)theButton ofItemStructure:(ItemStructure *)theItemStructure {

    if( [theItemStructure.subtype isEqualToString:@"Normal"] || [theItemStructure.subtype isEqualToString:@"Toggle"] || [theItemStructure.subtype isEqualToString:@"Recurring"] ){
        
        float thisItemHeight = BUTTON_BASE_HEIGHT;
        NSString *titleReference = [NSString stringWithFormat:@"%@_Q%li_Item%li", scaleDefinition.name, index, theItemStructure.index];
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - thisItemHeight, thisItemHeight)];
        emptyLabel.font = [Helper getScaleItemFont:scaleDefinition.name];
        emptyLabel.text = NSLocalizedString(titleReference, @"");
        CGSize size = [emptyLabel.text sizeWithAttributes:@{NSFontAttributeName:emptyLabel.font}];
        if (size.width > emptyLabel.bounds.size.width) {
            thisItemHeight *= 1 + ((size.width / emptyLabel.frame.size.width) / 3);
        }
        theButton.frame = CGRectMake(BUTTON_NORMAL_PADDING_X, cumulativeItemHeights, (questionDimensions.width - (2 * BUTTON_NORMAL_PADDING_X)), thisItemHeight);
        cumulativeItemHeights += thisItemHeight;
    }
    
    if( [theItemStructure.subtype isEqualToString:@"YES"] || [theItemStructure.subtype isEqualToString:@"NO"] ){
        cumulativeItemHeights = BUTTON_BASE_HEIGHT * 3;
    }
    
}

- (void)insertAnswerCustomInformation {
    
    NSString *theDescriptionReference = [NSString stringWithFormat:@"Q%li_Item%li", index, selectedItemIdenifier];
    answerCustomInformation = [Helper getLocalisedString:theDescriptionReference withScalePrefix:YES];
    
    // Adjustment for "Recurring" Buttons
    if( [answerCustomInformation length] == 0 ){
        theDescriptionReference = [NSString stringWithFormat:@"Item%li", selectedItemIdenifier];
        answerCustomInformation = [Helper getLocalisedString:theDescriptionReference withScalePrefix:YES];
    }
    
    [self adjustAnswerCustomInformationForAwkwardScale];
    
}

- (void)tidyQuestionUponLeaving {
    
    // Stop a running Stopwatch //////////////////////////////////////
    for( ItemStopwatch *aStopwatch in items ){
        if( [aStopwatch isKindOfClass:[ItemStopwatch class]] ){
            if( aStopwatch.status == BUTTON_STATE_ON ){
                [aStopwatch turnOffStopwatch];
            }
        }
    }
    //////////////////////////////////////////////////////////////////
    
}

- (void)clearDetails {
    
    previousSelectedItemIdenifier = -1;
    score = questionStructure.defaultScore;
    
    for( ItemButton *aButton in items ){
        if( [aButton isKindOfClass:[ItemButton class]] ){
            [aButton setItemStatus:BUTTON_STATE_OFF];
        }
    }
    for( ItemSlider *aSlider in items ){
        if( [aSlider isKindOfClass:[ItemSlider class]] ){
            [aSlider resetSlider];
        }
    }
    for( ItemSwiper *aSwiper in items ){
        if( [aSwiper isKindOfClass:[ItemSwiper class]] ){
            [aSwiper resetSwiper];
        }
    }
    for( ItemSelector *aSelector in items ){
        if( [aSelector isKindOfClass:[ItemSelector class]] ){
            [aSelector resetSelector];
        }
    }
    for( ItemEnergyBar *anEnergyBar in items ){
        if( [anEnergyBar isKindOfClass:[ItemEnergyBar class]] ){
            [anEnergyBar resetEnergyBar];
        }
    }
    for( ItemRotator *aRotator in items ){
        if( [aRotator isKindOfClass:[ItemRotator class]] ){
            [aRotator resetRotator];
        }
    }
    for( ItemStopwatch *aStopwatch in items ){
        if( [aStopwatch isKindOfClass:[ItemStopwatch class]] ){
            aStopwatch.score = aStopwatch.questionStructure.defaultScore;
            [aStopwatch resetStopwatch];
            [self resetAllButtonItems];
        }
    }
    for( ItemCrossReference *aCrossReference in items ){
        if( [aCrossReference isKindOfClass:[ItemCrossReference class]] ){
            [aCrossReference resetCrossReference];
        }
    }
    
    Interview *interview = [self parentInterview];
    [interview updateScore];
    
}

- (void)resetAllButtonItems {
    
    for( ItemButton *aButton in items ){
        if( [aButton isKindOfClass:[ItemButton class]] ){
            [aButton setItemStatus:BUTTON_STATE_OFF];
        }
    }
    previousSelectedItemIdenifier = -1;
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Scale-specific Adjustments
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)makeSpecificAdjustmentsForScale {
    
    // GOLD: COM - Q3 (hospitalisation button disappears if Slider value is 0)
    if( [scaleDefinition.name isEqualToString:@"COM"] ){
        if( index == 3 ){
            
            float sliderValue = 0.0;
            float buttonValue = 0.0;
            
            ItemSlider *theSlider;
            ItemButton *theButton;
            for( NSObject *anItem in items ){
                
                if( [anItem isKindOfClass:[ItemSlider class]] ) {
                    theSlider = (ItemSlider *)anItem;
                    if( theSlider.index == 0 ){
                        sliderValue = theSlider.actualValue;
                    }
                }
                
                if( [anItem isKindOfClass:[ItemButton class]] ){
                    theButton = (ItemButton *)anItem;
                    if( theButton.index == 1 ){
                        if( sliderValue >= 0.5 ){
                            theButton.hidden = NO;
                        }else{
                            theButton.hidden = YES;
                            [theButton setItemStatus:BUTTON_STATE_OFF];
                            theButton.score = 0.0;
                        }
                        buttonValue = theButton.score;
                    }
                }
            }
            
            if( sliderValue > 1.5 ){
                score = 1.0;
            }else{
                score = buttonValue;
            }
            
            if( ( theSlider.actualValue > 0.5 ) && ( theButton.score > 0.0 ) ){
                theSlider.valueLabel.textColor = [UIColor redColor];
            }
            
        }
    }
    ///////////
    
    // MSRS (Depression)
    if( [scaleDefinition.name isEqualToString:@"MSRS"] ){
        ItemSlider *frequencySlider = [items objectAtIndex:0];
        ItemSlider *intensitySlider = [items objectAtIndex:1];
        score = frequencySlider.score * intensitySlider.score;
        if( score < 0 ){
            score = 0;
        }
    }
    
    /* BCRSS: (COVID19)
    if( [scaleDefinition.name isEqualToString:@"BCRSS"] ){
        if( ( index == 4 ) || ( index == 5 ) || ( index == 6 ) ){
            ItemSwiper *theSwiper = [items objectAtIndex:0];
            NSLog(@"theSwiper.level: %i", (int)theSwiper.selectedElement.index);
            scoreLevel = theSwiper.selectedElement.index;
        }
    }
    */
}

- (void)adjustButtonForAwkwardScale:(ItemButton *)theButton {

    if( [scaleDefinition.name isEqualToString:@"COM"] ){
        
        if( index == 2 ){
            
            Interview *mmrc = [self parentInterview];
            if( theButton.score == 0 ){
                [mmrc conjureInternalInterview:@"MMRC"];
            }else{
                [mmrc conjureInternalInterview:@"CAT"];
            }
        }
        
        if( index == 3 ){
            score = theButton.score;
            [self makeSpecificAdjustmentsForScale];
        }
        
    }
    
}

- (void)adjustAnswerCustomInformationForAwkwardScale {
    
    if( [scaleDefinition.name isEqualToString:@"COM"] ){
        if( index == 1 ){
            ItemSlider *theSlider = (ItemSlider *)[items objectAtIndex:0];
            answerCustomInformation = [NSString stringWithFormat:@"%@ = %.1f", theSlider.valueTitleLabel.text, theSlider.value];
        }
        if( index == 3 ){
            ItemSlider *theSlider = (ItemSlider *)[items objectAtIndex:0];
            ItemButton *theButton = (ItemButton *)[items objectAtIndex:1];
            answerCustomInformation = [NSString stringWithFormat:@"%@ = %@, %@ = %.1f", theSlider.valueTitleLabel.text, theSlider.valueLabel.text, theButton.titleLabel.text, theButton.score];
        }
    }
    
    if( [scaleDefinition.name isEqualToString:@"MSRS"] ){
        ItemSlider *frequencySlider = (ItemSlider *)[items objectAtIndex:0];
        ItemSlider *intensitySlider = (ItemSlider *)[items objectAtIndex:1];
        answerCustomInformation = [NSString stringWithFormat:@"%@ = %.0f \n%@ = %.0f ", frequencySlider.valueTitleLabel.text, frequencySlider.value, intensitySlider.valueTitleLabel.text, intensitySlider.value];
    }
    
    if( [scaleDefinition.name isEqualToString:@"CACH"] ){
        if( index == 1 ){
            answerCustomInformation = [prefs objectForKey:@"cachCalciumUnits"];
        }
        if( index == 2 ){
            answerCustomInformation = [prefs objectForKey:@"cachAlbuminUnits"];
        }
        if( index == 3 ){
            answerCustomInformation = [prefs objectForKey:@"cachAlbuminUnits"];
        }
    }
    
    if( [scaleDefinition.name isEqualToString:@"AINT"] ){
        if( ( index == 3 ) || ( index == 4 ) ){
            ItemSelector *theSelector= (ItemSelector *)[items objectAtIndex:0];
            answerCustomInformation = @"";
            for( SelectorBundle *selectorBundle in theSelector.receiverBundles ){
                answerCustomInformation = [answerCustomInformation stringByAppendingFormat:@"%@: ", selectorBundle.heading.text];
                for( SelectorButton *selectorButton in selectorBundle.selectorButtons ){
                    answerCustomInformation = [answerCustomInformation stringByAppendingFormat:@"%@, ", selectorButton.heading.text];
                }
                answerCustomInformation = [answerCustomInformation stringByAppendingString:@"\n"];
            }
        }
    }
    
    if( [scaleDefinition.name isEqualToString:@"HORW"] ){
        answerCustomInformation = [Helper getLocalisedString:[NSString stringWithFormat:@"Q%i_Item0_Units", (int)index] withScalePrefix:YES];
    }
    
    if( [scaleDefinition.name isEqualToString:@"BERL"] ){
        if( ( index == 5 ) || ( index == 6 ) ){
            answerCustomInformation = [Helper getLocalisedString:[NSString stringWithFormat:@"Q%i_Item0_Units", (int)index] withScalePrefix:YES];
        }
    }
    
}

- (void)adjustQuestionForAwkwardScale {
    
    if( [scaleDefinition.name isEqualToString:@"HDRS"] ){
        if( [title containsString:@"Loss of Weight"] ){
            float THIS_BUTTON_WIDTH = self.frame.size.width;
            float THIS_BUTTON_HEIGHT = 100;
            hdrsLossOfWeightOption = [NSString stringWithFormat:@"%@_%@B_Subheading", scaleDefinition.name, qReference];
            hdrsLossOfWeightButton = [[UIButton alloc] initWithFrame:CGRectMake( ((self.frame.size.width - THIS_BUTTON_WIDTH) / 2), cumulativeItemHeights, THIS_BUTTON_WIDTH, THIS_BUTTON_HEIGHT)];
            NSLog(@"hdrsLossOfWeightButton Y: %f", hdrsLossOfWeightButton.frame.origin.y);
            [hdrsLossOfWeightButton setTitle:NSLocalizedString(hdrsLossOfWeightOption, @"") forState:UIControlStateNormal];
            [hdrsLossOfWeightButton addTarget:self action:@selector(toggleHDRSLossOfWeightOptions) forControlEvents:UIControlEventTouchDown];
            [self addSubview:hdrsLossOfWeightButton];
        }
    }
    
    NSString *scaleSpecificSettings = (NSString *)[Helper returnValueForKey:@"SettingsScaleSpecificOption"];
    if( [scaleSpecificSettings isEqualToString:@"Yes"] ){
        
        if( [scaleDefinition.name isEqualToString:@"MTS"] ){
            
            UILabel *guidance = [[UILabel alloc] initWithFrame:CGRectMake(0, cumulativeItemHeights + 150, self.frame.size.width, 50)];
            guidance.textColor = [UIColor blackColor];
            guidance.textAlignment = NSTextAlignmentCenter;
            guidance.numberOfLines = 3;
            guidance.text = @"";
            
            UIImageView *guidanceBackground = [[UIImageView alloc] initWithFrame:CGRectMake( guidance.frame.origin.x, guidance.frame.origin.y - (guidance.frame.size.height / 2), guidance.frame.size.width, (guidance.frame.size.height * 2) )];
            guidanceBackground.image = [UIImage imageNamed:@"logoband.png"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear) fromDate:[NSDate date]];
            
            if( [title containsString:@"Time"] ){
                
                NSInteger hour = [components hour];
                NSInteger minute = [components minute];
                NSString *ampm = @"am";
                if( minute >= 30 ){
                    hour++;
                }
                if( hour == 0 ){
                    hour = 12;
                }else{
                    if( hour >= 12 ){
                        if( hour > 12 ){
                            hour -= 12;
                        }
                        ampm = @"pm";
                    }
                }
                guidance.text = [NSString stringWithFormat:@"%li %@", hour, ampm];
                
            }
            
            if( [title containsString:@"Year"] ){
                
                NSInteger year = [components year];
                guidance.text = [NSString stringWithFormat:@"%li", year];
                
            }
            
            if( [title containsString:@"Recall"] ){
                
                guidance.text = [prefs objectForKey:@"mtsAddress"];
                
            }
            
            if( [title containsString:@"Location"] ){
                
                guidance.text = [prefs objectForKey:@"mtsAddressCurrent"];
                
            }
            
            if( [title containsString:@"Historical"] ){
                
                guidance.text = [prefs objectForKey:@"mtsHistoricalEventQuestion"];
                guidance.text = [guidance.text stringByAppendingFormat:@" \n%@", [prefs objectForKey:@"mtsHistoricalEventAnswer"]];
                
            }
            
            if( [title containsString:@"State"] ){
                
                guidance.text = [prefs objectForKey:@"mtsHeadOfState"];
                
            }
            
            if( [guidance.text length] > 0 ){
                [self addSubview:guidanceBackground];
                [self addSubview:guidance];
            }
            
            
        }
        
    }
    
    if( [scaleDefinition.name isEqualToString:@"CACH"] ){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (self.frame.size.height / 2));
    }
    
    if( [scaleDefinition.name isEqualToString:@"BCXR"] ){
        UIImageView *visualAid = [[UIImageView alloc] initWithFrame:CGRectMake( ( (self.frame.size.width - 200) / 2 ), 200, 200, 200)];
        visualAid.image = [UIImage imageNamed:[NSString stringWithFormat:@"bcxr0%i.png", (int)index]];
        [self addSubview:visualAid];
    }
    
}

- (void)toggleHDRSLossOfWeightOptions {
    NSString *baseReference;
    NSString *buttonReference;
    NSString *currentIndexReference;
    
    if( [hdrsLossOfWeightOption containsString:@"Patient"] ){
        baseReference = [NSString stringWithFormat:@"%@_%@_Item", scaleDefinition.name, qReference];
        buttonReference = [NSString stringWithFormat:@"%@_%@B_Subheading", scaleDefinition.name, qReference];
    }else{
        baseReference = [NSString stringWithFormat:@"%@_%@B_Item", scaleDefinition.name, qReference];
        buttonReference = [NSString stringWithFormat:@"%@_%@A_Subheading", scaleDefinition.name, qReference];
    }
    hdrsLossOfWeightOption = NSLocalizedString(buttonReference, @"");
    [hdrsLossOfWeightButton setTitle:NSLocalizedString(hdrsLossOfWeightOption, @"") forState:UIControlStateNormal];
    
    for( ItemButton *iButton in items ){
        if( [iButton isKindOfClass:[ItemButton class]] ){
            currentIndexReference = [NSString stringWithFormat:@"%@%i", baseReference, (int)iButton.index];
            iButton.titleLabel.text = NSLocalizedString(currentIndexReference, @"");
        }
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
