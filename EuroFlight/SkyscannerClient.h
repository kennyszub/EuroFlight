//
//  SkyscannerClient.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/25/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface SkyscannerClient : AFHTTPRequestOperationManager

+ (SkyscannerClient *)sharedInstance;

- (void)flightSearchWithDestinationAirport:(NSString *)destination completion:(void (^)(NSArray *results, NSError *error))completion;

@end
