//
//  TriangleView.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/17/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;

    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Draw a line from the top left and right to the bottom middle, fill it
    CGFloat rectWidth = CGRectGetWidth(rect);
    CGFloat rectHeight = CGRectGetHeight(rect);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);

    // draw the triangular path to fill it
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
    CGPathAddLineToPoint(path, NULL, rectWidth / 2.0, rectHeight);
    CGPathAddLineToPoint(path, NULL, rectWidth, 0.0f);
    CGContextAddPath(context, path);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextFillPath(context);
    CGPathRelease(path);

    // draw the triangular outline
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, rectWidth / 2.0, rectHeight);
    CGContextAddLineToPoint(context, rectWidth, 0.0f);
    CGContextStrokePath(context);
}


@end
