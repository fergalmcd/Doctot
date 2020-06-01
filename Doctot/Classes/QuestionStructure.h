//
//  QuestionStructure.h
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionStructure : NSObject {
    
    NSInteger index;
    NSInteger defaultScore;
    BOOL showScore;
    BOOL showItemScores;
    NSMutableArray *items;
    
}

@property NSInteger index;
@property NSInteger defaultScore;
@property BOOL showScore;
@property BOOL showItemScores;
@property (nonatomic, retain) NSMutableArray *items;

- (void)initialiseWithObject:(id)questionDict;


@end
