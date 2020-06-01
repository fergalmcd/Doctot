//
//  PatientManager.h
//  Doctot
//
//  Created by Fergal McDonnell on 04/05/2017.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PatientSelected.h"
#import "DataPatient.h"
#import "ScoresFilteredPatientList.h"


@interface PatientManager : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    
    NSUserDefaults *prefs;
    UIButton *leftNavBarButton;
    UIButton *rightNavBarButton;
    
    UIButton *identifierSort;
    UIButton *nameSort;
    UIButton *dobSort;
    UIImageView *identifierSortIndicator;
    UIImageView *nameSortIndicator;
    UIImageView *dobSortIndicator;
    BOOL identifierSortAscending;
    BOOL nameSortAscending;
    BOOL dobSortAscending;
    
    UISearchController *patientSearchController;
    NSMutableArray *patientsList;
    UITableView *patientTable;
    ScoresFilteredPatientList *scoresFilteredPatientList;
    UIImageView *patientsCollectionBackground;
    UICollectionView *patientsCollection;
    NSString *visualContextIndicator;
    BOOL searchControllerWasActive;
    BOOL searchControllerSearchFieldWasFirstResponder;
    
    PatientSelected *patientSelected;
    
    NSManagedObjectContext *managedObjectContext;
    NSArray *fetchedResults;
    
}

@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) IBOutlet UIButton *leftNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *rightNavBarButton;
@property (nonatomic, retain) IBOutlet UIButton *identifierSort;
@property (nonatomic, retain) IBOutlet UIButton *nameSort;
@property (nonatomic, retain) IBOutlet UIButton *dobSort;
@property (nonatomic, retain) IBOutlet UIImageView *identifierSortIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *nameSortIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *dobSortIndicator;
@property BOOL identifierSortAscending;
@property BOOL nameSortAscending;
@property BOOL dobSortAscending;
@property (nonatomic, retain) NSMutableArray *patientsList;
@property (strong, nonatomic) IBOutlet UISearchController *patientSearchController;
@property (nonatomic, retain) IBOutlet UITableView *patientTable;
@property (nonatomic, strong) ScoresFilteredPatientList *scoresFilteredPatientList;
@property (nonatomic, retain) IBOutlet UIImageView *patientsCollectionBackground;
@property (nonatomic, retain) IBOutlet UICollectionView *patientsCollection;
@property (nonatomic, retain) NSString *visualContextIndicator;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (nonatomic, retain) PatientSelected *patientSelected;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchedResults;

@end
