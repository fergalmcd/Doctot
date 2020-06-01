//
//  TouchIDFail.h
//  Doctot
//
//  Created by Fergal McDonnell on 18/05/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchIDFail : UIView {
    
	UIButton *retry;
    BOOL passwordAlsoRequired;
	
}

@property (nonatomic, retain) IBOutlet UIButton *retry;
@property BOOL passwordAlsoRequired;


@end
