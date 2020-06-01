//
//  CustomButton.m
//  Doctot
//
//  Created by Fergal McDonnell on 10/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "CustomButton.h"
#import "Helper.h"

@interface CustomButton ()

@end

@implementation CustomButton

@synthesize prefs, origin, order, type;
@synthesize underline, chevron;

float NORTH_PADDING = 20;
float BUTTON_HEIGHT = 50;

// Sample call: [tempButton setupForOrigin:@"Info" withKey:key andReference:[scaleDefinition.informationElementsIncluded objectForKey:key]];

- (void)setupForOrigin:(NSString *)theOrigin withKey:(NSString *)theKey andReference:(NSString *)theReference {
    
    origin = theOrigin;
    order = [theKey integerValue];
    type = theReference;
    NSString *titleReference;
    if( [origin isEqualToString:@"Info"] ){
        titleReference = [NSString stringWithFormat:@"Scale_Info_%@", type];
    }
    if( [origin isEqualToString:@"Help"] ){
        titleReference = [NSString stringWithFormat:@"Scale_Help_%@", type];
    }
    [self setTitle:[Helper getLocalisedString:titleReference withScalePrefix:NO] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(0, (NORTH_PADDING + (BUTTON_HEIGHT * order)), [UIScreen mainScreen].bounds.size.width, BUTTON_HEIGHT);
    
    [self includeVisuals];
    [self customise];
    
}

- (void)includeVisuals {
    
    chevron = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    chevron.image = [UIImage imageNamed:@"chevron_white_right.png"];
    chevron.contentMode = UIViewContentModeCenter;
    
    underline = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2)];
    underline.image = [UIImage imageNamed:@"content.png"];
    
}

- (void)customise {
    
    // Info Menu Buttons
    if( [origin isEqualToString:@"Info"] ){
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self.titleLabel.font pointSize]]];
        self.frame = CGRectMake(25, self.frame.origin.y, self.frame.size.width - 50, self.frame.size.height);
        
        [self includeVisuals];
        
        underline.alpha = 0.3;
        
    }
    
    // Help Menu Buttons
    if( [origin isEqualToString:@"Help"] ){
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self.titleLabel.font pointSize]]];
        self.frame = CGRectMake(25, self.frame.origin.y, self.frame.size.width - 50, self.frame.size.height);
        
        [self includeVisuals];
        
        underline.alpha = 0.3;
        
    }
    
    [self addSubview:chevron];
    [self addSubview:underline];

}

- (void)adjustWidth:(float)newWidth {
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
    chevron.frame = CGRectMake((newWidth - chevron.frame.size.width), chevron.frame.origin.y, chevron.frame.size.width, chevron.frame.size.height);
    underline.frame = CGRectMake(underline.frame.origin.x, underline.frame.origin.y, newWidth, underline.frame.size.height);
    
}


@end

