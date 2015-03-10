//
//  Event.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;

+ (NSArray *)allEvents;

@end
