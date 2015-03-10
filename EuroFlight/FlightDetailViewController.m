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

@interface FlightDetailViewController ()

@property (weak, nonatomic) IBOutlet OneWayFlightDetailView *outboundFlightDetailView;
@property (weak, nonatomic) IBOutlet OneWayFlightDetailView *returnFlightDetailView;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

- (IBAction)onStartOverButton:(id)sender;
- (IBAction)onBuyButton:(id)sender;
- (IBAction)onTellAFriendButton:(id)sender;

@end

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
    self.costLabel.text = [NSString stringWithFormat:@"%@ %0.2f", self.trip.currencyType, self.trip.flightCost];
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
    // TODO
}

- (IBAction)onTellAFriendButton:(id)sender {
    // TODO
}

@end
