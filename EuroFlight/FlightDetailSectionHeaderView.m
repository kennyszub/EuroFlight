//
//  FlightDetailSectionHeaderView.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightDetailSectionHeaderView.h"

#define kMinutesInHour 60

@interface FlightDetailSectionHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *sourceAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopsAndDurationLabel;

@end

@implementation FlightDetailSectionHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    return [self initSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return [self initSubviews];
}

- (instancetype)initSubviews {
    UINib *nib = [UINib nibWithNibName:@"FlightDetailSectionHeaderView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = [self bounds];
    [self addSubview:self.contentView];
    return self;
}

static NSDateFormatter *formatter;

- (void)setFlight:(Flight *)flight {
    _flight = flight;
    self.sourceAirportLabel.text = flight.sourceAirportCode;
    self.destinationAirportLabel.text = flight.destinationAirportCode;
    if (!formatter) {
        [FlightDetailSectionHeaderView initFormatter];
    }
    self.dateLabel.text = [formatter stringFromDate:flight.departureDate];
    self.stopsAndDurationLabel.text = [self stopsAndDurationTextForFlight:flight];
}

+ (void)initFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE, M/d";
    });
}

- (NSString *)stopsAndDurationTextForFlight:(Flight *)flight {
    return [NSString stringWithFormat:@"%@, %@", [self stopsForFlight:flight], [self durationAsString:flight.totalDuration]];
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

- (NSString *)durationAsString:(NSInteger)duration {
    NSInteger numHours = duration / kMinutesInHour;
    NSInteger numMinutes = duration - (kMinutesInHour * numHours);

    return [NSString stringWithFormat:@"%ldh %ldm", numHours, numMinutes];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
