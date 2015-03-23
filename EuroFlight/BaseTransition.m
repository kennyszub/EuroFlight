//
//  BaseTransition.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/22/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "BaseTransition.h"
#import "BaseTransitionPrivate.h"
#import <UIKit/UIKit.h>

@interface BaseTransition ()

@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation BaseTransition

- (instancetype)init {
    self = [super init];

    self.duration = 0.5;

    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning methods

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.isPresenting) {
        [self presentTransitionInContainerView:containerView fromViewController:fromViewController toViewController:toViewController];
    } else {
        [self dismissTransitionInContainerView:containerView fromViewController:fromViewController toViewController:toViewController];
    }
}

- (void)presentTransitionInContainerView:(UIView *)containerView fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    // override in subclasses
}

- (void)dismissTransitionInContainerView:(UIView *)containerView fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    // override in subclasses
}

- (void)finish {
    if (!self.isPresenting) {
        UIViewController *fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [fromViewController.view removeFromSuperview];
    }

    [self.transitionContext completeTransition:YES];
}

@end
