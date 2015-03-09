//
//  NameMappingHelper.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/8/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "NameMappingHelper.h"

@interface NameMappingHelper ()

@property (nonatomic, strong) NSMutableDictionary *airportCodeToCityCode;
@property (nonatomic, strong) NSMutableDictionary *cityCodeToCityName;

@end

@implementation NameMappingHelper

- (id)init {
    self = [super init];

    if (self) {
        self.airportCodeToCityCode = [NSMutableDictionary dictionary];
        self.cityCodeToCityName = [NSMutableDictionary dictionary];
    }

    return self;
}

+ (NameMappingHelper *)sharedInstance {
    static NameMappingHelper *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[NameMappingHelper alloc] init];
        }
    });

    return instance;
}

- (NSString *)cityNameForAirportCode:(NSString *)code {
    NSString *cityCode = self.airportCodeToCityCode[code];
    if (!cityCode) {
        return nil;
    }
    return self.cityCodeToCityName[cityCode];
}

- (void)parseTripData:(NSDictionary *)data {
    NSArray *airportData = data[@"airport"];
    for (NSDictionary *airport in airportData) {
        [self setCityCode:airport[@"city"] forAirportCode:airport[@"code"]];
    }

    NSArray *cityData = data[@"city"];
    for (NSDictionary *city in cityData) {
        [self setCityName:city[@"name"] forCityCode:city[@"code"]];
    }
}

- (void)setCityCode:(NSString *)cityCode forAirportCode:(NSString *)airportCode {
    [self.airportCodeToCityCode setValue:cityCode forKey:airportCode];
}

- (void)setCityName:(NSString *)name forCityCode:(NSString *)code {
    [self.cityCodeToCityName setValue:name forKey:code];
}

@end
