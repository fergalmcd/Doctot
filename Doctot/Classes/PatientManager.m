//
//  PatientManager.m
//  Doctot
//
//  Created by Fergal McDonnell on 04/05/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import "PatientManager.h"
#import "Constants.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Scale.h"
#import "Interview.h"
#import "Summary.h"


@interface PatientManager ()

@end

@implementation PatientManager

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize identifierSort, nameSort, dobSort, identifierSortIndicator, nameSortIndicator, dobSortIndicator, identifierSortAscending, nameSortAscending, dobSortAscending/*, scoresList, scoreTable*/;
@synthesize patientSearchController, patientsList, patientTable, scoresFilteredPatientList, patientsCollectionBackground, patientsCollection, visualContextIndicator, searchControllerWasActive, searchControllerSearchFieldWasFirstResponder;
@synthesize patientSelected;
@synthesize managedObjectContext, fetchedResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Patient_Heading" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"patient_list.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(toggleVisualContext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    [identifierSort setTitle:[Helper getLocalisedString:@"Patient_HeaderIdentifier" withScalePrefix:NO] forState:UIControlStateNormal];
    [nameSort setTitle:[Helper getLocalisedString:@"Patient_HeaderName" withScalePrefix:NO] forState:UIControlStateNormal];
    [dobSort setTitle:[Helper getLocalisedString:@"Patient_HeaderDOB" withScalePrefix:NO] forState:UIControlStateNormal];
    
    identifierSortAscending = YES;
    nameSortAscending = YES;
    dobSortAscending = YES;
    [self displaySortIndicators];
    
    visualContextIndicator = (NSString *)[prefs stringForKey:@"PatientVisualContext"];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Patient List view
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    self.definesPresentationContext = YES;
    
    [self returnAllPatients];
    
    [self.patientTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ScoresCell"];
    
    scoresFilteredPatientList = [[ScoresFilteredPatientList alloc] init];
    scoresFilteredPatientList.source = @"patientList";
    scoresFilteredPatientList.tableView.delegate = self;
    
    patientSearchController = [[UISearchController alloc] initWithSearchResultsController:scoresFilteredPatientList];
    patientSearchController.searchResultsUpdater = self;
    patientSearchController.delegate = self;
    patientSearchController.dimsBackgroundDuringPresentation = NO;
    patientSearchController.searchBar.delegate = self;
    [patientSearchController.searchBar sizeToFit];
    patientSearchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    patientSearchController.searchBar.tintColor = [UIColor whiteColor];
    // Changes the colour of the placeholder text to white (different approach for iOS versions before iOS 13)
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if( iOSVersion >= 13 ){
        
        if ([patientSearchController.searchBar.searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            [patientSearchController.searchBar.searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
            UIImageView *imgView = (UIImageView*)patientSearchController.searchBar.searchTextField.leftView;
            imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            imgView.tintColor = [UIColor whiteColor];
        }
        
    }else{
        
        UITextField *searchTextField = [patientSearchController.searchBar valueForKey:@"_searchField"];
        if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: color}]];
        }
        
        NSString *adjustedCancel = [NSString stringWithFormat:@"%@   ", [Helper getLocalisedString:@"Button_Cancel" withScalePrefix:NO]];
        [patientSearchController.searchBar setValue:adjustedCancel forKey:@"_cancelButtonText"];
        
    }

    patientTable.tableHeaderView = patientSearchController.searchBar;
    patientTable.backgroundColor = [UIColor clearColor];
    
    [scoresFilteredPatientList.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"FilteredCell"];
    [patientsCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PatientsCollectionCell"];
    [self sortTable:nameSort];
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    [self displayVisualContext:[prefs stringForKey:@"PatientVisualContext"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        patientSearchController.active = self.searchControllerWasActive;
        searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [patientSearchController.searchBar becomeFirstResponder];
            searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
    
    [self returnAllPatients];
    [patientTable reloadData];
    [patientsCollection reloadData];

}

- (void)displayVisualContext:(NSString *)theContext {

    if( [theContext isEqualToString:VISUALCONTEXT_GRID] ){
        patientsCollectionBackground.hidden = NO;
        patientsCollection.hidden = NO;
    }
    
    if( [theContext isEqualToString:VISUALCONTEXT_LIST] ){
        patientsCollectionBackground.hidden = YES;
        patientsCollection.hidden = YES;
    }
    
}

- (IBAction)toggleVisualContext {

    if( [visualContextIndicator isEqualToString:VISUALCONTEXT_GRID] ){
        visualContextIndicator = VISUALCONTEXT_LIST;
        [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"patient_grid.png"] forState:UIControlStateNormal];
    }else{
        if( [visualContextIndicator isEqualToString:VISUALCONTEXT_LIST] ){
            visualContextIndicator = VISUALCONTEXT_GRID;
            [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"patient_list.png"] forState:UIControlStateNormal];
        }
    }
    
    [self displayVisualContext:visualContextIndicator];
    
}

