//
//  FlightResultGroupCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightResultGroupCell.h"
#import "Trip.h"
#import "CurrencyFormatter.h"

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
    self.numFlightsLabel.text = [NSString stringWithFormat:@"%ld Flights", trips.count];
    self.airlineLabel.text = @"Multiple Airlines";
    NSNumberFormatter *currencyFormatter = [CurrencyFormatter formatterWithCurrencyCode:firstTrip.currencyType];
    self.costLabel.text = [currencyFormatter stringFromNumber:@(firstTrip.flightCost)];
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
