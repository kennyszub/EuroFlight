//
//  LocationManager.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "LocationManager.h"

static BOOL haveLatestCoordinates = YES;

@interface LocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) void (^locationCompletion)(CLLocation *location);

@end

@implementation LocationManager



+ (LocationManager *)sharedInstance {
    static LocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LocationManager alloc] init];
        }
    });
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.manager requestWhenInUseAuthorization];
        self.manager.delegate = self;
    }
    return self;
}

- (void)getCurrentLocationWithCompletion:(void (^)(CLLocation *))completion {
    self.locationCompletion = completion;
    haveLatestCoordinates = NO;
    [self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSDate *locationDate = location.timestamp;
    NSTimeInterval howRecent = [locationDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0 && !haveLatestCoordinates) {
        haveLatestCoordinates = YES;
        [self.manager stopUpdatingLocation];
        self.locationCompletion(location);
    }
}

@end
