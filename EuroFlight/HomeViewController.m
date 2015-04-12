//
//  HomeViewController.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "HomeViewController.h"
#import "ResultsViewController.h"
#import "THDatePickerViewController.h"
#import "Country.h"
#import "PlacesClient.h"
#import "KimonoClient.h"
#import "Event.h"
#import "AirportSearchResultsControllerViewController.h"
#import "Context.h"
#import "LocationManager.h"
#import "AirportClient.h"
#import "DepartureCityCell.h"
#import "DateSelectionCell.h"
#import "OneWayRoundTripCell.h"
#import "UIImage+Util.h"
#import "PlaneLoadingView.h"
#import "NavigationControllerDelegate.h"

#define ENABLE_LOADING_VIEW 0
#define LOADING_VIEW_DURATION 5

@interface HomeViewController () <THDatePickerDelegate, UITextFieldDelegate, AirportSearchResultsControllerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, OneWayRoundTripCellDelegate>
@property (nonatomic, strong) THDatePickerViewController *outboundDatePicker;
@property (nonatomic, strong) THDatePickerViewController *returnDatePicker;
@property (nonatomic, strong) NSDate *outboundDate;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (strong, nonatomic)  UILabel *dateErrorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isRoundTrip;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) ResultsViewController *rvc;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) NavigationControllerDelegate *navigationDelegate;

enum Weeks {
    SUNDAY = 1,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
};

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //this is kind of a hack, but whatever (kimono stuff needs to be initialized before Cities are created)
    [KimonoClient sharedInstance];
    
    self.outboundDate = [self getNextWeekdayDate:FRIDAY];
    [Context currentContext].departureDate = self.outboundDate;
    
    self.returnDate = [self dateByAddingDaystoDate:self.outboundDate days:2];
    [Context currentContext].returnDate = self.returnDate;
    [Context currentContext].isRoundTrip = YES;
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"EEE MMM d, y"];
    
    self.title = @"EuroFlight";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    // set up table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DepartureCityCell" bundle:nil] forCellReuseIdentifier:@"DepartureCityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DateSelectionCell" bundle:nil] forCellReuseIdentifier:@"DateSelectionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OneWayRoundTripCell" bundle:nil] forCellReuseIdentifier:@"OneWayRoundTripCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.isRoundTrip = YES;
    
    // set background picture
    UIImageView *budapestView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"budapestCropped"]];
    [self.view addSubview:budapestView];
    [budapestView.superview sendSubviewToBack:budapestView];
    self.backgroundImage = budapestView;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self addSearchButton];

    self.navigationDelegate = [[NavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navigationDelegate; // this tells the navigation controller to check the navigationDelegate for custom transitions - returns nil otherwise which does a standard transition
    self.navigationDelegate.navController = self.navigationController;
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.backgroundImage setFrame:self.view.bounds];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    self.searchButton.hidden = NO;
    self.tableView.hidden = NO;
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self addErrorLabel]; // TODO this is resulting in an error label getting created every time viewWillAppear is called
    
    // set frame of search button
    CGFloat frameWidth = self.view.bounds.size.width;
    self.searchButton.frame = CGRectMake((frameWidth - (frameWidth - 20)) / 2.0, self.view.bounds.size.height - 60, frameWidth - 20, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)airportSearchResultsControllerViewController:(AirportSearchResultsControllerViewController *)airportsController didSelectAirport:(Airport *)airport {
    DepartureCityCell *cell = (DepartureCityCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.airport = airport;
}

- (void)addSearchButton {
    UIButton *button = [[UIButton alloc] init];
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    [button setTitle: @"Search Flights" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:0.5]] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(onSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    self.searchButton = button;
}

- (void)addErrorLabel {
    CGFloat frameWidth = self.view.frame.size.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, frameWidth, 20)];
    label.text = @"Select a departure date prior to the return date";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    self.dateErrorLabel = label;
}

- (void)onSearchButton {
    if ([self.outboundDate compare:self.returnDate] == NSOrderedDescending) {
        [self.view addSubview:self.dateErrorLabel];
        self.dateErrorLabel.hidden = NO;
    } else {
        self.dateErrorLabel.hidden = YES;

        if (ENABLE_LOADING_VIEW) {
            // show the loading HUD
            PlaneLoadingView *hud = [[PlaneLoadingView alloc] init];
            [self.view addSubview:hud];
            [hud show:YES];

//            self.rvc = [[ResultsViewController alloc] initWithResults];
//            [NSTimer scheduledTimerWithTimeInterval:LOADING_VIEW_DURATION target:self selector:@selector(hideHud:) userInfo:hud repeats:NO];
            [Country initFlightsWithCompletion:^{
                [hud hide:YES];
                self.rvc = [[ResultsViewController alloc] initWithResults];
                [self.navigationController pushViewController:self.rvc animated:YES];
            }];

            [self fadeOutTableView];
        } else {
            ResultsViewController *rvc = [[ResultsViewController alloc] initWithResults];
            [self.navigationController pushViewController:rvc animated:YES];
        }
    }
}

