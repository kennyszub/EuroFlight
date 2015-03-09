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
#import "PlacesClient.h"
#import "Place.h"

@interface City ()
@property (nonatomic, strong) NSDictionary *summaries;
@end
@implementation City

NSString * const kPlaceDataPrefix = @"PlaceData";

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"city"];
        self.trips = [[NSMutableArray alloc] init];
        NSArray *airportCodes = dictionary[@"airportCodes"];
        for (NSString *airportCode in airportCodes) {
            [self makeFlightRequestWithAirportCode:airportCode];
        }
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self userDefaultsKeyWithCity:self.name]];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"Using saved data");
            self.places = [Place placesWithArray:dictionary[@"results"]];
        } else {
            [[PlacesClient sharedInstance] searchWithCity:self.name success:^(AFHTTPRequestOperation *operation, id response) {
                NSLog(@"Status %@", response[@"status"]);
                if ([response[@"status"] isEqualToString:@"OK"]) {
                    self.places = [Place placesWithArray:response[@"results"]];
                    NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:NULL];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[self userDefaultsKeyWithCity:self.name]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failed for %@", self.name);
            }];
        }
        
        self.summary = [PlacesClient sharedInstance].placeSummaries[self.name];
        
    }
    return self;
}

- (NSString *)userDefaultsKeyWithCity:(NSString *)cityName {
    return [NSString stringWithFormat:@"%@%@", kPlaceDataPrefix, cityName];
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

// dynamically compute the lowest cost across all trips available
- (float)lowestCost {
    float min = [[self.trips valueForKeyPath:@"@min.flightCost"] floatValue];
    return min;
}

@end
