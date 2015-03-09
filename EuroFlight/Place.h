//
//  Place.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *name;
+ (NSArray *)placesWithArray:(NSArray *)array;
@end
