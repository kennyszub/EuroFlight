//
//  GoogleSearchClient.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/16/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface GoogleSearchClient : AFHTTPRequestOperationManager

+ (GoogleSearchClient *)sharedInstance;

- (void)imageSearchWithQuery:(NSString *)query completion:(void (^)(NSArray *urls, NSError *error))completion;

@end