- (void)returnAllPatients {

    fetchedResults = [Helper resultsFromTable:@"Patient" forQuery:@"uniqueID == *" ofType:@"AND" sortedBy:@"lastName" sortDirections:@"Ascending"];
    [self loadFetchedDataIntoTable:@"Patient"];
    
}

- (IBAction)sortTable:(UIButton *)source {

    NSString *sortString;
    BOOL sortDirection = YES;
    
    if( source == identifierSort ){  sortString = @"hospitalNo";   identifierSortAscending = !identifierSortAscending; sortDirection = identifierSortAscending;      }
    if( source == nameSort ){   sortString = @"lastName";   nameSortAscending = !nameSortAscending; sortDirection = nameSortAscending;    }
    if( source == dobSort ){   sortString = @"dob";   dobSortAscending = !dobSortAscending; sortDirection = dobSortAscending;  }
    [self displaySortIndicators];
    
    patientsList = [Helper sortedArray:patientsList byIndex:sortString andAscending:sortDirection];
    [patientTable reloadData];
    
}

- (void)displaySortIndicators {

    NSString *sortAscendingImage = @"arrow_up.png";
    NSString *sortDescendingImage = @"arrow_down.png";
    
    if( identifierSortAscending ){
        identifierSortIndicator.image = [UIImage imageNamed:sortAscendingImage];
    }else{
        identifierSortIndicator.image = [UIImage imageNamed:sortDescendingImage];
    }
    
    if( nameSortAscending ){
        nameSortIndicator.image = [UIImage imageNamed:sortAscendingImage];
    }else{
        nameSortIndicator.image = [UIImage imageNamed:sortDescendingImage];
    }
    
    if( dobSortAscending ){
        dobSortIndicator.image = [UIImage imageNamed:sortAscendingImage];
    }else{
        dobSortIndicator.image = [UIImage imageNamed:sortDescendingImage];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadFetchedDataIntoTable:(NSString *)theTable {
    
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"patientSelected"]){
        
        patientSelected = (PatientSelected *)segue.destinationViewController;
        
        DataPatient *senderPatient = (DataPatient *)sender;
        [patientSelected setupPatient:senderPatient];
        
    }
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////
// Collection View Methods
///////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sections = 1;
    
    if( collectionView == patientsCollection ){
        sections = 1;
    }
    
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rowsInSection = 0;
    
    if( collectionView == patientsCollection ){
        rowsInSection = [patientsList count];
    }
    
    return rowsInSection;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(INDIVIDUAL_CELL_WIDTH, INDIVIDUAL_CELL_HEIGHT);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SpeakerCollectionCellIdentifier = @"PatientsCollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpeakerCollectionCellIdentifier forIndexPath:indexPath];
    
    DataPatient *thisPatient;
    
    for (UIView *aView in [cell subviews]) {
        [aView removeFromSuperview];
    }
    
    if( collectionView == patientsCollection ){
        
        thisPatient = (DataPatient *)[patientsList objectAtIndex:indexPath.row];
        
        float widthPadding = 9;
        float topPadding = 15;
        UIImageView *holderImage = [[UIImageView alloc] initWithFrame:CGRectMake(widthPadding, topPadding, (cell.frame.size.width - (2 * widthPadding)), 86)];
        holderImage.image = [UIImage imageNamed:@"holder.png"];
        [cell addSubview:holderImage];
        
        UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        border.layer.cornerRadius = 10;
        border.layer.borderColor = [UIColor whiteColor].CGColor;
        border.layer.borderWidth = 1.0;
        [cell addSubview:border];
        
        UIImageView *personImage = [[UIImageView alloc] initWithFrame:CGRectMake((holderImage.frame.origin.x + 2), (holderImage.frame.origin.y + 2), (holderImage.frame.size.width - 4), (holderImage.frame.size.height - 7))];
        if( thisPatient.photoData == nil ){
            personImage.image = [UIImage imageNamed:@"patient.png"];
            personImage.contentMode = UIViewContentModeCenter;
        }else{
            personImage.image = [UIImage imageWithData:thisPatient.photoData];
        }
        [cell addSubview:personImage];
        
        float textTopPadding = topPadding + holderImage.frame.size.height;
        UILabel *role = [[UILabel alloc] initWithFrame:CGRectMake(widthPadding, textTopPadding, holderImage.frame.size.width, 20)];
        role.text = thisPatient.hospitalNo;
        role.textColor = [UIColor whiteColor];
        role.backgroundColor = [UIColor clearColor];
        role.textAlignment = NSTextAlignmentCenter;
        role.font = [UIFont fontWithName:@"Helvetica" size:8];
        [cell addSubview:role];
        
        textTopPadding = topPadding + holderImage.frame.size.height + role.frame.size.height - 5;
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(widthPadding, textTopPadding, holderImage.frame.size.width, 15)];
        name.text = [NSString stringWithFormat:@"%@ %@", thisPatient.firstName, thisPatient.lastName];
        name.textColor = [UIColor whiteColor];
        name.backgroundColor = [UIColor clearColor];
        name.textAlignment = NSTextAlignmentCenter;
        name.font = [UIFont fontWithName:@"Helvetica" size:12];
        //CGSize size = [name.text sizeWithFont:name.font];
        CGSize size = [name.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12]}];
        if (size.width > name.bounds.size.width) {
            name.numberOfLines = 2;
            name.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y, name.frame.size.width, (2 * name.frame.size.height));
        }
        [cell addSubview:name];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DataPatient *thisPatient;
    
    if( collectionView == patientsCollection ){
        thisPatient = (DataPatient *)[patientsList objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"patientSelected" sender:thisPatient];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Table Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;

    if( tableView == patientTable ){
        sections = 1;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsInSection = 0;

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
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if( tableView == patientTable ){
        
        DataPatient *thisPatient = (DataPatient *)[patientsList objectAtIndex:indexPath.row];
        
        UILabel *identifierLabel = [[UILabel alloc] initWithFrame:CGRectMake(identifierSort.frame.origin.x, 0, identifierSort.frame.size.width, cell.frame.size.height)];
        identifierLabel.text = [NSString stringWithFormat:@"%@", thisPatient.hospitalNo];
        [self drawLabel:identifierLabel];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameSort.frame.origin.x, 0, nameSort.frame.size.width, cell.frame.size.height)];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", thisPatient.firstName, thisPatient.lastName];
        [self drawLabel:nameLabel];
        
        UILabel *dobLabel = [[UILabel alloc] initWithFrame:CGRectMake(dobSort.frame.origin.x, 0, dobSort.frame.size.width, cell.frame.size.height)];
        NSString *dateOfBirthString = [Helper convertDateToString:thisPatient.dob forStyle:@"Text"];
        if( ( dateOfBirthString == nil ) || ( [dateOfBirthString isEqualToString:@"(null)"] ) || ( [dateOfBirthString length] == 0 ) ){
            dobLabel.text = @"";
        }else{
            dobLabel.text = dateOfBirthString;
        }
        [self drawLabel:dobLabel];

        [cell.contentView addSubview:identifierLabel];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:dobLabel];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DataPatient *thisPatient;
    
    if( tableView == patientTable ){
        thisPatient = (DataPatient *)[patientsList objectAtIndex:indexPath.row];
    }
    if( tableView == scoresFilteredPatientList.tableView ){
        thisPatient = (DataPatient *)[scoresFilteredPatientList.filteredResults objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"patientSelected" sender:thisPatient];
    
}

- (void)drawLabel:(UILabel *)formatLabel {

    formatLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    formatLabel.textAlignment = NSTextAlignmentCenter;
    formatLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    formatLabel.backgroundColor = [UIColor clearColor];
    
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
    NSMutableArray *searchResults = patientsList; //[self.products mutableCopy];
    
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
    
    // hand over the filtered results to our search results table
    ScoresFilteredPatientList *tableController = (ScoresFilteredPatientList *)patientSearchController.searchResultsController;
    tableController.filteredResults = searchResults;
    tableController.tableView.frame = CGRectMake(tableController.tableView.frame.origin.x, -55, tableController.tableView.frame.size.width, tableController.tableView.frame.size.height);
    tableController.tableView.backgroundColor = [UIColor clearColor];
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

