//
//  Scores.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "Scores.h"
#import "Constants.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"
#import "Summary.h"


@interface Scores ()

@end

@implementation Scores

@synthesize prefs, scaleDefinition, questions;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize dateSort, nameSort, scoreSort, dateSortIndicator, nameSortIndicator, scoreSortIndicator;
@synthesize scoreSearchController, scoresList, scoreTable, scoresFilteredScoreList;
@synthesize patientSearchController, patientsList, patientTable, scoresFilteredPatientList, searchControllerWasActive, searchControllerSearchFieldWasFirstResponder, singleApp, patientManager;
@synthesize scoreSelected, dateSortAscending, nameSortAscending, scoreSortAscending, scoreSelectedToExpand, expandScoreToFullView;
@synthesize managedObjectContext, fetchedResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Scale_Score" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"patient_barbutton.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(showPatients) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    [dateSort setTitle:[Helper getLocalisedString:@"Scale_Score_Date" withScalePrefix:NO] forState:UIControlStateNormal];
    [nameSort setTitle:[Helper getLocalisedString:@"Scale_Score_Name" withScalePrefix:NO] forState:UIControlStateNormal];
    [scoreSort setTitle:[Helper getLocalisedString:@"Scale_Score_Score" withScalePrefix:NO] forState:UIControlStateNormal];
    
    dateSortAscending = YES;
    nameSortAscending = YES;
    scoreSortAscending = YES;
    [self displaySortIndicators];
    
    expandScoreToFullView.hidden = YES;
    
    NSDictionary *diagnosisLevels = scaleDefinition.diagnosisLevels;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Scores List view controller
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self fetchAllInterviewAssessments];
    
    [self.scoreTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ScoresCell"];
    
    scoresFilteredScoreList = [[ScoresFilteredPatientList alloc] init];
    scoresFilteredScoreList.source = @"scoreList";
    scoresFilteredScoreList.item1Padding = 0;//dateSort.frame.origin.x;
    scoresFilteredScoreList.item1Width = 100;//dateSort.frame.size.width;
    scoresFilteredScoreList.item2Width = 175;//nameSort.frame.size.width;
    scoresFilteredScoreList.item3Width = 50;//scoreSort.frame.size.width;
    scoreSearchController = [self configureSearchBar:scoresFilteredScoreList];
    scoreTable.tableHeaderView = scoreSearchController.searchBar;
    scoreTable.backgroundColor = [UIColor clearColor];
    scoresFilteredScoreList.tableView.delegate = self;
    
    [scoresFilteredScoreList.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"FilteredCell"];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Patient List view (at the end of the Assessment: patient selection from the Summary)
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fetchedResults = [Helper resultsFromTable:@"Patient" forQuery:@"uniqueID == *" ofType:@"AND" sortedBy:@"lastName" sortDirections:@"Ascending"];
    [self loadFetchedDataIntoTable:@"Patient"];
    
    [self.patientTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ScoresCell"];
    
    scoresFilteredPatientList = [[ScoresFilteredPatientList alloc] init];
    scoresFilteredPatientList.source = @"patientList";
    patientSearchController = [self configureSearchBar:scoresFilteredPatientList];
    patientTable.tableHeaderView = patientSearchController.searchBar;
    patientTable.backgroundColor = [UIColor clearColor];
    scoresFilteredPatientList.tableView.delegate = self;
    
    [scoresFilteredPatientList.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"FilteredCell"];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    self.definesPresentationContext = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        patientSearchController.active = self.searchControllerWasActive;
        searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [patientSearchController.searchBar becomeFirstResponder];
            searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
    
    [self fetchAllInterviewAssessments];
    [scoreTable reloadData];
}

- (void)fetchAllInterviewAssessments {

    NSString *queryString = [NSString stringWithFormat:@"scale == '%@'", scaleDefinition.name];
    fetchedResults = [Helper resultsFromTable:@"Interview" forQuery:queryString ofType:@"AND" sortedBy:@"creationDate" sortDirections:@"Descending"];
    [self loadFetchedDataIntoTable:@"Interview"];
    
}

- (IBAction)insertScore {

}

- (IBAction)sortTable:(UIButton *)source {

    NSString *sortString;
    BOOL sortDirection = YES;
    
    if( source == dateSort ){   sortString = @"date";   dateSortAscending = !dateSortAscending; sortDirection = dateSortAscending;  }
    if( source == nameSort ){   sortString = @"lastName";   nameSortAscending = !nameSortAscending; sortDirection = nameSortAscending;    }
    if( source == scoreSort ){  sortString = @"score";   scoreSortAscending = !scoreSortAscending; sortDirection = scoreSortAscending;      }
    [self displaySortIndicators];
    
    scoresList = [Helper sortedArray:scoresList byIndex:sortString andAscending:sortDirection];
    [scoreTable reloadData];
    
}

- (void)displaySortIndicators {

    NSString *sortAscendingImage = @"arrow_up.png";
    NSString *sortDescendingImage = @"arrow_down.png";
    
    if( dateSortAscending ){
        dateSortIndicator.image = [UIImage imageNamed:sortAscendingImage];
    }else{
        dateSortIndicator.image = [UIImage imageNamed:sortDescendingImage];
    }
    
    if( nameSortAscending ){
        nameSortIndicator.image = [UIImage imageNamed:sortAscendingImage];
    }else{
        nameSortIndicator.image = [UIImage imageNamed:sortDescendingImage];
    }
    
    if( scoreSortAscending ){
        scoreSortIndicator.image = [UIImage imageNamed:sortAscendingImage];
    }else{
        scoreSortIndicator.image = [UIImage imageNamed:sortDescendingImage];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadFetchedDataIntoTable:(NSString *)theTable {
    
    if( [theTable isEqualToString:@"Interview"] ){
    
        ScoreSelected *thisScore;
        DataInterview *interviewObject;
        DataPatient *patientObject;
        NSManagedObject *interviewEntity;
        NSManagedObject *patientEntity;
        NSManagedObject *questionEntity;
        scoresList = [[NSMutableArray alloc] init];
        
        for( int i = 0; i < [fetchedResults count]; i++ ){
            
            interviewEntity = [fetchedResults objectAtIndex:i];
            interviewObject = [[DataInterview alloc] init];
            [interviewObject configureData:[fetchedResults objectAtIndex:i]];
            
            patientEntity = [interviewEntity valueForKeyPath:@"patient"];
            patientObject = [[DataPatient alloc] init];
            [patientObject configureData:patientEntity];
            
            thisScore = [[ScoreSelected alloc] init];
            
            thisScore.date = interviewObject.creationDate;
            thisScore.dateString = [Helper convertDateToString:thisScore.date forStyle:@"Text"];
            thisScore.firstName = patientObject.firstName;
            thisScore.lastName = patientObject.lastName;
            thisScore.fullName = [NSString stringWithFormat:@"%@ %@", thisScore.firstName, thisScore.lastName];
            thisScore.score = interviewObject.score;
            thisScore.definition = scaleDefinition;
            thisScore.interviewEntity = interviewEntity;
            thisScore.interviewObject = interviewObject;
            NSSet *theResultsSet = [[NSSet alloc] init];
            theResultsSet = [interviewEntity valueForKey:@"questions"];
            thisScore.questionResults = [[NSMutableArray alloc] init];
            for( NSManagedObject *aQuestionResult in theResultsSet ){
                [thisScore.questionResults addObject:aQuestionResult];
            }
            [thisScore determineScoreCatgory];
            
            [scoresList addObject:thisScore];
            
        }
        
    }
    
    if( [theTable isEqualToString:@"Patient"] ){
        
        DataPatient *patientObject;
        patientsList = [[NSMutableArray alloc] init];
        for( int i = 0; i < [fetchedResults count]; i++ ){
            patientObject = [[DataPatient alloc] init];
            [patientObject configureData:(NSManagedObject *)[fetchedResults objectAtIndex:i]];
            [patientsList addObject:patientObject];
        }
    
    }
    
}

- (void)showPatients {

    [self performSegueWithIdentifier:@"showPatients" sender:nil];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"showPatients"]){
        
        patientManager = (PatientManager *)segue.destinationViewController;
        
    }
    
    if([[segue identifier] isEqualToString:@"scoreSelected"]){
        
        scoreSelected = (ScoreSelected *)segue.destinationViewController;
        
        ScoreSelected *senderScore = (ScoreSelected *)sender;
        [scoreSelected setupScore:senderScore];
        
    }
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Table Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;
    
    if( tableView == scoreTable ){
        sections = 1;
    }
    if( tableView == patientTable ){
        sections = 1;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsInSection = 0;
    
    if( tableView == scoreTable ){
        rowsInSection = [scoresList count];
    }
    if( tableView == patientTable ){
        rowsInSection = [patientsList count];
    }
    
    return rowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ScoresCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // To keep the list refreshed when scrolling
    for(UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }
    
    if( tableView == scoreTable ){
    
        ScoreSelected *thisScore = (ScoreSelected *)[scoresList objectAtIndex:indexPath.row];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateSort.frame.origin.x, 0, dateSort.frame.size.width, cell.frame.size.height)];
        dateLabel.text = thisScore.dateString;
        dateLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameSort.frame.origin.x, 0, nameSort.frame.size.width, cell.frame.size.height)];
        nameLabel.text = thisScore.fullName;
        nameLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        nameLabel.numberOfLines = 3;
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreSort.frame.origin.x, 0, scoreSort.frame.size.width, cell.frame.size.height)];
        scoreLabel.text = [self generateScoreText:thisScore];
        scoreLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        scoreLabel.textAlignment = NSTextAlignmentCenter;        
        scoreLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        float shaveIconBy = 3;
        UIImageView *categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake( scoreLabel.frame.origin.x + shaveIconBy , scoreLabel.frame.origin.y + shaveIconBy, scoreLabel.frame.size.width - (2 * shaveIconBy), scoreLabel.frame.size.height - (2 * shaveIconBy))];
        categoryIcon.image = [UIImage imageNamed:thisScore.iconName];
        categoryIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        float chevronWidth = cell.frame.size.height / 2;
        UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake( cell.frame.size.width - chevronWidth, (cell.frame.size.height / 4), chevronWidth, (cell.frame.size.height / 2))];
        chevron.image = [UIImage imageNamed:@"chevron_white_right.png"];
        chevron.contentMode = UIViewContentModeCenter;
        
        UIImageView *underline = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 2, cell.frame.size.width, 2)];
        underline.image = [UIImage imageNamed:@"content.png"];
        underline.alpha = 0.3;
        
        [cell.contentView addSubview:dateLabel];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:categoryIcon];
        [cell.contentView addSubview:scoreLabel];
        [cell.contentView addSubview:chevron];
        [cell.contentView addSubview:underline];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    if( tableView == patientTable ){
        
        DataPatient *thisPatient = (DataPatient *)[patientsList objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, cell.frame.size.width - 50, cell.frame.size.height)];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", thisPatient.firstName, thisPatient.lastName];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:nameLabel];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( tableView == scoreTable ){
        
        ScoreSelected *thisScore = (ScoreSelected *)[scoresList objectAtIndex:indexPath.row];
        
        if( [Helper isiPad] ){
            
            // iPad
            scoreSelectedToExpand = thisScore;
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
            ScoreSelected *iPadScore =  [sb instantiateViewControllerWithIdentifier:@"ScoreSelected"];
            iPadScore.view.tag = 10;
            [iPadScore setupScore:thisScore];
            iPadScore.adjustedDimensions = YES;
            [iPadScore viewDidLoad];
            [iPadScore viewDidAppear:YES];
            iPadScore.deleteScore.hidden = YES;
            iPadScore.emailScore.hidden = YES;
            iPadScore.category.hidden = YES;
            iPadScore.view.backgroundColor = [UIColor yellowColor];
            [self.view addSubview:iPadScore.view];
            
            iPadScore.view.frame = CGRectMake(scoreTable.frame.size.width, 0, self.view.frame.size.width - scoreTable.frame.size.width, self.view.frame.size.height);
            
            expandScoreToFullView.hidden = NO;
            //[expandScoreToFullView setTitle:[Helper getLocalisedString:@"Button_More" withScalePrefix:NO] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:expandScoreToFullView];
            
        }
        else{
            [self performSegueWithIdentifier:@"scoreSelected" sender:thisScore];
        }
        
    }
    
    if( tableView == patientTable ){
        
        DataPatient *aPatient = (DataPatient *)[patientsList objectAtIndex:indexPath.row];
        [self returnAdoptingNameForScore:aPatient];
        
    }
    
    if( tableView == scoresFilteredScoreList.tableView ){
        
        ScoreSelected *aScore = (ScoreSelected *)[scoresFilteredScoreList.filteredResults objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"scoreSelected" sender:aScore];
        
    }
    
    if( tableView == scoresFilteredPatientList.tableView ){
        
        DataPatient *aPatient = (DataPatient *)[scoresFilteredPatientList.filteredResults objectAtIndex:indexPath.row];
        [self returnAdoptingNameForScore:aPatient];
        
    }
    
}

