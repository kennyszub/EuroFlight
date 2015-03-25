//
//  FlightDetailsTransition.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/24/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FlightDetailsTransition.h"
#import "BaseTransitionPrivate.h"

@implementation FlightDetailsTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformMakeScale(0, 0);

    [UIView animateWithDuration:self.duration animations:^{
        toViewController.view.alpha = 1;
        toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
