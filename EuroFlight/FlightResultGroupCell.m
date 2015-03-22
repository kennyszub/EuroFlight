//
//  FlightResultGroupCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightResultGroupCell.h"
#import "Trip.h"
#import "FlightSegment.h"
#import "CurrencyFormatter.h"
#import "NameMappingHelper.h"
#import "GoogleSearchClient.h"
#import <UIImageView+AFNetworking.h>

@interface FlightResultGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *dropdownImageView;
@property (weak, nonatomic) IBOutlet UILabel *numFlightsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *airlineLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *airlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation FlightResultGroupCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTrips:(NSArray *)trips {
    _trips = trips;
    Trip *firstTrip = (Trip *)trips[0];

    self.dropdownImageView.image = [UIImage imageNamed:@"right-dropdown"];
    self.numFlightsLabel.text = [self numFlightsText:trips.count];
    [self setupAirlinesForTrips:trips];
    NSNumberFormatter *currencyFormatter = [CurrencyFormatter formatterWithCurrencyCode:firstTrip.currencyType];
    self.costLabel.text = [currencyFormatter stringFromNumber:@(firstTrip.flightCost)];
}

- (NSString *)numFlightsText:(NSInteger)count {
    if (count <= 1) {
        return @"1 Flight";
    } else {
        return [NSString stringWithFormat:@"%ld Flights", count];
    }
}

- (void)setupAirlinesForTrips:(NSArray *)trips {
    NSString *airline = nil;
    for (Trip *trip in trips) {
        NSString *outboundAirline = [self singleAirlineForFlight:trip.outboundFlight];
        NSString *returnAirline = [self singleAirlineForFlight:trip.returnFlight];

        if (!outboundAirline || !returnAirline || ![outboundAirline isEqualToString:returnAirline]) {
            // outbound and return airlines are different
            self.airlineLabel.text = @"Multiple Airlines";
            self.airlineLogoImageView.image = [UIImage imageNamed:@"plane-logo-default"];
            return;
        }

        if (!airline) {
            airline = outboundAirline;
        } else if (![airline isEqualToString:outboundAirline]) {
            self.airlineLabel.text = @"Multiple Airlines";
            self.airlineLogoImageView.image = [UIImage imageNamed:@"plane-logo-default"];
            return;
        }
    }

    NameMappingHelper *helper = [NameMappingHelper sharedInstance];
    NSString *carrierName = [helper carrierNameForCode:airline];
    self.airlineLabel.text = carrierName;

    // grab a flight segment and use the logo
    Flight *flight = ((Trip *)trips[0]).outboundFlight;
    FlightSegment *segment = flight.flightSegments[0];
    [self.airlineLogoImageView setImageWithURL:[NSURL URLWithString:segment.airlineImageURL]];
}

// if a flight uses a single airline, return the airline
// otherwise return nil
- (NSString *)singleAirlineForFlight:(Flight *)flight {
    NSString *airline = nil;
    for (FlightSegment *segment in flight.flightSegments) {
        if (!airline) {
            airline = segment.airline;
        } else {
            if (![airline isEqualToString:segment.airline]) {
                return nil;
            }
        }
    }

    return airline;
}

- (void)setCollapsed:(BOOL)collapsed {
    [UIView animateWithDuration:0.3 animations:^{
        if (collapsed) {
            // collapsed, should become right arrow
            self.dropdownImageView.transform = CGAffineTransformIdentity;
        } else {
            // not collapsed, should become down arrow
            self.dropdownImageView.transform = CGAffineTransformMakeRotation(90 * M_PI / 180.);
        }
    }];
}

@end
