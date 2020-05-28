//
//  Helper.h
//  Doctot
//
//  Created by Fergal McDonnell on 28/09/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Scale.h"
#import "Book.h"

@interface Helper : NSObject {
    
}

+ (NSString *)getLocalisedString:(NSString *)referenceString withScalePrefix:(BOOL)scalePrefix;
//+ (Scale *)getScale;
+ (NSString *)returnValueForKey:(NSString *)theKey;
+ (UIColor *)getColourFromString:(NSString *)colourString;
+ (UIColor *)getBackgroundColourForText:(UIColor *)textColour givenBackground:(NSString *)backgroundType;
+ (void)showNavigationBar:(BOOL)show;
+ (CGSize)getInterviewQuestionDimensions;
+ (NSMutableArray *)generateScaleDefinitionsArray;
+ (NSMutableArray *)generateDefinitionsArrayForSpecifiedScale:(NSString *)theScale;
+ (NSMutableArray *)createCurrentScaleQuestions;
+ (NSMutableArray *)createQuestionsForScale:(ScaleDefinition *)theScaleDefinition;
+ (NSMutableArray *)sortedArray:(NSMutableArray *)originalArray byIndex:(NSString *)sortKey andAscending:(BOOL)isAscending;
+ (NSMutableArray *)returnPickerValueList:(NSString *)pickerName;
+ (Book *)generateBook:(NSString *)theBookReference;
+ (NSString *)prefixStyle:(NSString *)styleReference toHTMLContent:(NSString *)theContent;
+ (NSString *)convertDateToString:(NSDate *)inputDate forStyle:(NSString *)theStyle;
+ (NSDate *)convertStringToDate:(NSString *)inputDateString withFormat:(NSString *)theFormat;
+ (NSString *)convertDateToTimeString:(NSDate *)inputDate;
+ (UIFont *)getScaleItemFont:(NSString *)theScale;
+ (BOOL)alphaNumericOnly:(NSString *)theString;
+ (BOOL)validNameCharacters:(NSString *)theString;
+ (UIImageView *)returnAnimatedImage:(NSArray *)imageArray;
+ (BOOL)isConnectedToInternet;
+ (NSString *)printPrecision:(NSInteger)precision;
+ (NSString *)returnParameter:(NSString *)theParameter inJSONString:(NSString *)theJSONString forRecordIndex:(int)theIndex;
+ (void)saveOnlineResourcesToDocuments;
+ (BOOL)isiPad;
+ (UIButton *)customAlertControllerForiPadWithHeading:(NSString *)theHeading andMessage:(NSString *)theMessage;
+ (float)adjustYShiftDownwards;
+ (NSDictionary *)determineMostUpToDateResource:(NSString *)resourceFile;
+ (void)sendAppActivationEmail;
+ (BOOL)checkIfTouchIDSupported;
+ (void)postFirebaseEventForEventName:(NSString *)eventName withContent:(NSDictionary *)theContent;
+ (void)shareApp:(UIViewController *)sourceViewController;
+ (void)requestAppStoreReview;
+ (UIImage *)getSponsorshipImageFor:(NSString *)imageReference;
+ (UIImage *)readSponsorshipImageFromDocuments:(NSString *)imageReference;
+ (void)writeSponsorshipImageFromOnlineToDocumentsDirectory:(NSString *)imageReference;
+ (void)generateNewsNotifications;
+ (void)newsSearchRunAfterBackground;
+ (UIAlertController *)defaultAlertController:(UIViewController *)parentController withHeading:(NSString *)theHeading andMessage:(NSString *)theMessage includeCancel:(BOOL)includeCancel;
// SQL Commands
+ (id)executeRemoteSQLFromQueryBundle:(NSMutableDictionary *)queryBundle includeDelay:(BOOL)delayNeeded;
+ (id)executeRemoteSQLStatement:(NSString *)sqlQueryString includeDelay:(BOOL)delayNeeded;
+ (NSMutableArray *)returnArrayOfType:(NSString *)sqlObject FromJSONStringResult:(NSString *)theJSONString;
+ (BOOL)isSQLResponseValid:(NSString *)sqlReturns;
+ (void)resubmitStoredSQLQueries;
// Core Data
+ (void)createRecordinTable:(NSString *)theTable withObject:(id)newObject andParentObject:(id)parentObject;
+ (NSArray *)resultsFromTable:(NSString *)theTable forQuery:(NSString *)query ofType:(NSString *)andOr sortedBy:(NSString *)sortAttribute sortDirections:(NSString *)sortOrders;
+ (void)updateRecordFrom:(NSString *)theTable withObject:(id)updatedObject;
+ (void)updateRecordFrom:(NSString *)theTable forField:(NSString *)theField withNewValue:(id)theValue regardingObject:(id)updatedObject;
+ (void)createRelationshipFor:(id)parentObject andChild:(id)childObject;
+ (void)deleteRecordFrom:(NSString *)theTable fromReferenceObject:(id)deletedObject;
+ (NSArray *)fetchMatchingObjectsFrom:(NSString *)theTable referencingObject:(id)updatedObject;


@end
