//
//  FlightResultGroupCell.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/15/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightResultGroupCell : UITableViewCell

@property (nonatomic, strong) NSArray *trips;

- (void)setCollapsed:(BOOL)collapsed;

@end
