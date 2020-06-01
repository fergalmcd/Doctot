//
//  ScoreSelected.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "ScoreSelected.h"
#import "Helper.h"
#import "Constants.h"

@interface ScoreSelected ()

@end

@implementation ScoreSelected

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize definition, interviewEntity, interviewObject, dtPlusID, date, dateString, patientDTPlusID, firstName, lastName, fullName, score, scorePrecision, adjustedDimensions;
@synthesize dateHeading, dateLabel, nameHeading, nameLabel, scoreHeading, scoreOutput, diagnosisCategory, iconName, category, categoryExpand, categoryExpandChevron, diagnosisExtended, details, detailsView, emailScore, deleteScore, questions, questionResults;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Scale_Score" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    if( [Helper isiPad] ){
        rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
        [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    prefs = [NSUserDefaults standardUserDefaults];
    questions = [Helper createCurrentScaleQuestions];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    
    UIColor *detailsTextColour = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    dateHeading.textColor = detailsTextColour;
    dateLabel.textColor = detailsTextColour;
    nameHeading.textColor = detailsTextColour;
    nameLabel.textColor = detailsTextColour;
    scoreHeading.textColor = detailsTextColour;
    
    dateHeading.text = [Helper getLocalisedString:@"Scale_Score_Date" withScalePrefix:NO];
    nameHeading.text = [Helper getLocalisedString:@"Scale_Score_Name" withScalePrefix:NO];
    scoreHeading.text = [Helper getLocalisedString:@"Scale_Score_Score" withScalePrefix:NO];
    
    dateLabel.text = dateString;
    nameLabel.text = fullName;
    [scoreOutput loadHTMLString:[self formatScoreDisplay] baseURL:theBaseURL];
    category.image = [UIImage imageNamed:iconName];
    
    detailsView.frame = CGRectMake(0, 0, self.view.frame.size.width, ([questions count] * QUESTION_SPACE_HEIGHT));
    if( [Helper isiPad] ){
        detailsView.frame = CGRectMake(categoryExpand.frame.origin.x, detailsView.frame.origin.y, detailsView.frame.size.width, detailsView.frame.size.height);
    }
    [details addSubview:detailsView];
    details.contentSize = CGSizeMake(detailsView.frame.size.width, detailsView.frame.size.height);
    
    [emailScore setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [emailScore setBackgroundImage:[UIImage imageNamed:@"email_barbutton.png"] forState:UIControlStateNormal];
    [deleteScore setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [deleteScore setBackgroundImage:[UIImage imageNamed:@"delete_barbutton.png"] forState:UIControlStateNormal];
    
    CGSize questionDimensions = [Helper getInterviewQuestionDimensions];
    scorePrecision = [NSString stringWithFormat:@"%%.%lif", (long)definition.precision];
    float PADDING = 20;
    float QUESTIONLABEL_WIDTH = ( (questionDimensions.width - (2 * PADDING)) * 0.8 );
    float SCOREQUESTIONLABEL_WIDTH = (questionDimensions.width - (2 * PADDING)) - QUESTIONLABEL_WIDTH;
    
    // iPad Adjustment
    float detailsViewXAdjustment = 0;
    if( [Helper isiPad] && adjustedDimensions ){
        QUESTIONLABEL_WIDTH -= 300;
        detailsViewXAdjustment = 50;
    }
    
    if( [diagnosisCategory.descriptionHTML length] == 0 ){
        categoryExpandChevron.hidden = YES;
    }else{
        categoryExpandChevron.hidden = NO;
    }
    
    for( UILabel *aLabel in [detailsView subviews] ){
        [aLabel removeFromSuperview];
    }
    
    NSString *questionReference;
    for( Question *aQuestion in questions ){
        
        // Set the question's score
        for( NSManagedObject *aQuestionResult in questionResults ){
            if( [[aQuestionResult valueForKey:@"index"] integerValue] == aQuestion.index ){
                aQuestion.selectedItemIdenifier = [[aQuestionResult valueForKey:@"item"] integerValue];
                aQuestion.score = [[aQuestionResult valueForKey:@"score"] floatValue];
                aQuestion.answerCustomInformation = [aQuestionResult valueForKey:@"customInformation"];
            }
        }
        
        // Set up the score box
        UIButton *expandButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ((aQuestion.index - 1) * QUESTION_SPACE_HEIGHT), self.view.frame.size.width, QUESTION_SPACE_HEIGHT)];
        expandButton.tag = aQuestion.index;
        [expandButton addTarget:self action:@selector(expandQuestion:) forControlEvents:UIControlEventTouchUpInside];
        [detailsView addSubview:expandButton];
        
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, expandButton.frame.origin.y, QUESTIONLABEL_WIDTH, QUESTION_SPACE_HEIGHT)];
        questionReference = [Helper getLocalisedString:aQuestion.qReference withScalePrefix:YES];
        questionLabel.text = [NSString stringWithFormat:@"%li. %@", (long)aQuestion.index, questionReference];
        questionLabel.textColor = detailsTextColour;
        questionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        questionLabel.numberOfLines = 3;
        [detailsView addSubview:questionLabel];
        
        UILabel *questionScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake( (questionLabel.frame.origin.x + questionLabel.frame.size.width), expandButton.frame.origin.y, SCOREQUESTIONLABEL_WIDTH, QUESTION_SPACE_HEIGHT)];
        questionScoreLabel.text = [NSString stringWithFormat:scorePrecision, aQuestion.score];
        questionScoreLabel.textColor = detailsTextColour;
        questionScoreLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        questionScoreLabel.textAlignment = NSTextAlignmentCenter;
        questionScoreLabel.numberOfLines = 3;
        [detailsView addSubview:questionScoreLabel];
        
        float chevronWidth = questionLabel.frame.size.height / 2;
        UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake( (questionScoreLabel.frame.origin.x + questionScoreLabel.frame.size.width), questionScoreLabel.frame.origin.y, chevronWidth, questionScoreLabel.frame.size.height)];
        chevron.image = [UIImage imageNamed:@"chevron_white_right.png"];
        chevron.contentMode = UIViewContentModeCenter;
        [detailsView addSubview:chevron];
        
        UIImageView *underline = [[UIImageView alloc] initWithFrame:CGRectMake(questionLabel.frame.origin.x, (questionLabel.frame.origin.y + questionLabel.frame.size.height - 2), (questionLabel.frame.size.width + questionScoreLabel.frame.size.width + chevronWidth), 2)];
        underline.image = [UIImage imageNamed:@"content.png"];
        underline.alpha = 0.3;
        [detailsView addSubview:underline];
        
        detailsView.frame = CGRectMake( (detailsView.frame.origin.x - detailsViewXAdjustment), detailsView.frame.origin.y, detailsView.frame.size.width, detailsView.frame.size.height);
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)setupScore:(ScoreSelected *)senderScore {
    
    dtPlusID = senderScore.dtPlusID;
    date = senderScore.date;
    dateString = [Helper convertDateToString:date forStyle:@"Numeric"];
    patientDTPlusID = senderScore.patientDTPlusID;
    firstName = senderScore.firstName;
    lastName = senderScore.lastName;
    fullName = senderScore.fullName;
    score = senderScore.score;
    
    definition = senderScore.definition;
    interviewEntity = senderScore.interviewEntity;
    interviewObject = senderScore.interviewObject;
    
    questionResults = senderScore.questionResults;
    
    [self determineScoreCatgory];
}

