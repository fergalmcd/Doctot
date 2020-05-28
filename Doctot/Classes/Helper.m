//
//  Helper.m
//  Doctot
//
//  Created by Fergal McDonnell on 28/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "ScaleDefinition.h"
#import "Question.h"
#import "DataPatient.h"
#import "DataInterview.h"
#import "DataQuestion.h"
#import "Book.h"
#import "OnlineResource.h"
#import "Constants.h"
#import "SQLAppAccess.h"
#import "SQLAppDownload.h"
#import "SQLApp.h"
#import "SQLAssessmentSave.h"
#import "SQLUser.h"
#import "NewsItem.h"
#import "NewsNotification.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <StoreKit/StoreKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

//@import Firebase;

@implementation Helper

NSDictionary *dictionary;
NSUserDefaults *helperPrefs;

+ (NSString *)getLocalisedString:(NSString *)referenceString withScalePrefix:(BOOL)scalePrefix {
    
    NSString *localisedString = @"";
    
    Scale *thisScale = [Helper getScale];
    
    if( scalePrefix ){
        referenceString = [NSString stringWithFormat:@"%@_%@", [thisScale.definition.name uppercaseString], referenceString];
    }
    
    localisedString = NSLocalizedString(referenceString, @"");
    if( [localisedString isEqualToString:referenceString] ){
        localisedString = @"";
    }
    
    return localisedString;
}

+ (Scale *)getScale {

    Scale *thisScale;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    ViewController *home = (ViewController *)[nav.viewControllers objectAtIndex:0];
    thisScale = home.scale;
    
    return thisScale;
}

+ (id)returnValueForKey:(NSString *)theKey {
    
    id value;
    id defaultValue = @"";
    helperPrefs = [NSUserDefaults standardUserDefaults];
    dictionary = [Helper determineMostUpToDateResource:@"Settings"];
    NSArray *array = [dictionary objectForKey:theKey];
    
    for( NSArray *entry in array ){
        NSString *theTag = [entry objectAtIndex:0];
        if( [theTag isEqualToString:[helperPrefs stringForKey:@"appName"]] ){
            value = (NSString *)[entry objectAtIndex:1];
        }
        if( [theTag isEqualToString:@"Default"] ){
            defaultValue = (NSString *)[entry objectAtIndex:1];
        }
    }
    
    if( value == nil ){
        value = defaultValue;
    }
    
    return value;
    
}

+ (UIColor *)getColourFromString:(NSString *)colourString {

    UIColor *returnColour = [UIColor whiteColor];
    
    // iOS Colour Scheme as per https://www.schemecolor.com/ios.php and https://ivomynttinen.com/blog/ios-design-guidelines/blog/ios-design-guidelines
    if( [colourString isEqualToString:@"Black"] )   returnColour = [UIColor blackColor];
    if( [colourString isEqualToString:@"Blue"] )   returnColour = [UIColor colorWithRed:0.37 green:0.79 blue:0.97 alpha:1.0]; //[UIColor blueColor]; // 5FC9F8
    if( [colourString isEqualToString:@"Red"] )   returnColour = [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1.0];//[UIColor redColor]; // FC3D39
    if( [colourString isEqualToString:@"Green"] )   returnColour = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];//[UIColor greenColor]; // 008000
    if( [colourString isEqualToString:@"Yellow"] )   returnColour = [UIColor colorWithRed:1.0 green:0.8 blue:0.18 alpha:1.0];//[UIColor yellowColor]; // FECB2E
    if( [colourString isEqualToString:@"Brown"] )   returnColour = [UIColor brownColor];
    if( [colourString isEqualToString:@"Orange"] )   returnColour = [UIColor colorWithRed:1.0 green:0.5 blue:0.31 alpha:1.0];//[UIColor orangeColor]; // FF7F50
    if( [colourString isEqualToString:@"White"] )   returnColour = [UIColor whiteColor];
    if( [colourString isEqualToString:@"DarkGray"] )   returnColour = [UIColor darkGrayColor];
    if( [colourString isEqualToString:@"LightGray"] )   returnColour = [UIColor lightGrayColor];
    if( [colourString isEqualToString:@"Gray"] )   returnColour = [UIColor grayColor];
    if( [colourString isEqualToString:@"alphaRed"] )    return [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:0.3];
    if( [colourString isEqualToString:@"DoctotBlue"] )    return [UIColor colorWithRed:0.235 green:0.62 blue:0.863 alpha:1.0]; // 3c9edc
    
    return returnColour;
    
}

+ (UIColor *)getBackgroundColourForText:(UIColor *)textColour givenBackground:(NSString *)backgroundType {
    UIColor *backgroundColour;
    
    const CGFloat* components = CGColorGetComponents(textColour.CGColor);
    float redComponent = components[0];
    float greenComponent = components[1];
    float blueComponent = components[2];
    //float alphaComponent = CGColorGetAlpha(textColour.CGColor);
    
    // Light Coloured Text
    if( ( (redComponent > 0.9) && (greenComponent > 0.8) && (blueComponent < 0.1) ) ||
        ( textColour == [UIColor yellowColor] ) || ( textColour == [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] ) || // Yellow Colour
        ( textColour == [UIColor whiteColor] )
       ) {
        if( [backgroundType isEqualToString:@"Dark"] ){
            backgroundColour = [UIColor clearColor];
        }
        if( [backgroundType isEqualToString:@"Light"] ){
            backgroundColour = [UIColor blackColor];
        }
    }
    
    // Dark Coloured Text
    if(( (redComponent < 0.1) && (greenComponent > 0.3) && (blueComponent < 0.1) ) ||
       ( textColour == [UIColor greenColor] ) ||
       ( textColour == [UIColor blackColor] ) ||
       ( textColour == [UIColor blueColor] ) ||
       ( textColour == [UIColor redColor] ) ||
       ( textColour == [UIColor brownColor] ) ||
       ( textColour == [UIColor orangeColor] )
       ) {
        if( [backgroundType isEqualToString:@"Dark"] ){
            backgroundColour = [UIColor whiteColor];
        }
        if( [backgroundType isEqualToString:@"Light"] ){
            backgroundColour = [UIColor clearColor];
        }
    }
    
    return backgroundColour;
}

+ (void)showNavigationBar:(BOOL)show {

    BOOL hide = !show;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)appDelegate.window.rootViewController;
    UIViewController *home = [nav.viewControllers objectAtIndex:0];
    [[home navigationController] setNavigationBarHidden:hide animated:YES];
    
}

+ (CGSize)getInterviewQuestionDimensions {
    CGSize questionDimensions = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // Adjustment for iPad: so that it fits into the scrollview properly
    if( [Helper isiPad] ){
        questionDimensions.width = IPAD_INTERVIEW_QUESTION_WIDTH;
        //questionDimensions.height = IPAD_INTERVIEW_QUESTION_HEIGHT;
    }
    
    return questionDimensions;
}

+ (NSMutableArray *)generateScaleDefinitionsArray {
    NSMutableArray *scaleDefinitions = [[NSMutableArray alloc] init];
    
    ScaleDefinition *scaleDefinitionObject;
    scaleDefinitions = [[NSMutableArray alloc] init];
    helperPrefs = [NSUserDefaults standardUserDefaults];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"scaleDefinitions" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSMutableDictionary *scaleDefinitionsJSON = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    
    for (NSString *key in scaleDefinitionsJSON){
        id object = scaleDefinitionsJSON[key];
        
        scaleDefinitionObject = [[ScaleDefinition alloc] init];
        [scaleDefinitionObject setup:object forKey:key];
        
        if( [scaleDefinitionObject.parentApp isEqualToString:(NSString *)[helperPrefs stringForKey:@"appName"]] ){
            [scaleDefinitions addObject:scaleDefinitionObject];
        }
    }
    
    return scaleDefinitions;
}

+ (ScaleDefinition *)generateDefinitionsArrayForSpecifiedScale:(NSString *)theScale {
    ScaleDefinition *theScaleDefinitions;
    
    ScaleDefinition *scaleDefinitionObject;
    theScaleDefinitions = [[ScaleDefinition alloc] init];
    helperPrefs = [NSUserDefaults standardUserDefaults];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"scaleDefinitions" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSMutableDictionary *scaleDefinitionsJSON = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    
    for (NSString *key in scaleDefinitionsJSON){
        id object = scaleDefinitionsJSON[key];
        
        scaleDefinitionObject = [[ScaleDefinition alloc] init];
        [scaleDefinitionObject setup:object forKey:key];
        
        if( [scaleDefinitionObject.name isEqualToString:theScale] ){
            theScaleDefinitions = scaleDefinitionObject;
        }
    }
    
    return theScaleDefinitions;
}

+ (NSMutableArray *)createCurrentScaleQuestions {
    
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    Scale *thisScale = [Helper getScale];
    
    int inc = 0;
    NSString *searchString;
    Question *newQuestion;
    BOOL allQuestionsFound = NO;
    while( !allQuestionsFound ) {
        inc++;
        searchString = [NSString stringWithFormat:@"Q%i", inc];
        if( [[Helper getLocalisedString:searchString withScalePrefix:YES] length] > 0 ){
            newQuestion = [[Question alloc] init];
            newQuestion.scaleDefinition = thisScale.definition;
            newQuestion.index = inc;
            [newQuestion initialise];
            [questions addObject:newQuestion];
        }else{
            allQuestionsFound = YES;
        }
    }
    
    return questions;
    
}

+ (NSMutableArray *)createQuestionsForScale:(ScaleDefinition *)theScaleDefinition {
    
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    int inc = 0;
    NSString *searchString;
    Question *newQuestion;
    BOOL allQuestionsFound = NO;
    while( !allQuestionsFound ) {
        inc++;
        searchString = [NSString stringWithFormat:@"%@_Q%i", theScaleDefinition.name, inc];
        if( [[Helper getLocalisedString:searchString withScalePrefix:NO] length] > 0 ){
            newQuestion = [[Question alloc] init];
            newQuestion.scaleDefinition = theScaleDefinition;
            newQuestion.index = inc;
            [newQuestion initialise];
            [questions addObject:newQuestion];
        }else{
            allQuestionsFound = YES;
        }
    }
    
    return questions;
    
}

+ (NSMutableArray *)sortedArray:(NSMutableArray *)originalArray byIndex:(NSString *)sortKey andAscending:(BOOL)isAscending {
    
    NSMutableArray *returnedArray;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAscending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [originalArray sortedArrayUsingDescriptors:sortDescriptors];
    returnedArray = (NSMutableArray *)sortedArray;
    
    return returnedArray;
}

+ (NSMutableArray *)returnPickerValueList:(NSString *)pickerName {
    
    NSMutableArray *pickerValueList = [[NSMutableArray alloc] init];
    NSString *indexPrefix = [NSString stringWithFormat:@"PickerValueList_%@", pickerName];
    int inc = 0;
    NSString *searchString;
    BOOL allQuestionsFound = NO;
    while( !allQuestionsFound ) {
        inc++;
        searchString = [NSString stringWithFormat:@"%@%i", indexPrefix, inc];
        if( [[Helper getLocalisedString:searchString withScalePrefix:NO] length] > 0 ){
            [pickerValueList addObject:[Helper getLocalisedString:searchString withScalePrefix:NO]];
        }else{
            allQuestionsFound = YES;
        }
    }
    
    return pickerValueList;
    
}

