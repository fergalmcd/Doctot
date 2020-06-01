//
//  News.m
//  Doctot
//
//  Created by Fergal McDonnell on 13/09/2018.
//  Copyright © 2018 Fergal McDonnell. All rights reserved.
//

#import "News.h"
#import "Helper.h"
#import "Constants.h"

@interface News ()

@end

@implementation News

@synthesize prefs;
@synthesize leftNavBarButton, rightNavBarButton, feedTable, spinner, expandedNewsItem;
@synthesize feed;
@synthesize selectedItem, selectedItemActivated;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = [Helper getLocalisedString:@"Scale_News" withScalePrefix:NO];
    
    leftNavBarButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 49, 43)];
    [leftNavBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    selectedItemActivated = NO;

    [spinner startAnimating];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Only includes NewsItems which are not app specific or are specically for this app
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT * FROM News WHERE appSpecific = 'NO' OR appId = %@", [prefs objectForKey:@"DTPlusAppId"]];
    NSString *sqlResponse = [Helper executeRemoteSQLStatement:sqlCommand includeDelay:YES];
    NSLog(@"sqlResponse: %@", sqlResponse);
    
    NSError *err = nil;
    NSArray *newsItems = [NSJSONSerialization JSONObjectWithData:[sqlResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];

    feed = [[NSMutableArray alloc] init];
    NewsItem *anItem;
    for (NSMutableDictionary *aDictionaryNewsItem in newsItems) {
        anItem = [[NewsItem alloc] init];
        [anItem initialiseWithObject:aDictionaryNewsItem];
        [feed addObject:anItem];
    }
    
    [self.feedTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NewsCell"];
    [feedTable reloadData];
    
    [spinner stopAnimating];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Table Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feed count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return NEWS_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *scalesCellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scalesCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:scalesCellIdentifier];
    }
    // To keep the list refreshed when scrolling
    for(UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
    }
    
    NewsItem *thisItem = (NewsItem *)[feed objectAtIndex:indexPath.row];
    
    float fullWidth = tableView.frame.size.width;
    float padding = 5;
    float innerPadding = padding * 3;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, (cell.frame.size.width - (padding * 2)), (cell.frame.size.height - (padding * 2)))];
    background.image = [UIImage imageNamed:@"newsItemBackground.png"];
    background.alpha = 0.2;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(innerPadding, padding, (cell.frame.size.height - (padding * 2)), (cell.frame.size.height - (padding * 2)))];
    icon.image = thisItem.image;
    if( icon.image == nil ){
        icon.image = [UIImage imageNamed:@"newsAvatarDefault.png"];
    }
    icon.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( (icon.frame.origin.x + icon.frame.size.width + padding), padding, (fullWidth - icon.frame.size.width - 35), (cell.frame.size.height / 2))];
    titleLabel.text = (NSString *)[thisItem.title uppercaseString];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
    titleLabel.numberOfLines = 3;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height, titleLabel.frame.size.width, (cell.frame.size.height - titleLabel.frame.size.height - innerPadding))];
    NSString *detaggedMessge = (NSString *)[thisItem.message stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
    messageLabel.text = detaggedMessge;
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.textColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    messageLabel.numberOfLines = 5;
    
    /*
    UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectMake(fullWidth - 25, 0, 25, cell.frame.size.height)];
    chevron.image = [UIImage imageNamed:@"chevron_white_right.png"];
    chevron.contentMode = UIViewContentModeCenter;
    
    UIImageView *underline = [[UIImageView alloc] initWithFrame:CGRectMake(0, (cell.frame.size.height - 2), cell.frame.size.width, 2)];
    underline.backgroundColor = [UIColor whiteColor];
    */
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = myBackView;
    
    [cell.contentView addSubview:background];
    [cell.contentView addSubview:icon];
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:messageLabel];
    //[cell.contentView addSubview:chevron];
    //[cell.contentView addSubview:underline];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedItem = (NewsItem *)[feed objectAtIndex:indexPath.row];
    [self expandSelectedNewsItem];
    
}

