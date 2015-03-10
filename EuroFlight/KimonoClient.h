//
//  KimonoClient.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/8/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface KimonoClient : AFHTTPRequestOperationManager
@property (nonatomic, strong) NSMutableDictionary *placeSummaries;
@property (nonatomic, strong) NSMutableDictionary *cityImages;
@property (nonatomic, strong) NSMutableDictionary *eventImages;
@property (nonatomic, strong) NSMutableDictionary *eventDetails;
+ (KimonoClient *)sharedInstance;
@end
