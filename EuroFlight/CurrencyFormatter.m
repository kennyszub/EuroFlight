//
//  CurrencyFormatter.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/11/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CurrencyFormatter.h"

@implementation CurrencyFormatter

// TODO does this work for multiple currency codes?
+ (NSNumberFormatter *)formatterWithCurrencyCode:(NSString *)code {
    static NSNumberFormatter *sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedFormatter == nil) {
            sharedFormatter = [[NSNumberFormatter alloc] init];
            [sharedFormatter setCurrencyCode:code];
            [sharedFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [sharedFormatter setMaximumFractionDigits:0];
        }
    });
    return sharedFormatter;
}

@end
