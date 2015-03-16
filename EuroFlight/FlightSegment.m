//
//  FlightLeg.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightSegment.h"
#import "GoogleSearchClient.h"
#import "NameMappingHelper.h"

@implementation FlightSegment

@synthesize airlineImageURL = _airlineImageURL;

static NSDateFormatter *dateTimeParser;

static NSMutableSet *requestedAirlines;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (!dateTimeParser) {
            [FlightSegment initDateTimeParser];
        }
        if (!requestedAirlines) {
            [FlightSegment initRequestedAirlines];
        }
        
        NSArray *legDictionaries = dictionary[@"leg"];
        if (legDictionaries.count == 0) {
            NSLog(@"wtf why aren't there any legs?");
        } else {
            NSInteger lastIndex = legDictionaries.count - 1;
            self.sourceAirportCode = legDictionaries[0][@"origin"];
            self.destinationAirportCode = legDictionaries[lastIndex][@"destination"];
            NSString *departureTime = legDictionaries[0][@"departureTime"];
            NSString *arrivalTime = legDictionaries[lastIndex][@"arrivalTime"];
            self.departureDate = [dateTimeParser dateFromString:departureTime];
            self.arrivalDate = [dateTimeParser dateFromString:arrivalTime];
        }
        
        self.airline = [dictionary valueForKeyPath:@"flight.carrier"];
        self.flightNumber = [dictionary valueForKeyPath:@"flight.number"];
        self.duration = [dictionary[@"duration"] integerValue];
        self.connectionDuration = [dictionary[@"connectionDuration"] integerValue];

        NSString *airlineImageURL = [[NSUserDefaults standardUserDefaults] stringForKey:[self userDefaultsKeyWithAirline]];
        if (!airlineImageURL) {
            if (![requestedAirlines containsObject:self.airline]) {
                // if we haven't already requested this airline, do so
//                NSLog(@"making google search request for %@", self.airline);
                [requestedAirlines addObject:self.airline];

                NameMappingHelper *helper = [NameMappingHelper sharedInstance];
                NSString *query = [NSString stringWithFormat:@"%@ logo", [helper carrierNameForCode:self.airline]];

                [[GoogleSearchClient sharedInstance] imageSearchWithQuery:query completion:^(NSArray *urls, NSError *error) {
                    if (error) {
                        NSLog(@"Error fetching logo for %@: %@", self.airline, error);
                    } else {
                        if (urls.count > 0) {
                            self.airlineImageURL = urls[0];
                        }
                    }
                }];
            }
        } else {
//            NSLog(@"loading image URL for %@ from user defaults: %@", self.airline, airlineImageURL);
            self.airlineImageURL = airlineImageURL;
        }
    }
    
    return self;
}

+ (void)initDateTimeParser {
    dateTimeParser = [[NSDateFormatter alloc] init];
    dateTimeParser.dateFormat = @"y'-'MM'-'dd'T'HH':'mmxxx";
}

+ (void)initRequestedAirlines {
    requestedAirlines = [NSMutableSet set];
}

NSString * const kUserDefaultsAirlineImagesKeyBase = @"AirlineImagesKeyBase";

- (NSString *)airlineImageURL {
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self userDefaultsKeyWithAirline]];
}

- (void)setAirlineImageURL:(NSString *)airlineImageURL {
    _airlineImageURL = airlineImageURL;
    [[NSUserDefaults standardUserDefaults] setValue:airlineImageURL forKey:[self userDefaultsKeyWithAirline]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userDefaultsKeyWithAirline {
    return [NSString stringWithFormat:@"%@%@", kUserDefaultsAirlineImagesKeyBase, self.airline];
}

@end
