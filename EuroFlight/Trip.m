//
//  Trip.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Trip.h"
#import "Flight.h"

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

- (void)parseCurrencyString:(NSString *)currencyString {
    NSRegularExpression *currencyRegex = [NSRegularExpression regularExpressionWithPattern:@"([A-Za-z]+)([0-9.]+)" options:0 error:nil];
    NSArray *matches = [currencyRegex matchesInString:currencyString options:0 range:NSMakeRange(0, currencyString.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange currencyTypeRange = [match rangeAtIndex:1];
        NSRange currencyAmountRange = [match rangeAtIndex:2];
        self.currencyType = [currencyString substringWithRange:currencyTypeRange];
        self.flightCost = [[currencyString substringWithRange:currencyAmountRange] floatValue];
    }
}

@end
