//
//  Context.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Context.h"
#import "Country.h"

NSString * const ContextChangedNotification = @"ContextChangedNotification";

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

        _currentContext.timeZone = @"GMT";
    }
    return _currentContext;
}

- (void)postContextChangedNotification {
    // HACK: instead of posting a notification, just change the state directly
    // Yay!
    [Country setFlightDataDirty:YES];
    NSLog(@"setting flight data to dirty");
//    [[NSNotificationCenter defaultCenter] postNotificationName:ContextChangedNotification object:nil];
}

- (void)setOriginAirport:(NSString *)originAirport {
    _originAirport = originAirport;
    [self postContextChangedNotification];
}

- (void)setDepartureDate:(NSDate *)departureDate {
    _departureDate = departureDate;
    [self postContextChangedNotification];
}

- (void)setReturnDate:(NSDate *)returnDate {
    _returnDate = returnDate;
    [self postContextChangedNotification];
}

- (void)setNumPassengers:(NSInteger)numPassengers {
    _numPassengers = numPassengers;
    [self postContextChangedNotification];
}

- (void)setIsRoundTrip:(BOOL)isRoundTrip {
    _isRoundTrip = isRoundTrip;
    [self postContextChangedNotification];
}

- (void)setTimeZone:(NSString *)timeZone {
    _timeZone = timeZone;
    [self postContextChangedNotification];
}

@end