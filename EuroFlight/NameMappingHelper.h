//
//  NameMappingHelper.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/8/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameMappingHelper : NSObject

+ (NameMappingHelper *)sharedInstance;

- (NSString *)cityNameForAirportCode:(NSString *)code;
- (NSString *)carrierNameForCode:(NSString *)code;

- (void)parseTripData:(NSDictionary *)data;

@end
