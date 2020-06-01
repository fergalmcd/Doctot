//
//  OnlineResource.m
//  Doctot
//
//  Created by Fergal McDonnell on 01/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "OnlineResource.h"
#import "Helper.h"
#import "Constants.h"


@implementation OnlineResource

@synthesize prefs;
@synthesize sourceApp, saveTitle, saveType, documentsSaveDirectory, onlineURLString, onlineURL, urlData, documentsfileName, documentsFullPath;

- (void)setupOnlineResourceFor:(NSString *)identifier {
    
    saveTitle = identifier;
    prefs = [NSUserDefaults standardUserDefaults];
    sourceApp = (NSString *)[prefs objectForKey:@"appName"];
    
    if( [saveTitle isEqualToString:@"updateInfo"] ){
        
        saveType = @"json";
        documentsSaveDirectory = @"";
        onlineURLString = [NSString stringWithFormat:@"%@%@.%@", RESOURCE_URL_BASE, saveTitle, saveType];
        
    }
    
    if( [saveTitle isEqualToString:@"books"] ){
        
        saveType = @"json";
        documentsSaveDirectory = @"";
        onlineURLString = [NSString stringWithFormat:@"%@%@.%@", RESOURCE_URL_BASE, saveTitle, saveType];
        
    }
    
    if( [saveTitle isEqualToString:@"Settings"] ){
        
        saveType = @"plist";
        documentsSaveDirectory = @"";
        //onlineURLString = [NSString stringWithFormat:@"%@%@/%@.%@", RESOURCE_URL_BASE, sourceApp, saveTitle, saveType];
        onlineURLString = [NSString stringWithFormat:@"%@%@.%@", RESOURCE_URL_BASE, saveTitle, saveType];
        
    }
    
    if( [saveTitle isEqualToString:@"scaleDefinitions"] ){
        
        saveType = @"json";
        documentsSaveDirectory = @"";
        onlineURLString = [NSString stringWithFormat:@"%@%@.%@", RESOURCE_URL_BASE, saveTitle, saveType];
        
    }
    
    if( [saveTitle isEqualToString:@"appSettings"] ){  // Gameification
        
        saveType = @"json";
        documentsSaveDirectory = @"";
        onlineURLString = [NSString stringWithFormat:@"%@%@.%@", GAMEIFICATION_IMAGE_URL_BASE, saveTitle, saveType];
        
    }
    
    if( [saveTitle isEqualToString:@"rules"] ){ // Gameification
        
        saveType = @"json";
        documentsSaveDirectory = @"";
        onlineURLString = [NSString stringWithFormat:@"%@%@.%@", GAMEIFICATION_IMAGE_URL_BASE, saveTitle, saveType];
        
    }
    
    //onlineURLString = [NSString stringWithFormat:@"%@%@/%@.%@", RESOURCE_URL_BASE, sourceApp, saveTitle, saveType];
    onlineURL = [NSURL URLWithString:onlineURLString];
    urlData = [NSData dataWithContentsOfURL:onlineURL];
    if( [documentsSaveDirectory length] > 0 ){
        documentsfileName = [NSString stringWithFormat:@"%@/%@.%@", documentsSaveDirectory, saveTitle, saveType];
    }else{
        documentsfileName = [NSString stringWithFormat:@"%@.%@", saveTitle, saveType];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsFullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, documentsfileName];
    
}

- (void)downloadFileToDocuments {
    
    if ( urlData ){
        [urlData writeToFile:documentsFullPath atomically:YES];
    }
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
