//
//  Context.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ContextChangedNotification;

@interface Context : NSObject

+ (Context *)currentContext;

@property (nonatomic, strong) NSString *originAirport;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, assign) NSInteger numPassengers;
@property (nonatomic, assign) BOOL isRoundTrip;
@property (nonatomic, strong) NSString *timeZone;

@end