- (void)determineScoreCatgory {
    
    diagnosisCategory = [[DiagnosisElement alloc] init];
    diagnosisCategory.scale = definition.name;
    diagnosisCategory.name = @"Black";
    diagnosisCategory.minScore = -1000000;
    for( DiagnosisElement *dElement in definition.diagnosisLevels ){
        if( dElement.minScore <= score ){
            diagnosisCategory = dElement;
        }
    }
    
    // Set the Category icon
    iconName = [NSString stringWithFormat:@"orb_%@.png", [diagnosisCategory.colourString lowercaseString]];
    category.image = [UIImage imageNamed:iconName];
    category.backgroundColor = diagnosisCategory.colour;
    
}

- (IBAction)displayExtendedDiagnosis {
    
    if( [diagnosisCategory.descriptionHTML length] > 0 ){
        [self performSegueWithIdentifier:@"scoreDiagnosisExtended" sender:definition];
    }
    
}

- (void)expandQuestion:(UIButton *)sourceQuestion {
    
    Question *expandedQuestion = (Question *)[questions objectAtIndex:(sourceQuestion.tag - 1)];
    
    NSString *theTitle = [Helper getLocalisedString:expandedQuestion.qReference withScalePrefix:YES];
    
    if( [Helper isiPad] ){
        UIButton *expandView = [Helper customAlertControllerForiPadWithHeading:theTitle andMessage:[self buildScoreDescription:expandedQuestion]];
        [expandView addTarget:self action:@selector(dismissExpandedView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:expandView];
    }else{
        UIAlertController *expandAlert = [Helper defaultAlertController:self withHeading:theTitle andMessage:[self buildScoreDescription:expandedQuestion] includeCancel:YES];
        [self presentViewController:expandAlert animated:YES completion:nil];
    }
    
}

- (void)dismissExpandedView:(UIButton *)source {
    
    [source removeFromSuperview];
    
}

- (NSString *)formatScoreDisplay {
    
    NSString *theFormat;
    NSString *htmlFormat;
    
    if( [[Helper returnValueForKey:@"TextColourForTransparentBackground"] isEqualToString:@"White"] ){
        htmlFormat = @"<CENTER><B><p style='font-size:16pt font-family:Helvetica; color:#FFFFFF;'>";
    }else{
        htmlFormat = @"<CENTER><B><p style='font-size:16pt font-family:Helvetica; color:#000000;'>";
    }
    
    if( [diagnosisCategory.description length] > 0 ){
        theFormat = [NSString stringWithFormat:@"%@%.1f<BR>%@", htmlFormat, score, diagnosisCategory.description];
        if( [theFormat containsString:@".0<BR>"] ){
            theFormat = [NSString stringWithFormat:@"%@%.0f<BR>%@", htmlFormat, score, diagnosisCategory.description];
        }
        theFormat = [self adjustForAwkwardScales:theFormat withHTML:htmlFormat];
    }else{
        theFormat = [NSString stringWithFormat:@"%@%@", htmlFormat, diagnosisCategory.name];
    }
    
    return theFormat;
}

- (NSString *)adjustForAwkwardScales:(NSString *)inputFormat withHTML:(NSString *)html {
    NSString *newFormat = inputFormat;
    
    if( [definition.name isEqualToString:@"COM"] ){
        newFormat = [NSString stringWithFormat:@"%@%@<BR>%@", html, diagnosisCategory.name, diagnosisCategory.description];
    }
    
    if( [definition.name isEqualToString:@"CACH"] ){
        NSString *theUnits = @"";
        int theIndex = 0;
        for( NSManagedObject *aQuestion in questionResults ){
            theIndex = (int)[[aQuestion valueForKey:@"index"] integerValue];
            if( theIndex == 1 ){
                theUnits = [aQuestion valueForKey:@"customInformation"];
            }
        }
        if( [theUnits containsString:@"mmol/L"] ){
            newFormat = [NSString stringWithFormat:@"%@%.1f mg/dL (%.2f mmol/L)<BR>%@", html, score, (score / 4), diagnosisCategory.description];
        }else{
            newFormat = [NSString stringWithFormat:@"%@%.1f mg/dL<BR>%@", html, score, diagnosisCategory.description];
        }
    }
    
    return newFormat;
}



- (NSString *)buildScoreDescription:(Question *)sourceQuestion {
    NSString *theMessage;
    
    NSString *theScoreMessage = [NSString stringWithFormat:scorePrecision, sourceQuestion.score];
    
    if( ( [sourceQuestion.answerCustomInformation length] == 0 ) || ( [sourceQuestion.answerCustomInformation containsString:@"(null)"] ) ){
        theMessage = theScoreMessage;
    }else{
        theMessage = [NSString stringWithFormat:@"%@ (%@)", theScoreMessage, sourceQuestion.answerCustomInformation];
    }
    
    return theMessage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"scoreDiagnosisExtended"]){
        
        diagnosisExtended = (DiagnosisExtended *)segue.destinationViewController;
        diagnosisExtended.diagnosis = diagnosisCategory;
        diagnosisExtended.scaleDefinition = definition;
        diagnosisExtended.score = score;
        diagnosisExtended.resultString = diagnosisCategory.name;
        
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Email Methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)generateEmail {
    
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    NSArray *recipients = [NSArray arrayWithObject:[prefs stringForKey:@"Email"]];
    NSString *theSubject = [NSString stringWithFormat:@"%@ %@ %@", definition.displayTitle, [Helper getLocalisedString:@"Email_Subject" withScalePrefix:NO], fullName];
    NSString *theMessageBody = [self createEmailBody];
    
    [composeVC setToRecipients:recipients];
    [composeVC setSubject:theSubject];
    [composeVC setMessageBody:theMessageBody isHTML:NO];
    
    // Present the view controller modally.
    if( composeVC != nil ){
        [self presentViewController:composeVC animated:YES completion:nil];
    }
    
}

