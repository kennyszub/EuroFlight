//
//  Place.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Place.h"
#import "PlacesClient.h"

@implementation Place

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSString *photoReference = dictionary[@"photos"][0][@"photo_reference"];
        self.photoURL = [PlacesClient photoURLWithPhotoReference:photoReference maxWidth:400];
        self.name = dictionary[@"name"];
    }
    return self;
}

+ (NSArray *)placesWithArray:(NSArray *)array {
    NSMutableArray *places = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        [places addObject:[[Place alloc] initWithDictionary:dictionary]];
    }
    
    return places;
}
@end
