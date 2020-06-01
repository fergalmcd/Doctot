//
//  QuestionStructure.m
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import "QuestionStructure.h"
#import "ItemStructure.h"
#import "Helper.h"


@implementation QuestionStructure

@synthesize index, defaultScore, showScore, showItemScores, items;

- (void)initialiseWithObject:(id)questionDict {
    
    index = [[questionDict valueForKey:@"index"] integerValue];
    defaultScore = [[questionDict valueForKey:@"defaultScore"] integerValue];
    NSString *showScoreString = (NSString *)[questionDict valueForKey:@"displayScore"];
    if( [showScoreString isEqualToString:@"NO"] ){
        showScore = NO;
    }else{
        showScore = YES;
    }
    NSString *showItemScoresString = (NSString *)[questionDict valueForKey:@"displayItemScore"];
    if( [showItemScoresString isEqualToString:@"NO"] ){
        showItemScores = NO;
    }else{
        showItemScores = YES;
    }
    
    items = [[NSMutableArray alloc] init];
    ItemStructure *itemStructure;
    for( int j = 0; j < [(NSArray *)[questionDict allKeys] count]; j++ ){
        NSString *jRef = [NSString stringWithFormat:@"item%i", j];
        NSDictionary *singleItem = questionDict[jRef];
        if( [(NSArray *)[singleItem allKeys] count] > 0 ){
            itemStructure = [[ItemStructure alloc] init];
            [itemStructure initialiseWithObject:singleItem];
            [items addObject:itemStructure];
        }
    }
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