+ (Book *)generateBook:(NSString *)theBookReference {
    Book *theBook;
    
    Book *bookObject;
    theBook = [[Book alloc] init];
    helperPrefs = [NSUserDefaults standardUserDefaults];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"books" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSMutableDictionary *booksJSON = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    
    for (NSString *key in booksJSON){
        id object = booksJSON[key];
        
        bookObject = [[Book alloc] init];
        [bookObject setup:object forKey:key];
        
        if( [bookObject.name isEqualToString:theBookReference] ){
            theBook = bookObject;
        }
    }
    
    return theBook;
}

+ (NSString *)prefixStyle:(NSString *)styleReference toHTMLContent:(NSString *)theContent {

    NSString *returnedHTML = @"";
    NSString *styleCode = [NSString stringWithFormat:@"HTMLStyle_%@", styleReference];
    NSString *styleHTML = [Helper getLocalisedString:styleCode withScalePrefix:NO];
    returnedHTML = [NSString stringWithFormat:@"%@%@", styleHTML, theContent];
    
    return returnedHTML;
    
}

+ (NSString *)convertDateToString:(NSDate *)inputDate forStyle:(NSString *)theStyle {
    
    NSString *dateString;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if( [theStyle isEqualToString:@"Numeric"] ){
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
    }
    if( [theStyle isEqualToString:@"Numeric Reversed"] ){
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    if( [theStyle isEqualToString:@"Text"] ){
        [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    }
    dateString = [dateFormat stringFromDate:inputDate];
    
    return dateString;

}

+ (NSDate *)convertStringToDate:(NSString *)inputDateString withFormat:(NSString *)theFormat {
    
    NSDate *outputDate;
    
    if( [theFormat length] == 0 ){
        theFormat = @"dd-mm-yyyy";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:theFormat];
    outputDate = [dateFormat dateFromString:inputDateString];
    
    return outputDate;
}

+ (NSString *)convertDateToTimeString:(NSDate *)inputDate {
    
    NSString *timeString;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    timeString = [dateFormat stringFromDate:inputDate];
    
    return timeString;
    
}

+ (UIFont *)getScaleItemFont:(NSString *)theScale {

    UIFont *returnFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    if( [theScale isEqualToString:@"MTS"] ){
        returnFont = [UIFont boldSystemFontOfSize:16.0];
    }
    
    return returnFont;
}

+ (BOOL)alphaNumericOnly:(NSString *)theString {
    BOOL alphaNumericOnly = YES;
    
    for( int i = 0; i < [theString length]; i++ ){
        char c = (char)[theString characterAtIndex:i];
        if( ( c != 'a' ) && ( c != 'b' ) && ( c != 'c' ) && ( c != 'd' ) && ( c != 'e' ) && ( c != 'f' ) && ( c != 'g' ) && ( c != 'h' ) && ( c != 'i' ) && ( c != 'j' ) && ( c != 'k' ) && ( c != 'l' ) && ( c != 'm' ) && ( c != 'n' ) && ( c != 'o' ) && ( c != 'p' ) && ( c != 'q' ) && ( c != 'r' ) && ( c != 's' ) && ( c != 't' ) && ( c != 'u' ) && ( c != 'v' ) && ( c != 'w' ) && ( c != 'x' ) && ( c != 'y' ) && ( c != 'z' ) &&
           ( c != 'A' ) && ( c != 'B' ) && ( c != 'C' ) && ( c != 'D' ) && ( c != 'E' ) && ( c != 'F' ) && ( c != 'G' ) && ( c != 'H' ) && ( c != 'I' ) && ( c != 'J' ) && ( c != 'K' ) && ( c != 'L' ) && ( c != 'M' ) && ( c != 'N' ) && ( c != 'O' ) && ( c != 'P' ) && ( c != 'Q' ) && ( c != 'R' ) && ( c != 'S' ) && ( c != 'T' ) && ( c != 'U' ) && ( c != 'V' ) && ( c != 'W' ) && ( c != 'X' ) && ( c != 'Y' ) && ( c != 'Z' ) &&
           ( c != '0' ) && ( c != '1' ) && ( c != '2' ) && ( c != '3' ) && ( c != '4' ) && ( c != '5' ) && ( c != '6' ) && ( c != '7' ) && ( c != '8' ) && ( c != '9' )
        ){
            alphaNumericOnly = NO;
        }
    }
    
    return alphaNumericOnly;
}

+ (BOOL)validNameCharacters:(NSString *)theString {
    BOOL validNameCharacters = YES;
    
    for( int i = 0; i < [theString length]; i++ ){
        char c = (char)[theString characterAtIndex:i];
        if( ( c != 'a' ) && ( c != 'b' ) && ( c != 'c' ) && ( c != 'd' ) && ( c != 'e' ) && ( c != 'f' ) && ( c != 'g' ) && ( c != 'h' ) && ( c != 'i' ) && ( c != 'j' ) && ( c != 'k' ) && ( c != 'l' ) && ( c != 'm' ) && ( c != 'n' ) && ( c != 'o' ) && ( c != 'p' ) && ( c != 'q' ) && ( c != 'r' ) && ( c != 's' ) && ( c != 't' ) && ( c != 'u' ) && ( c != 'v' ) && ( c != 'w' ) && ( c != 'x' ) && ( c != 'y' ) && ( c != 'z' ) &&
           ( c != 'A' ) && ( c != 'B' ) && ( c != 'C' ) && ( c != 'D' ) && ( c != 'E' ) && ( c != 'F' ) && ( c != 'G' ) && ( c != 'H' ) && ( c != 'I' ) && ( c != 'J' ) && ( c != 'K' ) && ( c != 'L' ) && ( c != 'M' ) && ( c != 'N' ) && ( c != 'O' ) && ( c != 'P' ) && ( c != 'Q' ) && ( c != 'R' ) && ( c != 'S' ) && ( c != 'T' ) && ( c != 'U' ) && ( c != 'V' ) && ( c != 'W' ) && ( c != 'X' ) && ( c != 'Y' ) && ( c != 'Z' ) &&
           ( c != '0' ) && ( c != '1' ) && ( c != '2' ) && ( c != '3' ) && ( c != '4' ) && ( c != '5' ) && ( c != '6' ) && ( c != '7' ) && ( c != '8' ) && ( c != '9' ) &&
           ( c != '-' ) && ( c != ' ' )
        ){
            validNameCharacters = NO;
        }
    }
    
    return validNameCharacters;
}

+ (UIImageView *)returnAnimatedImage:(NSArray *)imageArray {

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.animationImages = imageArray;
    imageView.animationDuration = 1.0;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
    imageView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    
    return imageView;
}

+ (BOOL)isConnectedToInternet {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if (reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0){
                // If target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
                // If target host is reachable and no connection is required, then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)){
                // ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs.
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
                // ... but WWAN connections are OK if the calling application is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;

}

+ (NSString *)printPrecision:(NSInteger)precision {
    return [NSString stringWithFormat:@"%%.%lif", precision];
}

+ (NSString *)returnParameter:(NSString *)theParameter inJSONString:(NSString *)theJSONString forRecordIndex:(int)theIndex {
 
    NSString *returnValue = @"";
    
    NSData *jsonData = [theJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *jsonObject = (NSMutableDictionary *)[[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] objectAtIndex:theIndex];
    
    for(NSString *key in jsonObject) {
        if ([key isEqual:theParameter]) {
            returnValue = [jsonObject objectForKey:theParameter];
        }
    }
    
    return returnValue;
    
}

 + (NSMutableArray *)returnArrayOfType:(NSString *)sqlObject FromJSONStringResult:(NSString *)theJSONString {
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    SQLAppAccess *sqlAppAccess = [[SQLAppAccess alloc] init];
    SQLAppDownload *sqlAppDownload = [[SQLAppDownload alloc] init];
    SQLAssessmentSave *sqlAssessmentSave = [[SQLAssessmentSave alloc] init];
    SQLApp *sqlApp = [[SQLApp alloc] init];
    SQLUser *sqlUser = [[SQLUser alloc] init];
    
    NSData *jsonData = [theJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *jsonObject = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    for(NSDictionary *aDictionary in jsonObject) {
        
        if( [sqlObject isEqualToString:@"AppAccess"] ){
            sqlAppAccess = [[SQLAppAccess alloc] init];
            sqlAppAccess.uniqueId = (int)[[aDictionary objectForKey:@"uniqueId"] integerValue];
            sqlAppAccess.referenceAppId = (int)[[aDictionary objectForKey:@"referenceAppId"] integerValue];
            sqlAppAccess.userId = (int)[[aDictionary objectForKey:@"userId"] integerValue];
            sqlAppAccess.deviceId = (int)[[aDictionary objectForKey:@"deviceId"] integerValue];
            sqlAppAccess.creationTimeStamp = [Helper convertStringToDate:(NSString *)[aDictionary objectForKey:@"creationTimeStamp"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            [returnArray addObject:sqlAppAccess];
        }
        if( [sqlObject isEqualToString:@"AppDownload"] ){
            sqlAppDownload = [[SQLAppDownload alloc] init];
            sqlAppDownload.uniqueId = (int)[[aDictionary objectForKey:@"uniqueId"] integerValue];
            sqlAppDownload.referenceAppId = (int)[[aDictionary objectForKey:@"referenceAppId"] integerValue];
            sqlAppDownload.userId = (int)[[aDictionary objectForKey:@"userId"] integerValue];
            sqlAppDownload.deviceId = (int)[[aDictionary objectForKey:@"deviceId"] integerValue];
            sqlAppDownload.disclaimerAccepted = (int)[[aDictionary objectForKey:@"disclaimerAccepted"] integerValue];
            sqlAppDownload.numberOfLogins = (int)[[aDictionary objectForKey:@"numberOfLogins"] integerValue];
            sqlAppDownload.numberOfSocialMediaShares = (int)[[aDictionary objectForKey:@"numberOfSocialMediaShares"] integerValue];
            sqlAppDownload.creationTimeStamp = [Helper convertStringToDate:(NSString *)[aDictionary objectForKey:@"creationTimeStamp"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            [returnArray addObject:sqlAppDownload];
        }
        if( [sqlObject isEqualToString:@"AssessmentSave"] ){
            sqlAssessmentSave = [[SQLAssessmentSave alloc] init];
            sqlAssessmentSave.uniqueId = (int)[[aDictionary objectForKey:@"uniqueId"] integerValue];
            sqlAssessmentSave.creationTimeStamp = [Helper convertStringToDate:(NSString *)[aDictionary objectForKey:@"creationTimeStamp"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            sqlAssessmentSave.userId = (int)[[aDictionary objectForKey:@"userId"] integerValue];
            sqlAssessmentSave.patientId = (int)[[aDictionary objectForKey:@"patientId"] integerValue];
            sqlAssessmentSave.assessmentId = (int)[[aDictionary objectForKey:@"assessmentId"] integerValue];
            sqlAssessmentSave.appId = (int)[[aDictionary objectForKey:@"appId"] integerValue];
            sqlAssessmentSave.score = [[aDictionary objectForKey:@"score"] floatValue];
            sqlAssessmentSave.description = (NSString *)[aDictionary objectForKey:@"description"];
            [returnArray addObject:sqlAssessmentSave];
        }
        if( [sqlObject isEqualToString:@"zReference_App"] ){
            sqlApp = [[SQLApp alloc] init];
            sqlApp.uniqueId = (int)[[aDictionary objectForKey:@"uniqueId"] integerValue];
            sqlApp.appstoreIdentifier = (NSString *)[aDictionary objectForKey:@"appstoreIdentifier"];
            sqlApp.name = (NSString *)[aDictionary objectForKey:@"name"];
            sqlApp.platform = (NSString *)[aDictionary objectForKey:@"platform"];
            [returnArray addObject:sqlApp];
        }
        if( [sqlObject isEqualToString:@"User"] ){
            sqlUser = [[SQLUser alloc] init];
            sqlUser.uniqueId = (int)[[aDictionary objectForKey:@"uniqueId"] integerValue];
            sqlUser.firstName = (NSString *)[aDictionary objectForKey:@"firstName"];
            sqlUser.lastName = (NSString *)[aDictionary objectForKey:@"lastName"];
            sqlUser.email = (NSString *)[aDictionary objectForKey:@"lastName"];
            sqlUser.dobAsString = (NSString *)[aDictionary objectForKey:@"dob"];
            sqlUser.description = (NSString *)[aDictionary objectForKey:@"description"];
            sqlUser.profession = (NSString *)[aDictionary objectForKey:@"profession"];
            sqlUser.specialty = (NSString *)[aDictionary objectForKey:@"specialty"];
            sqlUser.emailsAllowed = (NSString *)[aDictionary objectForKey:@"emailsAllowed"];
            [returnArray addObject:sqlUser];
        }
        
    }
    
     return returnArray;
}

+ (void)saveOnlineResourcesToDocuments {
    
    // updateInfo.json
    // Settings.plist
    // books.json
    // scaleDefinitions.json
    // appSettings.json (Gameification)
    // rules.json (Gameification)
    
    OnlineResource *updateInfoOnlineResource = [[OnlineResource alloc] init];
    [updateInfoOnlineResource setupOnlineResourceFor:@"updateInfo"];
    [updateInfoOnlineResource downloadFileToDocuments];
    
    OnlineResource *booksOnlineResource = [[OnlineResource alloc] init];
    [booksOnlineResource setupOnlineResourceFor:@"books"];
    [booksOnlineResource downloadFileToDocuments];
    
    OnlineResource *settingsOnlineResource = [[OnlineResource alloc] init];
    [settingsOnlineResource setupOnlineResourceFor:@"Settings"];
    [settingsOnlineResource downloadFileToDocuments];
    
    OnlineResource *scaleDefinitionsOnlineResource = [[OnlineResource alloc] init];
    [scaleDefinitionsOnlineResource setupOnlineResourceFor:@"scaleDefinitions"];
    [scaleDefinitionsOnlineResource downloadFileToDocuments];
    
    OnlineResource *appSettingsOnlineResource = [[OnlineResource alloc] init];
    [appSettingsOnlineResource setupOnlineResourceFor:@"appSettings"];
    [appSettingsOnlineResource downloadFileToDocuments];
    
    OnlineResource *rulesOnlineResource = [[OnlineResource alloc] init];
    [rulesOnlineResource setupOnlineResourceFor:@"rules"];
    [rulesOnlineResource downloadFileToDocuments];
    
}

+ (BOOL)isiPad {
    BOOL isAniPad = NO;
    
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
        isAniPad = YES;
    }
    
    return isAniPad;
}

+ (UIButton *)customAlertControllerForiPadWithHeading:(NSString *)theHeading andMessage:(NSString *)theMessage {
    UIButton *entireView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    float xPadding = entireView.frame.size.width / 3;
    float yPadding = entireView.frame.size.height / 3;
    float backgroundPanelWidth = entireView.frame.size.width - (xPadding * 2);
    float backgroundPanelHeight = entireView.frame.size.height - (yPadding * 2);
    UIImageView *backgroundPanel = [[UIImageView alloc] initWithFrame:CGRectMake(xPadding, yPadding, backgroundPanelWidth, backgroundPanelHeight)];
    backgroundPanel.image = [UIImage imageNamed:@"content.png"];
    
    UILabel *heading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backgroundPanel.frame.size.width, (backgroundPanel.frame.size.height / 4))];
    heading.text = theHeading;
    heading.textColor = [UIColor darkGrayColor];
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, heading.frame.size.height, backgroundPanel.frame.size.width, (backgroundPanel.frame.size.height - heading.frame.size.height))];
    message.text = theMessage;
    message.textColor = [UIColor blackColor];
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    [backgroundPanel addSubview:heading];
    [backgroundPanel addSubview:message];
    [entireView addSubview:backgroundPanel];
    
    return entireView;
}

+ (float)adjustYShiftDownwards {
    
    float yPosition = 0;
    
    int screenHeight = (int)[[UIScreen mainScreen] nativeBounds].size.height;
    if( ![Helper isiPad] && ( ( screenHeight == 1792 ) || ( screenHeight == 2436 ) || ( screenHeight == 2688 ) ) ){
        yPosition += 20;
    }
    
    return yPosition;
    
}

+ (NSDictionary *)determineMostUpToDateResource:(NSString *)resourceFile {
    
    NSDictionary *dictionaryToUse = [[NSDictionary alloc] init];
    
    /************************************************************************************************************************************************

    Returns the correct dictionary data, based upon the resourseFile parameter and the version of that file most up-to-date (in Documents - downloaded from online - or Main Bundle)
     
     1. Get the latest version of the relevant resourseFile in the Main Bundle - updateInfo.json
     2. Get the latest version of the relevant resourseFile in the Documents folder (previously downloaded from online [see saveOnlineResourcesToDocuments]) - updateInfo.json
     3. Determine the type of resourseFile (plist, json etc.)
     4. Get the data for the resourceFile specified, depending on which one is more up-to-date from which (In a tie, Main Bundle trumps Documents)
        4a. Process if the file is a plist from local Documents folder
        4b. Process if the file is a json from local Documents folder
        4c. Process if the file is a plist from Main Bundle
        4d. Process if the file is a json from Main Bundle
     
     ***********************************************************************************************************************************************/
    
    NSInteger mainBundleLatestVersion = 0;
    NSInteger documentsLatestVersion = 0;
    
    // 1. Get the latest version of the relevant resourseFile in the Main Bundle
    NSString *mainBundleFilePath = [[NSBundle mainBundle] pathForResource:@"updateInfo" ofType:@"json"];
    NSData *mainBundleContent = [[NSData alloc] initWithContentsOfFile:mainBundleFilePath];
    NSMutableDictionary *mainBundleDictionary = [NSJSONSerialization JSONObjectWithData:mainBundleContent options:kNilOptions error:nil];
    
    for (NSString *key in mainBundleDictionary){
        
        if( [key isEqualToString:resourceFile] ){
            id object = mainBundleDictionary[key];
            mainBundleLatestVersion = [[object objectForKey:@"latestVerion"] integerValue];
        }
        
    }
    
    // 2. Get the latest version of the relevant resourseFile in the Documents folder (previously downloaded from online [see saveOnlineResourcesToDocuments])
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsFilePath = [documentsDirectory stringByAppendingPathComponent:@"updateInfo.json"];
    NSData *documentsContent = [[NSData alloc] initWithContentsOfFile:documentsFilePath];
    
    if( documentsContent == nil ){
        // If no file has yet been downloaded to Documents folder
        documentsLatestVersion = 0;
        
    }else{
        
        NSMutableDictionary *documentsDictionary = [NSJSONSerialization JSONObjectWithData:documentsContent options:kNilOptions error:nil];
        
        for (NSString *key in documentsDictionary){
            
            if( [key isEqualToString:resourceFile] ){
                id object = documentsDictionary[key];
                documentsLatestVersion = [[object objectForKey:@"latestVerion"] integerValue];
            }
            
        }
        
    }
    
    // 3. Determine the type of resourseFile
    // Specific for Settings.plist - All other files are json
    NSString *fileType;
    if( [resourceFile isEqualToString:@"Settings"] ){
        fileType = @"plist";
    }else{
        fileType = @"json";
    }
    
    // 4. Get the data for the resourceFile specified, depending on which one is more up-to-date from which (In a tie, Main Bundle trumps Documents)
    if( documentsLatestVersion > mainBundleLatestVersion ){
        
        NSString *outputDocumentsFilePath;
        NSData *outputDocumentsContent;
        NSDictionary *outputDocumentsDictionary;
        
        outputDocumentsFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", resourceFile, fileType]];
        
        // 4a. Process if the file is a plist from local Documents folder
        if( [fileType isEqualToString:@"plist"] ){
            outputDocumentsDictionary = [NSDictionary dictionaryWithContentsOfFile:outputDocumentsFilePath];
        }
        
        // 4b. Process if the file is a json from local Documents folder
        if( [fileType isEqualToString:@"json"] ){
            outputDocumentsContent = [[NSData alloc] initWithContentsOfFile:outputDocumentsFilePath];
            outputDocumentsDictionary = [NSJSONSerialization JSONObjectWithData:outputDocumentsContent options:kNilOptions error:nil];
        }
        
        dictionaryToUse = outputDocumentsDictionary;
        
    }else{
        
        NSString *outputMainBundleFilePath = [[NSBundle mainBundle] pathForResource:resourceFile ofType:fileType];
        NSDictionary *outputMainBundleDictionary;
        NSData *outputMainBundleContent;
        
        // 4c. Process if the file is a plist from Main Bundle
        if( [fileType isEqualToString:@"plist"] ){
            outputMainBundleDictionary = [NSDictionary dictionaryWithContentsOfFile:outputMainBundleFilePath];
        }
        
        // 4d. Process if the file is a json from Main Bundle
        if( [fileType isEqualToString:@"json"] ){
            outputMainBundleContent = [[NSData alloc] initWithContentsOfFile:outputMainBundleFilePath];
            outputMainBundleDictionary = [NSJSONSerialization JSONObjectWithData:outputMainBundleContent options:kNilOptions error:nil];
        }
        
        dictionaryToUse = outputMainBundleDictionary;
    
    }
    
    return dictionaryToUse;
    
}

+ (void)sendAppActivationEmail {
    
    helperPrefs = [NSUserDefaults standardUserDefaults];
    
    NSString *url =[NSString stringWithFormat:@"http://www.doctotapps.com/registrationemailgenerate.php?email=%@", [helperPrefs objectForKey:@"Email"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          
          NSLog(@"Email Sent to %@!", [helperPrefs objectForKey:@"Email"]);
          
      }] resume];
    
}

+ (BOOL)checkIfTouchIDSupported {
    
    BOOL isTouchIDSupported = NO;
    
    if ([LAContext class]) {
        LAContext *context = [LAContext new];
        NSError *error = nil;
        isTouchIDSupported = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    }
    
    return isTouchIDSupported;
    
}

+ (void)postFirebaseEventForEventName:(NSString *)eventName withContent:(NSDictionary *)theContent {
    
    //[FIRAnalytics logEventWithName:eventName parameters:theContent];
    
}

+ (void)shareApp:(UIViewController *)sourceViewController {
    
    helperPrefs = [NSUserDefaults standardUserDefaults];
    
    NSString *smShareText = (NSString *)[Helper returnValueForKey:@"SocialMediaShareText"];
    NSString *smShareAppleURL_asText = (NSString *)[Helper returnValueForKey:@"SocialMediaShareAppleLink"];
    NSString *smShareAndroidURL_asText = (NSString *)[Helper returnValueForKey:@"SocialMediaShareAndroidLink"];
    NSString *smShareImage_asText = (NSString *)[Helper returnValueForKey:@"SocialMediaShareImage"];
    
    NSURL *smShareAppleURL = [NSURL URLWithString:smShareAppleURL_asText];
    NSURL *smShareAndroidURL = [NSURL URLWithString:smShareAndroidURL_asText];
    UIImage *smShareImage = [UIImage imageNamed:smShareImage_asText];
    NSData *smShareImageData = UIImagePNGRepresentation(smShareImage);
    
    NSArray *shareArray;
    if( [smShareAndroidURL_asText containsString:@"*android"] ){
        shareArray = @[smShareText,smShareAppleURL];
    }else{
        shareArray = @[smShareText,smShareAppleURL,smShareAndroidURL];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:shareArray applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks,@"com.apple.mobilenotes.SharingExtension",@"com.apple.reminders.RemindersEditorExtension"];
    activityController.popoverPresentationController.sourceView = sourceViewController.view;
    activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if( completed ){
            NSString *sqlCommand = [NSString stringWithFormat:@"SELECT numberOfSocialMediaShares FROM AppDownload WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", [helperPrefs objectForKey:@"DTPlusAppId"], [helperPrefs objectForKey:@"DTPlusUserId"], [helperPrefs objectForKey:@"DTPlusDeviceId"]];
            NSString *sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
            
            if( [Helper isSQLResponseValid:sqlResponse] ){
                
                NSString *sqlResultItem = [Helper returnParameter:@"numberOfSocialMediaShares" inJSONString:sqlResponse forRecordIndex:0];
                
                // increment the current count
                int incrementedValue = (int)[sqlResultItem integerValue] + 1;
                
                // update with the incremented count
                sqlCommand = [NSString stringWithFormat:@"UPDATE AppDownload SET numberOfSocialMediaShares = %i WHERE referenceAppId = '%@' AND userId = '%@' AND deviceId = '%@'", incrementedValue, [helperPrefs objectForKey:@"DTPlusAppId"], [helperPrefs objectForKey:@"DTPlusUserId"], [helperPrefs objectForKey:@"DTPlusDeviceId"]];
                sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
                
            }
        }
    };
    [sourceViewController presentViewController:activityController animated:YES completion:nil];
    
}

+ (void)requestAppStoreReview {
    
    if (@available(iOS 10.3, *)) {
        
        helperPrefs = [NSUserDefaults standardUserDefaults];
        NSInteger occurances = [helperPrefs integerForKey:@"appStoreReviewSkipCount"];
        occurances++;
        if( ( occurances % APP_STORE_REVIEW_REQUEST ) == 0 ){
            [SKStoreReviewController requestReview];
        }
        [helperPrefs setInteger:occurances forKey:@"appStoreReviewSkipCount"];
        
    }
    
}

+ (UIImage *)getSponsorshipImageFor:(NSString *)imageReference {
    
    UIImage *foundImage = nil;
    
    /********************************************************************************************************************************************************************
     
    1. Try to get image from online (SPONSOR_IMAGE_URL_BASE) [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
        2a. If image is found, insert the file into the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory & assign that image to foundImage
        2b. If image is not found, check if there is a file in the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
            3a. If If image is found, assign it to foundImage
            3b. If If image is not found, check for a country-specific image in the app Bundle [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
                4a. If YES, assign it to foundImage
                4b. If NO, use the default
    
     ********************************************************************************************************************************************************************/
    
    // Configuration
    
    // A. Get the country details
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    // B. Get the app name
    helperPrefs = [NSUserDefaults standardUserDefaults];
    NSString *appName = [helperPrefs objectForKey:@"appName"];
    
    // C. Set up the call to the online reference: SPONSOR_IMAGE_URL_BASE
    NSString *imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
    NSString *urlPath = [NSString stringWithFormat:@"%@%@", SPONSOR_IMAGE_URL_BASE, imageFileName];
    NSURL *url = [NSURL URLWithString:urlPath];
    
    // D. Set up the reference to the image downloaded previously from SPONSOR_IMAGE_URL_BASE and stored in SPONSOR_DOCUMENTS_DIRECTORY
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:SPONSOR_DOCUMENTS_DIRECTORY];
    NSString *potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
    
    // E. If the SPONSOR_DOCUMENTS_DIRECTORY doesn't exist, create it!
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:directoryPath] ){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    // End of Configuration
    
    // 1. Try to get image from online (SPONSOR_IMAGE_URL_BASE) [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    // Search 1: imageReference_appName_country
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    // Search 2: imageReference_appName (Couldn't find a specific image for that app for that country, so try default image for that app)
    if( data == nil ){
        
        imageFileName = [NSString stringWithFormat:@"%@_%@.png",imageReference, appName];
        urlPath = [NSString stringWithFormat:@"%@%@", SPONSOR_IMAGE_URL_BASE, imageFileName];
        url = [NSURL URLWithString:urlPath];
        data = [[NSData alloc] initWithContentsOfURL:url];
    
        // Search 3: imageReference (Couldn't find a specific image for that app, so try default image)
        if( data == nil ){
            
            imageFileName = [NSString stringWithFormat:@"%@.png",imageReference];
            urlPath = [NSString stringWithFormat:@"%@%@", SPONSOR_IMAGE_URL_BASE, imageFileName];
            url = [NSURL URLWithString:urlPath];
            data = [[NSData alloc] initWithContentsOfURL:url];
            
        }
        
    }
    
    // 2a. If image is found, insert the file into the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory & assign that image to foundImage
    if( data != nil ){
        
        // Save/overwrite the imageFileName file from SPONSOR_IMAGE_URL_BASE to SPONSOR_DOCUMENTS_DIRECTORY
        [data writeToFile:potentialImagePath atomically:YES];
        
    }
    
    //2b. If image is not found, check if there is a file in the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    // No internet image found
    if( data == nil ){
        
        // Search 1: imageReference_appName_country
        imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
        potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:potentialImagePath]){
            // 3a. If image is found, assign it to foundImage
            data = [[NSData alloc] initWithContentsOfFile:potentialImagePath];
        }else{
            // Search 2: imageReference_appName
            imageFileName = [NSString stringWithFormat:@"%@_%@.png",imageReference, appName];
            potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:potentialImagePath]){
                // 3a. If image is found, assign it to foundImage
                data = [[NSData alloc] initWithContentsOfFile:potentialImagePath];
            }else{
                // Search 3: imageReference_appName
                imageFileName = [NSString stringWithFormat:@"%@.png",imageReference];
                potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
                if ([[NSFileManager defaultManager] fileExistsAtPath:potentialImagePath]){
                    // 3a. If image is found, assign it to foundImage
                    data = [[NSData alloc] initWithContentsOfFile:potentialImagePath];
                }
            }
        }
        
    }
    
    // ASSIGN WHATEVER DATA HAS BEEN FOUND AT THIS POINT TO FOUND IMAGE
    foundImage = [[UIImage alloc] initWithData:data];
    
    // 3b. If image is NOT found, foundImage = nil, check for a country-specific image in the app Bundle [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    UIImage *checkImage;
    if( foundImage == nil ){
        // Search 1: imageReference_appName_country
        imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
        checkImage = [UIImage imageNamed:imageFileName];
        if( checkImage != nil ){
            // 4a. If image is found, assign it to foundImage
            foundImage = checkImage;
        }else{
            // Search 2: imageReference_appName
            imageFileName = [NSString stringWithFormat:@"%@_%@.png",imageReference, appName];
            checkImage = [UIImage imageNamed:imageFileName];
            if( checkImage != nil ){
                // 4a. If image is found, assign it to foundImage
                foundImage = checkImage;
            }else{
                // Search 3: imageReference
                imageFileName = [NSString stringWithFormat:@"%@.png",imageReference];
                checkImage = [UIImage imageNamed:imageFileName];
                if( checkImage != nil ){
                    // 4a. If image is found, assign it to foundImage
                    foundImage = checkImage;
                }
            }
        }
    }
    
    // 4b. If image is found, use the default
    // No action is required here because foundImage = nil (The UI assigns a default Doctot )
    
    // Lists the files in SPONSOR_DOCUMENTS_DIRECTORY (not needed for anything except testing/confirmation)
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    for(int count = 0; count < (int)[directoryContent count]; count++){
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    
    return foundImage;
    
}

