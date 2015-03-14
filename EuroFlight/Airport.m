//
//  Airport.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Airport.h"

@implementation Airport

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.code = dictionary[@"code"];
        self.name = dictionary[@"name"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        self.lat = [dictionary[@"lat"] floatValue];
        self.lng = [dictionary[@"lng"] floatValue];
        self.timezone = dictionary[@"timezone"];
    }
    return self;
}

+ (NSMutableArray *)airportsWithArray:(NSArray *)array {
    NSMutableArray *airports = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        if (dictionary != (id) [NSNull null]) {
            [airports addObject:[[Airport alloc] initWithDictionary:dictionary]];
        }
    }
    return airports;
}
@end