- (void)hideHud:(NSTimer *)timer {
    PlaneLoadingView *hud = timer.userInfo;
    [hud hide:YES];

    [self.navigationController pushViewController:self.rvc animated:YES];
}

- (void)oneWayRoundTripCellDelegate:(OneWayRoundTripCell *)cell didSelectRoundTrip:(BOOL)isRoundTrip {
    self.isRoundTrip = isRoundTrip;
    [Context currentContext].isRoundTrip = isRoundTrip;
    if (isRoundTrip) {
        [self.tableView beginUpdates];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:3 inSection:0]];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:3 inSection:0]];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)fadeOutTableView {
    [UIView transitionWithView:self.tableView
                      duration:1.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [UIView transitionWithView:self.searchButton
                      duration:1.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.tableView.hidden = YES;
    self.searchButton.hidden = YES;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DepartureCityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DepartureCityCell"];
        cell.separatorInset = UIEdgeInsetsMake(0.f, self.view.frame.size.width, 0.f, 0.f);
        return cell;

    } else if (indexPath.row == 1) {
        OneWayRoundTripCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OneWayRoundTripCell"];
        cell.delegate = self;
        cell.separatorInset = UIEdgeInsetsMake(0.f, self.view.frame.size.width, 0.f, 0.f);
        return cell;
    } else if (indexPath.row == 2) {
        DateSelectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DateSelectionCell"];
        cell.isDeparting = YES;
        cell.dateString = [self.formatter stringFromDate:self.outboundDate];
        return cell;
    } else {
        DateSelectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DateSelectionCell"];
        cell.isDeparting = NO;
        cell.dateString = [self.formatter stringFromDate:self.returnDate];

        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isRoundTrip) {
        return 4;
    } else {
        return 3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        AirportSearchResultsControllerViewController *avc = [[AirportSearchResultsControllerViewController alloc] init];
        avc.delegate = self;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:avc];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
    } else if (indexPath.row == 2) {
        self.dateErrorLabel.hidden = YES;
        if (!self.outboundDatePicker) {
            self.outboundDatePicker = [THDatePickerViewController datePicker];
        }
        [self configureDatePicker:self.outboundDatePicker];
        [self presentSemiViewController:self.outboundDatePicker withOptions:@{
                                                                              KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                              KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                              }];
    } else if (indexPath.row == 3) {
        self.dateErrorLabel.hidden = YES;
        if (!self.returnDatePicker) {
            self.returnDatePicker = [THDatePickerViewController datePicker];
        }
        [self configureDatePicker:self.returnDatePicker];
        [self presentSemiViewController:self.returnDatePicker withOptions:@{
                                                                            KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                            KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                                            KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                            }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 70;
    }
    return UITableViewAutomaticDimension;
}


#pragma mark Date picker methods
- (void)refreshDates {
    DateSelectionCell *departCell = (DateSelectionCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    DateSelectionCell *returnCell = (DateSelectionCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];

    departCell.dateString = [self.formatter stringFromDate:self.outboundDate];
    returnCell.dateString = [self.formatter stringFromDate:self.returnDate];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    if (datePicker == self.outboundDatePicker) {
        self.outboundDate = datePicker.date;
        [Context currentContext].departureDate = self.outboundDate;
    } else if (datePicker == self.returnDatePicker) {
        self.returnDate = datePicker.date;
        [Context currentContext].returnDate = self.returnDate;
    }
    [self refreshDates];
    [self dismissSemiModalView];
}

- (void)configureDatePicker:(THDatePickerViewController *)datePicker {
    if (datePicker == self.outboundDatePicker) {
        datePicker.date = self.outboundDate;
    } else if (datePicker == self.returnDatePicker) {
        datePicker.date = self.returnDate;
    }
    datePicker.delegate = self;
    [datePicker setAllowClearDate:NO];
    [datePicker setClearAsToday:YES];
    [datePicker setAutoCloseOnSelectDate:YES];
    [datePicker setAllowSelectionOfSelectedDate:YES];
    [datePicker setDisableHistorySelection:YES];
    [datePicker setDisableFutureSelection:NO];
    [datePicker setSelectedBackgroundColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]];
    [datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker setCurrentDateColorSelected:[UIColor redColor]];    
    [datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        return NO;
    }];
}

- (NSDate *)getNextWeekdayDate:(enum Weeks)weekday {
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger todayWeekday = [weekdayComponents weekday];
    
    NSInteger moveDays = weekday - todayWeekday;
    if (moveDays <= 0) {
        moveDays += 7;
    }
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = moveDays;
    
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate* newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    return newDate;
}

- (NSDate *)dateByAddingDaystoDate:(NSDate *)date days:(NSInteger)days {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *nextDate = [cal dateByAddingComponents:dayComponent toDate:date options:0];
    
    return nextDate;
}

- (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
