//
//  CurrencyFormatter.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/11/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyFormatter : NSObject

+ (NSNumberFormatter *)formatterWithCurrencyCode:(NSString *)code;

@end
