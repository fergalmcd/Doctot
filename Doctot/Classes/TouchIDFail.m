//
//  TouchIDFail.m
//  Doctot
//
//  Created by Fergal McDonnell on 18/05/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "TouchIDFail.h"
#import "Helper.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation TouchIDFail

@synthesize retry, passwordAlsoRequired;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    [retry setTitle:NSLocalizedString(@"Settings_TouchIDRetry", @"") forState:UIControlStateNormal];
    
}

- (IBAction)retryTouchID {
    
    LAContext *context = [[LAContext alloc] init];
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:NSLocalizedString(@"Settings_TouchIDRequest", @"")
                      reply:^(BOOL success, NSError *error) {
                          if (success) {
                              dispatch_async(dispatch_get_main_queue(), ^(void){
                                  [self dismissView];
                              });
                          }
                          else {
                              //NSLog(@"Error received: %d", error);
                          }
                      }];
    
}

- (IBAction)dismissView {
    [self removeFromSuperview];
    if( !passwordAlsoRequired ){
        [Helper showNavigationBar:YES];
    }
}


@end
