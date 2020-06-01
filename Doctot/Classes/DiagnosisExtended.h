//
//  DiagnosisExtendedn.h
//  Doctot
//
//  Created by Fergal McDonnell on 03/04/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "DiagnosisElement.h"
#import "ScaleDefinition.h"

@interface DiagnosisExtended : UIViewController <UIPickerViewDelegate> {
    
    NSUserDefaults *prefs;
    NSString *path;
    NSURL *theBaseURL;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    DiagnosisElement *diagnosis;
    ScaleDefinition *scaleDefinition;
    float score;
    NSString *resultString;
    
    UILabel *scoreLabel;
    UILabel *scoreDisplay;
    WKWebView *content;
    
    // COM Scale Specific
    UIView *comView;
    
    // AINT Scale Specific
    UIView *currentAdviceView;
    UIPickerView *optionPicker;
    NSMutableArray *options;
    NSMutableArray *optionViews;
    WKWebView *theContent;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSURL *theBaseURL;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) DiagnosisElement *diagnosis;
@property (nonatomic, retain) ScaleDefinition *scaleDefinition;
@property float score;
@property (nonatomic, retain) NSString *resultString;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreDisplay;
@property (nonatomic, retain) IBOutlet WKWebView *content;
@property (nonatomic, retain) IBOutlet UIView *comView;
@property (nonatomic, retain) IBOutlet UIView *currentAdviceView;
@property (nonatomic, retain) IBOutlet UIPickerView *optionPicker;
@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, retain) NSMutableArray *optionViews;
@property (nonatomic, retain) IBOutlet WKWebView *theContent;

@end
