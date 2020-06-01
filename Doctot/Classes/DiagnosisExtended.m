//
//  DiagnosisExtended.m
//  Doctot
//
//  Created by Fergal McDonnell on 03/04/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import "DiagnosisExtended.h"
#import "Helper.h"

@interface DiagnosisExtended ()

@end

@implementation DiagnosisExtended

@synthesize prefs, path, theBaseURL;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize diagnosis, scaleDefinition, score, resultString;
@synthesize scoreLabel, scoreDisplay, content;
@synthesize comView;
@synthesize currentAdviceView, optionPicker, options, optionViews, theContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    UIColor *navBarTitleColour = [Helper getColourFromString:(NSString *)[Helper returnValueForKey:@"HomeNavbarTitleColour"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navBarTitleColour, NSFontAttributeName:[UIFont fontWithName:@"helvetica" size:20]}];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.title = [Helper getLocalisedString:@"Scale_Diagnosis" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    scoreLabel.text = [Helper getLocalisedString:@"Scale_Diagnosis_Result" withScalePrefix:NO];
    scoreDisplay.text = [NSString stringWithFormat:@"%.1f", score];
    scoreDisplay.textColor = diagnosis.colour;
    scoreDisplay.backgroundColor = [Helper getBackgroundColourForText:scoreDisplay.textColor givenBackground:@"Light"];
    scoreDisplay.layer.masksToBounds = YES;
    scoreDisplay.layer.cornerRadius = 8.0;
    
    diagnosis.description = [diagnosis.description stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
    
    if( [diagnosis.description length] > 0 ){
        scoreDisplay.text = [NSString stringWithFormat:@"%@\n %@", resultString, diagnosis.description];
        
        // Adjust for larger text strings
        CGSize size = [scoreDisplay.text sizeWithAttributes:@{NSFontAttributeName:scoreDisplay.font}];
        if (size.width > scoreDisplay.bounds.size.width) {
            scoreDisplay.numberOfLines = 3;
            scoreDisplay.font = [UIFont fontWithName:@"Helvetica" size:16];
        }
    }
    
    path = [[NSBundle mainBundle] bundlePath];
    theBaseURL = [NSURL fileURLWithPath:path];
    NSString *htmlString = [NSString stringWithFormat:@"<CENTER>%@%@", [Helper getLocalisedString:@"Font" withScalePrefix:YES], diagnosis.descriptionHTML];
    [content loadHTMLString:htmlString baseURL:theBaseURL];
    
    [self adjustForAwkwardScales];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)adjustForAwkwardScales {
    
    // AINT
    if( [diagnosis.scale isEqualToString:@"AINT"] ){
        
        scoreDisplay.text = [NSString stringWithFormat:@"%@", diagnosis.description];
        
        content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, 75);
        optionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 216), self.view.frame.size.width, 216)];
        optionPicker.delegate = self;
        
        options = [[NSMutableArray alloc] init];
        int inc = 0;
        NSString *searchString;
        BOOL allSectionsFound = NO;
        while( !allSectionsFound ) {
            inc++;
            searchString = [NSString stringWithFormat:@"Therapeutic_Section%i", inc];
            if( [[Helper getLocalisedString:searchString withScalePrefix:YES] length] > 0 ){
                [options addObject:[Helper getLocalisedString:searchString withScalePrefix:YES]];
            }else{
                allSectionsFound = YES;
            }
        }
        
        optionViews = [[NSMutableArray alloc] init];
        for( int i = 0; i < [options count]; i++ ){
            [optionViews addObject:[self constructCovidAdviceView:i]];
        }
        
        currentAdviceView = (UIView *)[optionViews objectAtIndex:0];
       
        [self.view addSubview:currentAdviceView];
        [self.view addSubview:optionPicker];
        
    }
    
}

/***************************************************************************************************************************

COVID19-specific methods

***************************************************************************************************************************/

