//
//  FlightResultCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightResultCell.h"

@interface FlightResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *outboundFlightLabel;
@property (weak, nonatomic) IBOutlet UILabel *outboundFlightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnFlightLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnFlightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation FlightResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTrip:(Trip *)trip {
    _trip = trip;
    
    self.outboundFlightLabel.text = [NSString stringWithFormat:@"%@ -> %@", trip.sourceAirportCode, trip.destinationAirportCode];
    self.returnFlightLabel.text = [NSString stringWithFormat:@"%@ -> %@", trip.destinationAirportCode, trip.sourceAirportCode];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %0.2f", trip.currencyType, trip.flightCost];
    
    // TODO cache the formatter so we don't keep initializing them
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d/yy, h:mm a";
    
    self.outboundFlightTimeLabel.text = [formatter stringFromDate:trip.outboundFlight.departureDate];
    self.returnFlightTimeLabel.text = [formatter stringFromDate:trip.returnFlight.departureDate];
}

@end