+ (UIImage *)readSponsorshipImageFromDocuments:(NSString *)imageReference {
    
    UIImage *foundImage = nil;
    
    /********************************************************************************************************************************************************************
     
    1. Try to get image from online (SPONSOR_IMAGE_URL_BASE) [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
        2a. If image is found, insert the file into the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory & assign that image to foundImage
        2b. If image is not found, check if there is a file in the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
            3a. If If image is found, assign it to foundImage
            3b. If If image is not found, check for a country-specific image in the app Bundle [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
                4a. If YES, assign it to foundImage
                4b. If NO, use the default
    
     ********************************************************************************************************************************************************************/
    
    // Configuration
    
    // A. Get the country details
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    // B. Get the app name
    helperPrefs = [NSUserDefaults standardUserDefaults];
    NSString *appName = [helperPrefs objectForKey:@"appName"];
    
    // C. Set up the reference to the image downloaded previously from SPONSOR_IMAGE_URL_BASE and stored in SPONSOR_DOCUMENTS_DIRECTORY
    NSString *imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:SPONSOR_DOCUMENTS_DIRECTORY];
    NSString *potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
    
    // E. If the SPONSOR_DOCUMENTS_DIRECTORY doesn't exist, create it!
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:directoryPath] ){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    // End of Configuration
    
    // Check if there is a file in the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    // Search 1: imageReference_appName_country
    NSData *data;
    imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
    potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:potentialImagePath]){
        // 3a. If image is found, assign it to foundImage
        data = [[NSData alloc] initWithContentsOfFile:potentialImagePath];
    }else{
        // Search 2: imageReference_appName
        imageFileName = [NSString stringWithFormat:@"%@_%@.png",imageReference, appName];
        potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:potentialImagePath]){
            // 3a. If image is found, assign it to foundImage
            data = [[NSData alloc] initWithContentsOfFile:potentialImagePath];
        }else{
            // Search 3: imageReference_appName
            imageFileName = [NSString stringWithFormat:@"%@.png",imageReference];
            potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:potentialImagePath]){
                // 3a. If image is found, assign it to foundImage
                data = [[NSData alloc] initWithContentsOfFile:potentialImagePath];
            }
        }
    }
    
    // ASSIGN WHATEVER DATA HAS BEEN FOUND AT THIS POINT TO FOUND IMAGE
    foundImage = [[UIImage alloc] initWithData:data];
    
    // If image is NOT found, foundImage = nil, check for a country-specific image in the app Bundle [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    UIImage *checkImage;
    if( foundImage == nil ){
        // Search 1: imageReference_appName_country
        imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
        checkImage = [UIImage imageNamed:imageFileName];
        if( checkImage != nil ){
            // 4a. If image is found, assign it to foundImage
            foundImage = checkImage;
        }else{
            // Search 2: imageReference_appName
            imageFileName = [NSString stringWithFormat:@"%@_%@.png",imageReference, appName];
            checkImage = [UIImage imageNamed:imageFileName];
            if( checkImage != nil ){
                // 4a. If image is found, assign it to foundImage
                foundImage = checkImage;
            }else{
                // Search 3: imageReference
                imageFileName = [NSString stringWithFormat:@"%@.png",imageReference];
                checkImage = [UIImage imageNamed:imageFileName];
                if( checkImage != nil ){
                    // 4a. If image is found, assign it to foundImage
                    foundImage = checkImage;
                }
            }
        }
    }
    
    // 4b. If image is found, use the default
    // No action is required here because foundImage = nil (The UI assigns a default Doctot )
    
    // Lists the files in SPONSOR_DOCUMENTS_DIRECTORY (not needed for anything except testing/confirmation)
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    for(int count = 0; count < (int)[directoryContent count]; count++){
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    
    return foundImage;
    
}

