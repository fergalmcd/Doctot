//
//  PatientSelected.h
//  Doctot
//
//  Created by Fergal McDonnell on 05/05/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScoreSelected.h"
#import "ScaleDefinition.h"
#import "DiagnosisElement.h"
#import "DataPatient.h"
#import "DataInterview.h"


@interface PatientSelected : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;

    DataPatient *patientDetails;
    BOOL arePatientDetailsUpdated;
    
    UIImageView *photo;
    UIImageView *initialPhoto;
    UIButton *insertPhotoFromCamera;
    UIButton *insertPhotoFromAlbum;
    UIButton *clearPhoto;
    UILabel *idTag;
    UITextField *identifierField;
    UILabel *firstNameTag;
    UITextField *firstNameField;
    UILabel *lastNameTag;
    UITextField *lastNameField;
    UIButton *hideKeyboard;
    UILabel *dobTag;
    UILabel *dobLabel;
    UIButton *dobActivate;
    UIButton *dobDeactivate;
    UILabel *dobPickerLabel;
    UIDatePicker *dobPicker;
    BOOL isDOBActive;
    UILabel *notesContent;
    UIButton *notesShow;
    UIView *notesView;
    UILabel *notesHeading;
    UITextView *notesField;
    UIButton *notesDismiss;
    
    UILabel *interviewScale;
    UILabel *interviewDate;
    UILabel *interviewScore;
    
    NSMutableArray *interviews;
    UITableView *interviewsTable;
    ScoreSelected *selectedInterview;
    
    UIButton *deletePatient;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) DataPatient *patientDetails;
@property BOOL arePatientDetailsUpdated;
@property (nonatomic, retain) IBOutlet UIImageView *photo;
@property (nonatomic, retain) IBOutlet UIImageView *initialPhoto;
@property (nonatomic, retain) IBOutlet UIButton *insertPhotoFromCamera;
@property (nonatomic, retain) IBOutlet UIButton *insertPhotoFromAlbum;
@property (nonatomic, retain) IBOutlet UIButton *clearPhoto;
@property (nonatomic, retain) IBOutlet UILabel *idTag;
@property (nonatomic, retain) IBOutlet UITextField *identifierField;
@property (nonatomic, retain) IBOutlet UILabel *firstNameTag;
@property (nonatomic, retain) IBOutlet UITextField *firstNameField;
@property (nonatomic, retain) IBOutlet UILabel *lastNameTag;
@property (nonatomic, retain) IBOutlet UITextField *lastNameField;
@property (nonatomic, retain) IBOutlet UIButton *hideKeyboard;
@property (nonatomic, retain) IBOutlet UILabel *dobTag;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;
@property (nonatomic, retain) IBOutlet UIButton *dobActivate;
@property (nonatomic, retain) IBOutlet UIButton *dobDeactivate;
@property (nonatomic, retain) IBOutlet UILabel *dobPickerLabel;
@property (nonatomic, retain) IBOutlet UIDatePicker *dobPicker;
@property BOOL isDOBActive;
@property (nonatomic, retain) IBOutlet UILabel *notesContent;
@property (nonatomic, retain) IBOutlet UIButton *notesShow;
@property (nonatomic, retain) IBOutlet UIView *notesView;
@property (nonatomic, retain) IBOutlet UILabel *notesHeading;
@property (nonatomic, retain) IBOutlet UITextView *notesField;
@property (nonatomic, retain) IBOutlet UIButton *notesDismiss;
@property (nonatomic, retain) IBOutlet UILabel *interviewScale;
@property (nonatomic, retain) IBOutlet UILabel *interviewDate;
@property (nonatomic, retain) IBOutlet UILabel *interviewScore;
@property (nonatomic, retain) NSMutableArray *interviews;
@property (nonatomic, retain) IBOutlet UITableView *interviewsTable;
@property (nonatomic, retain) ScoreSelected *selectedInterview;
@property (nonatomic, retain) IBOutlet UIButton *deletePatient;

- (void)setupPatient:(PatientSelected *)senderPatient;


@end
