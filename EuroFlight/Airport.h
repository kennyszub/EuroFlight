//
//  Airport.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airport : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)airportsWithArray:(NSArray *)array;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;

@end
