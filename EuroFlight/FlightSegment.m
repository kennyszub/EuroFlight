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
// in-memory cache of airline URLs, stores airline as key and logo URL as value
// initially pulls from NSUserDefaults
static NSMutableDictionary *airlineToURL;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (!dateTimeParser) {
            [FlightSegment initDateTimeParser];
        }
        if (!requestedAirlines) {
            [FlightSegment initRequestedAirlines];
        }
        if (!airlineToURL) {
            [FlightSegment initAirlineToURL];
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

        // UNCOMMENT THIS after rate limits have expired (100/day)
//        [self getAirlineURL];
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

- (void)getAirlineURL {
    NSString *airlineImageURL = airlineToURL[self.airline];
    if (!airlineImageURL) {
        if (![requestedAirlines containsObject:self.airline]) {
            // if we haven't already requested this airline, do so
//            NSLog(@"making google search request for %@", self.airline);
            [requestedAirlines addObject:self.airline];

            NameMappingHelper *helper = [NameMappingHelper sharedInstance];
            NSString *query = [NSString stringWithFormat:@"%@ logo", [helper carrierNameForCode:self.airline]];

            [[GoogleSearchClient sharedInstance] imageSearchWithQuery:query completion:^(NSArray *urls, NSError *error) {
                if (error) {
                    NSLog(@"Error fetching logo for %@: %@", self.airline, error);
                } else {
                    if (urls.count > 0) {
                        self.airlineImageURL = urls[0];
                        airlineToURL[self.airline] = urls[0];
                    }
                }
            }];
        }
    } else {
//        NSLog(@"loading image URL for %@ from user defaults: %@", self.airline, airlineImageURL);
        self.airlineImageURL = airlineImageURL;
    }
}

NSString * const kUserDefaultsAirlineImagesKey = @"AirlineImagesKey";

+ (void)initAirlineToURL {
    if (!airlineToURL) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefaultsAirlineImagesKey];
        if (!dict) {
            airlineToURL = [NSMutableDictionary dictionary];
        } else {
            airlineToURL = [dict mutableCopy];
        }
    }
}

- (NSString *)airlineImageURL {
    [FlightSegment initAirlineToURL];
    if (!_airlineImageURL && airlineToURL[self.airline]) {
        self.airlineImageURL = airlineToURL[self.airline];
    }

    return _airlineImageURL;
}

- (void)setAirlineImageURL:(NSString *)airlineImageURL {
    _airlineImageURL = airlineImageURL;
    [FlightSegment initAirlineToURL];
    airlineToURL[self.airline] = airlineImageURL;

    // for now, persist all image URLs to disk
    // TODO this might be too slow, so remove this and call it once somewhere else
    [FlightSegment saveAirlineImageURLs];
}

+ (void)saveAirlineImageURLs {
    [[NSUserDefaults standardUserDefaults] setObject:airlineToURL forKey:kUserDefaultsAirlineImagesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
