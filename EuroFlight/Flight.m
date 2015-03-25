//
//  Flight.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Flight.h"
#import "FlightSegment.h"

@implementation Flight

+ (NSDictionary *)flightsWithSkyscannerDictionary:(NSDictionary *)dictionary places:(NSDictionary *)places carriers:(NSDictionary *)carriers {
    NSMutableDictionary *flights = [[NSMutableDictionary alloc] init];

    NSDictionary *segments = [FlightSegment segmentsWithSkyscannerDictionary:dictionary places:places carriers:carriers];

    NSArray *flightArray = dictionary[@"Legs"];
    for (NSDictionary *flight in flightArray) {
        flights[flight[@"Id"]] = [[Flight alloc] initWithSkyscannerDictionary:flight segments:segments];
    }

    return flights;
}

- (id)initWithSkyscannerDictionary:(NSDictionary *)dictionary segments:(NSDictionary *)segments {
    self = [super init];
    if (self) {
        self.totalDuration = [dictionary[@"Duration"] integerValue];

        NSArray *segmentIds = dictionary[@"SegmentIds"];
        NSMutableArray *flightSegments = [[NSMutableArray alloc] init];
        for (NSString *segmentId in segmentIds) {
            [flightSegments addObject:segments[segmentId]];
        }
        self.flightSegments = flightSegments;

        NSInteger lastIndex = flightSegments.count - 1;
        self.sourceAirportCode = ((FlightSegment *)self.flightSegments[0]).sourceAirportCode;
        self.destinationAirportCode = ((FlightSegment *)self.flightSegments[lastIndex]).destinationAirportCode;
        self.departureDate = ((FlightSegment *)self.flightSegments[0]).departureDate;
        self.arrivalDate = ((FlightSegment *)self.flightSegments[lastIndex]).arrivalDate;
    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSMutableArray *flightSegments = [[NSMutableArray alloc] init];
        NSArray *segmentDictionaries = dictionary[@"segment"];
        for (NSDictionary *segmentDictionary in segmentDictionaries) {
            [flightSegments addObject:[[FlightSegment alloc] initWithDictionary:segmentDictionary]];
        }
        self.flightSegments = flightSegments;
        
        self.totalDuration = [dictionary[@"duration"] integerValue];
        
        NSInteger lastIndex = flightSegments.count - 1;
        self.sourceAirportCode = ((FlightSegment *)self.flightSegments[0]).sourceAirportCode;
        self.destinationAirportCode = ((FlightSegment *)self.flightSegments[lastIndex]).destinationAirportCode;
        self.departureDate = ((FlightSegment *)self.flightSegments[0]).departureDate;
        self.arrivalDate = ((FlightSegment *)self.flightSegments[lastIndex]).arrivalDate;
    }
    
    return self;
}

@end
