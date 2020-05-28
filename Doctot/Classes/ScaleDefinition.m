//
//  ScaleDefinition.m
//  Doctot
//
//  Created by Fergal McDonnell on 05/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "ScaleDefinition.h"
#import "QuestionStructure.h"
#import "ItemStructure.h"
#import "DiagnosisElement.h"
#import "Helper.h"


@implementation ScaleDefinition

@synthesize name, identifier, displayTitle, parentApp, allowsSettingsConfigurationString, allowsSettingsConfiguration, isScaleString, isScale, precision;
@synthesize arrayInformation, informationElementsIncluded, areinformationElementsIncluded, helpSource, helpElementsIncluded, areHelpElementsIncluded, diagnosisLevels;
@synthesize questions;

- (void)setup:(id)jsonObject forKey:(NSString *)jsonKey {
    
    name = jsonKey;
    identifier = [[jsonObject objectForKey:@"index"] integerValue];
    displayTitle = (NSString *)[jsonObject objectForKey:@"displayTitle"];
    parentApp = (NSString *)[jsonObject objectForKey:@"parentApp"];
    
    allowsSettingsConfigurationString = (NSString *)[jsonObject objectForKey:@"allowsSettingsConfiguration"];
    if( [allowsSettingsConfigurationString isEqualToString:@"NO"] ){
        allowsSettingsConfiguration = NO;
    }else{
        allowsSettingsConfiguration = YES;
    }
    
    isScaleString = (NSString *)[jsonObject objectForKey:@"isScale"];
    if( [isScaleString isEqualToString:@"NO"] ){
        isScale = NO;
    }else{
        isScale = YES;
    }
    
    precision = [[jsonObject objectForKey:@"precision"] integerValue];
    
    arrayInformation = (NSArray *)[jsonObject objectForKey:@"arrayInformation"];
    
    informationElementsIncluded = [[arrayInformation valueForKey:@"informationElementsIncluded"] objectAtIndex:0];
    areinformationElementsIncluded = YES;
    for(id key in informationElementsIncluded ){
        NSString *keyAsString = (NSString *)[informationElementsIncluded objectForKey:@"Any"];
        if( [keyAsString isEqualToString:@"NO"] ){
                areinformationElementsIncluded = NO;
        }
        //NSLog(@"Key: %@   Value: %@", key, [informationElementsIncluded objectForKey:key]);
    }
    
    helpSource = (NSString *)[[arrayInformation valueForKey:@"helpSource"] objectAtIndex:0];
    
    helpElementsIncluded = [[arrayInformation valueForKey:@"helpElementsIncluded"] objectAtIndex:0];
    areHelpElementsIncluded = YES;
    for(id key in helpElementsIncluded ){
        NSString *keyAsString = (NSString *)[helpElementsIncluded objectForKey:@"1"];
        if( [keyAsString isEqualToString:@"NONE"] ){
            areHelpElementsIncluded = NO;
        }
        //NSLog(@"Key: %@   Value: %@", key, [helpElementsIncluded objectForKey:key]);
    }
    
    NSDictionary *allDiagnosisLevelsDict = (NSDictionary *)[[arrayInformation valueForKey:@"diagnosisLevels"] objectAtIndex:0];
    if( ![allDiagnosisLevelsDict isKindOfClass:[NSNull class]] ){
    
        DiagnosisElement *diagnosisElement;
        diagnosisLevels = [[NSMutableArray alloc] init];
        
        for(id key in allDiagnosisLevelsDict ){
            diagnosisElement = [[DiagnosisElement alloc] init];
            
            diagnosisElement.scale = name;
            diagnosisElement.name = key;
            NSDictionary *attributes = [allDiagnosisLevelsDict objectForKey:key];
            diagnosisElement.index = [[attributes valueForKey:@"index"] integerValue];
            diagnosisElement.colourString = [attributes valueForKey:@"colour"];
            diagnosisElement.colour = [Helper getColourFromString:diagnosisElement.colourString];
            diagnosisElement.minScore = [[attributes valueForKey:@"minScore"] floatValue];
            NSString *theDescriptionReference = [NSString stringWithFormat:@"%@_Final_Diagnosis_Level%li", name, (diagnosisElement.index + 1)];
            diagnosisElement.description = [self filterReference:theDescriptionReference];
            theDescriptionReference = [theDescriptionReference stringByAppendingString:@"_Subtext"];
            diagnosisElement.descriptionSubtext = [self filterReference:theDescriptionReference];
            //diagnosisElement.descriptionSubtext = NSLocalizedString(theDescriptionReference, @"");
            theDescriptionReference = [NSString stringWithFormat:@"%@_Final_Diagnosis_Extended_Level%li", name, (diagnosisElement.index + 1)];
            diagnosisElement.descriptionHTML = [self filterReference:theDescriptionReference];
            //diagnosisElement.descriptionHTML = NSLocalizedString(theDescriptionReference, @"");
            if( [diagnosisElement.descriptionHTML isEqualToString:theDescriptionReference] ){
                diagnosisElement.descriptionHTML = @"";
            }
            
            [diagnosisLevels addObject:diagnosisElement];
        }
        
        diagnosisLevels = [Helper sortedArray:diagnosisLevels byIndex:@"minScore" andAscending:YES];
        
    }
    
    NSDictionary *allQuestionsDict = (NSDictionary *)[[arrayInformation valueForKey:@"questions"] objectAtIndex:0];
    if( ![allQuestionsDict isKindOfClass:[NSNull class]] ){
        
        QuestionStructure *questionStructure;
        ItemStructure *itemStructure;
        questions = [[NSMutableArray alloc] init];
        
        for( int i = 0; i < [(NSArray *)[allQuestionsDict allKeys] count]; i++ ){
            NSString *iRef = [NSString stringWithFormat:@"Q%i", (i + 1)];
            NSDictionary *questionDict = allQuestionsDict[iRef];
            questionStructure = [[QuestionStructure alloc] init];
            [questionStructure initialiseWithObject:questionDict];
            [questions addObject:questionStructure];
        }
        questions = [Helper sortedArray:questions byIndex:@"index" andAscending:YES];
    }
}

- (NSString *)filterReference:(NSString *)referenceString {
    NSString *resultString;
    NSString *reReference = NSLocalizedString(referenceString, @"");
    
    resultString = reReference;
    if( [reReference hasPrefix:@"Ref: "] ){
        reReference = [reReference substringFromIndex:5];
        resultString = NSLocalizedString(reReference, @"");
    }
    
    return resultString;
}


@end