- (NSString *)createEmailBody {
    NSString *emailBody = @"";
    
    if( [diagnosisCategory.description length] > 0 ){
        if( [definition.name isEqualToString:@"COM"] ){
            emailBody = [emailBody stringByAppendingFormat:@"%@: %@ (%@)\n\n", [Helper getLocalisedString:@"Scale_Diagnosis_Result" withScalePrefix:NO], diagnosisCategory.name, [diagnosisCategory formatDescriptionForObjectiveC]];
        }else{
            emailBody = [emailBody stringByAppendingFormat:@"%@: %.1f (%@)\n\n", [Helper getLocalisedString:@"Scale_Diagnosis_Result" withScalePrefix:NO], score, [diagnosisCategory formatDescriptionForObjectiveC]];
        }
    }else{
        emailBody = [emailBody stringByAppendingFormat:@"%@: %.1f\n\n", [Helper getLocalisedString:@"Scale_Diagnosis_Result" withScalePrefix:NO], score];
    }
    
    for( Question *aQuestion in questions ){
        emailBody = [emailBody stringByAppendingFormat:@"%@ = %@\n", aQuestion.title, [self buildScoreDescription:aQuestion]];
    }
    
    return emailBody;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Delete Methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)deleteSelectedScoreAction {
    
    UIAlertController *deleteAlert = [Helper defaultAlertController:self withHeading:[Helper getLocalisedString:@"Delete_InterviewHeading" withScalePrefix:NO] andMessage:[Helper getLocalisedString:@"Delete_InterviewMessage" withScalePrefix:NO] includeCancel:YES];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:[Helper getLocalisedString:@"Button_Delete" withScalePrefix:NO] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self executeDeleteSelectedScore];
    }];
    [deleteAlert addAction:ok];
    
    [self presentViewController:deleteAlert animated:YES completion:nil];
    
}

- (void)executeDeleteSelectedScore {
    
    [Helper deleteRecordFrom:@"Interview" fromReferenceObject:self.interviewEntity];
    
    [self dismiss];
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

