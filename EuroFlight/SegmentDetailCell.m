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
#import "TriangleView.h"
#import "Context.h"

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
@property (nonatomic, strong) TriangleView *triangleView;

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

#define kTriangleBaseLength 15
#define kTriangleHeight 7

- (void)setSegment:(FlightSegment *)segment {
    _segment = segment;

    [self.airlineLogoImageView setImageWithURL:[NSURL URLWithString:segment.airlineImageURL]];

    NameMappingHelper *helper = [NameMappingHelper sharedInstance];
    if (segment.airlineName) {
        self.airlineLabel.text = segment.airlineName;
    } else {
        NSString *carrierName = [helper carrierNameForCode:segment.airline];
        self.airlineLabel.text = carrierName;
    }
    self.flightNumberLabel.text = segment.flightNumber;

    [SegmentDetailCell initTimeFormatter];
    self.departureTimeLabel.text = [timeFormatter stringFromDate:segment.departureDate];
    self.arrivalTimeLabel.text = [timeFormatter stringFromDate:segment.arrivalDate];

    self.departureCityLabel.text = [helper cityNameForAirportCode:segment.sourceAirportCode];
    self.arrivalCityLabel.text = [helper cityNameForAirportCode:segment.destinationAirportCode];

    self.totalFlightDurationLabel.text = [self durationAsString:segment.duration];
}

- (void)setShowTriangleView:(BOOL)showTriangleView {
    _showTriangleView = showTriangleView;

    if (showTriangleView) {
        self.triangleView = [[TriangleView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width - kTriangleBaseLength) / 2.0, 0, kTriangleBaseLength, kTriangleHeight)];
        self.triangleView.fillColor = [UIColor groupTableViewBackgroundColor];
        self.triangleView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.triangleView];
    } else {
        self.triangleView = nil;
    }
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
            timeFormatter.dateFormat = @"h:mm a";
            timeFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:[Context currentContext].timeZone];
        });
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat rectWidth = CGRectGetWidth(rect);
    CGFloat rectHeight = CGRectGetHeight(rect);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);

    if (self.showTriangleView) {
        // showing triangle view, so draw the top border with a gap
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, (rectWidth - kTriangleBaseLength) / 2.0, 0.0f);
        CGContextMoveToPoint(context, (rectWidth + kTriangleBaseLength) / 2.0, 0.0f);
        CGContextAddLineToPoint(context, rectWidth, 0.0f);
    } else {
        // not showing triangle view, so draw the top border
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, rectWidth, 0.0f);
    }

    if (!self.nextCellWillShowTriangleView) {
        // next cell won't show a triangle view, so draw a full bottom border
        CGContextMoveToPoint(context, 0.0f, rectHeight);
        CGContextAddLineToPoint(context, rectWidth, rectHeight);
    }

    CGContextStrokePath(context);
}

@end
