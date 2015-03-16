//
//  LayoverDetailCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "LayoverDetailCell.h"

#define kMinutesInHour 60

@interface LayoverDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *layoverDetailLabel;

@end

@implementation LayoverDetailCell

- (void)awakeFromNib {
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSegment:(FlightSegment *)segment {
    _segment = segment;
    self.layoverDetailLabel.text = [NSString stringWithFormat:@"%@ layover in %@", [self durationAsString:segment.connectionDuration], segment.destinationAirportCode];
}

- (NSString *)durationAsString:(NSInteger)duration {
    NSInteger numHours = duration / kMinutesInHour;
    NSInteger numMinutes = duration - (kMinutesInHour * numHours);

    return [NSString stringWithFormat:@"%ld hr %ld min", numHours, numMinutes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
