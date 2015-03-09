//
//  PlacesClient.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PlacesClient.h"

@implementation PlacesClient

//NSString * const kApiKey = @"AIzaSyC2InBTC3Q8lelPtJHNCCtbFgvbw1n0O44";
NSString * const kApiKey = @"AIzaSyD8qHwJn4c7FFdSNDEtu19Cot2UlP3WHnc";

-(id)init {
    self = [super init];
    if (self) {
        self.placeSummaries = [self getSummaries];
    }
    return self;
}

+ (PlacesClient *)sharedInstance {
    static PlacesClient *instance = nil;
    
    if (instance == nil) {
        instance = [[PlacesClient alloc] init];
    }
    
    return instance;
}

- (AFHTTPRequestOperation *)searchWithCity:(NSString *)city success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *params = @{@"key" : kApiKey, @"query" : [NSString stringWithFormat:@"attractions in %@", city]};
    
    return [self GET:@"https://maps.googleapis.com/maps/api/place/textsearch/json" parameters:params success:success failure:failure];
}

+ (NSString *)photoURLWithPhotoReference:(NSString *)reference maxWidth:(NSInteger)width {
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxwidth=%ld", kApiKey, reference, width];
}

- (AFHTTPRequestOperation *)fetchSummariesWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary *params = @{@"apikey" : @"UTXwecz7u66PZKgeLKG3KcFLTQJ2LtjU"};
    
    return [self GET:@"https://www.kimonolabs.com/api/coyvgcjc" parameters:params success:success failure:failure];
}

- (NSDictionary *)getSummaries {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [self fetchSummariesWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        for (NSDictionary *item in response[@"results"][@"descriptions"]) {
            [dictionary setObject:item[@"description"] forKey:item[@"name"][@"text"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed getting summaries %@", error.description);
    }];
    return dictionary;
}

@end