+ (void)writeSponsorshipImageFromOnlineToDocumentsDirectory:(NSString *)imageReference {
    
    /********************************************************************************************************************************************************************
     
    Try to get image from online (SPONSOR_IMAGE_URL_BASE) [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    If image is found, insert the file into the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory & assign that image to foundImage
    
     ********************************************************************************************************************************************************************/
    
    // Configuration
    
    // A. Get the country details
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    // B. Get the app name
    helperPrefs = [NSUserDefaults standardUserDefaults];
    NSString *appName = [helperPrefs objectForKey:@"appName"];
    
    // C. Set up the call to the online reference: SPONSOR_IMAGE_URL_BASE
    NSString *imageFileName = [NSString stringWithFormat:@"%@_%@_%@.png",imageReference, appName, country];
    NSString *urlPath = [NSString stringWithFormat:@"%@%@", SPONSOR_IMAGE_URL_BASE, imageFileName];
    NSURL *url = [NSURL URLWithString:urlPath];
    
    // D. Set up the reference to the image downloaded previously from SPONSOR_IMAGE_URL_BASE and stored in SPONSOR_DOCUMENTS_DIRECTORY
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:SPONSOR_DOCUMENTS_DIRECTORY];
    NSString *potentialImagePath = [directoryPath stringByAppendingPathComponent:imageFileName];
    
    // E. If the SPONSOR_DOCUMENTS_DIRECTORY doesn't exist, create it!
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:directoryPath] ){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    // End of Configuration
    
    // 1. Try to get image from online (SPONSOR_IMAGE_URL_BASE) [3 searches: imageReference_appName_country, imageReference_appName and imageReference]
    // Search 1: imageReference_appName_country
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    // Search 2: imageReference_appName (Couldn't find a specific image for that app for that country, so try default image for that app)
    if( data == nil ){
        
        imageFileName = [NSString stringWithFormat:@"%@_%@.png",imageReference, appName];
        urlPath = [NSString stringWithFormat:@"%@%@", SPONSOR_IMAGE_URL_BASE, imageFileName];
        url = [NSURL URLWithString:urlPath];
        data = [[NSData alloc] initWithContentsOfURL:url];
    
        // Search 3: imageReference (Couldn't find a specific image for that app, so try default image)
        if( data == nil ){
            
            imageFileName = [NSString stringWithFormat:@"%@.png",imageReference];
            urlPath = [NSString stringWithFormat:@"%@%@", SPONSOR_IMAGE_URL_BASE, imageFileName];
            url = [NSURL URLWithString:urlPath];
            data = [[NSData alloc] initWithContentsOfURL:url];
            
        }
        
    }
    
    // 2a. If image is found, insert the file into the SPONSOR_DOCUMENTS_DIRECTORY of the Documents directory & assign that image to foundImage
    if( data != nil ){
        
        // Save/overwrite the imageFileName file from SPONSOR_IMAGE_URL_BASE to SPONSOR_DOCUMENTS_DIRECTORY
        [data writeToFile:potentialImagePath atomically:YES];
        
    }
    
}


