//
//  CrossReferenceOutputItem.h
//  Doctot
//
//  Created by Fergal McDonnell on 10/09/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrossReferenceOutputItem : UIView {
    
    NSUserDefaults *prefs;
    NSDictionary *sourceDictionary;
    
    NSInteger order;
    NSInteger heightRatio;
    float resultWidthRatio;
    NSString *description;
    
    UILabel *labelText;
    UILabel *result;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSDictionary *sourceDictionary;
@property NSInteger order;
@property NSInteger heightRatio;
@property float resultWidthRatio;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) IBOutlet UILabel *labelText;
@property (nonatomic, retain) IBOutlet UILabel *result;

- (void)setupWithDictionaryData:(NSDictionary *)sourceData;
- (void)alignLabelHeights;


@end