- (UIView *)constructCovidAdviceView:(int)sourceIndex {
    
    UIView *theView;
    UIImageView *topDivider, *bottomDivider;
    
    float theViewY = content.frame.origin.y + (content.frame.size.height * 2);
    float theViewHeight = self.view.frame.size.height - theViewY - optionPicker.frame.size.height;
    
    theView = [[UIView alloc] initWithFrame:CGRectMake(0, theViewY, self.view.frame.size.width, theViewHeight)];
    topDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 3)];
    topDivider.image = [UIImage imageNamed:@"table_row_middle.png"];
    bottomDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, theView.frame.size.height - 3, self.view.frame.size.width, 3)];
    bottomDivider.image = [UIImage imageNamed:@"table_row_middle.png"];
    theContent = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, theView.frame.size.width, theView.frame.size.height)];
    [theContent setBackgroundColor:[UIColor clearColor]];
    [theContent setOpaque:NO];
    
    NSString *baseTag = [NSString stringWithFormat:@"Therapeutic_Section%i_Content", sourceIndex + 1];
    NSString *htmlString = [NSString stringWithFormat:@"%@%@", [Helper getLocalisedString:@"Font" withScalePrefix:YES], [Helper getLocalisedString:baseTag withScalePrefix:YES]];
    
    NSString *additionalTag;
    if( sourceIndex == 0 ){
        NSString *combinedHTML = [self setCovidOxygenationData:1];
        htmlString = [NSString stringWithFormat:@"%@%@", [Helper getLocalisedString:@"Font" withScalePrefix:YES], combinedHTML];
    }
    if( sourceIndex == 2 ){
        additionalTag = [NSString stringWithFormat:@"%@_Group%.0f", baseTag, score];
        htmlString = [htmlString stringByAppendingFormat:@"%@", [Helper getLocalisedString:additionalTag withScalePrefix:YES]];
    }
    
    [theContent loadHTMLString:htmlString baseURL:theBaseURL];
    
    [theView addSubview:theContent];
    
    if( sourceIndex == 0 ){
        for( int i = 1; i <= 3; i++ ){
            [theView addSubview:[self createCovidOxygenationButton:i]];
        }
    }
    [theView addSubview:topDivider];
    [theView addSubview:bottomDivider];
    
    return theView;
}

- (UIButton *)createCovidOxygenationButton:(int)index {
    UIButton *theButton;
    
    NSString *titleReference = [NSString stringWithFormat:@"Therapeutic_Section1_Factor1_Option%i", index];
    theButton = [[UIButton alloc] initWithFrame:CGRectMake( ( ( index - 1 ) * (self.view.frame.size.width / 3) ) , 0, (self.view.frame.size.width / 3), 25)];
    theButton.tag = index;
    theButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [theButton setTitle:[Helper getLocalisedString:titleReference withScalePrefix:YES] forState:UIControlStateNormal];
    [theButton addTarget:self action:@selector(changeCovidOxygenationData:) forControlEvents:UIControlEventTouchUpInside];
    [theButton setBackgroundColor:[UIColor purpleColor]];
    if( index == 1 ){
        [theButton setBackgroundColor:[UIColor colorWithRed:0.58 green:0 blue:0.83 alpha:1.0]];
    }
    
    return theButton;
}

- (void)changeCovidOxygenationData:(UIButton *)optionSource {
    
    UIView *thisView = (UIView *)[optionViews objectAtIndex:0];
    
    for( WKWebView *aWebView in thisView.subviews ){
        if( [aWebView isKindOfClass:[WKWebView class]] ){
            [aWebView loadHTMLString:[self setCovidOxygenationData:(int)(optionSource.tag)] baseURL:theBaseURL];

        }
    }
    
    for( UIButton *aButton in thisView.subviews ){
        if( [aButton isKindOfClass:[UIButton class]] ){
            if( aButton.tag == optionSource.tag ){
                [aButton setBackgroundColor:[UIColor colorWithRed:0.58 green:0 blue:0.83 alpha:1.0]];
            }else{
                [aButton setBackgroundColor:[UIColor purpleColor]];
            }
        }
    }

}

- (NSString *)setCovidOxygenationData:(int)optionIndex {
    NSString *combinedHTML;
    
    NSString *fontSetup = [Helper getLocalisedString:@"Font" withScalePrefix:YES];
    NSString *baseContent = [Helper getLocalisedString:@"Therapeutic_Section1_Content" withScalePrefix:YES];
    NSString *optionSelectedHTMLReference = [NSString stringWithFormat:@"Therapeutic_Section1_Option%i", optionIndex];
    NSString *paco2 = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_PaCO2", optionSelectedHTMLReference] withScalePrefix:YES];
    NSString *target = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Target", optionSelectedHTMLReference] withScalePrefix:YES];
    NSString *titration = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Titration", optionSelectedHTMLReference] withScalePrefix:YES];
    NSString *monitoring = [Helper getLocalisedString:[NSString stringWithFormat:@"%@_Monitoring", optionSelectedHTMLReference] withScalePrefix:YES];
    combinedHTML = [fontSetup stringByAppendingFormat:baseContent, paco2, target, titration, monitoring];
    
    return combinedHTML;
}

/***************************************************************************************************************************
 
 PickerView Delegate Methods
 
 ***************************************************************************************************************************/

-(NSInteger)numberOfComponentsInPickerView:(CustomPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(CustomPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger pickerCount = 0;
    
    pickerCount = [options count];
    
    return pickerCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:aView.frame];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.text = [options objectAtIndex:row];
    
    [aView addSubview:aLabel];
    
    return aView;
    
}

- (void)pickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [currentAdviceView removeFromSuperview];
    currentAdviceView = (UIView *)[optionViews objectAtIndex:row];
    [self.view addSubview:currentAdviceView];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