/********************************************************************************************************************************************************************
 
 NEWS Nofitications
 
When the app goes into the background a series of timers, the generateNewsNotifications method is executed once
 
 generateNewsNotifications
 It sets NSTimers NEWS_DAYS_TO_NOFIFY_FOR number of times, NEWS_TIME_BETWEEN_ITEMS seconds apart.
 If this method is generated with NSTimers still not executed, then the method works out how many more are needed to top them up to NEWS_DAYS_TO_NOFIFY_FOR (and offset start point - from the end of the current series of NSTimers)
 Each NSTimer executes the newsSearchRunAfterBackground method
 
 newsSearchRunAfterBackground
 Produces a NewsNotification for each story in News table on DoctotPlus, which is:
  - relevant to this app (all apps or specifically to this app) and
  - is set as notificationEnabled and
  - the User has not already read it (checking NewsUserReads) and
  - the story was generated since the app was downloaded
 
 ********************************************************************************************************************************************************************/

+ (void)generateNewsNotifications {
    
    // Setting Up the Timers
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Clear all notifications first
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    /// Determine how many NSTimers are required on this access of the app
    int numberOfTopUpTimers = 0;
    int offSetTimeInterval = 0;
    NSDate *now = [NSDate date];
    NSDate *mostRecentNewsNoticationsDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastNewsNotificationGenerationDate"];
    if( mostRecentNewsNoticationsDate == nil ){
        mostRecentNewsNoticationsDate = now;
        numberOfTopUpTimers = NEWS_DAYS_TO_NOFIFY_FOR;
        offSetTimeInterval = 0;
    }else{
        NSTimeInterval interval = [now timeIntervalSinceDate:mostRecentNewsNoticationsDate];
        numberOfTopUpTimers = (int)( interval / NEWS_TIME_BETWEEN_ITEMS );
        offSetTimeInterval = ( NEWS_DAYS_TO_NOFIFY_FOR - numberOfTopUpTimers ) * NEWS_TIME_BETWEEN_ITEMS;
    }
    if( offSetTimeInterval < 0 ){
        numberOfTopUpTimers = NEWS_DAYS_TO_NOFIFY_FOR;
        offSetTimeInterval = 0;
    }
    
    // Create the series of local notifications using NSTimer to space them out
    for( int i = 0; i < numberOfTopUpTimers ; i++ ){
     
        //and create new timer with async call:
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //run function methodRunAfterBackground
            NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:( offSetTimeInterval + ( (i + 1) * NEWS_TIME_BETWEEN_ITEMS ) ) target:self selector:@selector(newsSearchRunAfterBackground) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
        
    }
    
    [helperPrefs setObject:[NSDate date] forKey:@"lastNewsNotificationGenerationDate"];
    
}

