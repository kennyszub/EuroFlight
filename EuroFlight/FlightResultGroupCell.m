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

@interface FlightResultGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *dropdownImageView;
@property (weak, nonatomic) IBOutlet UILabel *numFlightsLabel;
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
    self.airlineLabel.text = [self airlinesText:trips];
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

- (NSString *)airlinesText:(NSArray *)trips {
    NSString *airline = nil;
    for (Trip *trip in trips) {
        NSString *outboundAirline = [self singleAirlineForFlight:trip.outboundFlight];
        NSString *returnAirline = [self singleAirlineForFlight:trip.returnFlight];

        if (!outboundAirline || !returnAirline || ![outboundAirline isEqualToString:returnAirline]) {
            // outbound and return airlines are different
            return @"Multiple Airlines";
        }

        if (!airline) {
            airline = outboundAirline;
        } else if (![airline isEqualToString:outboundAirline]) {
            return @"Multiple Airlines";
        }
    }

    NameMappingHelper *helper = [NameMappingHelper sharedInstance];
    return [helper carrierNameForCode:airline];
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
