//
//  HelpContent.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "HelpContent.h"
#import "Helper.h"
#import "Constants.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HelpContent ()

@end

@implementation HelpContent

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize source, parentApp, scale, htmlContentReference;
@synthesize content, internetRequiredText, spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Scale_Help" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    internetRequiredText.text = [Helper getLocalisedString:@"Scale_Help_Internet_Warning" withScalePrefix:NO];
    [spinner startAnimating];

}

- (void)viewDidAppear:(BOOL)animated {
    
    /***************************************************************************************************************************************************************************************
     
     Help files are only loaded from the INTERNET only (HELP_URL_BASE)
     
     Depending upon the scaleDefinition's (NSString *) helpSource value:
      - Default: Gets the HTML file based upon NSLocaleLanguageCode and the help section selected by the user (Generic Localised Help - not app or scale specific)
      - parentApp: Gets the HTML file based upon NSLocaleLanguageCode, the app name and the help section selected by the user (App-specific Help - not scale specific)
      - scale: Gets the HTML file based upon NSLocaleLanguageCode, the specific scale name and the help section selected by the user
     
     Note: If an invalid URL is generated then Generic Help (not based upon NSLocaleLanguageCode) is loaded. So if there is no localised Help file available online (for example, spanish es), the english version is used
     
     Note: If a connection cannot be reached, the Spinner and warning label are not removed
     
     **************************************************************************************************************************************************************************************/
    
    __block NSString *helpURLString;
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleLanguageCode];
    
    // Default: Gets the HTML file based upon NSLocaleLanguageCode and the help section selected by the user (Generic Localised Help - not app or scale specific)
    // http://doctotapps.com/apphelp/en/Default/helpcontent_complete.html
    if( [source isEqualToString:@"Default"] ){
        helpURLString = [NSString stringWithFormat:@"%@%@/Default/helpcontent_%@.html", HELP_URL_BASE, countryCode, [htmlContentReference lowercaseString]];
    }
    // parentApp: Gets the HTML file based upon NSLocaleLanguageCode, the app name and the help section selected by the user (App-specific Help - not scale specific)
    // http://doctotapps.com/apphelp/en/Depression/helpcontent_complete.html
    if( [source isEqualToString:parentApp] ){
        helpURLString = [NSString stringWithFormat:@"%@%@/%@/helpcontent_%@.html", HELP_URL_BASE, countryCode, parentApp, [htmlContentReference lowercaseString]];
    }
    // scale: Gets the HTML file based upon NSLocaleLanguageCode, the specific scale name and the help section selected by the user
    // http://doctotapps.com/apphelp/en/HDRS/helpcontent_complete.html
    if( [source isEqualToString:scale] ){
        helpURLString = [NSString stringWithFormat:@"%@%@/%@/helpcontent_%@.html", HELP_URL_BASE, countryCode, scale, [htmlContentReference lowercaseString]];
    }
    
    __block NSURL *helpURL = [NSURL URLWithString:helpURLString];
    __block NSURLRequest *helpRequest = [NSURLRequest requestWithURL:helpURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    // content = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:[[WKWebViewConfiguration alloc] init]];
    self.content = [[WKWebView alloc] initWithFrame:CGRectMake(10, 0, (self.view.frame.size.width - 20), self.view.frame.size.height)];
    [self.content setOpaque:NO];
    self.content.backgroundColor = [UIColor clearColor];
    [self.content setNavigationDelegate:self];
    [self.content setUIDelegate:self];
    [self.view addSubview:self.content];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:helpURL
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // If an invalid URL is generated then Generic Help (not based upon NSLocaleLanguageCode) is loaded. So if there is no localised Help file available online (for example, spanish es), the english version is used
                if([((NSHTTPURLResponse *)response) statusCode] == 404){
                    helpURLString = [NSString stringWithFormat:@"%@en/Default/helpcontent_%@.html", HELP_URL_BASE, [self.htmlContentReference lowercaseString]];
                    helpURL = [NSURL URLWithString:helpURLString];
                    helpRequest = [NSURLRequest requestWithURL:helpURL];
                }
                
                [self.content loadRequest:helpRequest];
                
            }] resume];
    
    
    
}

- (void)webViewDidFinishLoad:(WKWebView *)theWebView {
    
    // Expands/shrinks out the HTML content to fit the web view
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = theWebView.bounds.size;
    float rw = viewSize.width / contentSize.width;

    theWebView.scrollView.zoomScale = rw;

    // If a connection cannot be reached, the Spinner and warning label are not removed
    internetRequiredText.hidden = YES;
    spinner.hidden = YES;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    internetRequiredText.hidden = NO;
    spinner.hidden = NO;

}

- (void)webView:(UIWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    // Expands/shrinks out the HTML content to fit the web view
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = webView.bounds.size;
    float rw = viewSize.width / contentSize.width;

    webView.scrollView.zoomScale = rw;

    // If a connection cannot be reached, the Spinner and warning label are not removed
    internetRequiredText.hidden = YES;
    spinner.hidden = YES;
    
}

