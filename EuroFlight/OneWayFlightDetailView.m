//
//  OneWayFlightDetailView.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/8/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "OneWayFlightDetailView.h"
#import "FlightSegment.h"
#import "NameMappingHelper.h"

#define kMinutesInHour 60

@interface OneWayFlightDetailView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *airportsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopsLabel;

@end

@implementation OneWayFlightDetailView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return [self initSubviews];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return [self initSubviews];
}

- (id)initSubviews {
    UINib *nib = [UINib nibWithNibName:@"OneWayFlightDetailView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = [self bounds];
    [self addSubview:self.contentView];
    return self;
}

static NSDateFormatter *dateFormatter;
static NSDateFormatter *timeFormatter;

- (void)setFlight:(Flight *)flight {
    _flight = flight;
    
    if (!dateFormatter) {
        [OneWayFlightDetailView initDateFormatter];
    }
    if (!timeFormatter) {
        [OneWayFlightDetailView initTimeFormatter];
    }

    self.airportsLabel.text = [NSString stringWithFormat:@"%@ -> %@", [self formatAirportStringForCode:flight.sourceAirportCode], [self formatAirportStringForCode:flight.destinationAirportCode]];
    self.dateLabel.text = [dateFormatter stringFromDate:flight.departureDate];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [timeFormatter stringFromDate:flight.departureDate], [timeFormatter stringFromDate:flight.arrivalDate]];
    FlightSegment *segment = flight.flightSegments[0];
    self.flightNumberLabel.text = [NSString stringWithFormat:@"%@ %@", segment.airline, segment.flightNumber];
    self.durationLabel.text = [self durationAsString:flight.totalDuration];
    self.stopsLabel.text = [self formatStopsLabelText];
}

- (NSString *)durationAsString:(NSTimeInterval)duration {
    NSInteger numHours = duration / kMinutesInHour;
    NSInteger numMinutes = duration - (kMinutesInHour * numHours);
    
    return [NSString stringWithFormat:@"%ld hr %ld min", numHours, numMinutes];
}

- (NSString *)formatAirportStringForCode:(NSString *)code {
    NameMappingHelper *mappingHelper = [NameMappingHelper sharedInstance];
    return [NSString stringWithFormat:@"%@ (%@)", [mappingHelper cityNameForAirportCode:code], code];
}

- (NSString *)formatStopsLabelText {
    NSInteger numSegments = self.flight.flightSegments.count;
    if (numSegments <= 1) {
        return @"Nonstop";
    } else if (numSegments == 2) {
        FlightSegment *segment = self.flight.flightSegments[0];
        return [NSString stringWithFormat:@"1 stop (%@ in %@)", [self durationAsString:segment.connectionDuration], segment.destinationAirportCode];
    } else {
        NSArray *layoverSegments = [self.flight.flightSegments subarrayWithRange:NSMakeRange(0, self.flight.flightSegments.count - 1)];
        NSArray *allStops = [layoverSegments valueForKeyPath:@"@unionOfObjects.destinationAirportCode"];

        return [NSString stringWithFormat:@"%ld stops (%@)", numSegments - 1, [allStops componentsJoinedByString:@", "]];
    }
}

+ (void)initDateFormatter {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE M/d/yy";
}

+ (void)initTimeFormatter {
    timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"h:mm a";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
