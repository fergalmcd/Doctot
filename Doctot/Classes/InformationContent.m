//
//  InformationContent.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "InformationContent.h"
#import "Helper.h"

@interface InformationContent ()

@end

@implementation InformationContent

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize scale, htmlContentReference, contentHolder, content;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    contentHolder.layer.cornerRadius = 3.0;
    contentHolder.layer.borderWidth = 3.0;
    contentHolder.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSString *titleReference = [NSString stringWithFormat:@"Scale_Info_%@", htmlContentReference];
    self.title = [Helper getLocalisedString:titleReference withScalePrefix:NO];
    
    NSString *theContent = [NSString stringWithFormat:@"%@_Info_%@", [scale uppercaseString], htmlContentReference];
    NSString *htmlContent = [Helper getLocalisedString:theContent withScalePrefix:NO];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    
    htmlContent = [Helper prefixStyle:@"LargeWhite" toHTMLContent:htmlContent];
    
    [content loadHTMLString:htmlContent baseURL:theBaseURL];
    
}

- (NSString *)constructOverviewContent {
    NSString *combinedHTMLContent = @"";
    NSString *reference;
    
    reference = [NSString stringWithFormat:@"%@_Info_Reference", [scale uppercaseString]];
    combinedHTMLContent = [combinedHTMLContent stringByAppendingFormat:@"%@<BR><BR>", [Helper getLocalisedString:reference withScalePrefix:NO]];
    
    reference = [NSString stringWithFormat:@"%@_Info_Rating", [scale uppercaseString]];
    combinedHTMLContent = [combinedHTMLContent stringByAppendingFormat:@"%@<BR><BR>", [Helper getLocalisedString:reference withScalePrefix:NO]];
    
    reference = [NSString stringWithFormat:@"%@_Info_AdministrationTime", [scale uppercaseString]];
    combinedHTMLContent = [combinedHTMLContent stringByAppendingFormat:@"%@<BR><BR>", [Helper getLocalisedString:reference withScalePrefix:NO]];
    
    reference = [NSString stringWithFormat:@"%@_Info_Population", [scale uppercaseString]];
    combinedHTMLContent = [combinedHTMLContent stringByAppendingFormat:@"%@<BR><BR>", [Helper getLocalisedString:reference withScalePrefix:NO]];
    
    return combinedHTMLContent;
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

