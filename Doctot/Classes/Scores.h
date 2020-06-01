//
//  Scores.h
//  Doctot
//
//  Created by Fergal McDonnell on 07/10/2016.
//  Copyright © 2016 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Scores.h"
#import "ScoreSelected.h"
#import "ScaleDefinition.h"
#import "DataPatient.h"
#import "DataInterview.h"
#import "DataQuestion.h"
#import "ScoresFilteredPatientList.h"
#import "PatientManager.h"


@interface Scores : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate> {
    
    NSUserDefaults *prefs;
    ScaleDefinition *scaleDefinition;
    NSMutableArray *questions;
    
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    UIButton *dateSort;
    UIButton *nameSort;
    UIButton *scoreSort;
    UIImageView *dateSortIndicator;
    UIImageView *nameSortIndicator;
    UIImageView *scoreSortIndicator;
    UISearchController *scoreSearchController;
    NSMutableArray *scoresList;
    UITableView *scoreTable;
    ScoresFilteredPatientList *scoresFilteredScoreList;
    
    UISearchController *patientSearchController;
    NSMutableArray *patientsList;
    UITableView *patientTable;
    ScoresFilteredPatientList *scoresFilteredPatientList;
    BOOL searchControllerWasActive;
    BOOL searchControllerSearchFieldWasFirstResponder;
    BOOL singleApp;
    
    PatientManager *patientManager;
    
    ScoreSelected *scoreSelected;
    BOOL dateSortAscending;
    BOOL nameSortAscending;
    BOOL scoreSortAscending;
    ScoreSelected *scoreSelectedToExpand;
    UIButton *expandScoreToFullView;
    
    NSManagedObjectContext *managedObjectContext;
    NSArray *fetchedResults;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) ScaleDefinition *scaleDefinition;
@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *dateSort;
@property (nonatomic, retain) IBOutlet UIButton *nameSort;
@property (nonatomic, retain) IBOutlet UIButton *scoreSort;
@property (nonatomic, retain) IBOutlet UIImageView *dateSortIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *nameSortIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *scoreSortIndicator;
@property (nonatomic, retain) UISearchController *scoreSearchController;
@property (nonatomic, retain) NSMutableArray *scoresList;
@property (nonatomic, retain) IBOutlet UITableView *scoreTable;
@property (nonatomic, strong) ScoresFilteredPatientList *scoresFilteredScoreList;
@property (nonatomic, retain) NSMutableArray *patientsList;
@property (strong, nonatomic) IBOutlet UISearchController *patientSearchController;
@property (nonatomic, retain) IBOutlet UITableView *patientTable;
@property (nonatomic, strong) ScoresFilteredPatientList *scoresFilteredPatientList;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property BOOL singleApp;
@property (nonatomic, retain) IBOutlet PatientManager *patientManager;
@property (nonatomic, retain) ScoreSelected *scoreSelected;
@property BOOL dateSortAscending;
@property BOOL nameSortAscending;
@property BOOL scoreSortAscending;
@property (nonatomic, retain) ScoreSelected *scoreSelectedToExpand;
@property (nonatomic, retain) IBOutlet UIButton *expandScoreToFullView;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchedResults;

@end
