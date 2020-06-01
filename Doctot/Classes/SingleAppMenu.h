//
//  ActivateView.h
//  Doctot
//
//  Created by Fergal McDonnell on 04/03/2019.
//  Copyright Doctot 2019. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleDefinition.h"

@interface SingleAppMenu : UIView {
    
    UILabel *mainHeading;
    UILabel *subHeading;
    UIButton *startInterview;
    UIButton *viewInformation;
    UIButton *viewScores;
    
    NSUserDefaults *singleAppViewPrefs;
    ScaleDefinition *scaleDefinition;
    
    
}

@property (nonatomic, retain) IBOutlet UILabel *mainHeading;
@property (nonatomic, retain) IBOutlet UILabel *subHeading;
@property (nonatomic, retain) IBOutlet UIButton *startInterview;
@property (nonatomic, retain) IBOutlet UIButton *viewInformation;
@property (nonatomic, retain) IBOutlet UIButton *viewScores;
@property (nonatomic, retain) NSUserDefaults *singleAppViewPrefs;
@property (nonatomic, retain) ScaleDefinition *scaleDefinition;

- (void)initialise;


@end
