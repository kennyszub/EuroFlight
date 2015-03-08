//
//  Country.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Country.h"
#import "City.h"

@implementation Country


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"countryName"];
        NSMutableArray *cities = [[NSMutableArray alloc] init];
        NSArray *cityDictionaries = dictionary[@"cities"];
        for (NSDictionary *cityDictionary in cityDictionaries) {
            City *city = [[City alloc] initWithDictionary:cityDictionary];
            [cities addObject:city];
        }
        self.cities = cities;
    }
    return self;
}

+ (NSArray *)initCountries {
    NSArray *destinations = [self getDestinations];
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    for (NSDictionary *countryDictionary in destinations) {
        Country *country = [[Country alloc] initWithDictionary:countryDictionary];
        [countries addObject:country];
    }
    return countries;
}

+ (NSArray *)getDestinations {
    NSArray *destinations =
    @[
      @{
          @"countryName" : @"Spain",
          @"cities" :
              @[@{@"city" : @"Barcelona",
                  @"airportCodes" : @[@"BCN"]},
                @{@"city" : @"Madrid",
                  @"airportCodes" : @[@"MAD"]}]
          },
      @{
          @"countryName" : @"France",
          @"cities" :
              @[@{@"city" : @"Paris",
                  @"airportCodes" : @[@"CDG", @"ORY"]},
                @{@"city" : @"Nice",
                  @"airportCodes" : @[@"NCE"]}]
          }
      ];
    
    return destinations;
}
        

@end
