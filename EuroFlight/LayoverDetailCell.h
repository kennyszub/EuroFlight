//
//  LayoverDetailCell.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightSegment.h"

@interface LayoverDetailCell : UITableViewCell

@property (nonatomic, strong) FlightSegment *segment;

// hack needed for skyscanner because they don't return connection duration
@property (nonatomic, strong) FlightSegment *secondSegment;

@end
