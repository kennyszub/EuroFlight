//
//  FlightResultsViewController.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "PlaneLoadingView.h"

@interface FlightResultsViewController : UIViewController

@property (nonatomic, strong) City *city;
@property (nonatomic, strong) PlaneLoadingView *hud;

@end