- (void)expandSelectedNewsItem {
    
    selectedItemActivated = YES;
    float padding = 10;
    float innerPadding = 5;
    float xPosFinish = 0;
    float expandedNewsItemWidth = [UIScreen mainScreen].bounds.size.width;
    float titleLabelFontsize = 24.0;
    
    if( [Helper isiPad] ){
        xPosFinish = feedTable.frame.size.width;
        expandedNewsItemWidth -= xPosFinish;
        titleLabelFontsize = 30.0;
    }
    
    // Adjustment for iPhone X, XS, 11 Pro / XS Max, 11 Pro Max / XR, 11: prevents the view from appearing in the header titlebar
    float expandedNewsItemYOffset = [Helper adjustYShiftDownwards];
    
    expandedNewsItem = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, expandedNewsItemYOffset, expandedNewsItemWidth, [UIScreen mainScreen].bounds.size.height)];
    expandedNewsItem.backgroundColor = [UIColor clearColor];
    
    /*
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding, 50, 100)];
    [dismissButton addTarget:self action:@selector(dismissExpandedNewsItem) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    */
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(innerPadding, (padding * 6), expandedNewsItem.frame.size.width - (2 * innerPadding), expandedNewsItem.frame.size.height - (padding * 7))];
    backgroundImage.image = [UIImage imageNamed:@"newsItemExpandedBackground.png"];
    if( [Helper isiPad] ){
        backgroundImage.image = [UIImage imageNamed:@""];
        backgroundImage.backgroundColor = [UIColor colorWithRed:220 green:220 blue:220 alpha:0.8];
        backgroundImage.layer.cornerRadius = 5.0;
    }
    
    float messageImageWidth = backgroundImage.frame.size.width - (padding * 2);
    float messageImageHeight = messageImageWidth / 2.25;
    UIImageView *messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundImage.frame.origin.x + padding, backgroundImage.frame.origin.y + padding, messageImageWidth, messageImageHeight)];
    if( selectedItem.image == nil ){
        messageImage.image = [UIImage imageNamed:@"newsHeaderDefault.png"];
    }else{
        messageImage.image = selectedItem.image;
    }
    messageImage.contentMode = UIViewContentModeScaleToFill;
    
    UIButton *linkButton = [[UIButton alloc] initWithFrame:CGRectMake(messageImage.frame.origin.x, messageImage.frame.origin.y, messageImage.frame.size.width, messageImage.frame.size.height)];
    [linkButton addTarget:self action:@selector(showNewsItemLink) forControlEvents:UIControlEventTouchUpInside];
    [linkButton setTitle:[selectedItem.link absoluteString] forState:UIControlStateNormal];
    [linkButton setTitleColor:[Helper getColourFromString:@"Blue"] forState:UIControlStateNormal];
    linkButton.titleLabel.font = [UIFont systemFontOfSize:8];
    //linkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentTrailing;
    linkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( messageImage.frame.origin.x, (messageImage.frame.origin.y + messageImage.frame.size.height + innerPadding), messageImage.frame.size.width, 100)];
    titleLabel.text = (NSString *)[selectedItem.title uppercaseString];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [Helper getColourFromString:@"DoctotBlue"];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:titleLabelFontsize];
    titleLabel.numberOfLines = 3;
    
    WKWebView *messageContent = [[WKWebView alloc] initWithFrame:CGRectMake( titleLabel.frame.origin.x, (titleLabel.frame.origin.y + titleLabel.frame.size.height), titleLabel.frame.size.width, ( (backgroundImage.frame.origin.y + backgroundImage.frame.size.height) - (titleLabel.frame.origin.y + titleLabel.frame.size.height) - (padding * 2) ))];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *theBaseURL = [NSURL fileURLWithPath:path];
    NSString *htmlString = [NSString stringWithFormat:@"%@%@<BR>%@", [Helper getLocalisedString:@"HTMLStyle_BodyWithPadding" withScalePrefix:NO], [Helper getLocalisedString:@"HTMLStyle_ExtremelyLargeBlack" withScalePrefix:NO], selectedItem.message];
    [messageContent loadHTMLString:htmlString baseURL:theBaseURL];
    /*
    if( selectedItem.image != nil ){
        messageContent.frame = CGRectMake(messageContent.frame.origin.x, (messageImage.frame.origin.y + messageImage.frame.size.height), messageContent.frame.size.width, ( linkButton.frame.origin.y - (messageImage.frame.origin.y + messageImage.frame.size.height) ));
    }
    */
    [expandedNewsItem addSubview:backgroundImage];
    //[expandedNewsItem addSubview:dismissButton];
    [expandedNewsItem addSubview:messageImage];
    [expandedNewsItem addSubview:titleLabel];
    [expandedNewsItem addSubview:messageContent];
    if( selectedItem.link != nil ){
        [expandedNewsItem addSubview:linkButton];
    }
    
    [self.view addSubview:expandedNewsItem];
    
    // Animate the transition
    
    [UIView beginAnimations:@"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration:1.0];
    
    expandedNewsItem.frame = CGRectMake(xPosFinish, expandedNewsItem.frame.origin.y, [UIScreen mainScreen].bounds.size.width, expandedNewsItem.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void)showNewsItemLink {
    
    [[UIApplication sharedApplication] openURL:selectedItem.link options:@{} completionHandler:^(BOOL success){}];
    
}

- (void)dismissExpandedNewsItem {
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration:1.0];
    
    expandedNewsItem.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, expandedNewsItem.frame.origin.y, [UIScreen mainScreen].bounds.size.width, expandedNewsItem.frame.size.height);
    
    [UIView commitAnimations];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)dismiss {
    
    if( selectedItemActivated && ![Helper isiPad] ){
        selectedItemActivated = NO;
        [self dismissExpandedNewsItem];
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

