//
//  Disclaimer.m
//  Doctot
//
//  Created by Fergal McDonnell on 25/07/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "Disclaimer.h"
#import "Helper.h"
#import "Constants.h"

@interface Disclaimer ()

@end

@implementation Disclaimer

@synthesize prefs, isCurrentlyVisible;
@synthesize background, logo, content, agree;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)initialise {
    
    float LOGO_OFFSET = 44;
    float BUTTON_HEIGHT = 68;
    prefs = [NSUserDefaults standardUserDefaults];
    isCurrentlyVisible = YES;
    
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.image = [UIImage imageNamed:@"background.png"];
    
    logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, LOGO_OFFSET, self.frame.size.width, BUTTON_HEIGHT)];
    logo.image = [UIImage imageNamed:@"signup_doctot_logo.png"];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    
    agree = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - BUTTON_HEIGHT, self.frame.size.width, BUTTON_HEIGHT)];
    [agree addTarget:self action:@selector(agreeToDisclaimer) forControlEvents:UIControlEventTouchUpInside];
    [agree setTitle:[Helper getLocalisedString:@"Scale_Disclaimer_Agree" withScalePrefix:NO] forState:UIControlStateNormal];

    content = [[WKWebView alloc] initWithFrame:CGRectMake(0, (logo.frame.origin.y + logo.frame.size.height), self.frame.size.width, (self.frame.size.height - (logo.frame.origin.y + logo.frame.size.height + agree.frame.size.height)))];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    if( [Helper isConnectedToInternet] ){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:DISCLAIMER_URL] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        [content loadRequest:request];
    }else{
        [self.content loadHTMLString:[Helper getLocalisedString:@"DisclaimerContent" withScalePrefix:NO] baseURL:theBaseURL];
    }
    
    [self addSubview:background];
    [self addSubview:logo];
    [self addSubview:content];
    [self addSubview:agree];
    
}

- (IBAction)agreeToDisclaimer {
    
    isCurrentlyVisible = NO;
    [prefs setBool:YES forKey:@"DTPlusDisclaimerAgreed"];
    [self removeFromSuperview];
    [Helper showNavigationBar:YES];
    
    /* Send the data to Firebase ///////////////////////////////////////////////////////////////////////////////////////////////
    
    NSMutableDictionary *disclaimerParameters = [[NSMutableDictionary alloc] initWithCapacity:1];
    [disclaimerParameters setObject:[prefs stringForKey:@"RegistrationID"] forKey:@"userId"];
    
    [Helper postFirebaseEventForEventName:@"disclaimer" withContent:disclaimerParameters];
    
    // Update the AppDownload record ///////////////////////////////////////////////////////////////////////////////////////////
    */
    
    [self performSelectorInBackground:@selector(updateDTPlusDisclaimerCount) withObject:nil];

}

- (void)updateDTPlusDisclaimerCount {
    
    // Get the current count
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT disclaimerAccepted FROM AppDownload WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", [prefs objectForKey:@"DTPlusAppId"], [prefs objectForKey:@"DTPlusUserId"], [prefs objectForKey:@"DTPlusDeviceId"]];
    NSString *sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    NSString *sqlResultItem = [Helper returnParameter:@"disclaimerAccepted" inJSONString:sqlResponse forRecordIndex:0];
    
    // increment the current count
    int incrementedValue = (int)[sqlResultItem integerValue] + 1;
    
    // update with the incremented count
    sqlCommand = [NSString stringWithFormat:@"UPDATE AppDownload SET disclaimerAccepted = %i WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", incrementedValue, [prefs objectForKey:@"DTPlusAppId"], [prefs objectForKey:@"DTPlusUserId"], [prefs objectForKey:@"DTPlusDeviceId"]];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:NO];
    
}


@end
