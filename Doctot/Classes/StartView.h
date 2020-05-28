//
//  StartView.h
//  DoctotDepression
//
//  Created by Fergal McDonnell on 12/11/2009.
//  Copyright Doctot 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIView {
    
	UILabel *support_label;
	UIButton *continue_button;
	
}

@property (nonatomic, retain) IBOutlet UILabel *support_label;
@property (nonatomic, retain) IBOutlet UIButton *continue_button;

- (void)initialise;
- (void)dismissViewAfterPause;


@end
