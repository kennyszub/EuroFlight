//
//  City.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "City.h"
#import "Context.h"
#import "TripClient.h"

@implementation City

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"city"];
        self.trips = [[NSMutableArray alloc] init];
        NSArray *airportCodes = dictionary[@"airportCodes"];
        for (NSString *airportCode in airportCodes) {
            [self makeFlightRequestWithAirportCode:airportCode];
        }
    }
    return self;
}

- (void)makeFlightRequestWithAirportCode:(NSString *)airportCode {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // TODO finalize params (example)
    Context *context = [Context currentContext];
    params[kSourceAirportParamsKey] = context.originAirport;
    params[kDestinationAirportParamsKey] = airportCode;

    [[TripClient sharedInstance] tripsWithParams:params completion:^(NSArray *trips, NSError *error) {
        [self.trips addObjectsFromArray:trips];
    }];
}

@end
