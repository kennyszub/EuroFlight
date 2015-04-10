//
//  TripClient.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "TripClient.h"
#import "Trip.h"
#import "NameMappingHelper.h"
#import "Context.h"

#define kNumQPXCalls 0

NSString * const kSourceAirportParamsKey = @"sourceAirport";
NSString * const kDestinationAirportParamsKey = @"destinationAirport";

NSString * const kGoogleQPXBaseURL = @"https://www.googleapis.com/qpxExpress/v1/trips/search";
NSString * const kGoogleQPXKey = @"AIzaSyADnB0ZZP2pJ-nPVwNrHlWK_6XZwLY0dec";

@implementation TripClient

+ (TripClient *)sharedInstance {
    static TripClient *instance = nil;
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^ {
        if (!instance) {
            instance = [[TripClient alloc] init];
            instance.requestSerializer = [AFJSONRequestSerializer serializer];
            [instance.requestSerializer setValue:@"com.oks.EuroFlight" forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
        }

        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
        }
    });
    
    return instance;
}

static NSInteger numQPXCallsMade;
static NSDateFormatter *formatter;

- (void)tripsWithDestinationAirport:(NSString *)destination completion:(void (^)(NSArray *trips, NSError *error))completion {
    if (kNumQPXCalls && numQPXCallsMade < kNumQPXCalls) {
        Context *context = [Context currentContext];
        NSString *source = [context originAirport];
        NSDate *departureDate = [context departureDate];
        NSDate *returnDate = [context returnDate];

        NSDictionary *params =
        @{
          @"request":
              @{
                  @"passengers":
                      @{
                          @"kind": @"qpxexpress#passengerCounts",
                          @"adultCount": @(1),
                          @"childCount": @(0),
                          @"infantInLapCount": @(0),
                          @"infantInSeatCount": @(0),
                          @"seniorCount": @(0)
                          },
                  @"slice":
                      @[
                          @{
                              @"kind": @"qpxexpress#sliceInput",
                              @"origin": source,
                              @"destination": destination,
                              @"date": [formatter stringFromDate:departureDate]
                              },
                          @{
                              @"kind": @"qpxexpress#sliceInput",
                              @"origin": destination,
                              @"destination": source,
                              @"date": [formatter stringFromDate:returnDate]
                              }
                          ],
                  @"solutions": @(20)
                  }
          };

        NSString *unescapedUrlPath = [NSString stringWithFormat:@"%@?key=%@", kGoogleQPXBaseURL, kGoogleQPXKey];
        NSString *escapedUrlPath = [unescapedUrlPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        numQPXCallsMade++;
        [self POST:escapedUrlPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Making Google flights request for %@", destination);

            [[NameMappingHelper sharedInstance] parseTripData:[responseObject valueForKeyPath:@"trips.data"]];

            NSArray *trips = [Trip tripsWithArray:[responseObject valueForKeyPath:@"trips.tripOption"]];

            completion(trips, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(nil, error);
        }];
    } else {
        NSDictionary *tripsResponse = [TripClient getSampleResponseForAirport:destination];

        // TODO make sure this is thread-safe (when this actually becomes part of a network call)
        // NOTE: this has to happen before the call to tripsWithArray because we need to parse all the metadata first
        [[NameMappingHelper sharedInstance] parseTripData:[tripsResponse valueForKeyPath:@"trips.data"]];

        NSArray *trips = [Trip tripsWithArray:tripsResponse[@"trips"][@"tripOption"]];

        completion(trips, nil);
    }
}

+ (id)getSampleResponseForAirport:(NSString *)airport {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:airport ofType:@"txt"];
    NSString *jsonString;
    if (!filePath) {
        filePath = [[NSBundle mainBundle] pathForResource:@"CDG" ofType:@"txt"]; // default to Paris for now
    }

    jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    return json;
}



@end
