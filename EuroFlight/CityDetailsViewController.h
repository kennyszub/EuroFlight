//
//  CityDetailsViewController.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface CityDetailsViewController : UIViewController

@property (strong, nonatomic) City *city;
@property (nonatomic, strong) NSString *eventName;

@end
