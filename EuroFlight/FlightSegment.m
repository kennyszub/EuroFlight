//
//  FlightLeg.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightSegment.h"

@implementation FlightSegment

static NSDateFormatter *dateTimeParser;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (!dateTimeParser) {
            [FlightSegment initDateTimeParser];
        }
        
        NSArray *legDictionaries = dictionary[@"leg"];
        if (legDictionaries.count == 0) {
            NSLog(@"wtf why aren't there any legs?");
        } else {
            NSInteger lastIndex = legDictionaries.count - 1;
            self.sourceAirportCode = legDictionaries[0][@"origin"];
            self.destinationAirportCode = legDictionaries[lastIndex][@"destination"];
            NSString *departureTime = legDictionaries[0][@"departureTime"];
            NSString *arrivalTime = legDictionaries[lastIndex][@"arrivalTime"];
            self.departureDate = [dateTimeParser dateFromString:departureTime];
            self.arrivalDate = [dateTimeParser dateFromString:arrivalTime];
        }
        
        self.airline = [dictionary valueForKeyPath:@"flight.carrier"];
        self.flightNumber = [dictionary valueForKeyPath:@"flight.number"];
        self.duration = [dictionary[@"duration"] integerValue];
        self.connectionDuration = [dictionary[@"connectionDuration"] integerValue];
    }
    
    return self;
}

+ (void)initDateTimeParser {
    dateTimeParser = [[NSDateFormatter alloc] init];
    dateTimeParser.dateFormat = @"y'-'MM'-'dd'T'HH':'mmxxx";
}

@end
