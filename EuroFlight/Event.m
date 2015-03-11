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
        self.summary = dictionary[@"description"];
        self.photoURL = dictionary[@"photoURL"];
        self.dateString = dictionary[@"date"];
        
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
