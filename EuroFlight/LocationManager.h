//
//  LocationManager.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (LocationManager *)sharedInstance;
- (void)getCurrentLocationWithCompletion:(void (^)(CLLocation *location))completion;

@property (nonatomic, strong) CLLocationManager *manager;
@end
