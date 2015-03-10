//
//  FavoritesManager.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface FavoritesManager : NSObject

+ (FavoritesManager *)sharedInstance;

// for storing and retrieving just names
- (NSArray *)favoritedCities;
- (BOOL)isCityNameFavorited:(NSString *)name;
- (void)setCity:(City *)city favorited:(BOOL)favorited;

@end
