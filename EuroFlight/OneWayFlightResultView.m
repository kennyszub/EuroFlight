//
//  OneWayFlightResultView.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/13/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "OneWayFlightResultView.h"
#import "Context.h"

#define kMinutesInHour 60

@interface OneWayFlightResultView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numStopsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end

@implementation OneWayFlightResultView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    return [self initSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return [self initSubviews];
}

- (instancetype)initSubviews {
    UINib *nib = [UINib nibWithNibName:@"OneWayFlightResultView" bundle:nil];
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
        [OneWayFlightResultView initDateFormatter];
    }

    if (!timeFormatter) {
        [OneWayFlightResultView initTimeFormatter];
    }

    self.dateLabel.text = [dateFormatter stringFromDate:flight.departureDate];
    self.sourceAirportLabel.text = flight.sourceAirportCode;
    self.departureTimeLabel.text = [timeFormatter stringFromDate:flight.departureDate];
    self.destinationAirportLabel.text = flight.destinationAirportCode;
    self.arrivalTimeLabel.text = [timeFormatter stringFromDate:flight.arrivalDate];
    self.flightTimeLabel.text = [self getTotalDurationString:flight.totalDuration];
    self.numStopsLabel.text = [self stopsForFlight:flight];
}

- (void)setIsOutboundFlight:(BOOL)isOutboundFlight {
    if (isOutboundFlight) {
        self.arrowImage.image = [UIImage imageNamed:@"plane-takeoff"];
    } else {
        self.arrowImage.image = [UIImage imageNamed:@"plane-landing"];
    }
}

+ (void)initDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"M/d";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:[Context currentContext].timeZone];
        }
    });
}

+ (void)initTimeFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!timeFormatter) {
            timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"h:mm a";
            timeFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:[Context currentContext].timeZone];
        }
    });
}

// round up to the nearest half hour
- (NSString *)getTotalDurationString:(NSInteger)duration {
    NSInteger hours = duration / kMinutesInHour;
    NSInteger minutes = duration - (hours * kMinutesInHour);

    if (minutes == 0) {
        return [NSString stringWithFormat:@"%ld.0h", hours];
    } else if (minutes <= 30) {
        return [NSString stringWithFormat:@"%ld.5h", hours];
    } else {
        return [NSString stringWithFormat:@"%ld.0h", hours + 1];
    }
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
