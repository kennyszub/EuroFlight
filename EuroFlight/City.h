//
//  City.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, strong) NSMutableArray *trips;
@property (nonatomic, assign) float lowestCost;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *currencyType;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
