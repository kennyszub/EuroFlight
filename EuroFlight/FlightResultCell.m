//
//  FlightResultCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightResultCell.h"
#import "CurrencyFormatter.h"

@interface FlightResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *outboundFlightLabel;
@property (weak, nonatomic) IBOutlet UILabel *outboundFlightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outboundFlightStopsLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnFlightLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnFlightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnFlightStopsLabel;
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

static NSDateFormatter *dateTimeFormatter;

- (void)setTrip:(Trip *)trip {
    _trip = trip;
    
    if (!dateTimeFormatter) {
        [FlightResultCell initDateTimeFormatter];
    }
    
    self.outboundFlightLabel.text = [NSString stringWithFormat:@"%@ -> %@", trip.sourceAirportCode, trip.destinationAirportCode];
    self.returnFlightLabel.text = [NSString stringWithFormat:@"%@ -> %@", trip.destinationAirportCode, trip.sourceAirportCode];

    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:trip.currencyType];
    self.priceLabel.text = [formatter stringFromNumber:@(trip.flightCost)];
    
    self.outboundFlightTimeLabel.text = [dateTimeFormatter stringFromDate:trip.outboundFlight.departureDate];
    self.returnFlightTimeLabel.text = [dateTimeFormatter stringFromDate:trip.returnFlight.departureDate];

    self.outboundFlightStopsLabel.text = [self stopsForFlight:trip.outboundFlight];
    self.returnFlightStopsLabel.text = [self stopsForFlight:trip.returnFlight];
}

+ (void)initDateTimeFormatter {
    dateTimeFormatter = [[NSDateFormatter alloc] init];
    dateTimeFormatter.dateFormat = @"M/d/yy h:mm a";
}

- (NSString *)stopsForFlight:(Flight *)flight {
    NSInteger numSegments = flight.flightSegments.count;
    if (numSegments <= 1) {
        return @"Nonstop";
    } else if (numSegments == 2) {
        return @"1 stop";
    } else {
        return [NSString stringWithFormat:@"%ld stops", numSegments - 1];
    }
}

@end
