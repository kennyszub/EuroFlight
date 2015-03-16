//
//  FlightDetailViewController.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightDetailViewController.h"
#import "OneWayFlightDetailView.h"
#import "HomeViewController.h"
#import "CurrencyFormatter.h"
#import "FlightSegment.h"
#import "BuyFlightViewController.h"
#import "LayoverDetailCell.h"
#import "SegmentDetailCell.h"
#import "FlightDetailSectionHeaderView.h"
#import <WebKit/WebKit.h>

@interface FlightDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onStartOverButton:(id)sender;
- (IBAction)onBuyButton:(id)sender;
- (IBAction)onTellAFriendButton:(id)sender;

@end

NSString * const kKayakBaseURL = @"http://www.kayak.com/flights";
NSString * const kSegmentDetailCellIdentifier = @"SegmentDetailCell";
NSString * const kLayoverDetailCellIdentifier = @"LayoverDetailCell";

@implementation FlightDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"Flight Details";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentDetailCell" bundle:nil] forCellReuseIdentifier:kSegmentDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LayoverDetailCell" bundle:nil] forCellReuseIdentifier:kLayoverDetailCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self numCellsForFlight:self.trip.outboundFlight];
        case 1:
            return [self numCellsForFlight:self.trip.returnFlight];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        // segment cell
        SegmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kSegmentDetailCellIdentifier forIndexPath:indexPath];
        cell.segment = [self segmentForIndexPath:indexPath];

        return cell;
    } else {
        // layover cell
        LayoverDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kLayoverDetailCellIdentifier forIndexPath:indexPath];
        cell.segment = [self segmentForIndexPath:indexPath];

        return cell;
    }
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return 100;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 106;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FlightDetailSectionHeaderView *view = [[FlightDetailSectionHeaderView alloc] init];
    if (section == 0) {
        view.flight = self.trip.outboundFlight;
    } else {
        view.flight = self.trip.returnFlight;
    }

    return view;
}

#pragma mark - Private methods

- (NSInteger)numCellsForFlight:(Flight *)flight {
    return 1 + 2 * (flight.flightSegments.count - 1);
}

- (FlightSegment *)segmentForIndexPath:(NSIndexPath *)indexPath {
    Flight *flight;
    if (indexPath.section == 0) {
        flight = self.trip.outboundFlight;
    } else {
        flight = self.trip.returnFlight;
    }

    return flight.flightSegments[indexPath.row / 2];
}

- (IBAction)onStartOverButton:(id)sender {
    HomeViewController *hvc = [[HomeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:hvc];

    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onBuyButton:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"y-MM-dd";

    NSString *sourceAirport = self.trip.sourceAirportCode;
    NSString *destinationAirport = self.trip.destinationAirportCode;
    NSString *departureDate = [formatter stringFromDate:((FlightSegment *)self.trip.outboundFlight.flightSegments[0]).departureDate ];
    NSString *returnDate = [formatter stringFromDate:((FlightSegment *)self.trip.returnFlight.flightSegments[0]).departureDate];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@-%@/%@/%@", kKayakBaseURL, sourceAirport, destinationAirport, departureDate, returnDate];

    BuyFlightViewController *bfvc = [[BuyFlightViewController alloc] init];
    bfvc.url = urlString;

    [self.navigationController pushViewController:bfvc animated:YES];
}

- (IBAction)onTellAFriendButton:(id)sender {
    // TODO
}

@end
