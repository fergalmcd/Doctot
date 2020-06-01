//
//  ScoreSelected.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreData/CoreData.h>
#import "ScoreSelected.h"
#import "ScaleDefinition.h"
#import "DiagnosisElement.h"
#import "DiagnosisExtended.h"
#import "DataInterview.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface ScoreSelected : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate> {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    ScaleDefinition *definition;
    NSManagedObject *interviewEntity;
    DataInterview *interviewObject;
    NSInteger dtPlusID;
    NSDate *date;
    NSString *dateString;
    NSInteger patientDTPlusID;
    NSString *firstName;
    NSString *lastName;
    NSString *fullName;
    float score;
    NSString *scorePrecision;
    BOOL adjustedDimensions;
    
    DiagnosisExtended *diagnosisExtended;
    
    UILabel *dateHeading;
    UILabel *dateLabel;
    UILabel *nameHeading;
    UILabel *nameLabel;
    UILabel *scoreHeading;
    WKWebView *scoreOutput;
    DiagnosisElement *diagnosisCategory;
    NSString *iconName;
    UIImageView *category;
    UIButton *categoryExpand;
    UIImageView *categoryExpandChevron;
    
    UIScrollView *details;
    UIView *detailsView;
    
    UIButton *emailScore;
    UIButton *deleteScore;
    
    NSMutableArray *questions;
    NSMutableArray *questionResults;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) ScaleDefinition *definition;
@property (nonatomic, retain) NSManagedObject *interviewEntity;
@property (nonatomic, retain) DataInterview *interviewObject;
@property NSInteger dtPlusID;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateString;
@property NSInteger patientDTPlusID;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *fullName;
@property float score;
@property (nonatomic, retain) NSString *scorePrecision;
@property BOOL adjustedDimensions;
@property (nonatomic, retain) IBOutlet DiagnosisExtended *diagnosisExtended;
@property (nonatomic, retain) IBOutlet UILabel *dateHeading;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameHeading;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreHeading;
@property (nonatomic, retain) IBOutlet WKWebView *scoreOutput;
@property (nonatomic, retain) DiagnosisElement *diagnosisCategory;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) IBOutlet UIImageView *category;
@property (nonatomic, retain) IBOutlet UIButton *categoryExpand;
@property (nonatomic, retain) IBOutlet UIImageView *categoryExpandChevron;
@property (nonatomic, retain) IBOutlet UIScrollView *details;
@property (nonatomic, retain) IBOutlet UIView *detailsView;
@property (nonatomic, retain) IBOutlet UIButton *emailScore;
@property (nonatomic, retain) IBOutlet UIButton *deleteScore;
@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) NSMutableArray *questionResults;

- (void)setupScore:(ScoreSelected *)senderScore;
- (void)determineScoreCatgory;


@end
