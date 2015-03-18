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

NSString * const kFlightResultCellIdentifier = @"FlightResultCell";
NSString * const kFlightResultGroupCellIdentifier = @"FlightResultGroupCell";

@interface FlightResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Dictionary of array of trips grouped by price
@property (nonatomic, strong) NSDictionary *tripGroupings;
// Array of trip costs as keys into tripGroupings
@property (nonatomic, strong) NSArray *tripCosts;

@property (nonatomic, strong) NSMutableSet *expandedSections;

@end

@implementation FlightResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = self.city.name;

    self.tripGroupings = [self groupTrips];
    self.expandedSections = [[NSMutableSet alloc] init];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"FlightResultCell" bundle:nil] forCellReuseIdentifier:kFlightResultCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FlightResultGroupCell" bundle:nil] forCellReuseIdentifier:kFlightResultGroupCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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
        [self.navigationController pushViewController:vc animated:YES];
        return;
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
