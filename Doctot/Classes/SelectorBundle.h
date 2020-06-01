//
//  SelectorBundle.h
//  Doctot
//
//  Created by Fergal McDonnell on 26/06/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "SelectorButton.h"
#import <UIKit/UIKit.h>

@interface SelectorBundle : UIView {
    
    NSUserDefaults *prefs;
    NSString *scaleName;
    NSString *parentType;
    int questionIndex;
    int parentIndex;
    
    NSString *key;
    NSInteger order;
    NSString *positionOnScreen;
    float receiverScore;
    NSDictionary *dictionary;
    
    UILabel *heading;
    UILabel *subHeading;
    UIImageView *displayImage;
    NSMutableArray *selectorButtons;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *scaleName;
@property (nonatomic, retain) NSString *parentType;
@property int questionIndex;
@property int parentIndex;
@property (nonatomic, retain) NSString *key;
@property NSInteger order;
@property (nonatomic, retain) NSString *positionOnScreen;
@property float receiverScore;
@property (nonatomic, retain) NSDictionary *dictionary;

@property (nonatomic, retain) UILabel *heading;
@property (nonatomic, retain) UILabel *subHeading;
@property (nonatomic, retain) UIImageView *displayImage;
@property (nonatomic, retain) NSMutableArray *selectorButtons;

- (void)setupWithKey:(id)theKey andDictionary:(NSDictionary *)sourceDictionaryData andParentType:(NSString *)theParentType;
- (void)configureInterface;
- (void)addSelectorButton:(SelectorButton *)newSelectorButton;
- (void)removeSelectorButton:(SelectorButton *)newSelectorButton;
- (void)resetSelectorButtons;


@end
