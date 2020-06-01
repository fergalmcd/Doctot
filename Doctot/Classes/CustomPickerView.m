//
//  CustomPickerView.m
//  Doctot
//
//  Created by Fergal McDonnell on 03/09/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "CustomPickerView.h"
#import "Constants.h"
#import "Helper.h"


@implementation CustomPickerView

@synthesize sourceDictionary;
@synthesize orderWithinMultiplePickers, heading, elements, selectedIndex;

- (void)setup:(NSDictionary *)source {
    
    sourceDictionary = source;
    
    heading = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, self.frame.size.width, 40)];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.textColor = [UIColor whiteColor];
    
    orderWithinMultiplePickers = (int)[[sourceDictionary valueForKey:@"index"] integerValue];
    NSString *pickerHeading = [sourceDictionary valueForKey:@"title"];
    NSDictionary *allPickerElements = [sourceDictionary valueForKey:@"elements"];
    
    // Check if there is a localised version for the picker header
    if( [[Helper getLocalisedString:pickerHeading withScalePrefix:YES] length] > 0 ){
        pickerHeading = [Helper getLocalisedString:pickerHeading withScalePrefix:YES];
    }
    heading.text = pickerHeading;
    [self addSubview:heading];
    
    elements = [[NSMutableArray alloc] init];
    NSDictionary *aPickerElement;
    for(int i = 0; i < [allPickerElements count]; i++ ){
        aPickerElement = [allPickerElements objectForKey:[NSString stringWithFormat:@"element%i", (i + 1)]];
        NSString *textReference = (NSString *)[aPickerElement objectForKey:@"text"];
        // Check if there is a localised version for the results
        if( [[Helper getLocalisedString:textReference withScalePrefix:YES] length] > 0 ){
            textReference = [Helper getLocalisedString:textReference withScalePrefix:YES];
        }
        [elements addObject:[self createElementView:aPickerElement]];
        //[elements addObject:textReference];
    }
    
}

- (UIView *)createElementView:(NSDictionary *)viewItems {
    UIView *rowView;
    
    rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    
    UILabel *indexLabelInvisible = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];  // Zero size: just for reference later
    indexLabelInvisible.text = [NSString stringWithFormat:@"%li", [[viewItems objectForKey:@"index"] integerValue]];
    indexLabelInvisible.tag = 1;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rowView.frame.size.width, rowView.frame.size.height)];
    NSString *textReference = [viewItems objectForKey:@"text"];
    if( [[Helper getLocalisedString:textReference withScalePrefix:YES] length] > 0 ){
        titleLabel.text = [Helper getLocalisedString:textReference withScalePrefix:YES];
    }else{
        titleLabel.text = textReference;
    }
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.tag = 2;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rowView.frame.size.height, rowView.frame.size.height)];
    NSString *iconName = (NSString *)[viewItems objectForKey:@"icon"];
    icon.image = [UIImage imageNamed:iconName];
    icon.tag = 1;
    
    [rowView addSubview:icon];
    [rowView addSubview:titleLabel];
    [rowView addSubview:indexLabelInvisible];   // Just for reference later
    
    if( [[viewItems objectForKey:@"index"] integerValue] % 2 == 0 ){
        rowView.backgroundColor = [UIColor greenColor];
    }else{
        rowView.backgroundColor = [UIColor redColor];
    }
    
    return rowView;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
