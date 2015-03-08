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
