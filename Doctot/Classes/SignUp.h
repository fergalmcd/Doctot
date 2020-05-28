//
//  SignUp.h
//  DoctotDepression
//
//  Created by Fergal McDonnell on 12/11/2009.
//  Copyright Doctot 2014. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignUp : UIView <UITextFieldDelegate, UITableViewDelegate> {
    
    NSUserDefaults *prefs;
    
    UIImageView *signup_content;
    UILabel *welcome_message;
    UILabel *welcome_submessage;
    UILabel *firstName_label;
    UILabel *lastName_label;
    UILabel *email_label;
    UILabel *warning_label;
    UIImageView *warningImage;
	
    UITextField *firstName;
    UITextField *lastName;
    UITextField *email;
    UIButton *registerApp;
    
    bool isFirstNameAccessed;
    bool isLastNameAccessed;
    bool isEmailAccessed;
    
    UIImageView *logoBand;
    UIImageView *logo;
    UIImageView *logoDoctot;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIImageView *signup_content;
@property (nonatomic, retain) IBOutlet UILabel *welcome_message;
@property (nonatomic, retain) IBOutlet UILabel *welcome_submessage;
@property (nonatomic, retain) IBOutlet UILabel *firstName_label;
@property (nonatomic, retain) IBOutlet UILabel *lastName_label;
@property (nonatomic, retain) IBOutlet UILabel *email_label;
@property (nonatomic, retain) IBOutlet UILabel *warning_label;
@property (nonatomic, retain) IBOutlet UIImageView *warningImage;
@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UIButton *registerApp;
@property bool isFirstNameAccessed;
@property bool isLastNameAccessed;
@property bool isEmailAccessed;
@property (nonatomic, retain) IBOutlet UIImageView *logoBand;
@property (nonatomic, retain) IBOutlet UIImageView *logo;
@property (nonatomic, retain) IBOutlet UIImageView *logoDoctot;

- (void)initialise;
- (BOOL)canProceedFromRegistration;
- (BOOL)checkDataValidity;
- (BOOL)isEmailCurrentlyConfiguredCorrectly;


@end
