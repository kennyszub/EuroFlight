//
//  Event.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Event.h"
#import "KimonoClient.h"

@implementation Event
static NSArray *_events = nil;

+ (NSArray *)allEvents {
    if (_events == nil) {
        NSLog(@"init events");
        _events = [self initEvents];
    }
    
    return _events;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.summary = dictionary[@"description"];
        self.photoURL = dictionary[@"photoURL"];
        self.dateString = dictionary[@"date"];
        NSArray *components = [dictionary[@"city"] componentsSeparatedByString:@", "];
        self.city = components[0];
        if (components.count > 1) {
            self.country = components[1];
        }
    }
    return self;
}

+ (NSMutableArray *)initEvents {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *images = [KimonoClient sharedInstance].eventImages;
    NSDictionary *details = [KimonoClient sharedInstance].eventDetails;
    
    for (id key in images) {
        if (details[key] != nil) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setObject:key forKey:@"name"];
            [dictionary setObject:images[key] forKey:@"photoURL"];
            [dictionary setObject:details[key][@"city"] forKey:@"city"];
            [dictionary setObject:details[key][@"date"] forKey:@"date"];
            [dictionary setObject:([details[key][@"description"] isKindOfClass:[NSDictionary class]] ? details[key][@"description"][@"text"] : details[key][@"description"]) forKey:@"description"];
            Event *event = [[Event alloc] initWithDictionary:dictionary];
            [array addObject:event];
        }
    }

    return array;
}

@end
