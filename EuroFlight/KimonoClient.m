//
//  KimonoClient.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/8/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "KimonoClient.h"
#import "Event.h"

@implementation KimonoClient

-(id)init {
    self = [super init];
    if (self) {
        self.placeSummaries = [[NSMutableDictionary alloc] init];
        self.cityImages = [[NSMutableDictionary alloc] init];
        self.eventImages = [[NSMutableDictionary alloc] init];
        self.eventDetails = [[NSMutableDictionary alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        NSOperation *summariesOperation = [self getSummaries];
        NSOperation *eventImagesOperation = [self getEventImages];
        NSOperation *eventDetailsOperation = [self getEventDetails];
        
        NSOperation *initCountriesOperation = [NSBlockOperation blockOperationWithBlock:^{
            [Country initCountries];
        }];
        
        [initCountriesOperation addDependency:summariesOperation];
        [initCountriesOperation addDependency:eventImagesOperation];
        [initCountriesOperation addDependency:eventDetailsOperation];
        
        [queue addOperation:initCountriesOperation];
    }
    return self;
}

+ (KimonoClient *)sharedInstance {
    static KimonoClient *instance = nil;
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^ {
        instance = [[KimonoClient alloc] init];
    });
    
    return instance;
}

- (AFHTTPRequestOperation *)fetchSummariesWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *params = @{@"apikey" : @"UTXwecz7u66PZKgeLKG3KcFLTQJ2LtjU"};
    
    return [self GET:@"https://www.kimonolabs.com/api/coyvgcjc" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)fetchEventImagesWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *params = @{@"apikey" : @"UTXwecz7u66PZKgeLKG3KcFLTQJ2LtjU"};
    
    return [self GET:@"https://www.kimonolabs.com/api/eetu0cjm" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)fetchEventDetailsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *params = @{@"apikey" : @"UTXwecz7u66PZKgeLKG3KcFLTQJ2LtjU"};
    
    return [self GET:@"https://www.kimonolabs.com/api/7vyz5imi" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)getSummaries {
    return [self fetchSummariesWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"get summaries");
        for (NSDictionary *item in response[@"results"][@"descriptions"]) {
            [self.placeSummaries setObject:item[@"description"] forKey:item[@"name"][@"text"]];
            [self.cityImages setObject:item[@"image"] forKey:item[@"name"][@"text"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed getting summaries %@", error.description);
    }];
}

- (AFHTTPRequestOperation *)getEventImages {
    return [self fetchEventImagesWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"get event images");
        for (NSDictionary *item in response[@"results"][@"events"]) {
            [self.eventImages setObject:item[@"imageUrl"][@"src"] forKey:item[@"event"][@"text"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed getting event images %@", error.description);
    }];
}

- (AFHTTPRequestOperation *)getEventDetails {
    return [self fetchEventDetailsWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"get event details");
        for (NSDictionary *item in response[@"results"][@"eventDetails"]) {
            [self.eventDetails setObject:item forKey:item[@"name"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed getting event details %@", error.description);
    }];
}

@end
