//
//  Country.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Country.h"
#import "City.h"
#import "ResultsViewController.h"

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
        // sort cities
        self.cities = [self.cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            float price1 = ((City *) obj1).lowestCost;
            float price2 = ((City *) obj2).lowestCost;
            return [ResultsViewController compareFloats:price1 secondFloat:price2];
        }];
    }
    return self;
}

// dynamically compute the lowest cost across all cities available
- (float)lowestCost {
    float min = [[self.cities valueForKeyPath:@"@min.lowestCost"] floatValue];
    return min;
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

- (NSString *)countryPhotoURL {
    if (self.cities.count > 0) {
        return ((City *) self.cities[0]).imageURL;
    } else {
        return nil;
    }
}
        

@end
