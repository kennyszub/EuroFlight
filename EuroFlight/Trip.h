//
//  Trip.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flight.h"

@interface Trip : NSObject

@property (nonatomic, strong) NSString *sourceAirportCode;
@property (nonatomic, strong) NSString *destinationAirportCode;
@property (nonatomic, assign) float flightCost;
@property (nonatomic, strong) NSString *currencyType;
@property (nonatomic, strong) Flight *outboundFlight;
@property (nonatomic, strong) Flight *returnFlight;
@property (nonatomic, strong) NSString *bookingURL;

+ (NSArray *)tripsWithArray:(NSArray *)array;
+ (NSArray *)tripsWithSkyscannerDictionary:(NSDictionary *)dictionary;

@end
