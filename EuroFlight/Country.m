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
#import "Event.h"

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
        
        NSMutableArray *array = [[Event allEvents] mutableCopy];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countryString like %@", self.name];
        NSArray *matchingEvents = [array filteredArrayUsingPredicate:predicate];
        for (Event *event in matchingEvents) {
            event.country = self;
            NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"name like %@", event.cityString];
            NSArray *matchingCities = [self.cities filteredArrayUsingPredicate:cityPredicate];
            if (matchingCities.count > 0) {
                event.city = [matchingCities objectAtIndex:0];
            }
        }
        self.events = matchingEvents;
    }
    return self;
}

// dynamically compute the lowest cost across all cities available
- (float)lowestCost {
    float min = [[self.cities valueForKeyPath:@"@min.lowestCost"] floatValue];
    return min;
}

// TODO for now, keep a static reference to the list of all countries once initialized
// this way we can grab the countries from multiple places
static NSArray *_allCountries;

+ (NSArray *)initCountries {
    if (!_allCountries) {
        NSArray *destinations = [self getDestinations];
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        for (NSDictionary *countryDictionary in destinations) {
            Country *country = [[Country alloc] initWithDictionary:countryDictionary];
            [countries addObject:country];
        }
        _allCountries = countries;
    }
    return _allCountries;
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
                  @"airportCodes" : @[@"MAD"]},
                @{@"city" : @"Ibiza",
                  @"airportCodes" : @[@"IBZ"]}]
          },
      @{
          @"countryName" : @"France",
          @"cities" :
              @[@{@"city" : @"Paris",
                  @"airportCodes" : @[@"CDG", @"ORY"]},
                @{@"city" : @"Nice",
                  @"airportCodes" : @[@"NCE"]}]
          },
      @{
          @"countryName" : @"Netherlands",
          @"cities" :
              @[@{@"city" : @"Amsterdam",
                  @"airportCodes" : @[@"AMS"]}]
          },
      @{
          @"countryName" : @"Hungary",
          @"cities" :
              @[@{@"city" : @"Budapest",
                  @"airportCodes" : @[@"BUD"]}]
          },
      @{
          @"countryName" : @"Ireland",
          @"cities" :
              @[@{@"city" : @"Dublin",
                  @"airportCodes" : @[@"DUB"]}]
          },
      @{
          @"countryName" : @"Scotland",
          @"cities" :
              @[@{@"city" : @"Edinburgh",
                  @"airportCodes" : @[@"EDI"]}]
          },
      @{
          @"countryName" : @"Italy",
          @"cities" :
              @[@{@"city" : @"Florence",
                  @"airportCodes" : @[@"FLR"]},
                @{@"city" : @"Venice",
                  @"airportCodes" : @[@"VCE"]},
                @{@"city" : @"Rome",
                  @"airportCodes" : @[@"FCO"]}]
          },
      @{
          @"countryName" : @"Sweden",
          @"cities" :
              @[@{@"city" : @"Stockholm",
                  @"airportCodes" : @[@"ARN"]},
                @{@"city" : @"Gothenburg",
                  @"airportCodes" : @[@"GOT"]}]
          },
      @{
          @"countryName" : @"Germany",
          @"cities" :
              @[@{@"city" : @"Munich",
                  @"airportCodes" : @[@"MUC"]},
                @{@"city" : @"Berlin",
                  @"airportCodes" : @[@"TXL", @"SXF"]},
                @{@"city" : @"Frankfurt",
                  @"airportCodes" : @[@"FRA"]}]
          },
      @{
          @"countryName" : @"Norway",
          @"cities" :
              @[@{@"city" : @"Oslo",
                  @"airportCodes" : @[@"OSL"]}]
          },
      @{
          @"countryName" : @"Switzerland",
          @"cities" :
              @[@{@"city" : @"Zurich",
                  @"airportCodes" : @[@"ZRH"]}]
          },
      @{
          @"countryName" : @"Austria",
          @"cities" :
              @[@{@"city" : @"Vienna",
                  @"airportCodes" : @[@"VIE"]}]
          },
      @{
          @"countryName" : @"Iceland",
          @"cities" :
              @[@{@"city" : @"Reykjavik",
                  @"airportCodes" : @[@"KEF"]}]
          },
      @{
          @"countryName" : @"Belgium",
          @"cities" :
              @[@{@"city" : @"Brussels",
                  @"airportCodes" : @[@"BRU"]}]
          },
      @{
          @"countryName" : @"Turkey",
          @"cities" :
              @[@{@"city" : @"Istanbul",
                  @"airportCodes" : @[@"IST"]}]
          },

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

- (NSString *)currencyType {
    if (self.cities.count > 0) {
        return ((City *) self.cities[0]).currencyType;
    } else {
        return nil;
    }
}
        

@end
