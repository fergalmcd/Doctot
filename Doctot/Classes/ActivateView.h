//
//  ActivateView.h
//  Doctot
//
//  Created by Fergal McDonnell on 03/01/2019.
//  Copyright Doctot 2019. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivateView : UIView {
    
    UILabel *unactivatedMessage;
    UIButton *activate_button;
    UIButton *continueWithoutActivation_button;
    UIButton *resendEmail_button;
    
    NSUserDefaults *activatePrefs;
    
}

@property (nonatomic, retain) IBOutlet UILabel *unactivatedMessage;
@property (nonatomic, retain) IBOutlet UIButton *activate_button;
@property (nonatomic, retain) IBOutlet UIButton *continueWithoutActivation_button;
@property (nonatomic, retain) IBOutlet UIButton *resendEmail_button;
@property (nonatomic, retain) NSUserDefaults *activatePrefs;

- (void)initialise;
- (IBAction)executeActivate;


@end