- (void)webView:(UIWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    
    internetRequiredText.hidden = NO;
    spinner.hidden = NO;
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 NSString *titleReference = [NSString stringWithFormat:@"Scale_Help_%@", htmlContentReference];
 self.title = [Helper getLocalisedString:titleReference withScalePrefix:NO];
 
 NSString *theContent = [NSString stringWithFormat:@"%@_HelpContent_%@", [[prefs objectForKey:@"appName"] uppercaseString], htmlContentReference];
 // Checks if there is App-specific Help
 if( [[Helper getLocalisedString:theContent withScalePrefix:NO] length] == 0 ){
 theContent = [NSString stringWithFormat:@"Scale_HelpContent_%@", htmlContentReference];
 }
 NSString *htmlContent = [Helper getLocalisedString:theContent withScalePrefix:NO];
 
 NSString *path = [[NSBundle mainBundle] bundlePath];
 NSURL *theBaseURL = [NSURL fileURLWithPath:path];
 
 htmlContent = [Helper prefixStyle:@"SmallBlack" toHTMLContent:htmlContent];
 
 [content loadHTMLString:htmlContent baseURL:theBaseURL];
 */

/*
 NSString *theHTMLFileName = [NSString stringWithFormat:@"helpcontent_%@", [htmlContentReference lowercaseString]];
 NSString *htmlFile = [[NSBundle mainBundle] pathForResource:theHTMLFileName ofType:@"html"];
 NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
 [content loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
 */

/*
 //Download data from URL
 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
 //use this data to write to any path as documentdirectory path + filename.html
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 //create file path
 NSString *htmlFilePath = [documentsDirectory stringByAppendingPathComponent:@"helpcontent_test.html"];
 //write at file path
 BOOL isSucess = [data writeToFile:htmlFilePath atomically:YES];
 if (isSucess)
 NSLog(@"written");
 else
 NSLog(@"not written");
 */
/*
 
 NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"helpcontent_overview" ofType:@"html"];
 NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
 [content loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
 */

/*
 //download the file in a seperate thread.
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 NSLog(@"Downloading Started");
 NSString *urlToDownload = @"https://youtu.be/d88APYIGkjk";
 //NSString *urlToDownload = @"https://www.gstatic.com/webp/gallery3/2.png";
 //NSString *urlToDownload = @"https://www.dropbox.com/s/zflicx2ofbiyzrz/alert.png?dl=0";
 //NSString *urlToDownload = @"abcd";
 NSURL  *url = [NSURL URLWithString:urlToDownload];
 NSData *urlData = [NSData dataWithContentsOfURL:url];
 NSLog(@"urlData: %@", urlData);
 if ( urlData != NULL ){
 NSLog(@"EXECUTES: ================================================================================================");
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 //NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"helpcontent_1.png"];
 NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"helpcontent_1.mov"];
 
 //saving is done on main thread
 dispatch_async(dispatch_get_main_queue(), ^{
 [urlData writeToFile:filePath atomically:YES];
 NSLog(@"File Saved !");
 });
 }
 
 });
 
 //NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"helpcontent_1.png"];
 NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"helpcontent_1.mov"];
 UIImageView *myimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
 myimage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
 
 content = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:[[WKWebViewConfiguration alloc] init]];
 NSURL *wkUrl = [NSURL URLWithString:filePath];
 NSURLRequest *wkRequest = [NSURLRequest requestWithURL:wkUrl];
 [content setOpaque:NO];
 [content loadRequest:wkRequest];
 //[content loadData:[NSData dataWithContentsOfFile:filePath] MIMEType:@"video/mpeg" characterEncodingName:@"" baseURL:[[NSBundle mainBundle] resourceURL]];
 [self.view addSubview:content];
 */

// MIME Types for video & images
// MPEG movie file (mpg or mpeg): video/mpeg
// MPEG-4 (mp4): video/mp4
// Apple QuickTime movie (mov): video/quicktime
// J-PEG (jpg): image/jpeg
// PNG (png): image/png

/*
 NSURL *fileURL = [NSURL fileURLWithPath:filePath];
 NSURL *fileURL = [NSURL fileURLWithPath:@"http://hubblesource.stsci.edu/sources/video/clips/details/images/centaur_1.mov"];
 AVPlayerViewController * _moviePlayer1 = [[AVPlayerViewController alloc] init];
 _moviePlayer1.player = [AVPlayer playerWithURL:fileURL];
 
 [self presentViewController:_moviePlayer1 animated:YES completion:^{
 [_moviePlayer1.player play];
 }];
 */

/*
 NSURL *moviePlayerURL = [NSURL URLWithString:@"http://hubblesource.stsci.edu/sources/video/clips/details/images/centaur_1.mov"];
 AVPlayer *player = [AVPlayer playerWithURL:moviePlayerURL];
 AVPlayerViewController * _moviePlayer1 = [[AVPlayerViewController alloc] init];
 [self presentViewController:_moviePlayer1 animated:YES completion:nil];
 _moviePlayer1.player = player;
 
 [self presentViewController:_moviePlayer1 animated:YES completion:^{
 [_moviePlayer1.player play];
 }];
 */

/*
 NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
 for( int i = 0; i < [filePathsArray count]; i++ ){
 NSLog( @"%@", [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:i]]);
 }
 */

@end

