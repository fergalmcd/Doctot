//
//  News.h
//  Doctot
//
//  Created by Fergal McDonnell on 13/09/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface News : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSUserDefaults *prefs;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    UITableView *feedTable;
    UIActivityIndicatorView *spinner;
    UIView *expandedNewsItem;
    
    NSMutableArray *feed;
    NewsItem *selectedItem;
    BOOL selectedItemActivated;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UITableView *feedTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIView *expandedNewsItem;
@property (nonatomic, retain) NSMutableArray *feed;
@property (nonatomic, retain) NewsItem *selectedItem;
@property BOOL selectedItemActivated;

@end
