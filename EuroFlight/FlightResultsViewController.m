//
//  FlightResultsViewController.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightResultsViewController.h"
#import "FlightResultCell.h"
#import "FlightDetailViewController.h"
#import "FlightResultGroupCell.h"
#import "Trip.h"
#import "Context.h"
#import "FlightDetailsTransition.h"

NSString * const kFlightResultCellIdentifier = @"FlightResultCell";
NSString * const kFlightResultGroupCellIdentifier = @"FlightResultGroupCell";

@interface FlightResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Dictionary of array of trips grouped by price
@property (nonatomic, strong) NSDictionary *tripGroupings;
// Array of trip costs as keys into tripGroupings
@property (nonatomic, strong) NSArray *tripCosts;

@property (nonatomic, strong) NSMutableSet *expandedSections;

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) FlightDetailsTransition *transition;

@end

@implementation FlightResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupTitleLabel];

    self.tripGroupings = [self groupTrips];
    self.expandedSections = [[NSMutableSet alloc] init];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"FlightResultCell" bundle:nil] forCellReuseIdentifier:kFlightResultCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlightResultGroupCell" bundle:nil] forCellReuseIdentifier:kFlightResultGroupCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.transition = [[FlightDetailsTransition alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tripCosts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isExpanded = [self.expandedSections containsObject:@(section)];
    if (!isExpanded) {
        return 1;
    } else {
        return [self tripsForSection:section].count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL sectionExpanded = [self.expandedSections containsObject:@(indexPath.section)];
    if (sectionExpanded && indexPath.row > 0) {
        // cell is a flight result
        FlightResultCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kFlightResultCellIdentifier forIndexPath:indexPath];
        cell.trip = [self tripForIndexPath:indexPath];
        [self setupBordersForCell:cell];

        return cell;
    } else {
        // cell is a flight grouping
        FlightResultGroupCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kFlightResultGroupCellIdentifier forIndexPath:indexPath];
        cell.trips = [self tripsForSection:indexPath.section];
        [self setupBordersForCell:cell];

        return cell;
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL sectionExpanded = [self.expandedSections containsObject:@(indexPath.section)];
    if (sectionExpanded && indexPath.row > 0) {
        // selected cell is flight result
        FlightDetailViewController *vc = [[FlightDetailViewController alloc] init];
        vc.trip = [self tripForIndexPath:indexPath];

//        vc.modalPresentationStyle = UIModalPresentationCustom;
//        vc.transitioningDelegate = self.transition;
//
//        [self presentViewController:vc animated:YES completion:nil];

        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // selected cell is flight grouping
        FlightResultGroupCell *cell = (FlightResultGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setCollapsed:sectionExpanded];
        [self.tableView beginUpdates];
        if (sectionExpanded) {
            [self.expandedSections removeObject:@(indexPath.section)];
            [self collapseSubItemsInSection:indexPath.section];
        } else {
            [self.expandedSections addObject:@(indexPath.section)];
            [self expandSubItemsInSection:indexPath.section];
        }
        [self.tableView endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Private methods

static NSDateFormatter *dateFormatter;

- (void)setupTitleLabel {
    [FlightResultsViewController initDateFormatter];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"Verdana" size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0];

    Trip *trip = self.city.trips[0];
    NSString *roundTripText;
    NSString *dateText;
    if ([Context currentContext].isRoundTrip) {
        roundTripText = @"Round-trip";
        dateText = [NSString stringWithFormat:@"%@ - %@",
                    [dateFormatter stringFromDate:[Context currentContext].departureDate],
                    [dateFormatter stringFromDate:[Context currentContext].returnDate]];
    } else {
        roundTripText = @"One-way";
        dateText = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[Context currentContext].departureDate]];
    }
    label.text = [NSString stringWithFormat:@"%@ - %@ %@\n%@", [Context currentContext].originAirport,
                  trip.destinationAirportCode, roundTripText, dateText];

    self.navigationItem.titleView = label;
}

+ (void)initDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MMM d";
        }
    });
}

- (void)setupBordersForCell:(UITableViewCell *)cell {
    // change the default margin of the table divider length
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

- (void)collapseSubItemsInSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSArray *trips = [self tripsForSection:section];
    for (int i = 1; i <= trips.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)expandSubItemsInSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSArray *trips = [self tripsForSection:section];
    for (int i = 1; i <= trips.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (NSDictionary *)groupTrips {
    NSMutableDictionary *groupings = [NSMutableDictionary dictionary];

    for (Trip *trip in self.city.trips) {
        NSNumber *cost = @(trip.flightCost);
        NSMutableArray *arr;
        if (!groupings[cost]) {
            arr = [NSMutableArray array];
            groupings[cost] = arr;
        } else {
            arr = groupings[cost];
        }
        [arr addObject:trip];
    }

    self.tripCosts = [[groupings allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];

    return groupings;
}

- (Trip *)tripForIndexPath:(NSIndexPath *)indexPath {
    NSArray *trips = [self tripsForSection:indexPath.section];
    return trips[indexPath.row - 1];
}

- (NSArray *)tripsForSection:(NSInteger)section {
    NSNumber *tripCost = self.tripCosts[section];
    return self.tripGroupings[tripCost];
}

@end
