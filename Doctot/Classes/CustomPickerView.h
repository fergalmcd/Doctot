//
//  CustomPickerView.h
//  Doctot
//
//  Created by Fergal McDonnell on 03/09/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerView : UIPickerView {
    
    NSDictionary *sourceDictionary;
    
    int orderWithinMultiplePickers;
    UILabel *heading;
    NSMutableArray *elements;
    
    int selectedIndex;
    
}

@property (nonatomic, retain) NSDictionary *sourceDictionary;
@property int orderWithinMultiplePickers;
@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) NSMutableArray *elements;
@property int selectedIndex;

- (void)setup:(NSDictionary *)source;


@end
