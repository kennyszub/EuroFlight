//
//  Flight.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flight : NSObject

@property (nonatomic, strong) NSString *sourceAirportCode;
@property (nonatomic, strong) NSString *destinationAirportCode;
@property (nonatomic, strong) NSArray *flightSegments;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *arrivalDate;
@property (nonatomic, assign) NSInteger totalDuration;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
