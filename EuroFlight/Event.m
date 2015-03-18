//
//  Event.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "Event.h"
#import "KimonoClient.h"
#import "AirportClient.h"
#import "PlacesClient.h"
#import "Airport.h"

@implementation Event
static NSArray *_events = nil;
static NSDateFormatter *dateTimeParser;

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
        if (!dateTimeParser) {
            [Event initDateTimeParser];
        }
        self.name = dictionary[@"name"];
        if ([dictionary[@"description"] isKindOfClass:[NSString class]]) {
            self.summary = [dictionary[@"description"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        }
        self.photoURL = dictionary[@"photoURL"];
        self.dateString = dictionary[@"date"];
        
        self.locationString = dictionary[@"city"];
        NSArray *components = [dictionary[@"city"] componentsSeparatedByString:@", "];
        self.cityString = components[0];
        if (components.count > 1) {
            self.countryString = components[1];
        }
        
        [self parseDateString:self.dateString];
        
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
            if (event.startDate != nil && event.endDate != nil) {
                [array addObject:event];
            }
        }
    }

    return array;
}

+ (void)connectCitiesAndEvents {
    for (Event *event in [self allEvents]) {
        [[PlacesClient sharedInstance] searchWithQuery:event.locationString success:^(AFHTTPRequestOperation *operation, id response) {
            NSDictionary *location = response[@"results"][0][@"geometry"][@"location"];
            
            [[AirportClient sharedInstance] searchAirportByLatitude:[location[@"lat"] doubleValue]longitude:[location[@"lng"] doubleValue] completion:^(NSMutableArray *airports, NSError *error) {
                if (airports.count > 0) {
                    Airport *airport = airports[0];
                    event.airport = airport;
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", airport.city];
                    
                    NSArray *matchingCities = [event.country.cities filteredArrayUsingPredicate:predicate];
                    if (matchingCities.count > 0) {
                        City *city = [matchingCities objectAtIndex:0];
                        event.city = city;
                        [city.events addObject:event];
                    }
                    
                    NSLog(@", %@, %@, %@", airport.code, airport.city, airport.country);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
        }];
    }
}

+ (void)initDateTimeParser {
    dateTimeParser = [[NSDateFormatter alloc] init];
    dateTimeParser.dateFormat = @"MMM' 'd', 'y";
}

static NSRegularExpression *dateRegex;

- (void)parseDateString:(NSString *)dateString {
    NSDate *startDate = [dateTimeParser dateFromString:dateString];
    NSDate *endDate = nil;
    
    if (!startDate) {
        if (!dateRegex) {
            dateRegex = [NSRegularExpression regularExpressionWithPattern:@"([A-Za-z]+ [0-9]+) - ([A-Za-z]* ?[0-9]+), ([0-9]+)" options:0 error:nil];
        }
        NSArray *matches = [dateRegex matchesInString:dateString options:0 range:NSMakeRange(0, dateString.length)];
        
        for (NSTextCheckingResult *match in matches) {
            NSRange startRange = [match rangeAtIndex:1];
            NSRange endRange = [match rangeAtIndex:2];
            NSRange yearRange = [match rangeAtIndex:3];
            NSString *startString = [dateString substringWithRange:startRange];
            NSString *endString = [dateString substringWithRange:endRange];
            NSString *year = [dateString substringWithRange:yearRange];
            NSString *startMonth = [startString componentsSeparatedByString:@" "][0];
            startString = [NSString stringWithFormat:@"%@, %@", startString, year];
            if ([endString componentsSeparatedByString:@" "].count == 1) {
                endString = [NSString stringWithFormat:@"%@ %@, %@", startMonth, endString, year];
            } else {
                endString = [NSString stringWithFormat:@"%@, %@", endString, year];
            }
            startDate = [dateTimeParser dateFromString:startString];
            endDate = [dateTimeParser dateFromString:endString];
            
        }
    } else {
        endDate = startDate;
    }
    
    self.startDate = startDate;
    self.endDate = endDate;
    
//    NSLog(@"3 %@ %@ %@", dateString, startDate, endDate);

}

@end
