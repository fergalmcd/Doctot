//
//  SettingsExtended.h
//  Doctot
//
//  Created by Fergal McDonnell on 30/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsExtended : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate> {
    
    NSUserDefaults *prefs;
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    UIView *ownerDetails;
    UIScrollView *ownerScrollView;
    UIView *ownerDetailsContentView;
    UILabel *firstNameLabel;
    UITextField *firstName;
    UILabel *lastNameLabel;
    UITextField *lastName;
    UILabel *emailLabel;
    UITextField *email;
    UILabel *descriptionLabel;
    UITextField *description;
    UILabel *professionLabel;
    UILabel *profession;
    UIButton *professionActivate;
    UIPickerView *professionPicker;
    NSMutableArray *professionOptions;
    UILabel *specialtyLabel;
    UILabel *specialty;
    UIButton *specialtyActivate;
    UIPickerView *specialtyPicker;
    NSMutableArray *specialtyOptions;
    UILabel *dobLabel;
    UILabel *dob;
    UIButton *dobActivate;
    UIDatePicker *dobPicker;
    UILabel *allowEmailLabel;
    UISwitch *allowEmail;
    UILabel *photoLinkLabel;
    UITextField *photoLink;
    UIButton *submitOwnerDetails;
    UIButton *logoutButton;
    
    UIView *pinUpdateView;
    UILabel *pinHeading;
    UILabel *pinSubeading;
    UILabel *pinWarning;
    UIImageView *pinNumbers;
    UITextField *pinField1;
    UITextField *pinField2;
    UITextField *pinField3;
    UITextField *pinField4;
    UIButton *pin0;
    UIButton *pin1;
    UIButton *pin2;
    UIButton *pin3;
    UIButton *pin4;
    UIButton *pin5;
    UIButton *pin6;
    UIButton *pin7;
    UIButton *pin8;
    UIButton *pin9;
    UIButton *reversePINEntry;
    NSString *pinToDate;
    NSString *pinUpdateState;
    
    UIView *maxSavesView;
    UISlider *maxSaves;
    UILabel *maxSavesInstructionLabel;
    UILabel *maxSavesCounterLabel;
    
    UIView *mtsSpecificView;
    UILabel *mtsAddressLabel;
    UITextField *mtsAddress;
    UILabel *mtsAddressCurrentLabel;
    UITextField *mtsAddressCurrent;
    UILabel *mtsHistoricalEventLabel;
    UILabel *mtsHistoricalEventQuestionLabel;
    UITextField *mtsHistoricalEventQuestion;
    UILabel *mtsHistoricalEventAnswerLabel;
    UITextField *mtsHistoricalEventAnswer;
    UILabel *mtsHeadOfStateLabel;
    UITextField *mtsHeadOfState;
    
    UIView *cachSpecificView;
    UILabel *cachCalciumLabel;
    UISegmentedControl *cachCalciumControl;
    UILabel *cachAlbuminLabel;
    UISegmentedControl *cachAlbuminControl;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIView *ownerDetails;
