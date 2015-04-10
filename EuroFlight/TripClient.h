//
//  TripClient.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

extern NSString * const kSourceAirportParamsKey;
extern NSString * const kDestinationAirportParamsKey;

@interface TripClient : AFHTTPRequestOperationManager

+ (TripClient *)sharedInstance;

- (void)tripsWithDestinationAirport:(NSString *)destination completion:(void (^)(NSArray *trips, NSError *error))completion;

@end
