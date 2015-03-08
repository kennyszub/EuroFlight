//
//  FlightLeg.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightSegment : NSObject

@property (nonatomic, strong) NSString *sourceAirportCode;
@property (nonatomic, strong) NSString *destinationAirportCode;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *arrivalDate;
@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSString *flightNumber;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger connectionDuration;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
