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
@property (nonatomic, strong) NSString *airlineImageURL;

// only set for Skyscanner flight segments
@property (nonatomic, strong) NSString *airlineName;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSDictionary *)segmentsWithSkyscannerDictionary:(NSDictionary *)dictionary places:(NSDictionary *)places carriers:(NSDictionary *)carriers;

@end
