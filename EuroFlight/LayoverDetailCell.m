//
//  LayoverDetailCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "LayoverDetailCell.h"
#import "TriangleView.h"

#define kMinutesInHour 60

@interface LayoverDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *layoverDetailLabel;
@property (nonatomic, strong) TriangleView *triangleView;

@end

@implementation LayoverDetailCell

- (void)awakeFromNib {
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#define kTriangleBaseLength 15
#define kTriangleHeight 7

- (void)setSegment:(FlightSegment *)segment {
    _segment = segment;
    self.layoverDetailLabel.text = [NSString stringWithFormat:@"%@ layover in %@", [self durationAsString:segment.connectionDuration], segment.destinationAirportCode];

    self.triangleView = [[TriangleView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width - kTriangleBaseLength) / 2.0, 0, kTriangleBaseLength, kTriangleHeight)];
    self.triangleView.fillColor = [UIColor whiteColor];
    self.triangleView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.triangleView];
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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat rectWidth = CGRectGetWidth(rect);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);

    // draw the top border with a gap for the triangle view
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, (rectWidth - kTriangleBaseLength) / 2.0, 0.0f);
    CGContextMoveToPoint(context, (rectWidth + kTriangleBaseLength) / 2.0, 0.0f);
    CGContextAddLineToPoint(context, rectWidth, 0.0f);

    CGContextStrokePath(context);
}

@end
