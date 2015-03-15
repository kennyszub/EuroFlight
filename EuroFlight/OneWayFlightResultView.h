//
//  OneWayFlightResultView.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/13/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"

@interface OneWayFlightResultView : UIView

@property (nonatomic, strong) Flight *flight;
@property (nonatomic, assign) BOOL isOutboundFlight;

@end
