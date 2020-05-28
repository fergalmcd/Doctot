//
//  ScoresFilteredPatientList.h
//  Doctot
//
//  Created by Fergal McDonnell on 27/04/2016.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoresFilteredPatientList : UITableViewController

@property NSString *source;
@property (nonatomic, strong) NSArray *filteredResults;
@property float item1Padding;
@property float item1Width;
@property float item2Width;
@property float item3Width;

@end
