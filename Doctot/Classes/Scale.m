//
//  Scale.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "Scale.h"
#import "Helper.h"
#import "Question.h"

@interface Scale ()

@end

@implementation Scale

@synthesize prefs, definition, singleApp, leftNavBarButton, rightNavBarButton, interview, information, scores;
@synthesize introLabel, startHeader, titleLabel, subtitleLabel, startInterview, viewInformation, viewScores, advertiser;
@synthesize questions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = definition.displayTitle;
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(goToInformation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    introLabel.text = [Helper getLocalisedString:@"Welcome_Message" withScalePrefix:YES];
    titleLabel.text = [Helper getLocalisedString:@"FullTitle" withScalePrefix:YES];
    subtitleLabel.text = [Helper getLocalisedString:@"SubTag" withScalePrefix:YES];
 
    [startInterview setTitle:[Helper getLocalisedString:@"Scale_Start" withScalePrefix:NO] forState:UIControlStateNormal];
    [viewInformation setTitle:[Helper getLocalisedString:@"Scale_Info" withScalePrefix:NO] forState:UIControlStateNormal];
    [viewScores setTitle:[Helper getLocalisedString:@"Scale_Score" withScalePrefix:NO] forState:UIControlStateNormal];
    
    // Settings.plist Advertiser option decides if this is visible
    if( ![(NSString *)[Helper returnValueForKey:@"Advertiser"] isEqualToString:@"Visible"] ) {
        advertiser.hidden = YES;
    }
    
    //[self createQuestions];
    questions = [Helper createCurrentScaleQuestions];
    /*
    UIImage *updatedSponsorImage = [Helper getSponsorshipImageFor:@"startHeader"];
    if( updatedSponsorImage != nil ){
        startHeader.image = updatedSponsorImage;
    }
    */
    startHeader.image = [Helper readSponsorshipImageFromDocuments:@"startHeader"];
}

- (void)createQuestions {
    
    int inc = 0;
    NSString *searchString;
    Question *newQuestion;
    questions = [[NSMutableArray alloc] init];
    BOOL allQuestionsFound = NO;
    while( !allQuestionsFound ) {
        inc++;
        searchString = [NSString stringWithFormat:@"Q%i", inc];
        if( [[Helper getLocalisedString:searchString withScalePrefix:YES] length] > 0 ){
            newQuestion = [[Question alloc] init];
            newQuestion.scaleDefinition = definition;
            newQuestion.index = inc;
            [newQuestion initialise];
            [questions addObject:newQuestion];
        }else{
            allQuestionsFound = YES;
        }
    }
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"interview"]){
        interview = (Interview *)segue.destinationViewController;
        interview.definition = definition;
        interview.questions = questions;
    }
    if([[segue identifier] isEqualToString:@"information"]){
        information = (Information *)segue.destinationViewController;
        information.scaleDefinition = definition;
    }
    if([[segue identifier] isEqualToString:@"scores"]){
        scores = (Scores *)segue.destinationViewController;
        scores.scaleDefinition = definition;
        scores.questions = questions;
    }
    
}

- (void)goToInformation {
    [self performSegueWithIdentifier:@"information" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

