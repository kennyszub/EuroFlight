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
                City *city = [matchingCities objectAtIndex:0];
                event.city = city;
                [city.events addObject:event];
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
        
        //[Event connectCitiesAndEvents];
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
                  @"airportCodes" : @[@"IBZ"]},
//                @{@"city" : @"Badajoz",
//                  @"airportCodes" : @[@"BJZ"]},
//                @{@"city" : @"Pamplona",
//                  @"airportCodes" : @[@"PNA"]},
                @{@"city" : @"Valencia",
                  @"airportCodes" : @[@"VLC"]}]
//                @{@"city" : @"Vigo",
//                  @"airportCodes" : @[@"VGO"]}]
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
                  @"airportCodes" : @[@"FCO"]},
                @{@"city" : @"Pisa",
                  @"airportCodes" : @[@"PSA"]}]
//                @{@"city" : @"Torino",
//                  @"airportCodes" : @[@"TRN"]}]
          },
      @{
          @"countryName" : @"Sweden",
          @"cities" :
              @[@{@"city" : @"Stockholm",
                  @"airportCodes" : @[@"ARN"]},
// Commented because the Gothenburg image sucks               @{@"city" : @"Gothenburg", 
//                  @"airportCodes" : @[@"GOT"]}
                ]
          },
      @{
          @"countryName" : @"Germany",
          @"cities" :
              @[@{@"city" : @"Munich",
                  @"airportCodes" : @[@"MUC"]},
                @{@"city" : @"Berlin",
                  @"airportCodes" : @[@"TXL", @"SXF"]},
                @{@"city" : @"Frankfurt",
                  @"airportCodes" : @[@"FRA"]},
//                @{@"city" : @"Laage",
//                  @"airportCodes" : @[@"RLG"]},
                @{@"city" : @"Leipzig",
                  @"airportCodes" : @[@"LEJ"]}]
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
                  @"airportCodes" : @[@"ZRH"]},
                @{@"city" : @"Geneva",
                  @"airportCodes" : @[@"GVA"]}]
          },
      @{
          @"countryName" : @"Austria",
          @"cities" :
              @[@{@"city" : @"Vienna",
                  @"airportCodes" : @[@"VIE"]}]
//                @{@"city" : @"Klagenfurt",
//                  @"airportCodes" : @[@"KLU"]}
//                @{@"city" : @"Linz",
//                  @"airportCodes" : @[@"LNZ"]}]
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
                  @"airportCodes" : @[@"IST"]},]
//                  @{@"city" : @"Konya",
//                  @"airportCodes" : @[@"KYA"]}]
          },
//      @{
//          @"countryName" : @"Finland",
//          @"cities" :
//              @[@{@"city" : @"Kajaani",
//                  @"airportCodes" : @[@"KAJ"]}]
//          },
//      @{
//          @"countryName" : @"Greece",
//          @"cities" :
//              @[@{@"city" : @"Alexandroupolis",
//                  @"airportCodes" : @[@"AXD"]},
//                @{@"city" : @"Chios",
//                  @"airportCodes" : @[@"JKH"]}]
//          },
      @{
          @"countryName" : @"Poland",
          @"cities" :
              @[@{@"city" : @"Gdansk",
                  @"airportCodes" : @[@"GDN"]}]
          },
      @{
          @"countryName" : @"Portugal",
          @"cities" :
              @[@{@"city" : @"Porto",
                  @"airportCodes" : @[@"OPO"]}]
          },
      @{
          @"countryName" : @"Russia",
          @"cities" :
              @[@{@"city" : @"St. Petersburg",
                  @"airportCodes" : @[@"LED"]}]
          },
      @{
          @"countryName" : @"Serbia",
          @"cities" :
              @[@{@"city" : @"Belgrade",
                  @"airportCodes" : @[@"BEG"]}]
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

- (NSString *)currencyType {
    if (self.cities.count > 0) {
        return ((City *) self.cities[0]).currencyType;
    } else {
        return nil;
    }
}

- (NSArray *)favoritedCities {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorited = YES"];
    NSArray *favoritedCities = [self.cities filteredArrayUsingPredicate:predicate];
    return favoritedCities;
}

- (NSArray *)citiesWithFavorite:(BOOL)on {
    if (on) {
        return [self favoritedCities];
    }
    return self.cities;
}

@end
