//
//  ItemStructure.m
//  Doctot
//
//  Created by Fergal McDonnell on 20/10/2016.
//  Copyright Doctot 2016. All rights reserved.
//

#import "DiagnosisElement.h"
#import "Helper.h"
#import "Constants.h"


@implementation DiagnosisElement

@synthesize index, scale, name, minScore, outputScore, outputScoreRelevant, colourString, colour, description, descriptionSubtext, descriptionHTML;
@synthesize prefs;

- (void)initialiseWithObject:(id)initialItem forScale:(NSString *)theScale {
    
    scale = theScale;
    
    // Defaults are set so there is no assignment to an overriding score from this diagnosis element
    outputScore = DIAGNOSIS_ELEMENT_NO_OUTPUT;
    outputScoreRelevant = NO;
    
}

- (void)makeScaleSpecificAdjustments {
    
    if( [scale isEqualToString:@""] ){
        
    }
    
}

- (NSString *)formatDescriptionForHTML {
    return [description stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"];
}

- (NSString *)formatDescriptionForObjectiveC {
    return [description stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
