//
//  Information.m
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import "Information.h"
#import "Helper.h"
#import "Help.h"
#import "CustomButton.h"

@interface Information ()

@end

@implementation Information

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton;
@synthesize help;
@synthesize scaleDefinition, informationContent, helpSection;
@synthesize iPadContent, iPadButtonWidth, iPadContentPadding, singleApp;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Scale_Info" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    iPadButtonWidth = self.view.frame.size.width * 0.25;
    iPadContentPadding = 50;
    
    // Visibility logic of Help button
    [help setTitle:[Helper getLocalisedString:@"Scale_Help" withScalePrefix:NO] forState:UIControlStateNormal];
    if( [scaleDefinition.helpElementsIncluded count] == 0 ){
        help.hidden = YES;
    }
    if( [scaleDefinition.helpElementsIncluded count] == 1  ){
        NSString *keyAsString = (NSString *)[scaleDefinition.helpElementsIncluded objectForKey:@"1"];
        if( [keyAsString isEqualToString:@"NONE"] ){
            help.hidden = YES;
        }
    }
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    CustomButton *tempButton;
    for(id key in scaleDefinition.informationElementsIncluded ){
        tempButton = [[CustomButton alloc] init];
        [tempButton setupForOrigin:@"Info" withKey:key andReference:[scaleDefinition.informationElementsIncluded objectForKey:key]];
        [buttonArray addObject:tempButton];
    }
    
    buttonArray = [Helper sortedArray:buttonArray byIndex:@"order" andAscending:YES];
    
    for( CustomButton *customButton in buttonArray ){
        [customButton addTarget:self action:@selector(navigateToInformation:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if( [Helper isiPad] ){
        if( ![help isHidden] ){
            help.frame = CGRectMake(help.frame.origin.x, help.frame.origin.y, iPadButtonWidth, help.frame.size.height);
        }
        iPadContent.frame = CGRectMake( self.view.frame.size.width, 0, ( (self.view.frame.size.width - iPadButtonWidth) - (2 * iPadContentPadding) ), self.view.frame.size.height);
    }
    
}

- (void)setupForScale:(NSString *)theScale andContent:(NSString *)theContent {

}

- (IBAction)navigateToInformation:(UIButton *)infoContents {
    
    if( [Helper isiPad] ){
        
        // iPad
        CustomButton *theCustomButton = (CustomButton *)infoContents;
        NSString *theContent = [NSString stringWithFormat:@"%@_Info_%@", scaleDefinition.name, theCustomButton.type];
        NSString *htmlHeading = [NSString stringWithFormat:@"<BR><B>%@</B><BR><BR>", theCustomButton.type];
        htmlHeading = [Helper prefixStyle:@"LargeWhite" toHTMLContent:htmlHeading];
        NSString *htmlContent = [Helper getLocalisedString:theContent withScalePrefix:NO];
        htmlContent = [htmlHeading stringByAppendingFormat:@"%@", htmlContent];
        htmlContent = [Helper prefixStyle:@"LargeWhite" toHTMLContent:htmlContent];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *theBaseURL = [NSURL fileURLWithPath:path];
        [iPadContent loadHTMLString:htmlContent baseURL:theBaseURL];
        
        iPadContent.frame = CGRectMake( self.view.frame.size.width, iPadContent.frame.origin.y, iPadContent.frame.size.width, self.view.frame.size.height);
        
        [UIView beginAnimations:@"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration:1.0];
        
        iPadContent.frame = CGRectMake( ( iPadButtonWidth + iPadContentPadding ), iPadContent.frame.origin.y, iPadContent.frame.size.width, iPadContent.frame.size.height);
        
        [UIView commitAnimations];
        
    }else{
        
        //iPhone
        [infoContents setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] forState:UIControlStateNormal];
        [self performSegueWithIdentifier:@"informationContent" sender:infoContents];
        
    }
    
}

- (IBAction)navigateToHelp:(id)infoContents {
    [self performSegueWithIdentifier:@"help" sender:infoContents];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"informationContent"]){
        
        informationContent = (InformationContent *)segue.destinationViewController;
        informationContent.scale = scaleDefinition.name;
        
        CustomButton *theCustomButton = (CustomButton *)sender;
        informationContent.htmlContentReference = theCustomButton.type;
        
    }
    
    if([[segue identifier] isEqualToString:@"help"]){
        
        helpSection = (Help *)segue.destinationViewController;
        helpSection.scaleDefinition = scaleDefinition;
        
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

