//
//  Context.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Context.h"

@implementation Context

static Context *_currentContext;

+ (Context *)currentContext {
    if (_currentContext == nil) {
        _currentContext = [[Context alloc] init];
        _currentContext.originAirport = @"LHR";
        _currentContext.numPassengers = 1;
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:27];
        [comps setMonth:3];
        [comps setYear:2015];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _currentContext.departureDate = [gregorian dateFromComponents:comps];
        
        [comps setDay:29];
        [comps setMonth:3];
        [comps setYear:2015];
        _currentContext.returnDate = [gregorian dateFromComponents:comps];
    }
    return _currentContext;
}

@end