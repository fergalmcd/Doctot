//
//  StartView.m
//  DoctotDepression
//
//  Created by Fergal McDonnell on 12/11/2009.
//  Copyright Doctot 2014. All rights reserved.
//

#import "StartView.h"
#import "AppDelegate.h"
#import "Helper.h"


@implementation StartView

@synthesize support_label;
@synthesize continue_button;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)initialise {
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (IBAction)dismissView {
    [self removeFromSuperview];
    [Helper showNavigationBar:YES];
}

- (void)dismissViewAfterPause {

    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
    
}


@end
