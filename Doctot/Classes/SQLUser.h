//
//  SQLApp.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/01/2020.
//  Copyright Doctot 2020. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLUser : NSObject {
    
    int uniqueId;
    NSString *firstName;
    NSString *lastName;
    NSString *email;
    NSString *dobAsString;
    NSString *description;
    NSString *profession;
    NSString *specialty;
    NSString *emailsAllowed;

}

@property int uniqueId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *dobAsString;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *profession;
@property (nonatomic, retain) NSString *specialty;
@property (nonatomic, retain) NSString *emailsAllowed;

@end
