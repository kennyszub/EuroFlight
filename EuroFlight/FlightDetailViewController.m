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
#import <WebKit/WebKit.h>

@interface FlightDetailViewController ()

@property (weak, nonatomic) IBOutlet OneWayFlightDetailView *outboundFlightDetailView;
@property (weak, nonatomic) IBOutlet OneWayFlightDetailView *returnFlightDetailView;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction)onStartOverButton:(id)sender;
- (IBAction)onBuyButton:(id)sender;
- (IBAction)onTellAFriendButton:(id)sender;

@end

NSString * const kKayakBaseURL = @"http://www.kayak.com/flights";

@implementation FlightDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    id topGuide = self.topLayoutGuide;
    UIView *outboundFlightDetailView = self.outboundFlightDetailView;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(outboundFlightDetailView, topGuide);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-8-[outboundFlightDetailView]" options:0 metrics:nil views:viewsDictionary]];
    
    self.outboundFlightDetailView.flight = self.trip.outboundFlight;
    self.returnFlightDetailView.flight = self.trip.returnFlight;
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:self.trip.currencyType];
    self.costLabel.text = [formatter stringFromNumber:@(self.trip.flightCost)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
