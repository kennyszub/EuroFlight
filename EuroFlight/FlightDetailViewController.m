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
#import "ZoomTransition.h"
#import "Context.h"

@interface FlightDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)onStartOverButton:(id)sender;
- (IBAction)onBuyButton:(id)sender;
- (IBAction)onTellAFriendButton:(id)sender;

@property (nonatomic, strong) ZoomTransition *transition;

@end

NSString * const kKayakBaseURL = @"http://www.kayak.com/flights";
NSString * const kSegmentDetailCellIdentifier = @"SegmentDetailCell";
NSString * const kLayoverDetailCellIdentifier = @"LayoverDetailCell";

@implementation FlightDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupTitleLabel];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentDetailCell" bundle:nil] forCellReuseIdentifier:kSegmentDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LayoverDetailCell" bundle:nil] forCellReuseIdentifier:kLayoverDetailCellIdentifier];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.transition = [[ZoomTransition alloc] init];
    self.transition.xScale = 1;
    self.transition.yScale = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupBuyButton];
}

- (void)setupBuyButton {
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:self.trip.currencyType];
    [self.buyButton setTitle:[NSString stringWithFormat:@"Buy now for %@", [formatter stringFromNumber:@(self.trip.flightCost)]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([Context currentContext].isRoundTrip) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        // segment cell
        SegmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kSegmentDetailCellIdentifier forIndexPath:indexPath];
        cell.segment = [self segmentForIndexPath:indexPath];
        cell.showTriangleView = indexPath.row > 0;
        cell.nextCellWillShowTriangleView = indexPath.row < [self numberOfRowsInSection:indexPath.section] - 1;
        [self setupBordersForCell:cell];

        return cell;
    } else {
        // layover cell
        LayoverDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kLayoverDetailCellIdentifier forIndexPath:indexPath];
        cell.segment = [self segmentForIndexPath:indexPath];
        [self setupBordersForCell:cell];

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

static NSDateFormatter *dateFormatter;

- (void)setupTitleLabel {
    [FlightDetailViewController initDateFormatter];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"Verdana" size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0];

    NSString *roundTripText;
    NSString *dateText;
    if ([Context currentContext].isRoundTrip) {
        roundTripText = @"Round-trip";
        dateText = [NSString stringWithFormat:@"%@ - %@",
                    [dateFormatter stringFromDate:self.trip.outboundFlight.departureDate],
                    [dateFormatter stringFromDate:self.trip.returnFlight.departureDate]];
    } else {
        roundTripText = @"One-way";
        dateText = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.trip.outboundFlight.departureDate]];
    }
    label.text = [NSString stringWithFormat:@"%@ - %@ %@\n%@", self.trip.sourceAirportCode,
                  self.trip.destinationAirportCode, roundTripText, dateText];

    self.navigationItem.titleView = label;
}

+ (void)initDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MMM d";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:[Context currentContext].timeZone];
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

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self numCellsForFlight:self.trip.outboundFlight];
        case 1:
            return [self numCellsForFlight:self.trip.returnFlight];
        default:
            return 0;
    }
}

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
    NSString *urlString;
    if (self.trip.bookingURL) {
        urlString = self.trip.bookingURL;
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y-MM-dd";

        NSString *sourceAirport = self.trip.sourceAirportCode;
        NSString *destinationAirport = self.trip.destinationAirportCode;
        NSString *departureDate = [formatter stringFromDate:((FlightSegment *)self.trip.outboundFlight.flightSegments[0]).departureDate];
        NSString *returnDate = [formatter stringFromDate:((FlightSegment *)self.trip.returnFlight.flightSegments[0]).departureDate];
        urlString = [NSString stringWithFormat:@"%@/%@-%@/%@/%@", kKayakBaseURL, sourceAirport, destinationAirport, departureDate, returnDate];
    }

    BuyFlightViewController *bfvc = [[BuyFlightViewController alloc] init];
    bfvc.url = urlString;

    bfvc.modalTransitionStyle = UIModalPresentationCustom;
    bfvc.transitioningDelegate = self.transition;

    [self presentViewController:bfvc animated:YES completion:nil];
}

- (IBAction)onTellAFriendButton:(id)sender {
    // TODO
}

@end
