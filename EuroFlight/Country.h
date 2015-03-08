//
//  Country.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, assign) float lowestCost;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *countryPhotoURL;

+ (NSArray *)initCountries;

@end
