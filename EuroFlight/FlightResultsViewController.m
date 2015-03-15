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
#import "Trip.h"

NSString * const kFlightResultCellIdentifier = @"FlightResultCell";

@interface FlightResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tripsSorted;

@end

@implementation FlightResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = self.city.name;

    self.tripsSorted = [self sortTrips];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"FlightResultCell" bundle:nil] forCellReuseIdentifier:kFlightResultCellIdentifier];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tripsSorted.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlightResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kFlightResultCellIdentifier forIndexPath:indexPath];

    cell.trip = self.tripsSorted[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FlightDetailViewController *fdvc = [[FlightDetailViewController alloc] init];
    fdvc.trip = self.tripsSorted[indexPath.row];

    [self.navigationController pushViewController:fdvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Private methods

- (NSArray *)sortTrips {
    return [self.city.trips sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Trip *trip1 = (Trip *)obj1;
        Trip *trip2 = (Trip *)obj2;

        return [@(trip1.flightCost) compare:@(trip2.flightCost)];
    }];
}

@end
