//
//  SkyscannerClient.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/25/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "SkyscannerClient.h"
#import "Trip.h"
#import "Context.h"

NSString * const kSkyscannerApiKey = @"bo426836823243347134407136148559";
NSString * const kSkyscannerCreateSessionURL = @"http://partners.api.skyscanner.net/apiservices/pricing/v1.0";

@implementation SkyscannerClient

+ (SkyscannerClient *)sharedInstance {
    static SkyscannerClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[SkyscannerClient alloc] init];
        }
    });

    return instance;
}

static NSDateFormatter *dateFormatter;

+ (void)initDateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
        }
    });
}

- (void)flightSearchWithDestinationAirport:(NSString *)destination completion:(void (^)(NSArray *results, NSError *error))completion {
    [SkyscannerClient initDateFormatter];

    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    allParams[@"apiKey"] = kSkyscannerApiKey;
    // hard coding a bunch of params
    allParams[@"locale"] = @"en-GB";
    allParams[@"country"] = @"UK";
    allParams[@"currency"] = @"GBP";
    allParams[@"originplace"] = @"LHR-Iata";
    allParams[@"destinationplace"] = [NSString stringWithFormat:@"%@-Iata", destination];
    Context *current = [Context currentContext];
    allParams[@"outbounddate"] = [dateFormatter stringFromDate:current.departureDate];
    allParams[@"inbounddate"] = [dateFormatter stringFromDate:current.returnDate];

    [self POST:kSkyscannerCreateSessionURL parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *location = [operation.response allHeaderFields][@"Location"];
        NSLog(@"Location: %@", location);

        NSDictionary *userInfo = @{
                                   @"location" : location,
                                   @"completion" : completion,
                                   };
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer:) userInfo:userInfo repeats:NO];
//        [self flightResultsFromLocation:location completion:completion];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)onTimer:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;

    [self flightResultsFromLocation:userInfo[@"location"] completion:userInfo[@"completion"]];
}

- (void)flightResultsFromLocation:(NSString *)location completion:(void (^)(NSArray *results, NSError *error))completion {
    NSDictionary *params = @{
                             @"apiKey" : kSkyscannerApiKey,
                             @"pageindex" : @(0),
                             @"pagesize" : @(20)
                             };
    [self GET:location parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *trips = [Trip tripsWithSkyscannerDictionary:responseObject];
        NSLog(@"got %ld trips back", trips.count);
        completion(trips, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
