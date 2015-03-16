//
//  SegmentDetailCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "SegmentDetailCell.h"
#import "NameMappingHelper.h"
#import <UIImageView+AFNetworking.h>

#define kMinutesInHour 60

@interface SegmentDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *airlineLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *airlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFlightDurationLabel;

@end

@implementation SegmentDetailCell

- (void)awakeFromNib {
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static NSDateFormatter *timeFormatter;

- (void)setSegment:(FlightSegment *)segment {
    _segment = segment;

    [self.airlineLogoImageView setImageWithURL:[NSURL URLWithString:segment.airlineImageURL]];

    NameMappingHelper *helper = [NameMappingHelper sharedInstance];
    self.airlineLabel.text = [helper carrierNameForCode:segment.airline];
    self.flightNumberLabel.text = segment.flightNumber;

    [SegmentDetailCell initTimeFormatter];
    self.departureTimeLabel.text = [timeFormatter stringFromDate:segment.departureDate];
    self.arrivalTimeLabel.text = [timeFormatter stringFromDate:segment.arrivalDate];

    self.departureCityLabel.text = [helper cityNameForAirportCode:segment.sourceAirportCode];
    self.arrivalCityLabel.text = [helper cityNameForAirportCode:segment.destinationAirportCode];

    self.totalFlightDurationLabel.text = [self durationAsString:segment.duration];
}

- (NSString *)durationAsString:(NSInteger)duration {
    NSInteger numHours = duration / kMinutesInHour;
    NSInteger numMinutes = duration - (kMinutesInHour * numHours);

    return [NSString stringWithFormat:@"%ld hr %ld min", numHours, numMinutes];
}

+ (void)initTimeFormatter {
    if (!timeFormatter) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"H:mm a";
        });
    }
}

@end