+ (void)newsSearchRunAfterBackground {
    
    // Get the registration date for the app (needed so the User does not see News from before that date)
    
    helperPrefs = [NSUserDefaults standardUserDefaults];
    NSDate *registrationDate = (NSDate *)[helperPrefs objectForKey:@"RegistrationDate"];
    NSLog(@"registrationDate: %@", registrationDate);
    
    NSString *sqlCommand;
    NSString *sqlResponse;
    NSError *err = nil;
    
    // Get all the previous News Items read by the User
    
    NSString *theUserId = (NSString *)[helperPrefs objectForKey:@"DTPlusUserId"];
    sqlCommand = [NSString stringWithFormat:@"SELECT newsId FROM NewsUserReads WHERE userId = '%@'", theUserId];
    sqlResponse = (NSString *)[Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    NSArray *alreadyReadByUserItems = [NSJSONSerialization JSONObjectWithData:[sqlResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    
    NSMutableArray *alreadyReadByUser = [[NSMutableArray alloc] init];
    NSString *newsItemId;
    for (NSMutableDictionary *aDictionaryNewsItem in alreadyReadByUserItems) {
        newsItemId = (NSString *)[aDictionaryNewsItem valueForKey:@"newsId"];
        [alreadyReadByUser addObject:newsItemId];
    }
    
    // Get any News Item related to the app
    
    sqlCommand = [NSString stringWithFormat:@"SELECT * FROM News WHERE ( notificationEnabled = 1 ) AND ( appSpecific = 'NO' OR appId = %@ )", [helperPrefs objectForKey:@"DTPlusAppId"]];
    sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    NSArray *newsItems = [NSJSONSerialization JSONObjectWithData:[sqlResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    
    NSMutableArray *readableNewsItemsToday = [[NSMutableArray alloc] init];
    NewsItem *anItem;
    for (NSMutableDictionary *aDictionaryNewsItem in newsItems) {
        
        anItem = [[NewsItem alloc] init];
        [anItem initialiseWithObject:aDictionaryNewsItem];
        
        // checks if the News Item is already read by the User
        bool isReadAlready = NO;
        for( NSString *theReadNewsId in alreadyReadByUser ){
            NSInteger readNewsId = [theReadNewsId integerValue];
            if( anItem.index == readNewsId ){
                isReadAlready = YES;
            }
        }
        
        // check if the News Item was published since the app was downloaded
        bool newsItemPublishedAfterRegistrationDate = NO;
        if( [anItem.creationTimeStamp compare:registrationDate] == NSOrderedDescending ){
            newsItemPublishedAfterRegistrationDate = YES;
        }
        
        if( !isReadAlready && newsItemPublishedAfterRegistrationDate ){
            [readableNewsItemsToday addObject:anItem];
        }
    }
    
    
    // Create a notification for the News item if one is present
    if( [readableNewsItemsToday count] > 0 ){
        
        // Get the first news item
        NewsItem *firstItem = [readableNewsItemsToday objectAtIndex:0];
        
        // Create a notification for the News item
        NewsNotification *newsNotification = [[NewsNotification alloc] init];
        [newsNotification initialiseWithTitle:firstItem.title andMessage:firstItem.message];
        
        // Add a record to NewsUserReads to mark this as read for the User
        sqlCommand = [NSString stringWithFormat:@"INSERT INTO NewsUserReads ( newsId, userId ) VALUES ( %li, %@ )", firstItem.index, theUserId];
        sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
        
    }
    
}

+ (UIAlertController *)defaultAlertController:(UIViewController *)parentController withHeading:(NSString *)theHeading andMessage:(NSString *)theMessage includeCancel:(BOOL)includeCancel {
    
    UIAlertController *defaultAlert = [UIAlertController alertControllerWithTitle:theHeading message:theMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    defaultAlert.popoverPresentationController.barButtonItem = parentController.navigationItem.rightBarButtonItem;
    defaultAlert.popoverPresentationController.sourceView = parentController.view;
    defaultAlert.popoverPresentationController.sourceRect = parentController.view.frame;
    
    if( includeCancel ){
        [defaultAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Button_Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [parentController dismissViewControllerAnimated:YES completion:^{}];
        }]];
    }
    
    return defaultAlert;
    
}


// SQL Commands

/********************************************************************************************************************************************************************
 
 + (id)executeRemoteSQLFromQueryBundle:(NSMutableDictionary *)queryBundle includeDelay:(BOOL)delayNeeded
 - queryBundle: (see below)
 - delayNeeded: sometimes the main app needs to wait for a result before continuing on
 
 NSMutableDictionary *theAttributes = [[NSMutableDictionary alloc] init];

 SELECT
 Sample Command: SELECT User WHERE email = 'fergalhartley@waterford.ie' AND firstName = 'Fergal';  and this returns a JSON string containing uniqueId and lastName values
 [theAttributes setObject:@"User" forKey:@"TABLE_NAME"];                     // TABLE to perform the action on
 [theAttributes setObject:@"SELECT" forKey:@"SQL_COMMAND"];                  // SELECT, INSERT, UPDATE or DELETE
 [theAttributes setObject:@"AND" forKey:@"CONDITION_OPERATOR"];              // AND, OR, NOT or ""   (Blank is used if there is only one parameter so no CONDITION_OPERATOR is needed)
 [theAttributes setObject:@"fergalmcd@yahoo.com" forKey:@"email"];           // Query Parameter (WHERE)
 [theAttributes setObject:@"Fergal" forKey:@"firstName"];                    // Query Parameter (WHERE)
 [theAttributes setObject:@"uniqueId,lastName" forKey:@"RETURN_VALUES"];     // Return Values from query

 INSERT
 // Sample Command: INSERT INTO User (email, firstName, lastName) VALUES ('fergalhartley@waterford.ie', 'Fergal', 'Hartley');
 [theAttributes setObject:@"User" forKey:@"TABLE_NAME"];                     // TABLE to perform the action on
 [theAttributes setObject:@"INSERT" forKey:@"SQL_COMMAND"];                  // SELECT, INSERT, UPDATE or DELETE
 [theAttributes setObject:@"fergalhartley@waterford.ie" forKey:@"email"];    // Insert key/Value Pair
 [theAttributes setObject:@"Fergal" forKey:@"firstName"];                    // Insert key/Value Pair
 [theAttributes setObject:@"Hartley" forKey:@"lastName"];                    // Insert key/Value Pair

 UPDATE
 // Sample Command: UPDATE User SET firstName = 'Feargal', lastName = 'Heartlee' WHERE email = 'fergalhartley@waterford.ie' AND firstName = 'Fergal';
 [theAttributes setObject:@"User" forKey:@"TABLE_NAME"];                     // TABLE to perform the action on
 [theAttributes setObject:@"UPDATE" forKey:@"SQL_COMMAND"];                  // SELECT, INSERT, UPDATE or DELETE
 [theAttributes setObject:@"AND" forKey:@"CONDITION_OPERATOR"];              // AND, OR, NOT or ""   (Blank is used if there is only one parameter so no CONDITION_OPERATOR is needed)
 [theAttributes setObject:@"fergalhartley@waterford.ie" forKey:@"email"];    // Query Parameter (WHERE)
 [theAttributes setObject:@"Fergal" forKey:@"firstName"];                    // Query Parameter (WHERE)
 [theAttributes setObject:@"lastName = 'Heartlee'" forKey:@"UPDATE_PAIR_01"];   // Update key/Value Pair (new replacement values to overwrite the old ones)
 [theAttributes setObject:@"firstName = 'Feargal'" forKey:@"UPDATE_PAIR_02"];   // Update key/Value Pair (new replacement values to overwrite the old ones)

 DELETE
 // Sample Command: DELETE FROM User WHERE email = 'fergalhartley@waterford.ie' AND firstName = 'Fergal';
 [theAttributes setObject:@"User" forKey:@"TABLE_NAME"];                     // TABLE to perform the action on
 [theAttributes setObject:@"DELETE" forKey:@"SQL_COMMAND"];                  // SELECT, INSERT, UPDATE or DELETE
 [theAttributes setObject:@"AND" forKey:@"CONDITION_OPERATOR"];              // AND, OR, NOT or ""   (Blank is used if there is only one parameter so no CONDITION_OPERATOR is needed)
 [theAttributes setObject:@"fergalhartley@waterford.ie" forKey:@"email"];    // Query Parameter (WHERE)
 [theAttributes setObject:@"Fergal" forKey:@"firstName"];                    // Query Parameter (WHERE)
 
 [Helper executeRemoteSQLFromQueryBundle:theAttributes includeDelay:NO];
 
 Note: There is a puase in the method when the SQL command is SELECT. This allows time for the response to be assigned to the id sqlResponse

 ********************************************************************************************************************************************************************/

+ (id)executeRemoteSQLFromQueryBundle:(NSMutableDictionary *)queryBundle includeDelay:(BOOL)delayNeeded {
    
    __block id sqlResponse = @"";
    __block BOOL waiting = YES;
    
    // Stores the query if there is no internet connection at the time
    if( ![Helper isConnectedToInternet] ){
        NSMutableArray *storedSQLQueriesArray = [[NSMutableArray alloc] init];
        storedSQLQueriesArray = (NSMutableArray *)[helperPrefs objectForKey:@"storedSQLQueriesArray"];
        if( [storedSQLQueriesArray isKindOfClass:[NSString class]]){
            storedSQLQueriesArray = [[NSMutableArray alloc] init];
        }
        [storedSQLQueriesArray addObject:queryBundle];
        [helperPrefs setObject:storedSQLQueriesArray forKey:@"storedSQLQueriesArray"];
    }
    
    // Escaping apostophes in any attribute in queryBundle
    NSArray *keys = [queryBundle allKeys];
    NSArray *values = [queryBundle allValues];
    for( int i = 0; i < [keys count]; i++ ){
        NSString *thisKey = (NSString *)[keys objectAtIndex:i];
        NSString *thisValue = (NSString *)[values objectAtIndex:i];
        if( [thisValue containsString:@"'"] ){
            thisValue = [thisValue stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            [queryBundle setObject:thisValue forKey:thisKey];
        }
    }
    
    //Create the request (POST)
    
    NSError *jsonError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:queryBundle options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *postLength = [NSString stringWithFormat:@"%li", [postData length]];
    
    //NSString *urlString = @"http://www.doctotapps.com/appsqlcommands/generalQuery.php";
    NSString *urlString = [NSString stringWithFormat:@"%@generalQuery.php", SQL_URL_BASE];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:postData];
    
    // For SELECT statements OR delayNeeded parameter is TRUE, which return results to the app, we need to wait for a response
    
    BOOL isSelectStatement = NO;
    for (NSString* key in queryBundle) {
        if ([key hasPrefix:@"SQL_COMMAND"]) {
            NSString *commandType = (NSString *)[queryBundle objectForKey:key];
            if( [commandType isEqualToString:@"SELECT"] || ( delayNeeded ) ){
                isSelectStatement = YES;
            }
        }
    }
    
    //Create the response and Error
    NSURLSession *session = [NSURLSession sharedSession];
    if( isSelectStatement ){
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        [[session dataTaskWithRequest:urlRequest
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        NSString *resSrt = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                        sqlResponse = resSrt;
                        waiting = NO;
                        dispatch_semaphore_signal(semaphore);
            
                        // If an invalid URL is generated
                        if([((NSHTTPURLResponse *)response) statusCode] == 404){
                            
                        }
                        
                    }]
         resume];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }else{
        
        [[session dataTaskWithRequest:urlRequest
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       
                       NSString *resSrt = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                       sqlResponse = resSrt;
           
                       // If an invalid URL is generated
                       if([((NSHTTPURLResponse *)response) statusCode] == 404){
                           
                       }
                       
                   }]
        resume];
        
    }
    
    return sqlResponse;
    
}

/********************************************************************************************************************************************************************
 
 + (id)executeRemoteSQLStatement:(NSString *)sqlQueryString includeDelay:(BOOL)delayNeeded
 - sqlQueryString: any SQL statement string
 - delayNeeded: sometimes the main app needs to wait for a result before continuing on
 
 [Helper executeRemoteSQLStatement:@"INSERT INTO User (email, firstName, lastName) VALUES ('fergalhartley@waterford.ie', 'Fergal', 'Hartley')"];
 
 Note: There is a puase in the method when the SQL command is SELECT. This allows time for the response to be assigned to the id sqlResponse
 
 ********************************************************************************************************************************************************************/
 
+ (id)executeRemoteSQLStatement:(NSString *)sqlQueryString includeDelay:(BOOL)delayNeeded {
    
    __block id sqlResponse = @"";
    __block BOOL waiting = YES;
    
    // Stores the query if there is no internet connection at the time
    if( ![Helper isConnectedToInternet] ){
        NSMutableArray *storedSQLQueriesArray = [[NSMutableArray alloc] init];
        storedSQLQueriesArray = (NSMutableArray *)[helperPrefs objectForKey:@"storedSQLQueriesArray"];
        [storedSQLQueriesArray addObject:sqlQueryString];
        [helperPrefs setObject:storedSQLQueriesArray forKey:@"storedSQLQueriesArray"];
    }
    
    //Create the request (GET)
    
    //NSString *baseURL = @"https://www.doctotapps.com/appsqlcommands/simpleTextQuery.php";
    NSString *baseURL = [NSString stringWithFormat:@"%@simpleTextQuery.php", SQL_URL_BASE];
    NSString *post = [NSString stringWithFormat:@"sqlCommand=%@", sqlQueryString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%li", [postData length]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:baseURL]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [urlRequest setHTTPBody:postData];
    
    //Create the response and Error
    
    NSURLSession *session = [NSURLSession sharedSession];
    // For SELECT statements OR delayNeeded parameter is TRUE, which return results to the app, we need to wait for a response
    if( [sqlQueryString hasPrefix:@"SELECT"] || ( delayNeeded ) ){
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        [[session dataTaskWithRequest:urlRequest
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        NSString *resSrt = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                        sqlResponse = resSrt;
                        waiting = NO;
                        dispatch_semaphore_signal(semaphore);
            
                        // If an invalid URL is generated
                        if([((NSHTTPURLResponse *)response) statusCode] == 404){
                            
                        }
                        
                    }]
         resume];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }else{
        
        [[session dataTaskWithRequest:urlRequest
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       
                       NSString *resSrt = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                       sqlResponse = resSrt;
           
                       // If an invalid URL is generated
                       if([((NSHTTPURLResponse *)response) statusCode] == 404){
                           
                       }
                       
                   }]
        resume];
        
    }
    
    /* For SELECT statements OR delayNeeded parameter is TRUE, which return results to the app, we need to wait for a response
    if( [sqlQueryString hasPrefix:@"SELECT"] || ( delayNeeded ) ){
        // Pause
        while( waiting ){
            // Pause
            int loopCount = 0;
            while( waiting ){
                loopCount++;
                NSLog(@"Looping: %i", loopCount);
            }
            NSLog(@"Waiting Loop: %i", loopCount);
        }
        
        //[NSThread sleepForTimeInterval:1.0];
    }
    */////////////////////////////////////////////////////////////////////////////////////////

    
    return sqlResponse;
}

/********************************************************************************************************************************************************************
 ********************************************************************************************************************************************************************/

+ (BOOL)isSQLResponseValid:(NSString *)sqlReturns {
    BOOL isValid = YES;
    
    if( ( [sqlReturns length] == 0 )  || [sqlReturns isEqualToString:@"[]"]  || [sqlReturns isEqualToString:@"(null)"] || [sqlReturns hasPrefix:@"Error"] || [sqlReturns hasPrefix:@"ERROR"] ){
        isValid = NO;
    }
    
    return isValid;
}

/********************************************************************************************************************************************************************
 ********************************************************************************************************************************************************************/

+ (void)resubmitStoredSQLQueries {
    
    if( [Helper isConnectedToInternet] ){
        
        NSMutableArray *storedSQLQueriesArray = [[NSMutableArray alloc] init];
        storedSQLQueriesArray = (NSMutableArray *)[helperPrefs objectForKey:@"storedSQLQueriesArray"];
        
        if( [storedSQLQueriesArray isKindOfClass:[NSString class]] ){
            return;
        }
        
        if( storedSQLQueriesArray == nil ){
            return;
        }
        
        NSString *sqlQueryString;
        NSMutableDictionary *sqlQueryDictionary;
        
        for( id storedQULQuery in storedSQLQueriesArray ){
            
            if( [storedQULQuery isKindOfClass:[NSString class]] ){
                sqlQueryString = (NSString *)storedQULQuery;
                [Helper executeRemoteSQLStatement:sqlQueryString includeDelay:YES];
            }
            
            if( [storedQULQuery isKindOfClass:[NSMutableDictionary class]] ){
                sqlQueryDictionary = (NSMutableDictionary *)storedQULQuery;
                [Helper executeRemoteSQLFromQueryBundle:sqlQueryDictionary includeDelay:YES];
            }
            
        }
        
        // Delete all the stored SQL Queries
        [helperPrefs setObject:@"" forKey:@"storedSQLQueriesArray"];
    
    }
    
}


// Save Scores

/********************************************************************************************************************************************************************
 
+ (void)createRecordinTable:(NSString *)theTable withObject:(id)newObject andParentObject:(id)parentObject
 - theTable: format = @"<tableName>"
 - newObject: format = any object that matches up with an entitiy in the data model
 - parentObject: format = the data object to which the new object is derived from (This can be nil - if there is no parent)
 
 [Helper createRecordinTable:@"Patient" withObject:thePatient andParentObject:nil];
 [Helper createRecordinTable:@"Interview" withObject:theInterview andParentObject:patientObj];
 
 ********************************************************************************************************************************************************************/

+ (void)createRecordinTable:(NSString *)theTable withObject:(id)newObject andParentObject:(id)parentObject {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:theTable inManagedObjectContext:context];
    NSManagedObject *newPatient;
    NSManagedObject *newInterview;
    NSManagedObject *newQuestion;
    
    // PATIENT
    if( [theTable isEqualToString:@"Patient"] ){
        newPatient = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        
        DataPatient *patientObject = (DataPatient *)newObject;
        [newPatient setValue:patientObject.uniqueID forKey:@"uniqueID"];
        [newPatient setValue:[NSNumber numberWithInteger:patientObject.dtPlusID] forKey:@"dtPlusId"];
        [newPatient setValue:patientObject.hospitalNo forKey:@"hospitalNo"];
        [newPatient setValue:patientObject.firstName forKey:@"firstName"];
        [newPatient setValue:patientObject.lastName forKey:@"lastName"];
        [newPatient setValue:patientObject.dob forKey:@"dob"];
        [newPatient setValue:patientObject.address forKey:@"address"];
        [newPatient setValue:patientObject.notes forKey:@"notes"];
        [newPatient setValue:patientObject.photoData forKey:@"photoData"];
    }
    
    // INTERVIEW
    if( [theTable isEqualToString:@"Interview"] ){
        newInterview = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        
        DataInterview *interviewObject = (DataInterview *)newObject;
        [newInterview setValue:interviewObject.uniqueID forKey:@"uniqueID"];
        [newInterview setValue:[NSNumber numberWithInteger:interviewObject.dtPlusID] forKey:@"dtPlusId"];
        [newInterview setValue:interviewObject.scale forKey:@"scale"];
        [newInterview setValue:[NSNumber numberWithFloat:interviewObject.score] forKey:@"score"];
        [newInterview setValue:interviewObject.scoreCategory forKey:@"scoreCategory"];
        [newInterview setValue:interviewObject.creationDate forKey:@"creationDate"];
        [newInterview setValue:interviewObject.creationTimeOnly forKey:@"creationTime"];
        
        // Relationship to parent DataPatient object
        NSArray *parentManagedObjects = [self fetchMatchingObjectsFrom:@"Patient" referencingObject:parentObject];
        NSManagedObject *parentReference = (NSManagedObject *)[parentManagedObjects objectAtIndex:0];
        [newInterview setValue:parentReference forKeyPath:@"patient"];
        
        // Relationship for parent DataPatient object to link with this new Interview object
        [Helper createRelationshipFor:parentObject andChild:newInterview];
    }
    
    // QUESTION
    if( [theTable isEqualToString:@"Question"] ){
        newQuestion = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        
        DataQuestion *questionObject = (DataQuestion *)newObject;
        [newQuestion setValue:questionObject.uniqueID forKey:@"uniqueID"];
        [newQuestion setValue:questionObject.scale forKey:@"scale"];
        [newQuestion setValue:[NSNumber numberWithInteger:questionObject.index] forKey:@"index"];
        [newQuestion setValue:[NSNumber numberWithFloat:questionObject.score] forKey:@"score"];
        [newQuestion setValue:[NSNumber numberWithInteger:questionObject.item] forKey:@"item"];
        [newQuestion setValue:questionObject.customInformation forKey:@"customInformation"];
        
        // Relationship to parent DataInterview object
        //DataInterview *parentReference = (DataInterview *)parentObject;
        NSArray *parentManagedObjects = [self fetchMatchingObjectsFrom:@"Interview" referencingObject:parentObject];
        NSManagedObject *parentReference = (NSManagedObject *)[parentManagedObjects objectAtIndex:0];
        [newQuestion setValue:parentReference forKeyPath:@"interview"];
        
        // Relationship for parent DataInterview object to link with this new Question object
        [Helper createRelationshipFor:parentObject andChild:newQuestion];
    }
    
    // Save the context.
    NSError *error = nil;
    if( ![context save:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

/********************************************************************************************************************************************************************
 
+ (NSArray *)resultsFromTable:(NSString *)theTable forQuery:(NSString *)query ofType:(NSString *)andOr sortedBy:(NSString *)sortAttribute sortDirections:(NSString *)sortOrders
 - forQuery: format = "<field> == <queryValue>, <field> == <queryValue>, <field> == <queryValue> ..."
            exceptions = @"" / @"uniqueID == '*'" / @"uniqueID == *" will return ALL records in that table
 - ofType: @"AND" causes andPredicateWithSubpredicates to be executed / @"OR" causes orPredicateWithSubpredicates to be executed
 - sortedBy: format = @"<field>, <field>, <field>" 
 - sortDirections: format = @"<direction>, <direction>, <direction>"  (e.g. @"Ascending, Descending, Ascending")
 
  [Helper resultsFromTable:@"Patient" forQuery:@"uniqueID == '*'" ofType:@"AND" sortedBy:@"firstName" sortDirections:@"Ascending"];
 
********************************************************************************************************************************************************************/

+ (NSArray *)resultsFromTable:(NSString *)theTable forQuery:(NSString *)query ofType:(NSString *)andOr sortedBy:(NSString *)sortAttribute sortDirections:(NSString *)sortOrders {
    
    NSArray *fetchedObjects;
    NSFetchedResultsController *fetchedResultsController;
    
    // Query format should be: "<field> == <queryValue>, <field> == <queryValue>, <field> == <queryValue> ..."
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    NSPredicate *thisPredicate;
    NSArray *delimitedQueryArray = [query componentsSeparatedByString:@","];
    NSMutableArray *delimitedQuery = [NSMutableArray arrayWithArray:delimitedQueryArray];
    NSArray *predicatesArray;
    
    BOOL errorInQuery = NO;
    
    if( ([query length] == 0) || ([query isEqualToString:@"uniqueID == *"]) || ([query isEqualToString:@"uniqueID == '*'"]) ){
        
        // In the case where every record is to be returned
        predicatesArray = [self createPredicateToReturnEverything];
        //errorInQuery = NO;
        andOr = @"OR";
    
    }else{
        
        // A typical Query
        for( NSString *querySegment in delimitedQuery ){
            if( [querySegment containsString:@"=="] ) {
                thisPredicate = [NSPredicate predicateWithFormat:querySegment];
                [predicates addObject:thisPredicate];
            }else{
                errorInQuery = YES;
            }
            
        }
        predicatesArray = (NSArray *)predicates;
        
    }
    

    if( !errorInQuery ){
    
        // Constructing the fetch request
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:theTable inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        // Setting up the Query
        NSCompoundPredicate *compoundPredicate;
        if( [andOr isEqualToString:@"OR"] ){
            compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicatesArray];
        }else{
            compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        }
        
        [fetchRequest setPredicate:compoundPredicate];
        
        // Setting up the Sorting
        NSMutableArray *sorts = [[NSMutableArray alloc] init];
        NSSortDescriptor *sortDescriptor;
        NSArray *sortDescriptors = [[NSArray alloc] init];
        BOOL errorInSort = NO;
        if( [sortAttribute length] > 0 ){
            
            NSArray *delimitedSortArray = [sortAttribute componentsSeparatedByString:@","];
            NSMutableArray *delimitedSort = [NSMutableArray arrayWithArray:delimitedSortArray];
            
            NSArray *delimitedSortDirectionArray = [sortOrders componentsSeparatedByString:@","];
            
            int i = 0;
            NSString *sortSegmentTidied;
            NSString *sortOrderSegment;
            for( NSString *sortSegment in delimitedSort ){
                if( [[entity propertiesByName] objectForKey:sortSegment] != nil ) {
                    
                    sortSegmentTidied = [sortSegment stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    sortOrderSegment = (NSString *)[delimitedSortDirectionArray objectAtIndex:i];
                    BOOL isAscending = NO;
                    if( [sortOrders containsString:@"Ascending"] ){
                        isAscending = YES;
                    }
                    
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortSegmentTidied ascending:isAscending];
                    [sorts addObject:sortDescriptor];
                    
                }else{
                    errorInSort = YES;
                }
                i++;
            }
            sortDescriptors = (NSArray *)sorts;
            
            if( !errorInSort ){
                [fetchRequest setSortDescriptors:sortDescriptors];
            }
        }else{
            errorInSort = YES;
        }
        
        if( errorInSort ) {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uniqueID" ascending:NO];
            sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
        }
        
        // Executing the fetch request
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            NSLog(@"Unable to execute fetch request.");
            NSLog(@"%@, %@", error, error.localizedDescription);
            
        } else {
            NSLog(@"%@", result);
        }
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
        
    }else{
    
        fetchedResultsController = nil;
        
    }
    
    NSError *error;
    [fetchedResultsController performFetch:&error];
    fetchedObjects = [fetchedResultsController fetchedObjects];
    
    return fetchedObjects;
}

/********************************************************************************************************************************************************************
 
+ (void)updateRecordFrom:(NSString *)theTable oldObject:(id)oldObject withNewObject:(id)newObject
 - updatedObject: format = any custom object that matches up with an entitiy in the data model (the object to be changed)
 
 [Helper updateRecordFrom:@"Patient" withObject:patientObject1 withNewObject:patientObject2];
 
 ********************************************************************************************************************************************************************/

+ (void)updateRecordFrom:(NSString *)theTable withObject:(id)updatedObject {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSArray *results = [Helper fetchMatchingObjectsFrom:theTable referencingObject:updatedObject];
    
    // Updating the NSManagedObject with data from the paramenter custom object
    
    NSManagedObject *updatedPatient;
    NSManagedObject *updatedInterview;
    NSManagedObject *updatedQuestion;
    
    if( [theTable isEqualToString:@"Patient"] ){
        updatedPatient = [results objectAtIndex:0];
        DataPatient *patientObject = (DataPatient *)updatedObject;
        
        [updatedPatient setValue:patientObject.uniqueID forKey:@"uniqueID"];
        [updatedPatient setValue:[NSNumber numberWithInteger:patientObject.dtPlusID] forKey:@"dtPlusId"];
        [updatedPatient setValue:patientObject.hospitalNo forKey:@"hospitalNo"];
        [updatedPatient setValue:patientObject.firstName forKey:@"firstName"];
        [updatedPatient setValue:patientObject.lastName forKey:@"lastName"];
        [updatedPatient setValue:patientObject.dob forKey:@"dob"];
        [updatedPatient setValue:patientObject.address forKey:@"address"];
        [updatedPatient setValue:patientObject.notes forKey:@"notes"];
        [updatedPatient setValue:patientObject.photoData forKey:@"photoData"];
    }
    
    if( [theTable isEqualToString:@"Interview"] ){
        updatedInterview = [results objectAtIndex:0];
        DataInterview *interviewObject = (DataInterview *)updatedObject;
        
        [updatedInterview setValue:interviewObject.uniqueID forKey:@"uniqueID"];
        [updatedInterview setValue:[NSNumber numberWithInteger:interviewObject.dtPlusID] forKey:@"dtPlusId"];
        [updatedInterview setValue:interviewObject.scale forKey:@"scale"];
        [updatedInterview setValue:[NSNumber numberWithFloat:interviewObject.score] forKey:@"scale"];
        [updatedInterview setValue:interviewObject.scoreCategory forKey:@"scoreCategory"];
        [updatedInterview setValue:interviewObject.creationDate forKey:@"creationDate"];
        [updatedInterview setValue:interviewObject.creationTimeOnly forKey:@"creationTime"];
    }
    
    if( [theTable isEqualToString:@"Question"] ){
        updatedQuestion = [results objectAtIndex:0];
        DataQuestion *questionObject = (DataQuestion *)updatedObject;

        [updatedQuestion setValue:questionObject.uniqueID forKey:@"uniqueID"];
        [updatedQuestion setValue:questionObject.scale forKey:@"scale"];
        [updatedQuestion setValue:[NSNumber numberWithFloat:questionObject.score] forKey:@"score"];
        [updatedQuestion setValue:[NSNumber numberWithInteger:questionObject.item] forKey:@"item"];
        [updatedQuestion setValue:questionObject.customInformation forKey:@"customInformation"];
    }
    
    // Save the context.
    NSError *error = nil;
    if( ![context save:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

/********************************************************************************************************************************************************************
 
+ (void)updateRecordFrom:(NSString *)theTable forField:(NSString *)theField withNewValue:(NSString *)theValue regardingObject:(id)updatedObject
 
 Setting an individual value in a record
 - theField: NSString - refering to the name of the attribute to be updated
 - theValue: id - the new value passed as an generic id
 - theFieldType: NSString - the type of value to convert the 'theValue' string back to
 - regardingObject: format = any custom object that matches up with an entitiy in the data model (the object to be changed)
 
 [Helper updateRecordFrom:@"Patient" forField:@"hospitalNo" withNewValue:@"123" regardingObject:patientObj];
 
 ********************************************************************************************************************************************************************/

+ (void)updateRecordFrom:(NSString *)theTable forField:(NSString *)theField withNewValue:(id)theValue regardingObject:(id)updatedObject {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSArray *results = [Helper fetchMatchingObjectsFrom:theTable referencingObject:updatedObject];
    
    NSManagedObject *updatedPatient;
    NSManagedObject *updatedInterview;
    NSManagedObject *updatedQuestion;
    
    if( [theTable isEqualToString:@"Patient"] ){
        updatedPatient = [results objectAtIndex:0];
        [updatedPatient setValue:theValue forKey:theField];
    }
    if( [theTable isEqualToString:@"Interview"] ){
        updatedInterview = [results objectAtIndex:0];
        [updatedInterview setValue:theValue forKey:theField];
    }
    if( [theTable isEqualToString:@"Question"] ){
        updatedQuestion = [results objectAtIndex:0];
        [updatedQuestion setValue:theValue forKey:theField];
    }
    
    // Save the context.
    NSError *error = nil;
    if( ![context save:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

/********************************************************************************************************************************************************************
 
 + (void)createRelationshipFor:(id)parentObject andChild:(id)childObject

 - parentObject: format = any custom object (DataPatient/DateInterview) that matches up with an entitiy in the data model (the object to create the relationship on)
 - childObject: format = any custom object (DateInterview/DataQuestion) that matches up with an entitiy in the data model (the 'many' object of the 'one-many' relationship)
 
 [Helper createRelationshipFor:patientObject andChild:interviewObject];
 
 ********************************************************************************************************************************************************************/

+ (void)createRelationshipFor:(id)parentObject andChild:(id)childObject {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSArray *parentResults;
    NSArray *childResults;
    
    NSManagedObject *updatedPatient;
    NSManagedObject *updatedInterview;
    NSManagedObject *updatedQuestion;
    
    // PATIENT
    if( [parentObject isKindOfClass:[DataPatient class]] ){
        parentResults = [Helper fetchMatchingObjectsFrom:@"Patient" referencingObject:parentObject];
        updatedPatient = [parentResults objectAtIndex:0];
        
        childResults = [Helper fetchMatchingObjectsFrom:@"Interview" referencingObject:childObject];
        updatedInterview = [childResults objectAtIndex:0];
        
        NSMutableSet *interviews = [updatedPatient mutableSetValueForKey:@"interviews"];
        [interviews addObject:updatedInterview];
        
        NSLog(@"Inside: Patient Interview: %@", [updatedPatient valueForKeyPath:@"interviews"]);
    }
    
    // INTERVIEW
    if( [parentObject isKindOfClass:[DataInterview class]] ){
        parentResults = [Helper fetchMatchingObjectsFrom:@"Interview" referencingObject:parentObject];
        updatedInterview = [parentResults objectAtIndex:0];
        
        childResults = [Helper fetchMatchingObjectsFrom:@"Question" referencingObject:childObject];
        updatedQuestion = [childResults objectAtIndex:0];
        
        NSMutableSet *questions = [updatedInterview mutableSetValueForKey:@"questions"];
        [questions addObject:updatedQuestion];
    }
    
    // Save the context.
    NSError *error = nil;
    if( ![context save:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

/********************************************************************************************************************************************************************
 
+ (void)deleteRecordFrom:(NSString *)theTable fromReferenceObject:(id)deletedObject
 - deletedObject: format = any custom object or NSManagedObject that matches up with an entitiy in the data model (the object to be deleted)
 
 [Helper deleteRecordFrom:@"Patient" fromReferenceObject:patientObj];
 
 ********************************************************************************************************************************************************************/

+ (void)deleteRecordFrom:(NSString *)theTable fromReferenceObject:(id)deletedObject {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *deletedManagedObject;
    
    if( [deletedObject isKindOfClass:[NSManagedObject class]] ){
    
        deletedManagedObject = deletedObject;
        
    }else{
    
        NSArray *results = [Helper fetchMatchingObjectsFrom:theTable referencingObject:deletedObject];
        deletedManagedObject = (NSManagedObject *)[results objectAtIndex:0];
        
    }
    
    [context deleteObject:deletedManagedObject];
    
    // Save the context.
    NSError *error = nil;
    if( ![context save:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSArray *)createPredicateToReturnEverything {
    NSArray *allArray = [[NSArray alloc] init];
    
    NSMutableArray *growingArray = [[NSMutableArray alloc] init];
    NSPredicate *thisPredicate;
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'a'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'b'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'c'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'd'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'e'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'f'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'g'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'h'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'i'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'j'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'k'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'l'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'm'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'n'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'o'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'p'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'q'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'r'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 's'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 't'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'u'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'v'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'w'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'x'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'y'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] 'z'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '0'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '1'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '2'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '3'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '4'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '5'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '6'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '7'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '8'"];  [growingArray addObject:thisPredicate];
    thisPredicate = [NSPredicate predicateWithFormat:@"uniqueID CONTAINS[c] '9'"];  [growingArray addObject:thisPredicate];
    
    allArray = (NSArray *)growingArray;
    
    return allArray;
}

+ (NSArray *)fetchMatchingObjectsFrom:(NSString *)theTable referencingObject:(id)updatedObject {
    NSArray *results;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:theTable inManagedObjectContext:context]];
    
    // Setting up the Query with the sending object's uniqueID
    NSString *queryString;
    DataPatient *patientObject;
    DataInterview *interviewObject;
    DataQuestion *questionObject;
    if( [theTable isEqualToString:@"Patient"] ){
        patientObject = (DataPatient *)updatedObject;
        queryString = [NSString stringWithFormat:@"uniqueID == '%@'", (DataPatient *)patientObject.uniqueID];
    }
    if( [theTable isEqualToString:@"Interview"] ){
        interviewObject = (DataInterview *)updatedObject;
        queryString = [NSString stringWithFormat:@"uniqueID == '%@'", (DataInterview *)interviewObject.uniqueID];
    }
    if( [theTable isEqualToString:@"Question"] ){
        questionObject = (DataQuestion *)updatedObject;
        queryString = [NSString stringWithFormat:@"uniqueID == '%@'", (DataQuestion *)questionObject.uniqueID];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:queryString];
    [request setPredicate:predicate];
    
    NSError *resultError = nil;
    results = [context executeFetchRequest:request error:&resultError];
    
    return results;
}


@end
