//
//  About.m
//  Doctot
//
//  Created by Fergal McDonnell on 29/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "About.h"
#import "Helper.h"

@interface About ()

@end

@implementation About

@synthesize leftNavBarButton, rightNavBarButton;
@synthesize logo, slogan, content, urlButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"AboutTitle" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    rightNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(49, 0, 49, 43)];
    [rightNavBarButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightNavBarButton.frame.size.width * 2, 44)];
    [rightView addSubview:rightNavBarButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    slogan.text = [Helper getLocalisedString:@"AboutSlogan" withScalePrefix:NO];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    [content loadHTMLString:[Helper getLocalisedString:@"AboutContent" withScalePrefix:NO] baseURL:theBaseURL];
    
    NSString *urlString = [Helper getLocalisedString:@"AboutLink" withScalePrefix:NO];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil ){
            [self.content loadData:data MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:urlString]];
        }else{
            // If the app can't connect to internet
            [self.content loadHTMLString:[Helper getLocalisedString:@"AboutContent" withScalePrefix:NO] baseURL:theBaseURL];
        }
                
    }] resume];
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)goToAboutLink {
    [[self navigationController] popViewControllerAnimated:YES];
    NSString *sponsorsLink = (NSString *)[Helper returnValueForKey:@"SponsorsLink"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sponsorsLink] options:@{} completionHandler:^(BOOL success){}];
}

- (IBAction)shareApp {
    [Helper shareApp:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
