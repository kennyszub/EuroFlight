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
#import "Context.h"

@interface FlightResultCell ()

@property (weak, nonatomic) IBOutlet OneWayFlightResultView *outboundFlightView;
@property (weak, nonatomic) IBOutlet OneWayFlightResultView *returnFlightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnFlightViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outboundFlightBottomConstraint;

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

    if ([Context currentContext].isRoundTrip) {
        self.returnFlightView.flight = trip.returnFlight;
        self.returnFlightView.isOutboundFlight = NO;
        self.returnFlightViewHeightConstraint.constant = 20;
        self.outboundFlightBottomConstraint.constant = 8;
        self.returnFlightView.hidden = NO;
    } else {
        self.returnFlightViewHeightConstraint.constant = 0;
        self.outboundFlightBottomConstraint.constant = 0;
        self.returnFlightView.hidden = YES;
    }
}

@end
