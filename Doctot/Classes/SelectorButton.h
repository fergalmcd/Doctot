//
//  SelectorButton.h
//  Doctot
//
//  Created by Fergal McDonnell on 26/06/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectorButton : UIButton {
    
    NSUserDefaults *prefs;
    NSString *scaleName;
    NSString *parentType;
    int questionIndex;
    int parentIndex;
    
    NSString *key;
    NSInteger order;
    
    float defaultScore;
    float offScore;
    float onScore;
    NSDictionary *dictionary;
    BOOL externalDescriptionActive;
    
    CGPoint gridPosition;
    NSString *canvas;
    NSInteger canvasIndex;
    
    UILabel *heading;
    UILabel *subHeading;
    UILabel *externalDescription;
    UIImageView *displayImage;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSString *scaleName;
@property (nonatomic, retain) NSString *parentType;
@property int questionIndex;
@property int parentIndex;
@property (nonatomic, retain) NSString *key;
@property NSInteger order;
@property float defaultScore;
@property float offScore;
@property float onScore;
@property (nonatomic, retain) NSDictionary *dictionary;
@property BOOL externalDescriptionActive;
@property CGPoint gridPosition;
@property (nonatomic, retain) NSString *canvas;
@property NSInteger canvasIndex;
@property (nonatomic, retain) UILabel *heading;
@property (nonatomic, retain) UILabel *subHeading;
@property (nonatomic, retain) UILabel *externalDescription;
@property (nonatomic, retain) UIImageView *displayImage;

- (void)setupWithKey:(id)theKey andDictionary:(NSDictionary *)sourceDictionaryData andParentType:(NSString *)theParentType;
- (void)configureInterface;
- (void)drawInterface;
- (void)configureGridPosition:(int)allButtonsCount;
- (int)calculateMaxXSize:(int)theSize;
- (void)showExpandedDetails;
- (void)clearExpandedDetails;
- (void)minimiseForBundle;


@end
