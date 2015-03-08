//
//  Context.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Context : NSObject

+ (Context *)currentContext;

@property (nonatomic, strong) NSString *originAirport;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, assign) NSInteger numPassengers;


@end
