//
//  CustomWebView.m
//  Doctot
//
//  Created by Fergal McDonnell on 23/08/2018.
//  Copyright Doctot 2018. All rights reserved.
//

#import "CustomWebView.h"
#import "Constants.h"
#import "Helper.h"


@implementation CustomWebView

@synthesize content, source, type, contentString, alternateContentString;
@synthesize path, theBaseURL;

- (void)setup:(NSString *)identifier {
    
    source = identifier;
    
    path = [[NSBundle mainBundle] bundlePath];
    theBaseURL = [NSURL fileURLWithPath:path];
    
    content = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [content setNavigationDelegate:self];
    [content setUIDelegate:self];
    content.backgroundColor = [UIColor clearColor];
    [self addSubview:content];
    
    /********************************************************************************************************************
     
     type:  1)  "url" means the content is inserted directly from the web
            2)  "file" means that a local file in the Main Bundle or Documents directory should be used
            3)  "local" means the content is in HTML format in the localised string file in the Main Bundle
     
     contentString: 1) an online url
                    2) a file reference (in Main Bundle or Directories)
                    3) a reference key in the localised string file in the Main Bundle
     
     alternateContentString:    1) for type = "url", a file reference (in Main Bundle or Directories)
                                2) for type = "url", a reference key in the localised string file in the Main Bundle
     
    ********************************************************************************************************************/
    
    if( [source isEqualToString:@"Disclaimer"] ){
        
        type = @"url";
        contentString = DISCLAIMER_URL;
        alternateContentString = @"DisclaimerContent";
        
    }
    
    if( [source isEqualToString:@"HelpContent"] ){
        
        //type = @"url";
        //contentString = [NSString stringWithFormat:@"%@gameificationInfo.html", GAMEIFICATION_IMAGE_URL_BASE];
        //alternateContentString = @"";
        
    }
    
    if( [source isEqualToString:@"GameificationInfo"] ){
        
        type = @"url";
        contentString = [NSString stringWithFormat:@"%@gameificationInformation.html", GAMEIFICATION_IMAGE_URL_BASE];
        alternateContentString = @"Gameification_Info";
        
    }
    
    if( [type hasPrefix:@"url"] ){
        
        // Clear cache
        NSSet *dataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache,]];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:dataTypes modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{}];
        
        NSURL *theURL = [NSURL URLWithString:contentString];
        NSURLRequest *theURLRequest = [NSURLRequest requestWithURL:theURL];
        
        NSString* htmlString= [Helper getLocalisedString:@"Loading" withScalePrefix:NO];
        [content loadHTMLString:htmlString baseURL:nil];
        
        [content loadRequest:theURLRequest];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:theURL
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    if([((NSHTTPURLResponse *)response) statusCode] == 404){
                        
                        [self.content loadHTMLString:[Helper getLocalisedString:alternateContentString withScalePrefix:NO] baseURL:theBaseURL];
                    
                    }
                    
                }] resume];
        
    }
    
    if( [type hasPrefix:@"file"] ){
        
        [self insertLocalFileData:contentString];
        
    }
    
    if( [type hasPrefix:@"local"] ){
        
        [content loadHTMLString:[Helper getLocalisedString:contentString withScalePrefix:NO] baseURL:theBaseURL];
        
    }
    
}

- (void)insertLocalFileData:(NSString *)fileReference {
    
    /********************************************************************************************************************
     
     1) Checks if "fileReference" is in the local Documents directory
     1.1) If "fileReference" in the local Documents directory, insert the data into the webview
     1.2) If no "fileReference" in the local Documents directory, check if "fileReference" is in the Main Bundle
     1.2.1) If "fileReference" in the Main Bundle is htm/html, convert the content to html and insert into the web view
     1.2.2) If "fileReference" in the Main Bundle is NOT htm/html (e.g. PDF), insert the data into the webview
     
     ********************************************************************************************************************/
    
    NSData *fileData;
    
    NSString *fileName = @"";
    NSString *fileType = @"";
    NSArray *delimitedFileName = [fileReference componentsSeparatedByString:@"."];
    if( [delimitedFileName count] == 2 ){
        fileName = [delimitedFileName objectAtIndex:0];
        fileType = [delimitedFileName objectAtIndex:1];
    }
    
    // Check in Documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsFilePath = [documentsDirectory stringByAppendingPathComponent:fileReference];
    fileData = [[NSData alloc] initWithContentsOfFile:documentsFilePath];
    
    if( fileData == nil ){
        
        // Check in Main Bundle
        NSString *mainBundleFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        fileData = [[NSData alloc] initWithContentsOfFile:mainBundleFilePath];
        
        if( [fileType hasPrefix:@"htm"] ){
            
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
            NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [content loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
            
        }else{
            
            NSString *mimeType = [NSString stringWithFormat:@"application/%@", fileType];
            [content loadData:fileData MIMEType:mimeType characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
            
        }
        
    }else{
        
        NSString *mimeType = [NSString stringWithFormat:@"application/%@", fileType];
        [content loadData:fileData MIMEType:mimeType characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
        
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Loaded!");
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