@property (nonatomic, retain) IBOutlet UIScrollView *ownerScrollView;
@property (nonatomic, retain) IBOutlet UIView *ownerDetailsContentView;
@property (nonatomic, retain) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UITextField *description;
@property (nonatomic, retain) IBOutlet UILabel *professionLabel;
@property (nonatomic, retain) IBOutlet UILabel *profession;
@property (nonatomic, retain) IBOutlet UIButton *professionActivate;
@property (nonatomic, retain) IBOutlet UIPickerView *professionPicker;
@property (nonatomic, retain) NSMutableArray *professionOptions;
@property (nonatomic, retain) IBOutlet UILabel *specialtyLabel;
@property (nonatomic, retain) IBOutlet UILabel *specialty;
@property (nonatomic, retain) IBOutlet UIButton *specialtyActivate;
@property (nonatomic, retain) IBOutlet UIPickerView *specialtyPicker;
@property (nonatomic, retain) NSMutableArray *specialtyOptions;
@property (nonatomic, retain) IBOutlet UILabel *dobLabel;
@property (nonatomic, retain) IBOutlet UILabel *dob;
@property (nonatomic, retain) IBOutlet UIButton *dobActivate;
@property (nonatomic, retain) IBOutlet UIDatePicker *dobPicker;
@property (nonatomic, retain) IBOutlet UILabel *allowEmailLabel;
@property (nonatomic, retain) IBOutlet UISwitch *allowEmail;
@property (nonatomic, retain) IBOutlet UILabel *photoLinkLabel;
@property (nonatomic, retain) IBOutlet UITextField *photoLink;
@property (nonatomic, retain) IBOutlet UIButton *submitOwnerDetails;
@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) IBOutlet UIView *pinUpdateView;
@property (nonatomic, retain) IBOutlet UILabel *pinHeading;
@property (nonatomic, retain) IBOutlet UILabel *pinSubheading;
@property (nonatomic, retain) IBOutlet UILabel *pinWarning;
@property (nonatomic, retain) IBOutlet UIImageView *pinNumbers;
@property (nonatomic, retain) IBOutlet UITextField *pinField1;
@property (nonatomic, retain) IBOutlet UITextField *pinField2;
@property (nonatomic, retain) IBOutlet UITextField *pinField3;
@property (nonatomic, retain) IBOutlet UITextField *pinField4;
@property (nonatomic, retain) IBOutlet UIButton *pin0;
@property (nonatomic, retain) IBOutlet UIButton *pin1;
@property (nonatomic, retain) IBOutlet UIButton *pin2;
@property (nonatomic, retain) IBOutlet UIButton *pin3;
@property (nonatomic, retain) IBOutlet UIButton *pin4;
@property (nonatomic, retain) IBOutlet UIButton *pin5;
@property (nonatomic, retain) IBOutlet UIButton *pin6;
@property (nonatomic, retain) IBOutlet UIButton *pin7;
@property (nonatomic, retain) IBOutlet UIButton *pin8;
@property (nonatomic, retain) IBOutlet UIButton *pin9;
@property (nonatomic, retain) IBOutlet UIButton *reversePINEntry;
@property (nonatomic, retain) NSString *pinToDate;
@property (nonatomic, retain) NSString *pinUpdateState;
@property (nonatomic, retain) IBOutlet UIView *maxSavesView;
@property (nonatomic, retain) IBOutlet UISlider *maxSaves;
@property (nonatomic, retain) IBOutlet UILabel *maxSavesInstructionLabel;
@property (nonatomic, retain) IBOutlet UILabel *maxSavesCounterLabel;
@property (nonatomic, retain) IBOutlet UIView *mtsSpecificView;
@property (nonatomic, retain) IBOutlet UILabel *mtsAddressLabel;
@property (nonatomic, retain) IBOutlet UITextField *mtsAddress; // Recall Address
@property (nonatomic, retain) IBOutlet UILabel *mtsAddressCurrentLabel;
@property (nonatomic, retain) IBOutlet UITextField *mtsAddressCurrent;
@property (nonatomic, retain) IBOutlet UILabel *mtsHistoricalEventLabel;
@property (nonatomic, retain) IBOutlet UILabel *mtsHistoricalEventQuestionLabel;
@property (nonatomic, retain) IBOutlet UITextField *mtsHistoricalEventQuestion;
@property (nonatomic, retain) IBOutlet UILabel *mtsHistoricalEventAnswerLabel;
@property (nonatomic, retain) IBOutlet UITextField *mtsHistoricalEventAnswer;
@property (nonatomic, retain) IBOutlet UILabel *mtsHeadOfStateLabel;
@property (nonatomic, retain) IBOutlet UITextField *mtsHeadOfState;
@property (nonatomic, retain) IBOutlet UIView *cachSpecificView;
@property (nonatomic, retain) IBOutlet UILabel *cachCalciumLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *cachCalciumControl;
@property (nonatomic, retain) IBOutlet UILabel *cachAlbuminLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *cachAlbuminControl;

- (void)setup:(UIView *)viewToDisplay;


@end
