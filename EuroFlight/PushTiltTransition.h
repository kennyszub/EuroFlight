//
//  PushTiltTransition.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/25/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PushTiltTransition : NSObject <UIViewControllerAnimatedTransitioning>
- (id)initWithPushTransition:(BOOL)isPushTransition;

@end