- (IBAction)navigateToScoreSelectedToExpand {
    
    [self performSegueWithIdentifier:@"scoreSelected" sender:scoreSelectedToExpand];
    
}

- (void)returnAdoptingNameForScore:(DataPatient *)thisPatient {

    [[self navigationController] popViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    Scale *thisScale = (Scale *)home.scale;
    Interview *thisInterview = (Interview *)thisScale.interview;
    if( thisInterview == nil ){
        thisInterview = home.singleAppInterview;
    }
    Summary *theSummary = (Summary *)thisInterview.summary;
    theSummary.firstName.text = thisPatient.firstName;
    theSummary.lastName.text = thisPatient.lastName;
    
}

- (NSString *)generateScoreText:(ScoreSelected *)aScore {

    NSString *scoreString = [NSString stringWithFormat:@"%.1f", aScore.score];
    
    // Special Case: COM
    if( [scaleDefinition.name isEqualToString:@"COM"] ){
        if( [aScore.diagnosisCategory.name containsString:@" A"] )   scoreString = @"A";
        if( [aScore.diagnosisCategory.name containsString:@" B"] )   scoreString = @"B";
        if( [aScore.diagnosisCategory.name containsString:@" C"] )   scoreString = @"C";
        if( [aScore.diagnosisCategory.name containsString:@" D"] )   scoreString = @"D";
        if( [aScore.diagnosisCategory.name containsString:@"Uncategorised"] )   scoreString = @"N/A";
    }
    
    // Special Case: CACH (divides by 4 if the units are mmol/L)
    if( [scaleDefinition.name isEqualToString:@"CACH"] ){
        NSString *theUnits = @"";
        int theIndex = 0;
        for( NSManagedObject *aQuestion in aScore.questionResults ){
            theIndex = (int)[[aQuestion valueForKey:@"index"] integerValue];
            if( theIndex == 1 ){
                theUnits = [aQuestion valueForKey:@"customInformation"];
            }
        }

        if( [theUnits containsString:@"mmol/L"] ){
            scoreString = [NSString stringWithFormat:@"%.2f*", (aScore.score / 4)];
        }
    }
    
    return scoreString;
}

- (UISearchController *)configureSearchBar:(UIViewController *)listToPopulate {
    UISearchController *generatedSearchController = [[UISearchController alloc] initWithSearchResultsController:listToPopulate];
    
    generatedSearchController.searchResultsUpdater = self;
    [generatedSearchController.searchBar sizeToFit];
    
    generatedSearchController.delegate = self;
    generatedSearchController.dimsBackgroundDuringPresentation = NO; // default is YES
    generatedSearchController.searchBar.delegate = self; // so we can monitor text changes + others
    generatedSearchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    generatedSearchController.searchBar.tintColor = [UIColor whiteColor];
    // Changes the colour of the placeholder text to white (different approach for iOS versions before iOS 13)
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if( iOSVersion >= 13 ){
        
        if ([generatedSearchController.searchBar.searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            [generatedSearchController.searchBar.searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
            UIImageView *imgView = (UIImageView*)generatedSearchController.searchBar.searchTextField.leftView;
            imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            imgView.tintColor = [UIColor whiteColor];
            [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:[NSString stringWithFormat:@"%@ ", [Helper getLocalisedString:@"Button_Cancel" withScalePrefix:NO]]];
        }
        
    }else{
        
        UITextField *searchTextField = [generatedSearchController.searchBar valueForKey:@"_searchField"];
        if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: color}]];
        }
        
        NSString *adjustedCancel = [NSString stringWithFormat:@"%@   ", [Helper getLocalisedString:@"Button_Cancel" withScalePrefix:NO]];
        [generatedSearchController.searchBar setValue:adjustedCancel forKey:@"_cancelButtonText"];
        
    }
    
    return generatedSearchController;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults; //[self.products mutableCopy];
    
    if( searchController == patientSearchController ){
        searchResults = patientsList;
    }
    if( searchController == scoreSearchController ){
        searchResults = scoresList;
    }
    
    //NSLog(@"searchText: %@", searchText);
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"firstName"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        lhs = [NSExpression expressionForKeyPath:@"lastName"];
        rhs = [NSExpression expressionForConstantValue:searchString];
        finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    //NSLog(@"searchResults: %@", searchResults);
    
    // hand over the filtered results to our search results table
    ScoresFilteredPatientList *tableController;
    if( searchController == patientSearchController ){
       tableController = (ScoresFilteredPatientList *)patientSearchController.searchResultsController;
    }
    if( searchController == scoreSearchController ){
        tableController = (ScoresFilteredPatientList *)scoreSearchController.searchResultsController;
    }
    tableController.filteredResults = searchResults;
    tableController.tableView.backgroundColor = [UIColor clearColor];
    tableController.tableView.frame = CGRectMake(tableController.tableView.frame.origin.x, -25, tableController.tableView.frame.size.width, tableController.tableView.frame.size.height);
    [tableController.tableView reloadData];
}


#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = patientSearchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    patientSearchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

