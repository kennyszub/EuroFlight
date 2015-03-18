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

+ (PlacesClient *)sharedInstance {
    static PlacesClient *instance = nil;
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^ {
        instance = [[PlacesClient alloc] init];
    });
    
    return instance;
}

- (AFHTTPRequestOperation *)searchWithQuery:(NSString *)query success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
        NSDictionary *params = @{@"key" : kApiKey, @"query" : query};
    return [self GET:@"https://maps.googleapis.com/maps/api/place/textsearch/json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithCity:(NSString *)city success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self searchWithQuery:[NSString stringWithFormat:@"attractions in %@", city]success:success failure:failure];
}

+ (NSString *)photoURLWithPhotoReference:(NSString *)reference maxWidth:(NSInteger)width {
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxwidth=%ld", kApiKey, reference, width];
}

@end
