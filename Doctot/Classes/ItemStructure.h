//
//  ItemStructure.h
//  Doctot
//
//  Created by Fergal McDonnell on 12/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemStructure : NSObject {
    
    NSInteger index;
    NSString *type;
    NSString *subtype;
    float defaultScore;
    float offScore;
    float onScore;
    
    // Slider
    NSInteger markerSpaces;
    NSString *direction;
    NSDictionary *scoreRanges;
    
    // Swiper
    float startLeftScore;
    float startRightScore;
    float singleTapSpaces;
    float doubleTapSpaces;
    
    // Selector
    NSDictionary *selectorButtons;
    NSDictionary *bundles;
    
    // EnergyBar
    float defaultPosition;
    NSInteger precision;
    float height;
    float width;
    float groupSize;
    NSString *backgroundImageName;
    NSString *gripImageName;
    
    // Rotator
    float singleRotationSize;
    
    // Stopwatch
    float startSeconds;
    float endSeconds;
    NSDictionary *timingRanges;
    
    // CrossReference
    NSInteger numberOfPickers;
    NSDictionary *pickers;
    NSDictionary *outputItems;
    NSDictionary *outputResults;
    
}

@property NSInteger index;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *subtype;
@property float defaultScore;
@property float offScore;
@property float onScore;
// Slider
@property NSInteger markerSpaces;
@property (nonatomic, retain) NSString *direction;
@property (nonatomic, retain) NSDictionary *scoreRanges;
// Swiper
@property float startLeftScore;
@property float startRightScore;
@property float singleTapSpaces;
@property float doubleTapSpaces;
// Selector
@property (nonatomic, retain) NSDictionary *selectorButtons;
@property (nonatomic, retain) NSDictionary *bundles;
// EnergyBar
@property float defaultPosition;
@property NSInteger precision;
@property float height;
@property float width;
@property float groupSize;
@property (nonatomic, retain) NSString *backgroundImageName;
@property (nonatomic, retain) NSString *gripImageName;
// Rotator
@property float singleRotationSize;
// Stopwatch
@property float startSeconds;
@property float endSeconds;
@property (nonatomic, retain) NSDictionary *timingRanges;
// CrossReference
@property NSInteger numberOfPickers;
@property (nonatomic, retain) NSDictionary *pickers;
@property (nonatomic, retain) NSDictionary *outputItems;
@property (nonatomic, retain) NSDictionary *outputResults;

- (void)initialiseWithObject:(id)initialItem;


@end
