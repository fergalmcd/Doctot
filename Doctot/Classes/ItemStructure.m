//
//  ItemStructure.m
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import "ItemStructure.h"
#import "Helper.h"


@implementation ItemStructure

@synthesize index, type, subtype, defaultScore, offScore, onScore;
@synthesize markerSpaces, direction, scoreRanges;
@synthesize startLeftScore, startRightScore, singleTapSpaces, doubleTapSpaces;
@synthesize selectorButtons, bundles;
@synthesize defaultPosition, precision, height, width, groupSize, backgroundImageName, gripImageName;
@synthesize singleRotationSize;
@synthesize startSeconds, endSeconds, timingRanges;
@synthesize numberOfPickers, pickers, outputItems, outputResults;

- (void)initialiseWithObject:(id)initialItem {
    
    index = [[initialItem valueForKey:@"index"] integerValue];
    type = [initialItem valueForKey:@"type"];
    
    if( [type isEqualToString:@"Button"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        offScore = [[initialItem valueForKey:@"offScore"] floatValue];
        onScore = [[initialItem valueForKey:@"onScore"] floatValue];
    }
    
    if( [type isEqualToString:@"Slider"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        offScore = [[initialItem valueForKey:@"minScore"] floatValue];
        onScore = [[initialItem valueForKey:@"maxScore"] floatValue];
        markerSpaces = [[initialItem valueForKey:@"markerSpaces"] integerValue];
        direction = [initialItem valueForKey:@"direction"];
        scoreRanges = [initialItem valueForKey:@"scoreRanges"];
    }
    
    if( [type isEqualToString:@"Swiper"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        offScore = [[initialItem valueForKey:@"minScore"] floatValue];
        onScore = [[initialItem valueForKey:@"maxScore"] floatValue];
        precision = [[initialItem valueForKey:@"precision"] integerValue];
        startLeftScore = [[initialItem valueForKey:@"startLeftScore"] floatValue];
        startRightScore = [[initialItem valueForKey:@"startRightScore"] floatValue];
        singleTapSpaces = [[initialItem valueForKey:@"singleTapSpaces"] floatValue];
        doubleTapSpaces = [[initialItem valueForKey:@"doubleTapSpaces"] floatValue];        
        direction = [initialItem valueForKey:@"direction"];
        scoreRanges = [initialItem valueForKey:@"scoreRanges"];
    }
    
    if( [type isEqualToString:@"Selector"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        scoreRanges = [initialItem valueForKey:@"scoreRanges"];
        selectorButtons = [initialItem valueForKey:@"selectorButtons"];
        bundles = [initialItem valueForKey:@"bundles"];
    }
    
    if( [type isEqualToString:@"EnergyBar"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        offScore = [[initialItem valueForKey:@"minScore"] floatValue];
        onScore = [[initialItem valueForKey:@"maxScore"] floatValue];
        defaultPosition = [[initialItem valueForKey:@"defaultPosition"] floatValue];
        precision = [[initialItem valueForKey:@"precision"] integerValue];
        height = [[initialItem valueForKey:@"height"] floatValue];
        width = [[initialItem valueForKey:@"width"] floatValue];
        groupSize = [[initialItem valueForKey:@"groupSize"] floatValue];
        backgroundImageName = [initialItem valueForKey:@"backgroundImage"];
        gripImageName = [initialItem valueForKey:@"gripImage"];
        scoreRanges = [initialItem valueForKey:@"scoreRanges"];
    }
    
    if( [type isEqualToString:@"Rotator"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        offScore = [[initialItem valueForKey:@"minScore"] floatValue];
        onScore = [[initialItem valueForKey:@"maxScore"] floatValue];
        defaultPosition = [[initialItem valueForKey:@"defaultPosition"] floatValue];
        singleRotationSize = [[initialItem valueForKey:@"singleRotationSize"] floatValue];
        precision = [[initialItem valueForKey:@"precision"] integerValue];
        scoreRanges = [initialItem valueForKey:@"scoreRanges"];
    }
    
    if( [type isEqualToString:@"Stopwatch"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        startSeconds = [[initialItem valueForKey:@"startSeconds"] floatValue];
        endSeconds = [[initialItem valueForKey:@"endSeconds"] floatValue];
        timingRanges = [initialItem valueForKey:@"timingRanges"];
    }
    
    if( [type isEqualToString:@"CrossReference"] ){
        subtype = [initialItem valueForKey:@"subtype"];
        defaultScore = [[initialItem valueForKey:@"defaultScore"] floatValue];
        numberOfPickers = [[initialItem valueForKey:@"numberOfPickers"] floatValue];
        scoreRanges = [initialItem valueForKey:@"scoreRanges"];
        outputItems = [initialItem valueForKey:@"outputItems"];
        outputResults = [initialItem valueForKey:@"outputResults"];
        pickers = [initialItem valueForKey:@"pickers"];
    }
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
