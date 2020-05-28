//
//  ScaleDefinition.h
//  Doctot
//
//  Created by Fergal McDonnell on 05/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleDefinition : NSObject {
    
    NSString *name;
    NSInteger identifier;
    NSString *displayTitle;
    NSString *parentApp;
    NSString *allowsSettingsConfigurationString;
    BOOL allowsSettingsConfiguration;
    NSString *isScaleString;
    BOOL isScale;
    NSInteger precision;
    
    NSArray *arrayInformation;
    NSDictionary *informationElementsIncluded;
    NSString *helpSource;
    BOOL areinformationElementsIncluded;
    NSDictionary *helpElementsIncluded;
    BOOL areHelpElementsIncluded;
    NSMutableArray *diagnosisLevels;
    
    NSMutableArray *questions;
    
}

@property (nonatomic, retain) NSString *name;
@property NSInteger identifier;
@property (nonatomic, retain) NSString *displayTitle;
@property (nonatomic, retain) NSString *parentApp;
@property (nonatomic, retain) NSString *allowsSettingsConfigurationString;
@property BOOL allowsSettingsConfiguration;
@property (nonatomic, retain) NSString *isScaleString;
@property BOOL isScale;
@property NSInteger precision;
@property (nonatomic, retain) NSArray *arrayInformation;
@property (nonatomic, retain) NSDictionary *informationElementsIncluded;
@property (nonatomic, retain) NSString *helpSource;
@property BOOL areinformationElementsIncluded;
@property (nonatomic, retain) NSDictionary *helpElementsIncluded;
@property BOOL areHelpElementsIncluded;
@property (nonatomic, retain) NSMutableArray *diagnosisLevels;
@property (nonatomic, retain) NSMutableArray *questions;

- (void)setup:(id)jsonObject forKey:(NSString *)jsonKey;


@end
