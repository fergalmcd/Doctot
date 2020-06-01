//
//  CrossReferenceOutputItem.m
//  Doctot
//
//  Created by Fergal McDonnell on 10/09/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "CrossReferenceOutputItem.h"
#import "Helper.h"
#import "Constants.h"

@interface CrossReferenceOutputItem ()

@end

@implementation CrossReferenceOutputItem

@synthesize prefs, sourceDictionary, order, heightRatio, resultWidthRatio, description;
@synthesize labelText, result;

- (void)setupWithDictionaryData:(NSDictionary *)sourceData {
    
    sourceDictionary = sourceData;
    
    order = [[sourceDictionary objectForKey:@"index"] integerValue];
    heightRatio = [[sourceDictionary objectForKey:@"heightRatio"] integerValue];
    resultWidthRatio = [[sourceDictionary objectForKey:@"resultWidthRatio"] floatValue];
    description = [sourceDictionary objectForKey:@"description"];
    // Check if there is a localised version for the label
    if( [[Helper getLocalisedString:description withScalePrefix:YES] length] > 0 ){
        description = [Helper getLocalisedString:description withScalePrefix:YES];
    }
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (25 * heightRatio));
    
    labelText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ( self.frame.size.width / (resultWidthRatio + 1) ), self.frame.size.height )];
    labelText.text = description;
    labelText.textColor = [UIColor lightGrayColor];
    labelText.backgroundColor = [UIColor clearColor];
    labelText.numberOfLines = 5;
    
    result = [[UILabel alloc] initWithFrame:CGRectMake(labelText.frame.size.width, 0, ( self.frame.size.width - labelText.frame.size.width ), self.frame.size.height )];
    result.text = @"-";
    result.textColor = [UIColor whiteColor];
    result.backgroundColor = [UIColor clearColor];
    result.numberOfLines = 5;
    
    [self addSubview:labelText];
    [self addSubview:result];
    
}

- (void)alignLabelHeights {
    
    labelText.frame = CGRectMake(labelText.frame.origin.x, labelText.frame.origin.y, labelText.frame.size.width, self.frame.size.height);
    result.frame = CGRectMake(result.frame.origin.x, result.frame.origin.y, result.frame.size.width, self.frame.size.height);
    
}

@end

