//
//  SegmentDetailCell.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightSegment.h"

@interface SegmentDetailCell : UITableViewCell

@property (nonatomic, strong) FlightSegment *segment;
@property (nonatomic, assign) BOOL showTriangleView;
@property (nonatomic, assign) BOOL nextCellWillShowTriangleView;

@end
