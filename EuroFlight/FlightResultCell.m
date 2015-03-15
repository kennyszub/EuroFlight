//
//  FlightResultCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightResultCell.h"
#import "CurrencyFormatter.h"
#import "OneWayFlightResultView.h"

@interface FlightResultCell ()

@property (weak, nonatomic) IBOutlet OneWayFlightResultView *outboundFlightView;
@property (weak, nonatomic) IBOutlet OneWayFlightResultView *returnFlightView;

@end

@implementation FlightResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static NSDateFormatter *dateTimeFormatter;

- (void)setTrip:(Trip *)trip {
    _trip = trip;

    self.outboundFlightView.flight = trip.outboundFlight;
    self.outboundFlightView.isOutboundFlight = YES;
    self.returnFlightView.flight = trip.returnFlight;
    self.returnFlightView.isOutboundFlight = NO;
}

@end
