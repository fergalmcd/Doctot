//
//  CustomButton.h
//  Doctot
//
//  Created by Fergal McDonnell on 10/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton {
    
    NSUserDefaults *prefs;
    
    NSString *origin;
    NSInteger order;
    NSString *type;
    
    UIImageView *underline;
    UIImageView *chevron;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *origin;
@property NSInteger order;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) IBOutlet UIImageView *underline;
@property (nonatomic, retain) IBOutlet UIImageView *chevron;

- (void)setupForOrigin:(NSString *)theOrigin withKey:(NSString *)theKey andReference:(NSString *)theReference;
- (void)adjustWidth:(float)newWidth;

@end
