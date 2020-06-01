//
//  ItemSelector.m
//  Doctot
//
//  Created by Fergal McDonnell on 25/06/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "ItemSelector.h"
#import "Helper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"

/***************************************************************************************************************************

 
***************************************************************************************************************************/

@implementation ItemSelector

@synthesize delegate, itemStructure, questionStructure, index, scaleName, status, actualValue, score, diagnosisElements, selectorButtons, receiverBundles;
@synthesize heading, iconImage, firstTopBundle, firstLeftBundle, firstRightBundle, numberOfTopBundles, numberOfLeftBundles, numberOfRightBundles, maxColumns, maxRows;

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
    self.frame = CGRectMake(0, (index * SELECTOR_HEIGHT), questionDimensions.width, SELECTOR_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    if( [itemStructure.subtype isEqualToString:@"Linear"] || [itemStructure.subtype isEqualToString:@"Grid"] || [itemStructure.subtype isEqualToString:@"Card"] ){
        
        // Setup the dementsions of the Swiper (gathered from the scaleDefinitions.json settings via itemStructure [ItemStructure])
        [self defineDementions];
        
        // Initialisation of all bundles which RECEIVE buttons
        [self configureBundles];
        
        // Initialisation of all draggable/swipable buttons
        [self configureButtons];
        
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
    
    
    // Selector Bundles //////////////////////////////////////////////////////////////////////////////////////////
    
    receiverBundles = [[NSMutableArray alloc] init];
    SelectorBundle *selectorBundle;
    NSDictionary *selectorBundleDictionary;
    for(id key in itemStructure.bundles ){
        selectorBundle = [[SelectorBundle alloc] init];
        
        selectorBundleDictionary = [itemStructure.bundles valueForKey:key];
        
        selectorBundle = [[SelectorBundle alloc] init];
        selectorBundle.scaleName = scaleName;
        selectorBundle.questionIndex = (int)questionStructure.index;
        selectorBundle.parentIndex = (int)index;
        [selectorBundle setupWithKey:key andDictionary:selectorBundleDictionary andParentType:itemStructure.subtype];
        
        [receiverBundles addObject:selectorBundle];
    }
    
    receiverBundles = [Helper sortedArray:receiverBundles byIndex:@"order" andAscending:YES];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // Selector Buttons //////////////////////////////////////////////////////////////////////////////////////////
    selectorButtons = [[NSMutableArray alloc] init];
    SelectorButton *selectorButton;
    NSDictionary *selectorButtonDictionary;
    for(id key in itemStructure.selectorButtons ){
        selectorButton = [[SelectorButton alloc] init];

        selectorButtonDictionary = [itemStructure.selectorButtons valueForKey:key];

        selectorButton = [[SelectorButton alloc] init];
        selectorButton.scaleName = scaleName;
        selectorButton.questionIndex = (int)questionStructure.index;
        selectorButton.parentIndex = (int)index;
        [selectorButton setupWithKey:key andDictionary:selectorButtonDictionary andParentType:itemStructure.subtype];
        [selectorButton configureGridPosition:(int)[itemStructure.selectorButtons count]];
        
        [selectorButtons addObject:selectorButton];
    }
    
    selectorButtons = [[NSMutableArray alloc] initWithArray:[Helper sortedArray:selectorButtons byIndex:@"order" andAscending:YES]];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}


/***************************************************************************************************************************
 
- (void)configureBundles
 
***************************************************************************************************************************/

- (void)configureBundles {
    
    NSString *itemReference = [NSString stringWithFormat:@"%@_Q%li_Item%li", scaleName, questionStructure.index, index];
    
    iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(((self.frame.size.width - SELECTOR_BUNDLE_HEIGHT) / 2), 0, SELECTOR_BUNDLE_HEIGHT, SELECTOR_BUNDLE_HEIGHT)];
    iconImage.image = [UIImage imageNamed:@"selector_button_icon.png"];
    [self addSubview:iconImage];
    
    // Get the number of bundles in each position
    numberOfTopBundles = 0;
    numberOfLeftBundles = 0;
    numberOfRightBundles = 0;
    for( SelectorBundle *aView in receiverBundles ){
        if( [aView.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_TOP] ){
            numberOfTopBundles++;
        }
        if( [aView.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_LEFT] ){
            numberOfLeftBundles++;
        }
        if( [aView.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
            numberOfRightBundles++;
        }
    }
    
    // Set the dimensions for each bundles
    float originX = 0.0, originY = 0.0, bundleWidth = 0.0, bundleHeight = 0.0;
    for( SelectorBundle *aView in receiverBundles ){
        if( [aView.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_TOP] ){
            bundleHeight = SELECTOR_BUNDLE_HEIGHT;
            bundleWidth = ( self.frame.size.width - (SELECTOR_BUNDLE_WIDTH * 2) ) / numberOfTopBundles;
            originX = SELECTOR_BUNDLE_WIDTH + (bundleWidth * (aView.order - 1));
            originY = 0.0;
            if( aView.order == 1 ){
                firstTopBundle = aView;
            }
            iconImage.frame = CGRectMake(0, 0, SELECTOR_BUNDLE_HEIGHT, SELECTOR_BUNDLE_HEIGHT);
        }
        if( [aView.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_LEFT] ){
            bundleHeight = (self.frame.size.height - (SELECTOR_BUNDLE_HEIGHT * 2) ) / numberOfLeftBundles;
            if( numberOfTopBundles == 0 ){
                bundleHeight += SELECTOR_BUNDLE_HEIGHT;
            }
            bundleWidth = SELECTOR_BUNDLE_WIDTH;
            originX = 0.0;
            originY = SELECTOR_BUNDLE_HEIGHT + (bundleHeight * (aView.order - 1));
            if( aView.order == 1 ){
                firstLeftBundle = aView;
            }
        }
        if( [aView.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
            bundleHeight = (self.frame.size.height  - (SELECTOR_BUNDLE_HEIGHT * 2) ) / numberOfRightBundles;
            if( numberOfTopBundles == 0 ){
                bundleHeight += SELECTOR_BUNDLE_HEIGHT;
            }
            bundleWidth = SELECTOR_BUNDLE_WIDTH;
            originX = self.frame.size.width - bundleWidth;
            originY = SELECTOR_BUNDLE_HEIGHT + (bundleHeight * (aView.order - 1));
            if( aView.order == 1 ){
                firstRightBundle = aView;
            }
        }
        aView.frame = CGRectMake(originX, originY, bundleWidth, bundleHeight);
        [aView configureInterface];
        
        [self addSubview:aView];
    }
    
}


/***************************************************************************************************************************
 
- (void)configureButtons
 
***************************************************************************************************************************/

- (void)configureButtons {
    
    for( SelectorButton *aButton in selectorButtons ){
        
        maxColumns = [aButton calculateMaxXSize:(int)[selectorButtons count]];
        maxRows = (int)([selectorButtons count] / maxColumns);
        
        [self configureSelectorButtonDimensions:aButton];
        [aButton configureInterface];
        [self addSubview:aButton];
        
        // Drag
        UIPanGestureRecognizer *panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        
        // Swipe Top
        UISwipeGestureRecognizer *swipeTopGesture;
        swipeTopGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Swipe Left
        UISwipeGestureRecognizer *swipeLeftGesture;
        swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [swipeLeftGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
        // Swipe Right
        UISwipeGestureRecognizer *swipeRightGesture;
        swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [swipeRightGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
        
        // Long Press
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        
        
        /* Single Tap
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        singleTapGestureRecognizer.enabled = YES;
        singleTapGestureRecognizer.cancelsTouchesInView = NO;
        [aButton addGestureRecognizer:singleTapGestureRecognizer];
        */
        
        if( numberOfTopBundles <= 1 ){
            [aButton addGestureRecognizer:swipeTopGesture];
        }else{
            [aButton addGestureRecognizer:panGestureRecognizer];
        }
        
        if( numberOfLeftBundles <= 1 ){
            [aButton addGestureRecognizer:swipeLeftGesture];
        }else{
            [aButton addGestureRecognizer:panGestureRecognizer];
        }
        
        if( numberOfRightBundles <= 1 ){
            [aButton addGestureRecognizer:swipeRightGesture];
        }else{
            [aButton addGestureRecognizer:panGestureRecognizer];
        }
        
        [aButton addGestureRecognizer:longPressGestureRecognizer];
        
        //[panGestureRecognizer requireGestureRecognizerToFail:singleTapGestureRecognizer];
        [panGestureRecognizer requireGestureRecognizerToFail:swipeLeftGesture];
        [panGestureRecognizer requireGestureRecognizerToFail:swipeRightGesture];
        
    }
    
    //
    if( [itemStructure.subtype isEqualToString:@"Card"] ){
        
        SelectorButton *thisSelectorButton;
        for( int i = (int)[selectorButtons count] - 1; i >= 0; i-- ){
            thisSelectorButton = (SelectorButton *)[selectorButtons objectAtIndex:i];
            [self bringSubviewToFront:thisSelectorButton];
        }
        
    }
    
}

- (void)configureSelectorButtonDimensions:(SelectorButton *)theButton {
    float originX = 0.0, originY = 0.0, buttonWidth = 0.0, buttonHeight = 0.0;
    
    buttonHeight = (self.frame.size.height - (SELECTOR_BUNDLE_HEIGHT * 2) ) / maxRows;
    buttonWidth = (self.frame.size.width - (SELECTOR_BUNDLE_WIDTH * 2) ) / maxColumns;
    buttonHeight = buttonWidth;
    originX = SELECTOR_BUNDLE_WIDTH + (buttonWidth * theButton.gridPosition.x);
    originY = SELECTOR_BUNDLE_HEIGHT + (buttonHeight * theButton.gridPosition.y);
    
    theButton.frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
    
    if( [itemStructure.subtype isEqualToString:@"Linear"]  ){
        buttonHeight = (self.frame.size.height - SELECTOR_BUNDLE_HEIGHT) / [itemStructure.selectorButtons count];
        originY = SELECTOR_BUNDLE_HEIGHT + (buttonHeight * theButton.gridPosition.y);
        theButton.frame = CGRectMake(theButton.frame.origin.x, originY, theButton.frame.size.width, buttonHeight);
    }
    
    if( [itemStructure.subtype isEqualToString:@"Card"]  ){
        float cardOffsetIncrement = 2.0;
        float orderPosition = theButton.order - ((int)[selectorButtons count] / 2);
        float calculatedOffset = orderPosition * cardOffsetIncrement;
        theButton.frame = CGRectMake(theButton.frame.origin.x + calculatedOffset, theButton.frame.origin.y + ( (SELECTOR_HEIGHT - theButton.frame.origin.y) / 4 ) + calculatedOffset, theButton.frame.size.width, theButton.frame.size.height);
    }
    
}

- (SelectorBundle *)returnParentSelectorBundleforSelectorButton:(SelectorButton *)sourceButton {
    SelectorBundle *theParentSelectorBundle;
    
    for( SelectorBundle *thisBundle in receiverBundles ){
        if( ( thisBundle.positionOnScreen == sourceButton.canvas ) &&  ( thisBundle.order == sourceButton.canvasIndex ) ){
            theParentSelectorBundle = thisBundle;
        }
    }
    
    return theParentSelectorBundle;
}

- (void)returnSelectorButton:(SelectorButton *)theButton fromSelectorBundle:(SelectorBundle *)theBundle {
    
    // Left Swipe on a SelectorButton from a SelectorBundle (Needed for the animation which follows)
    if( ( [itemStructure.subtype isEqualToString:@"Card"] ) && ( theBundle == firstLeftBundle ) ){
        theButton.frame = CGRectMake(self.frame.size.width, theButton.frame.origin.y, theButton.frame.size.width, theButton.frame.size.height);
    }
    if( ( [itemStructure.subtype isEqualToString:@"Linear"] || [itemStructure.subtype isEqualToString:@"Grid"] ) && ( theBundle == firstRightBundle ) ){
        theButton.frame = CGRectMake(self.frame.size.width, theButton.frame.origin.y, theButton.frame.size.width, theButton.frame.size.height);
    }
    
    // Animate
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    theButton.canvas = SELECTOR_BUNDLE_CANVAS_NONE;
    theButton.canvasIndex = 0;
    [theBundle removeSelectorButton:theButton];
    
    for( SelectorBundle *sBundle in receiverBundles  ){
        for( SelectorButton *sButton in sBundle.selectorButtons ){
            if( sButton == theButton ){
                [sBundle removeSelectorButton:theButton];
            }
        }
    }
    
    [self configureSelectorButtonDimensions:theButton];
    [theButton drawInterface];
    [theButton.subHeading setHidden:NO];
    [self addSubview:theButton];
    [theButton clearExpandedDetails];
    
    [UIView commitAnimations];

}

- (void)removeSelectorButtonFromCentre:(SelectorButton *)removedButton {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for( SelectorButton *aButton in selectorButtons ){
        if( [aButton isKindOfClass:[SelectorButton class]] ){
            if( aButton != removedButton ){
                [tempArray addObject:aButton];
            }
        }
    }
    selectorButtons = tempArray;
    
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    SelectorButton *currentSelectorButton = (SelectorButton *)swipeGestureRecognizer.view;
    
    // Swipe Top
    if( swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp ){
        if( ![currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_TOP] ){
            NSLog(@"Swipe Top: %li (%@)", currentSelectorButton.order, currentSelectorButton.canvas);
            if( [currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_NONE] ){
                [firstTopBundle addSelectorButton:currentSelectorButton];
                [self removeSelectorButtonFromCentre:currentSelectorButton];
            }else{
                // Return to Unassigned section
                NSLog(@"Swipe back to centre");
                [self returnSelectorButton:currentSelectorButton fromSelectorBundle:firstTopBundle];
            }
        }
    }
    
    // Swipe Left
    if( swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ){        
        if( ![currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_LEFT] ){
            NSLog(@"Swipe Left: %li (%@)", currentSelectorButton.order, currentSelectorButton.canvas);
            if( [currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_NONE] ){
                [firstLeftBundle addSelectorButton:currentSelectorButton];
                [self removeSelectorButtonFromCentre:currentSelectorButton];
            }else{
                // Return to Unassigned section
                NSLog(@"Swipe back to centre");
                [self returnSelectorButton:currentSelectorButton fromSelectorBundle:firstLeftBundle];
            }
        }
    }
    
    // Swipe Right
    if( swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight ){
        if( ![currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
            NSLog(@"Swipe Right: %li (%@)", currentSelectorButton.order, currentSelectorButton.canvas);
            if( [currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_NONE] ){
                [firstRightBundle addSelectorButton:currentSelectorButton];
                [self removeSelectorButtonFromCentre:currentSelectorButton];
            }else{
                // Return to Unassigned section
                NSLog(@"Swipe back to centre");
                [self returnSelectorButton:currentSelectorButton fromSelectorBundle:firstRightBundle];
            }
        }
    }
    
    [self calculateScore];
    /*
    for( SelectorButton *sButton in firstLeftBundle.selectorButtons ){
        NSLog(@"Left Heading: %@", sButton.heading.text);
    }
    for( SelectorButton *sButton in firstRightBundle.selectorButtons ){
        NSLog(@"Right Heading: %@", sButton.heading.text);
    }
    for( SelectorButton *sButton in selectorButtons ){
        NSLog(@"Centre Heading: %@", sButton.heading.text);
    }
    */
}


-(void)handleDrag:(UIPanGestureRecognizer *)panGestureRecognizer {
    SelectorButton *currentSelectorButton = (SelectorButton *)panGestureRecognizer.view;
    
    CGPoint touchLocation = [panGestureRecognizer locationInView:self];
    currentSelectorButton.center = touchLocation;
    
    [self bringSubviewToFront:currentSelectorButton];
    float dragSensitivity = 0.75;
    
    // Only allows execution if drag has ended
    if(panGestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    // If SelectorButton currently resides unnassigned, associated with no SelectorBundle
    if( [currentSelectorButton.canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_NONE] ){
        for( SelectorBundle *thisBundle in receiverBundles ){
            if( ( currentSelectorButton.center.x > thisBundle.frame.origin.x ) &&  ( currentSelectorButton.center.y > thisBundle.frame.origin.y ) &&
                ( currentSelectorButton.center.x <= (thisBundle.frame.origin.x + thisBundle.frame.size.width) ) && ( currentSelectorButton.center.y <= (thisBundle.frame.origin.y + thisBundle.frame.size.height) )
               ){
                [thisBundle addSelectorButton:currentSelectorButton];
                [self removeSelectorButtonFromCentre:currentSelectorButton];
                [self calculateScore];
                return;
            }
        }
    }
    
    SelectorBundle *parentBundle = [self returnParentSelectorBundleforSelectorButton:currentSelectorButton];
    
    // If SelectorButton currently resides in a TOP SelectorBundle
    if( [parentBundle.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_TOP] ){
        if( currentSelectorButton.frame.origin.y < 0 ){
            currentSelectorButton.frame = CGRectMake(currentSelectorButton.frame.origin.x, 0, currentSelectorButton.frame.size.width, currentSelectorButton.frame.size.height);
        }
        if( currentSelectorButton.center.y < (parentBundle.frame.size.height * (dragSensitivity - 1)) ){
            [self returnSelectorButton:currentSelectorButton fromSelectorBundle:parentBundle];
        }
        
    }
    
    // If SelectorButton currently resides in a LEFT SelectorBundle
    if( [parentBundle.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_LEFT] ){
        if( currentSelectorButton.frame.origin.x < 0 ){
            currentSelectorButton.frame = CGRectMake(0, currentSelectorButton.frame.origin.y, currentSelectorButton.frame.size.width, currentSelectorButton.frame.size.height);
        }
        if( currentSelectorButton.center.x > (parentBundle.frame.size.width * dragSensitivity) ){
            [self returnSelectorButton:currentSelectorButton fromSelectorBundle:parentBundle];
        }
        
    }
    
    // If SelectorButton currently resides in a RIGHT SelectorBundle
    if( [parentBundle.positionOnScreen isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
        if( currentSelectorButton.frame.origin.x > 0 ){
            currentSelectorButton.frame = CGRectMake(0, currentSelectorButton.frame.origin.y, currentSelectorButton.frame.size.width, currentSelectorButton.frame.size.height);
        }
        if( currentSelectorButton.center.x < (parentBundle.frame.size.width * (dragSensitivity - 1)) ){
            [self returnSelectorButton:currentSelectorButton fromSelectorBundle:parentBundle];
        }
        
    }
    
    [self calculateScore];
    
}

-(void)handleSingleTap:(UIPanGestureRecognizer *)singleTapGestureRecognizer {
    SelectorButton *currentSelectorButton = (SelectorButton *)singleTapGestureRecognizer.view;
}

- (void)handleLongPress:(UIPanGestureRecognizer *)longPressGestureRecognizer  {
    SelectorButton *currentSelectorButton = (SelectorButton *)longPressGestureRecognizer.view;
    [self bringSubviewToFront:currentSelectorButton];
    [currentSelectorButton.externalDescription bringSubviewToFront:currentSelectorButton];
    
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded ) {
        [currentSelectorButton clearExpandedDetails];
    }
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan ){
        [currentSelectorButton showExpandedDetails];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 
}

- (void)clearAnyExpandedDetails {
    
    for( SelectorButton *aButton in selectorButtons ){
        [aButton clearExpandedDetails];
    }
    
}

/***************************************************************************************************************************
 
 SCORING
 
***************************************************************************************************************************/

- (void)calculateScore {

    score = 0;
    for( SelectorBundle *thisBundle in receiverBundles ){
        for( SelectorButton *thisButton in thisBundle.selectorButtons ){
            score += thisBundle.receiverScore * thisButton.onScore;
        }
    }
    
    [delegate updateItemSelector:self]; // ItemSelectorDelegate calls - (void)updateItemSelector:(ItemSelector *)theSelector in Question class
}

- (void)resetSelector {
    
    status = BUTTON_STATE_DEFAULT;
    score = itemStructure.defaultScore;
    actualValue = score;
    
    for( SelectorBundle *thisBundle in receiverBundles ){
        for( SelectorButton *thisButton in thisBundle.selectorButtons ){
            [self returnSelectorButton:thisButton fromSelectorBundle:thisBundle];
        }
    }
    
    /* Brings the lower index options to the top of the deck
    NSInteger arrangementIndex = [selectorButtons count];
    while( arrangementIndex > 0 ){
        for( SelectorButton *thisButton in selectorButtons ){
            NSLog(@"arrangementIndex : %li   order: %li", arrangementIndex, thisButton.order);
            if( thisButton.order == arrangementIndex ){
                [self bringSubviewToFront:thisButton];
                NSLog(@"In");
            }
        }
        arrangementIndex--;
    }
    */
    
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
