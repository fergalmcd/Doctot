//
//  Book.m
//  Doctot
//
//  Created by Fergal McDonnell on 26/09/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import "Book.h"
#import "Helper.h"
#import "Constants.h"

@interface Book ()

@end

@implementation Book

@synthesize prefs, name;
@synthesize definition;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = name;
    
    UIButton *leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    
}

- (void)setup:(id)jsonObject forKey:(NSString *)jsonKey {
    
    name = jsonKey;
    /*
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
    */
}


- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

