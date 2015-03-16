//
//  TripClient.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "TripClient.h"
#import "Trip.h"
#import "NameMappingHelper.h"

NSString * const kSourceAirportParamsKey = @"sourceAirport";
NSString * const kDestinationAirportParamsKey = @"destinationAirport";

@implementation TripClient

+ (TripClient *)sharedInstance {
    static TripClient *instance = nil;
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^ {
        instance = [[TripClient alloc] init];
    });
    
    return instance;
}

- (void)tripsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *trips, NSError *error))completion {
    NSString *destinationAirport = params[kDestinationAirportParamsKey];
    NSDictionary *tripsResponse = [TripClient getSampleResponseForAirport:destinationAirport];

    // TODO make sure this is thread-safe (when this actually becomes part of a network call)
    // NOTE: this has to happen before the call to tripsWithArray because we need to parse all the metadata first
    [[NameMappingHelper sharedInstance] parseTripData:[tripsResponse valueForKeyPath:@"trips.data"]];

    NSArray *trips = [Trip tripsWithArray:tripsResponse[@"trips"][@"tripOption"]];

    completion(trips, nil);
}

+ (id)getSampleResponseForAirport:(NSString *)airport {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:airport ofType:@"txt"];
    NSString *jsonString;
    if (!filePath) {
        filePath = [[NSBundle mainBundle] pathForResource:@"CDG" ofType:@"txt"]; // default to Paris for now
    }
    
    jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    return json;
}



@end
