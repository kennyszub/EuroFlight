//
//  FlightLeg.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightSegment.h"

@implementation FlightSegment

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y'-'MM'-'dd'T'HH':'mmxxx";
        
        NSArray *legDictionaries = dictionary[@"leg"];
        if (legDictionaries.count == 0) {
            NSLog(@"wtf why aren't there any legs?");
        } else {
            NSInteger lastIndex = legDictionaries.count - 1;
            self.sourceAirportCode = legDictionaries[0][@"origin"];
            self.destinationAirportCode = legDictionaries[lastIndex][@"destination"];
            NSString *departureTime = legDictionaries[0][@"departureTime"];
            NSString *arrivalTime = legDictionaries[lastIndex][@"arrivalTime"];
            self.departureDate = [formatter dateFromString:departureTime];
            self.arrivalDate = [formatter dateFromString:arrivalTime];
        }
        
        self.airline = [dictionary valueForKeyPath:@"flight.carrier"];
        self.flightNumber = [dictionary valueForKeyPath:@"flight.number"];
        self.duration = [dictionary[@"duration"] integerValue];
    }
    
    return self;
}

@end
