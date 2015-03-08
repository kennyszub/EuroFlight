//
//  TripClient.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kSourceAirportParamsKey;
extern NSString * const kDestinationAirportParamsKey;

@interface TripClient : NSObject

+ (TripClient *)sharedInstance;

- (void)tripsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *trips, NSError *error))completion;

@end
