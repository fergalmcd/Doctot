//
//  PatientSelected.m
//  Doctot
//
//  Created by Fergal McDonnell on 05/05/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import "PatientSelected.h"
#import "Helper.h"
#import "Constants.h"

@interface PatientSelected ()

@end

@implementation PatientSelected

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize patientDetails, arePatientDetailsUpdated;
@synthesize photo, initialPhoto, insertPhotoFromCamera, insertPhotoFromAlbum, clearPhoto, idTag, identifierField, firstNameTag, firstNameField, lastNameTag, lastNameField, hideKeyboard, dobTag, dobLabel, dobActivate, dobDeactivate, dobPickerLabel, dobPicker, isDOBActive;
@synthesize notesContent, notesShow, notesView, notesHeading, notesField, notesDismiss;
@synthesize interviewScale, interviewDate, interviewScore, interviews, interviewsTable, selectedInterview, deletePatient;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Patient_Selected" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"delete_barbutton.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(deleteSelectedPatientAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    arePatientDetailsUpdated = NO;
    
    identifierField.placeholder = [Helper getLocalisedString:@"Registration_HospitlNo" withScalePrefix:NO];
    firstNameField.placeholder = [Helper getLocalisedString:@"Registration_FirstName" withScalePrefix:NO];
    lastNameField.placeholder = [Helper getLocalisedString:@"Registration_LastName" withScalePrefix:NO];
    
    idTag.text = [Helper getLocalisedString:@"Patient_HeaderIdentifier" withScalePrefix:NO];
    firstNameTag.text = [Helper getLocalisedString:@"Patient_HeaderFirstName" withScalePrefix:NO];
    lastNameTag.text = [Helper getLocalisedString:@"Patient_HeaderLastName" withScalePrefix:NO];
    dobTag.text = [Helper getLocalisedString:@"Patient_HeaderDOB" withScalePrefix:NO];
    
    identifierField.text = patientDetails.hospitalNo;
    firstNameField.text = patientDetails.firstName;
    lastNameField.text = patientDetails.lastName;
    dobLabel.text = [Helper convertDateToString:patientDetails.dob forStyle:@"Text"];
    photo.image = [patientDetails convertDataToImage:patientDetails.photoData];
    initialPhoto = [[UIImageView alloc] init];
    initialPhoto.image = photo.image;
    photo.layer.cornerRadius = 10;
    
    [insertPhotoFromCamera setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [insertPhotoFromAlbum setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [clearPhoto setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [dobActivate setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [dobDeactivate setTitle:[Helper getLocalisedString:@"" withScalePrefix:NO] forState:UIControlStateNormal];
    [hideKeyboard setTitle:[Helper getLocalisedString:@"Scale_Hide_Keyboard" withScalePrefix:NO] forState:UIControlStateNormal];
    hideKeyboard.hidden = YES;
    
    interviewDate.text = [Helper getLocalisedString:@"Scale_Score_Date" withScalePrefix:NO];
    interviewDate.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    
    interviewScale.text = [Helper getLocalisedString:@"Scale_Score_Scale" withScalePrefix:NO];
    interviewScale.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    
    interviewScore.text = [Helper getLocalisedString:@"Scale_Score_Score" withScalePrefix:NO];
    interviewScore.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    
    dobPickerLabel.text = [Helper getLocalisedString:@"Scale_DateOfBirth_Heading" withScalePrefix:NO];
    dobPickerLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
    [dobPicker setValue:dobPickerLabel.textColor forKey:@"textColor"];
    if( patientDetails.dob != nil ){
        [dobPicker setDate:patientDetails.dob];
    }
    [self setDateOfBirthInputVisibility:NO];
    
    // notesContent, notesShow, notesView, notesHeading, notesField, notesDismiss
    notesContent.text = patientDetails.notes;
    notesView.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, (self.view.frame.size.height / 2) );
    notesHeading.text = [[Helper getLocalisedString:@"Patient_HeaderNotes" withScalePrefix:NO] stringByAppendingFormat:@"\n%@ %@", firstNameField.text, lastNameField.text];
    [self.view addSubview:notesView];
    
    [deletePatient setTitle:[Helper getLocalisedString:@"Button_Delete" withScalePrefix:NO] forState:UIControlStateNormal];
    
    [self configurePatientInterviews];
    
    [interviewsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PatientsCell"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self configurePatientInterviews];
    [interviewsTable reloadData];
}

- (void)setupPatient:(DataPatient *)senderPatient {
    
    patientDetails = senderPatient;

}

- (void)configurePatientInterviews {

    NSString *queryString = [NSString stringWithFormat:@"uniqueID == '%@'", patientDetails.uniqueID];
    NSArray *patientRetrieved = [Helper resultsFromTable:@"Patient" forQuery:queryString ofType:@"AND" sortedBy:@"" sortDirections:@""];
    DataPatient *patientObject = [[DataPatient alloc] init];
    [patientObject configureData:(NSManagedObject *)[patientRetrieved objectAtIndex:0]];
    interviews = [[NSMutableArray alloc] init];
    interviews = patientObject.interviews;
    
}

- (IBAction)toggleDOBActiveState:(UIButton *)sender {

    if( sender == dobActivate ){
        [self dismissKeyboard];
        [self setDateOfBirthInputVisibility:YES];
    }
    if( sender == dobDeactivate ){
        [self setDateOfBirthInputVisibility:NO];
    }
    
    
}

- (void)setDateOfBirthInputVisibility:(BOOL)isVisble {

    isDOBActive = isVisble;
    
    dobPickerLabel.hidden = YES;
    dobPicker.hidden = YES;
    dobDeactivate.hidden = YES;
    
    // Don't hide these for an iPad
    if( ![Helper isiPad] ){
        interviewScale.hidden = YES;
        interviewDate.hidden = YES;
        interviewScore.hidden = YES;
        interviewsTable.hidden = YES;
    }
    
    if( isDOBActive ){
        
        dobPickerLabel.hidden = NO;
        dobPicker.hidden = NO;
        dobDeactivate.hidden = NO;
        
    }else{
    
        interviewScale.hidden = NO;
        interviewDate.hidden = NO;
        interviewScore.hidden = NO;
        interviewsTable.hidden = NO;
        
    }
    
}

- (IBAction)dismissKeyboard {
    
    hideKeyboard.hidden = YES;
    
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    [identifierField resignFirstResponder];
    
}

- (IBAction)updateDateOfBirth {

    patientDetails.dob = [dobPicker date];
    dobLabel.text = [Helper convertDateToString:patientDetails.dob forStyle:@"Text"];
    arePatientDetailsUpdated = YES;
    
}

- (IBAction)toggleNotesView:(UIButton *)sender {
    
    [UIView beginAnimations:@"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration:1.0];
    
    float newXPosition = 0.0;
    
    if( sender == notesShow ){
        newXPosition = 0.0;
        notesField.text = patientDetails.notes;
        [notesField becomeFirstResponder];
    }
    if( sender == notesDismiss ){
        newXPosition = self.view.frame.size.width;
        patientDetails.notes = notesField.text;
        [notesField resignFirstResponder];
    }
    
    notesView.frame = CGRectMake(newXPosition, notesView.frame.origin.y, notesView.frame.size.width, notesView.frame.size.height );
    
    [UIView commitAnimations];
    
}

- (IBAction)dismissNotes {
    
    if( ![patientDetails.notes isEqualToString:notesField.text]  ){
        patientDetails.notes = notesField.text;
        notesContent.text = patientDetails.notes;
        arePatientDetailsUpdated = YES;
    }
    [self toggleNotesView:notesDismiss];
    
}

- (IBAction)showSelectedInterview {
    
}

- (IBAction)deleteSelectedPatientAction {
    
    UIAlertController *deleteAlert = [Helper defaultAlertController:self withHeading:[Helper getLocalisedString:@"Delete_PatientHeading" withScalePrefix:NO] andMessage:[Helper getLocalisedString:@"Delete_PatientMessage" withScalePrefix:NO] includeCancel:YES];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:[Helper getLocalisedString:@"Button_Delete" withScalePrefix:NO] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self executeDeleteSelectedPatient];
    }];
    [deleteAlert addAction:ok];
    
    [self presentViewController:deleteAlert animated:YES completion:nil];
    
}

- (void)executeDeleteSelectedPatient {
    
    [Helper deleteRecordFrom:@"Patient" fromReferenceObject:patientDetails];
    [self dismiss];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"patientScoreSelected"]){
        
        selectedInterview = (ScoreSelected *)segue.destinationViewController;
        
        ScoreSelected *senderScore = [[ScoreSelected alloc] init];
        DataInterview *dataInterview = (DataInterview *)sender;
        senderScore.dtPlusID = dataInterview.dtPlusID;
        senderScore.date = dataInterview.creationDate;
        senderScore.dateString = [Helper convertDateToString:senderScore.date forStyle:@"Numeric"];
        senderScore.patientDTPlusID = patientDetails.dtPlusID;
        senderScore.firstName = patientDetails.firstName;
        senderScore.lastName = patientDetails.lastName;
        senderScore.fullName = [patientDetails.firstName stringByAppendingFormat:@" %@", patientDetails.lastName];
        senderScore.score = dataInterview.score;
        
        NSMutableArray *allScalesDefinitions = [Helper generateScaleDefinitionsArray];
        ScaleDefinition *thisScaleDefininition = [[ScaleDefinition alloc] init];
        for( ScaleDefinition *aDefinition in allScalesDefinitions ){
            if( [aDefinition.name isEqualToString:dataInterview.scale] ){
                thisScaleDefininition = aDefinition;
            }
        }
        senderScore.definition = thisScaleDefininition;
        senderScore.interviewEntity = dataInterview.mirrorEntity;
        senderScore.interviewObject = dataInterview;
        senderScore.questionResults = dataInterview.questions;
        
        [senderScore determineScoreCatgory];
        
        [selectedInterview setupScore:senderScore];
        
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Image Picker Delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)acquirePhoto:(UIButton *)sender{

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if( sender == insertPhotoFromCamera ) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if( sender == insertPhotoFromAlbum ){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)clearPhotoFromScreen {
    
    photo.image = initialPhoto.image;
    patientDetails.photoData = [patientDetails convertImageToData:photo.image];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    photo.image = chosenImage;
    patientDetails.photoData = [patientDetails convertImageToData:photo.image];
    arePatientDetailsUpdated = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TextArea Delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    /*
    if (textView == notesField) {
        patientDetails.notes = notesField.text;
    }
    
    arePatientDetailsUpdated = YES;
     */
    return YES;
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TextField Delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField {

    hideKeyboard.hidden = NO;
    [self setDateOfBirthInputVisibility:NO];
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)theTextField {
    
    if (theTextField == identifierField) {
        patientDetails.hospitalNo = identifierField.text;
    }
    if (theTextField == firstNameField) {
        patientDetails.firstName = firstNameField.text;
    }
    if (theTextField == lastNameField) {
        patientDetails.lastName = lastNameField.text;
    }
    
    arePatientDetailsUpdated = YES;
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    NSString *tempStr;
    
    if (theTextField == identifierField) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", firstNameField.text];
        [firstNameField becomeFirstResponder];
        firstNameField.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == firstNameField) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", lastNameField.text];
        [lastNameField becomeFirstResponder];
        lastNameField.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    if (theTextField == lastNameField) {
        tempStr = [[NSString alloc] initWithFormat:@"%@", identifierField.text];
        [identifierField becomeFirstResponder];
        identifierField.text = [[NSString alloc] initWithFormat:@"%@", tempStr];
    }
    
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Table Delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;
    
    if( tableView == interviewsTable ){
        sections = 1;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsInSection = 0;
    
    if( tableView == interviewsTable ){
        rowsInSection = [interviews count];
    }
    
    return rowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PatientsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // To keep the list refreshed when scrolling
    for(UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }
    
    if( tableView == interviewsTable ){
        
        float dateLabelXPos = interviewDate.frame.origin.x - interviewsTable.frame.origin.x;
        float scaleLabelXPos = interviewScale.frame.origin.x - interviewsTable.frame.origin.x;
        float scoreLabelXPos = interviewScore.frame.origin.x - interviewsTable.frame.origin.x;
        
        DataInterview *thisInterview = (DataInterview *)[interviews objectAtIndex:indexPath.row];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabelXPos, 0, interviewDate.frame.size.width, cell.frame.size.height)];
        dateLabel.text = [Helper convertDateToString:thisInterview.creationDate forStyle:@"Text"];
        dateLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleLabelXPos, 0, interviewScale.frame.size.width, cell.frame.size.height)];
        scaleLabel.text = thisInterview.scale;
        scaleLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        scaleLabel.textAlignment = NSTextAlignmentCenter;
        scaleLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabelXPos, 0, interviewScore.frame.size.width, cell.frame.size.height)];
        scoreLabel.text = [NSString stringWithFormat:@"%.1f", thisInterview.score];
        scoreLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        [cell.contentView addSubview:dateLabel];
        [cell.contentView addSubview:scaleLabel];
        [cell.contentView addSubview:scoreLabel];
        
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( tableView == interviewsTable ){
        
        DataInterview *thisInterview = (DataInterview *)[interviews objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"patientScoreSelected" sender:thisInterview];
        
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateAction {
    
    [self dismissKeyboard];
    
    if( !arePatientDetailsUpdated ){
    
        [self dismiss];
        
    }else{
    
        //UIAlertController * updateAlert = [UIAlertController alertControllerWithTitle:[Helper getLocalisedString:@"Update_PatientHeading" withScalePrefix:NO] message:[Helper getLocalisedString:@"Update_PatientMessage" withScalePrefix:NO] preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertController *updateAlert = [Helper defaultAlertController:self withHeading:[Helper getLocalisedString:@"Update_PatientHeading" withScalePrefix:NO] andMessage:[Helper getLocalisedString:@"Update_PatientMessage" withScalePrefix:NO] includeCancel:YES];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:[Helper getLocalisedString:@"Button_OK" withScalePrefix:NO] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self saveUpdatedPatient];
        }];
        [updateAlert addAction:ok];
        
        /*UIAlertAction* cancel = [UIAlertAction actionWithTitle:[Helper getLocalisedString:@"Button_Cancel" withScalePrefix:NO] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [updateAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [updateAlert addAction:cancel];
        */
        
        [self presentViewController:updateAlert animated:YES completion:nil];
        
    }
    
}

- (void)saveUpdatedPatient {
    
    // Update Core Data locally
    [Helper updateRecordFrom:@"Patient" withObject:patientDetails];
    
    // Update DTPlus Patient entity also
    NSString *sqlStatement = [NSString stringWithFormat:@"UPDATE Patient SET hospitalNumber = '%@', firstName = '%@', lastName = '%@', dob = '%@', notes = '%@' WHERE uniqueId='%li'", patientDetails.hospitalNo, patientDetails.firstName, patientDetails.lastName, patientDetails.dob, patientDetails.notes, patientDetails.dtPlusID];
    [Helper executeRemoteSQLStatement:sqlStatement includeDelay:NO];
    
    // Return to the list of Patients
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

