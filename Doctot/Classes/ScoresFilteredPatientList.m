//
//  ScoresFilteredPatientList.m
//  Doctot
//
//  Created by Fergal McDonnell on 27/04/2016.
//  Copyright © 2017 Fergal McDonnell. All rights reserved.
//

#import "ScoresFilteredPatientList.h"
#import "DataPatient.h"
#import "ScoreSelected.h"
#import "Helper.h"

@implementation ScoresFilteredPatientList

- (void)viewDidLoad {
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImage.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:bgImage];
    bgImage.layer.zPosition = -5;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if( [_source isEqualToString:@"patientList"] ){
        numberOfRows = self.filteredResults.count;
    }
    if( [_source isEqualToString:@"scoreList"] ){
        numberOfRows = self.filteredResults.count;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilteredCell" forIndexPath:indexPath];
    
    if( [_source isEqualToString:@"patientList"] ){
        
        DataPatient *thisPatient = (DataPatient *)[_filteredResults objectAtIndex:indexPath.row];
        
        UIImageView *bgCellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        bgCellImage.image = [UIImage imageNamed:@"background.png"];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, cell.frame.size.width - 50, cell.frame.size.height)];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", thisPatient.firstName, thisPatient.lastName];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:bgCellImage];
        [cell.contentView addSubview:nameLabel];
        
    }
    
    if( [_source isEqualToString:@"scoreList"] ){
        
        ScoreSelected *thisScore = (ScoreSelected *)[_filteredResults objectAtIndex:indexPath.row];

        UIImageView *bgCellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        bgCellImage.image = [UIImage imageNamed:@"background.png"];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_item1Padding, 0, _item1Width, cell.frame.size.height)];
        dateLabel.text = thisScore.dateString;
        dateLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( (dateLabel.frame.origin.x + dateLabel.frame.size.width), 0, _item2Width, cell.frame.size.height)];
        nameLabel.text = thisScore.fullName;
        nameLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        nameLabel.numberOfLines = 3;
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake( (nameLabel.frame.origin.x + nameLabel.frame.size.width), 0, _item3Width, cell.frame.size.height)];
        scoreLabel.text = [NSString stringWithFormat:@"%.1f", thisScore.score];
        scoreLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = [Helper getColourFromString:[Helper returnValueForKey:@"TextColourForTransparentBackground"]];
        
        float shaveIconBy = 3;
        UIImageView *categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake( scoreLabel.frame.origin.x + shaveIconBy , scoreLabel.frame.origin.y + shaveIconBy, scoreLabel.frame.size.width - (2 * shaveIconBy), scoreLabel.frame.size.height - (2 * shaveIconBy))];
        categoryIcon.image = [UIImage imageNamed:thisScore.iconName];
        categoryIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        float chevronWidth = cell.frame.size.height / 2;
        UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake( cell.frame.size.width - chevronWidth, (cell.frame.size.height / 4), chevronWidth, (cell.frame.size.height / 2))];
        chevron.image = [UIImage imageNamed:@"chevron_white_right.png"];
        chevron.contentMode = UIViewContentModeCenter;
        
        UIImageView *underline = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 2, cell.frame.size.width, 2)];
        underline.image = [UIImage imageNamed:@"content.png"];
        underline.alpha = 0.3;
        
        [cell.contentView addSubview:bgCellImage];
        [cell.contentView addSubview:dateLabel];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:categoryIcon];
        [cell.contentView addSubview:scoreLabel];
        [cell.contentView addSubview:chevron];
        [cell.contentView addSubview:underline];
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( [_source isEqualToString:@"scoreList"] ){
        
    }
    
    if( [_source isEqualToString:@"patientList"] ){
        
    }
    
}

@end
