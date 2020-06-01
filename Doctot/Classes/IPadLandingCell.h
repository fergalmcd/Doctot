//
//  IPadLandingCell.h
//  Doctot
//
//  Created by Fergal McDonnell on 03/05/2019.
//  Copyright © 2019 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleDefinition.h"

@interface IPadLandingCell : UIView {
    
    NSUserDefaults *prefs;
    ScaleDefinition *scaleDefinition;
    
    UIImageView *background;
    UILabel *title;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) ScaleDefinition *scaleDefinition;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet UILabel *title;

- (void)setupForScaleDefinition:(ScaleDefinition *)theScaleDefinition;


@end
