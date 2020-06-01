//
//  SelectorButton.m
//  Doctot
//
//  Created by Fergal McDonnell on 26/06/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "SelectorButton.h"
#import "Helper.h"
#import "Constants.h"

@interface SelectorButton ()

@end

@implementation SelectorButton

@synthesize prefs, scaleName, parentType, questionIndex, parentIndex, dictionary, externalDescriptionActive;
@synthesize key, order, defaultScore, offScore, onScore;
@synthesize gridPosition, canvas, canvasIndex;
@synthesize heading, subHeading, externalDescription, displayImage;

// Sample call: [selectorButton setupWithKey:key andDictionary:selectorButtonDictionary andParentType:itemStructure.subtype];

- (void)setupWithKey:(id)theKey andDictionary:(NSDictionary *)sourceDictionaryData andParentType:(NSString *)theParentType {
    
    parentType = theParentType;
    dictionary = sourceDictionaryData;
    
    key = (NSString *)theKey;
    order = [[dictionary valueForKey:@"order"] integerValue];
    defaultScore = [[dictionary valueForKey:@"defaultScore"] floatValue];
    offScore = [[dictionary valueForKey:@"offScore"] floatValue];
    onScore = [[dictionary valueForKey:@"onScore"] floatValue];
    
    externalDescriptionActive = NO;
    canvas = SELECTOR_BUNDLE_CANVAS_NONE;
    canvasIndex = 0;
    
}

- (void)configureInterface {
    
    displayImage = [[UIImageView alloc] init];
    heading = [[UILabel alloc] init];
    subHeading = [[UILabel alloc] init];
    externalDescription = [[UILabel alloc] init];
    
    [self drawInterface];
    
    [self addSubview:displayImage];
    [self addSubview:heading];
    [self addSubview:subHeading];
    
}

- (void)drawInterface {
    
    NSString *reference;
    
    reference = [NSString stringWithFormat:@"%@.png", [dictionary valueForKey:@"image"]];
    displayImage.image = [UIImage imageNamed:reference];
    displayImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    reference = [NSString stringWithFormat:@"Q%i_Item%i_SelectorButton%li_Title", questionIndex, parentIndex, (order - 1)];
    heading.text = [Helper getLocalisedString:reference withScalePrefix:YES];
    heading.textColor = [UIColor whiteColor];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    heading.numberOfLines = 0;
    heading.frame = CGRectMake( ( self.frame.size.width * ( (1 - SELECTOR_BUTTON_WIDTH_RATIO ) / 2 ) ), 0, ( self.frame.size.width * SELECTOR_BUTTON_WIDTH_RATIO ), (self.frame.size.height / 2));
    
    reference = [NSString stringWithFormat:@"Q%i_Item%i_SelectorButton%li_Subtitle", questionIndex, parentIndex, (order - 1)];
    subHeading.text = [Helper getLocalisedString:reference withScalePrefix:YES];
    subHeading.textAlignment = NSTextAlignmentCenter;
    subHeading.textColor = [UIColor whiteColor];
    subHeading.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    subHeading.numberOfLines = 0;
    subHeading.frame = CGRectMake( heading.frame.origin.x, (self.frame.size.height / 2), heading.frame.size.width, (self.frame.size.height / 2));
    
    [self configureExpandedDescription];
    
    if( ( [subHeading.text length] == 0 ) || ( self.frame.size.height > 50 ) ){
        heading.frame = CGRectMake(heading.frame.origin.x, 0, heading.frame.size.width, self.frame.size.height);
        subHeading.frame = CGRectMake(heading.frame.origin.x, heading.frame.size.height, heading.frame.size.width, 0);
    }
    
}

- (void)configureExpandedDescription {
    
    externalDescription.text = subHeading.text;
    externalDescription.textAlignment = NSTextAlignmentCenter;
    externalDescription.textColor = [UIColor blackColor];
    externalDescription.backgroundColor = [UIColor whiteColor];
    externalDescription.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    externalDescription.layer.borderColor = [UIColor blueColor].CGColor;
    externalDescription.layer.borderWidth = 1.0;
    externalDescription.layer.cornerRadius = 10.0;
    externalDescription.clipsToBounds = YES;
    //externalDescription.shadowOffset = CGSizeMake(10, 10);
    //externalDescription.shadowColor = [UIColor blueColor];
    externalDescription.numberOfLines = 0;
    
    if( self.frame.origin.y > self.frame.size.height ){
        externalDescription.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }else{
        externalDescription.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }
    //NSLog(@"Position (%f, %f)   W: %F   H: %f", externalDescription.frame.origin.x, externalDescription.frame.origin.y, externalDescription.frame.size.width, externalDescription.frame.size.height );
    
    externalDescriptionActive = NO;
    
}

