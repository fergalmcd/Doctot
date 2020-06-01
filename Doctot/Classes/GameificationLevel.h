//
//  GameificationLevel.h
//  Doctot
//
//  Created by Fergal McDonnell on 16/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameificationLevel : NSObject {
    
    NSString *key;
    float index;
    NSString *name;
    NSString *alternateName;
    NSString *sublevel;
    float maximumScore;
    float minimumScore;
    
}

@property (nonatomic, retain) NSString *key;
@property float index;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *alternateName;
@property (nonatomic, retain) NSString *sublevel;
@property float maximumScore;
@property float minimumScore;

@end
