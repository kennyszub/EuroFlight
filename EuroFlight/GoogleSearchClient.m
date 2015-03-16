//
//  GoogleSearchClient.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/16/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "GoogleSearchClient.h"

NSString * const kGoogleSearchBaseURL = @"https://www.googleapis.com/customsearch/v1";
NSString * const kGoogleSearchEngineId = @"011387016634526722520:i-ekolo9cui";
NSString * const kGoogleSearchAPIKey = @"AIzaSyBbclmABS0E2yjAUo1sVaIi69UwH-QOjjk";

@implementation GoogleSearchClient

+ (GoogleSearchClient *)sharedInstance {
    static GoogleSearchClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[GoogleSearchClient alloc] init];
            [instance.requestSerializer setValue:@"com.oks.EuroFlight" forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
        }
    });

    return instance;
}

- (void)imageSearchWithQuery:(NSString *)query completion:(void (^)(NSArray *urls, NSError *error))completion {
    // TODO imgSize: small?
    NSDictionary *params = @{ @"q": query, @"cx": kGoogleSearchEngineId, @"key": kGoogleSearchAPIKey, @"searchType": @"image"};
    [self GET:kGoogleSearchBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *items = responseObject[@"items"];
        NSArray *urls = [items valueForKeyPath:@"@unionOfObjects.link"];

        completion(urls, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