- (void)configureGridPosition:(int)allButtonsCount {
    
    if( [parentType isEqualToString:@"Linear"] || [parentType isEqualToString:@"Grid"] ){
        
        int maxXSize = 0, maxYSize = 0;
        float xPosition = 0, yPosition = 0;
        
        maxXSize = [self calculateMaxXSize:allButtonsCount];
        
        maxYSize = roundf( allButtonsCount / maxXSize );
        
        xPosition = (order % maxXSize) - 1;
        if( xPosition < 0 ){
            xPosition = maxXSize - 1;
        }
        
        yPosition = ( order - (xPosition + 1) ) / (float)maxXSize;
        if( yPosition < 0 ){
            yPosition = 0;
        }

        gridPosition = CGPointMake(xPosition, yPosition);
        
    }
    
    if( [parentType isEqualToString:@"Card"] ){
        gridPosition = CGPointMake(0, 0);
    }
    
}


- (int)calculateMaxXSize:(int)theSize {
    int theMaxXSize = 0;
    
    if( [parentType isEqualToString:@"Linear"] ){
        theMaxXSize = 1;
    }
    
    if( [parentType isEqualToString:@"Grid"] ){
        if( theSize == 0 ){     theMaxXSize = 0;     }
        if( theSize == 1 ){     theMaxXSize = 1;      }
        if( theSize == 2 ){     theMaxXSize = 1;      }
        if( theSize == 3 ){     theMaxXSize = 1;      }
        if( theSize == 4 ){     theMaxXSize = 2;      }
        if( theSize == 5 ){     theMaxXSize = 1;      }
        if( theSize == 6 ){     theMaxXSize = 2;      }
        if( theSize == 7 ){     theMaxXSize = 2;      }
        if( theSize == 8 ){     theMaxXSize = 2;      }
        if( theSize == 9 ){     theMaxXSize = 3;      }
        if( theSize == 10 ){    theMaxXSize = 2;      }
        if( theSize > 10 ){     theMaxXSize = 3;      }
    }
    
    if( [parentType isEqualToString:@"Card"] ){
        theMaxXSize = 1;
    }
    
    return theMaxXSize;
    
}

- (void)minimiseForBundle {
    
    [self clearExpandedDetails];
    [subHeading setHidden:YES];
    
    heading.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NSString *reference = [NSString stringWithFormat:@"Q%i_Item%i_SelectorButton%li_Title_Minimised", questionIndex, parentIndex, (order - 1)];
    heading.text = [Helper getLocalisedString:reference withScalePrefix:YES];
    heading.textColor = [UIColor whiteColor];
    heading.backgroundColor = [UIColor clearColor];
    
    if( [canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_LEFT] || [canvas isEqualToString:SELECTOR_BUNDLE_CANVAS_RIGHT] ){
        displayImage.frame = CGRectMake(0, ( (self.frame.size.height - self.frame.size.width) / 2 ), self.frame.size.width, self.frame.size.width);
    }else{
        displayImage.frame = CGRectMake(0, ( (self.frame.size.width - self.frame.size.height) / 2 ), self.frame.size.height, self.frame.size.height);
    }
    
}

- (void)showExpandedDetails {
    
    if( [externalDescription.text length] > 0 ){
        
        externalDescription = [[UILabel alloc] init];
        [self configureExpandedDescription];
        [self addSubview:externalDescription];
        externalDescriptionActive = YES;
        
    }
    
}

- (void)clearExpandedDetails {
    
    for( UILabel *aLabel in self.subviews ){
        if( [aLabel isKindOfClass:[UILabel class]] ){
            if ( ( aLabel != heading ) && ( aLabel !=subHeading ) ) {
                [aLabel removeFromSuperview];
            }
        }
    }
    
    [externalDescription removeFromSuperview];
    externalDescriptionActive = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end

