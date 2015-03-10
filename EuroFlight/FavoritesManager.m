//
//  FavoritesManager.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FavoritesManager.h"
#import "Country.h"

@interface FavoritesManager ()

@property (nonatomic, strong) NSMutableArray *favoritedCities;

@end

NSString * const kFavoritesKey = @"FavoritedCities";
NSString * const kFavoriteCityNamesKey = @"FavoriteCityNames";

@implementation FavoritesManager

- (id)init {
    self = [super init];

    if (self) {
        // no other initialization needed
    }

    return self;
}

+ (FavoritesManager *)sharedInstance {
    static FavoritesManager *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[FavoritesManager alloc] init];
        }
    });

    return instance;
}

- (NSArray *)favoritedCityNames {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kFavoriteCityNamesKey];
}

- (NSArray *)favoritedCities {
    NSArray *favorites = [self favoritedCityNames];
    NSMutableArray *cities = [NSMutableArray array];

    // TODO creating all the countries here in case they haven't been initialized yet :(
    NSArray *countries = [Country initCountries];
    for (Country *country in countries) {
        for (City *city in country.cities) {
            if ([favorites containsObject:city.name]) {
                [cities addObject:city];
            }
        }
    }

    return cities;
}

- (BOOL)isCityNameFavorited:(NSString *)name {
    NSArray *favoritedCityNames = [self favoritedCityNames];
    if (!favoritedCityNames || favoritedCityNames.count == 0) {
        return false;
    }

    return [favoritedCityNames containsObject:name];
}

- (void)setCity:(City *)city favorited:(BOOL)favorited {
    NSArray *favorites = [self favoritedCityNames];
    NSMutableArray *newFavorites = [NSMutableArray array];
    if (favorites) {
        newFavorites = [favorites mutableCopy];
    }

    if (favorited) {
        // set the city as favorited
        if ([favorites containsObject:city.name]) {
            // it's already favorited
            return;
        } else {
            [newFavorites addObject:city.name];
        }
    } else {
        // set the city as not favorited
        if (![favorites containsObject:city.name]) {
            // it's already not favorited
            return;
        } else {
            [newFavorites removeObject:city.name];
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:newFavorites forKey:kFavoriteCityNamesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
