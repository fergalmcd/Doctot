//
//  Book.h
//  Doctot
//
//  Created by Fergal McDonnell on 26/09/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleDefinition.h"


@interface Book : UIViewController {
    
    NSUserDefaults *prefs;
    
    NSString *name;
    ScaleDefinition *definition;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) ScaleDefinition *definition;

- (void)setup:(id)jsonObject forKey:(NSString *)jsonKey;


@end
