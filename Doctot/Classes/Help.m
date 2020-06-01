//
//  Help.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "Help.h"
#import "Helper.h"
#import "CustomButton.h"

@interface Help ()

@end

@implementation Help

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize helpContent, scaleDefinition;
@synthesize iPadButtonWidth, iPadContentPadding;

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
    
    iPadButtonWidth = self.view.frame.size.width * 0.25;
    iPadContentPadding = 50;
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    CustomButton *tempButton;
    for(id key in scaleDefinition.helpElementsIncluded ){
        tempButton = [[CustomButton alloc] init];
        [tempButton setupForOrigin:@"Help" withKey:key andReference:[scaleDefinition.helpElementsIncluded objectForKey:key]];
        [buttonArray addObject:tempButton];
    }
    
    buttonArray = [Helper sortedArray:buttonArray byIndex:@"order" andAscending:YES];
    
    for( CustomButton *customButton in buttonArray ){
        [customButton addTarget:self action:@selector(showContent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:customButton];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    for( CustomButton *customButton in self.view.subviews ){
        if( [customButton isKindOfClass:[CustomButton class]] ){
            [customButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            // Adjust screen for iPad landscape view
            if( [Helper isiPad] ){
                [customButton adjustWidth:iPadButtonWidth];
            }
        }
    }
    
}

- (void)showContent:(UIButton *)sender {
    
    if( [Helper isiPad] ){
        
        // iPad
        for( WKWebView *anyWebView in [self.view subviews] ){
            if( [anyWebView isKindOfClass:[WKWebView class]] ){
                [anyWebView removeFromSuperview];
            }
        }
        
        helpContent = [[HelpContent alloc] init];
        helpContent.scale = scaleDefinition.name;
        helpContent.source = scaleDefinition.helpSource;
        helpContent.parentApp = scaleDefinition.parentApp;
        
        CustomButton *theCustomButton = (CustomButton *)sender;
        helpContent.htmlContentReference = theCustomButton.type;
        
        [helpContent viewDidLoad];
        [helpContent viewDidAppear:YES];
        
        [self.view addSubview:helpContent.spinner];
        helpContent.spinner.frame = CGRectMake( ( self.view.frame.size.width / 2 ),
                                               ( self.view.frame.size.height / 2 ),
                                               helpContent.spinner.frame.size.width,
                                               helpContent.spinner.frame.size.height);
        
        [self.view addSubview:helpContent.internetRequiredText];
        helpContent.internetRequiredText.frame = CGRectMake( 0,
                                               ( self.view.frame.size.height / 2 ),
                                               self.view.frame.size.width,
                                               helpContent.internetRequiredText.frame.size.height);
        
        [self.view addSubview:helpContent.content];
        helpContent.content.frame = CGRectMake( ( iPadButtonWidth + iPadContentPadding ),
                                               helpContent.content.frame.origin.y,
                                               ( (self.view.frame.size.width - iPadButtonWidth) - (2 * iPadContentPadding) ),
                                               helpContent.content.frame.size.height);
        
    }else{
        
        //iPhone
        [sender setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] forState:UIControlStateNormal];
        [self performSegueWithIdentifier:@"helpContent" sender:sender];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"helpContent"]){
        
        helpContent = (HelpContent *)segue.destinationViewController;
        helpContent.scale = scaleDefinition.name;
        helpContent.source = scaleDefinition.helpSource;
        helpContent.parentApp = scaleDefinition.parentApp;
        
        CustomButton *theCustomButton = (CustomButton *)sender;
        helpContent.htmlContentReference = theCustomButton.type;
        
    }
    
}

- (void)dismiss {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

