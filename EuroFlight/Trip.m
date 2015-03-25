//
//  Trip.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Trip.h"
#import "Flight.h"
#import "FlightSegment.h"
#import "Context.h"

@implementation Trip

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.outboundFlight = [[Flight alloc] initWithDictionary:dictionary[@"slice"][0]];
        self.returnFlight = [[Flight alloc] initWithDictionary:dictionary[@"slice"][1]];
    }
    
    [self parseCurrencyString:dictionary[@"saleTotal"]];
    
    return self;
}

- (id)initWithSkyscannerDictionary:(NSDictionary *)dictionary flights:(NSDictionary *)flights places:(NSDictionary *)places carriers:(NSDictionary *)carriers {
    self = [super init];
    if (self) {
        self.outboundFlight = flights[dictionary[@"OutboundLegId"]];
        self.returnFlight = flights[dictionary[@"InboundLegId"]];
    }

    // TODO this is hardcoded for now
    self.currencyType = @"GBP";
    // TODO this just gets the first pricing option
    NSDictionary *pricingOptions = dictionary[@"PricingOptions"][0];
    self.flightCost = [pricingOptions[@"Price"] floatValue];
    self.bookingURL = pricingOptions[@"DeeplinkUrl"];

    return self;
}

- (NSString *)sourceAirportCode {
    return self.outboundFlight.sourceAirportCode;
}

- (NSString *)destinationAirportCode {
    return self.outboundFlight.destinationAirportCode;
}

+ (NSArray *)tripsWithArray:(NSArray *)array {
    NSMutableArray *trips = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        [trips addObject:[[Trip alloc] initWithDictionary:dictionary]];
    }
    
    return trips;
}

+ (NSArray *)tripsWithSkyscannerDictionary:(NSDictionary *)dictionary {
    NSMutableArray *trips = [[NSMutableArray alloc] init];

    // dictionary of place id => place dictionary
    NSDictionary *places = [self parsePlaces:dictionary[@"Places"]];
    // dictionary of carrier id => carrier dictionary
    NSDictionary *carriers = [self parseCarriers:dictionary[@"Carriers"]];
    // dictionary of flight id => Flight object
    NSDictionary *flights = [Flight flightsWithSkyscannerDictionary:dictionary places:places carriers:carriers];

    for (NSDictionary *trip in dictionary[@"Itineraries"]) {
        [trips addObject:[[Trip alloc] initWithSkyscannerDictionary:trip flights:flights places:places carriers:carriers]];
    }

    return trips;
}

+ (NSDictionary *)parsePlaces:(NSArray *)places {
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];

    for (NSDictionary *place in places) {
        results[place[@"Id"]] = place;
    }

    return results;
}

+ (NSDictionary *)parseCarriers:(NSArray *)carriers {
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];

    for (NSDictionary *carrier in carriers) {
        results[carrier[@"Id"]] = carrier;
    }

    return results;
}

static NSRegularExpression *currencyRegex;

- (void)parseCurrencyString:(NSString *)currencyString {
    if (!currencyRegex) {
        currencyRegex = [NSRegularExpression regularExpressionWithPattern:@"([A-Za-z]+)([0-9.]+)" options:0 error:nil];
    }

    NSArray *matches = [currencyRegex matchesInString:currencyString options:0 range:NSMakeRange(0, currencyString.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange currencyTypeRange = [match rangeAtIndex:1];
        NSRange currencyAmountRange = [match rangeAtIndex:2];
        self.currencyType = [currencyString substringWithRange:currencyTypeRange];
        self.flightCost = [[currencyString substringWithRange:currencyAmountRange] floatValue];
    }
}

- (float)flightCost {
    if ([Context currentContext].isRoundTrip) {
        return _flightCost;
    } else {
        return _flightCost / 2;
    }
}

@end
