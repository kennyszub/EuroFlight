//
//  PlacesClient.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface PlacesClient : AFHTTPRequestOperationManager
@property (nonatomic, strong) NSDictionary *placeSummaries;
+ (PlacesClient *)sharedInstance;

- (AFHTTPRequestOperation *)searchWithCity:(NSString *)city success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSString *)photoURLWithPhotoReference:(NSString *)reference maxWidth:(NSInteger)width;

@end
