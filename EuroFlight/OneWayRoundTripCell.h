//
//  OneWayRoundTripCell.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OneWayRoundTripCell;
@protocol OneWayRoundTripCellDelegate <NSObject>

- (void)oneWayRoundTripCellDelegate:(OneWayRoundTripCell *)cell didSelectRoundTrip:(BOOL)isRoundTrip;

@end

@interface OneWayRoundTripCell : UITableViewCell
@property (nonatomic, weak) id<OneWayRoundTripCellDelegate> delegate;

@end
