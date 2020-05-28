//
//  Password.h
//  Doctot
//
//  Created by Fergal McDonnell on 12/11/2009.
//  Copyright Doctot 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Password : UIView {
	UINavigationBar *navigation_bar;
	UINavigationItem *navigation_item;
	
	UILabel *welcome_label;
    UILabel *password_label;
	UILabel *warning_label;
	UIImageView *warning_image;
    UIImageView *pinNumbers;
	UITextField *password;
    UIImageView *pinBackground;
    UITextField *password_char1;
    UIImageView *pinCharacterDivider1;
    UITextField *password_char2;
    UIImageView *pinCharacterDivider2;
    UITextField *password_char3;
    UIImageView *pinCharacterDivider3;
    UITextField *password_char4;
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
	UIButton *clearPassword;
	UIImageView *login_background;
	
	NSString *passwordToDate;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigation_bar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigation_item;

@property (nonatomic, retain) IBOutlet UILabel *welcome_label;
@property (nonatomic, retain) IBOutlet UILabel *password_label;
@property (nonatomic, retain) IBOutlet UILabel *warning_label;
@property (nonatomic, retain) IBOutlet UIImageView *warning_image;
@property (nonatomic, retain) IBOutlet UIImageView *pinNumbers;
@property (nonatomic, retain) IBOutlet UIImageView *pinBackground;
@property (nonatomic, retain) IBOutlet UITextField *password_char1;
@property (nonatomic, retain) IBOutlet UIImageView *pinCharacterDivider1;
@property (nonatomic, retain) IBOutlet UITextField *password_char2;
@property (nonatomic, retain) IBOutlet UIImageView *pinCharacterDivider2;
@property (nonatomic, retain) IBOutlet UITextField *password_char3;
@property (nonatomic, retain) IBOutlet UIImageView *pinCharacterDivider3;
@property (nonatomic, retain) IBOutlet UITextField *password_char4;
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
@property (nonatomic, retain) IBOutlet UIButton *clearPassword;
@property (nonatomic, retain) IBOutlet UIImageView *login_background;

@property (nonatomic, retain) IBOutlet NSString *passwordToDate;

- (void)setup;
- (void)configurePINFields;
- (void)configurePINNumberPad;


@end
