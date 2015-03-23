//
//  BaseTransitionPrivate.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/22/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#ifndef EuroFlight_BaseTransitionPrivate_h
#define EuroFlight_BaseTransitionPrivate_h

#import <UIKit/UIKit.h>

@interface BaseTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

- (void)presentTransitionInContainerView:(UIView *)containerView fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (void)dismissTransitionInContainerView:(UIView *)containerView fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (void)finish;

@end

#endif
