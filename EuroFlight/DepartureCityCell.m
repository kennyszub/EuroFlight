//
//  DepartureCityCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "DepartureCityCell.h"
#import "LocationManager.h"
#import "AirportClient.h"

@interface DepartureCityCell ()
@property (weak, nonatomic) IBOutlet UILabel *airportCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityCountryLabel;

@end

@implementation DepartureCityCell

- (void)awakeFromNib {
    // Initialization code
    [self setUpAirport];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpAirport {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[LocationManager sharedInstance] getCurrentLocationWithCompletion:^(CLLocation *location) {
            [[AirportClient sharedInstance] searchAirportByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude completion:^(NSMutableArray *airports, NSError *error) {
                if (airports.count > 0) {
                    Airport *airport = airports[0];
                    self.airport = airport;
                } else {
                    [self setDefaultAirportInfo];
                }
            }];
        }];
    } else {
        [self setDefaultAirportInfo];
    }
}

- (void)setAirport:(Airport *)airport {
    _airport = airport;
    self.airportCodeLabel.text = self.airport.code;
    self.airportNameLabel.text = self.airport.name;
    self.cityCountryLabel.text = [NSString stringWithFormat:@"%@, %@", self.airport.city, self.airport.country];
}

- (void)setDefaultAirportInfo {
    self.airportCodeLabel.text = @"LHR";
    self.airportNameLabel.text = @"London Heathrow Airport";
    self.cityCountryLabel.text = @"London, United Kingdom";
}

@end
