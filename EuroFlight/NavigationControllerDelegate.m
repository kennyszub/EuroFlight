//
//  NavigationControllerDelegate.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/24/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "FlightResultsViewController.h"
#import "FlightDetailViewController.h"
#import "FlightDetailsTransition.h"
#import "ResultsViewController.h"
#import "CityDetailsViewController.h"
#import "PushTiltTransition.h"
#import "HomeViewController.h"

@interface NavigationControllerDelegate ()

@end
@implementation NavigationControllerDelegate

- (void)setNavController:(UINavigationController *)navController {
    _navController = navController;
    UIScreenEdgePanGestureRecognizer *screenPanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenPan:)];
    screenPanRecognizer.edges = UIRectEdgeLeft;
    // adds the gesture recognizer to every navigation controller view
    [navController.view addGestureRecognizer:screenPanRecognizer];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  {
    if ([fromVC isKindOfClass:[FlightResultsViewController class]] && [toVC isKindOfClass:[FlightDetailViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return [[PushTiltTransition alloc] initWithPushTransition:YES];
        }
    } else if ([fromVC isKindOfClass:[FlightDetailViewController class]] && [toVC isKindOfClass:[FlightResultsViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return [[PushTiltTransition alloc] initWithPushTransition:NO];
        }
    } else if ([fromVC isKindOfClass:[ResultsViewController class]] && [toVC isKindOfClass:[CityDetailsViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return [[PushTiltTransition alloc] initWithPushTransition:YES];
//            return (id <UIViewControllerAnimatedTransitioning>) fromVC; // tells the navigationController that fromVC implements UIViewControllerAnimatedTransitioning and can handle the transition. Same effect as doing vc.transitioningDelegate = self; for modal transitions.
        }
    } else if ([toVC isKindOfClass:[ResultsViewController class]] && [fromVC isKindOfClass:[CityDetailsViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return [[PushTiltTransition alloc] initWithPushTransition:NO];
//            return (id <UIViewControllerAnimatedTransitioning>) toVC;
        }
    } else if ([toVC isKindOfClass:[FlightResultsViewController class]] && [fromVC isKindOfClass:[CityDetailsViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return [[PushTiltTransition alloc] initWithPushTransition:YES];
        }
    } else if ([toVC isKindOfClass:[CityDetailsViewController class]] && [fromVC isKindOfClass:[FlightResultsViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return [[PushTiltTransition alloc] initWithPushTransition:NO];
        }
    } else if ([toVC isKindOfClass:[ResultsViewController class]] && [fromVC isKindOfClass:[HomeViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return [[PushTiltTransition alloc] initWithPushTransition:YES];
        }
    } else if ([toVC isKindOfClass:[HomeViewController class]] && [fromVC isKindOfClass:[ResultsViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return [[PushTiltTransition alloc] initWithPushTransition:NO];
        }
    } else if ([toVC isKindOfClass:[FlightResultsViewController class]] && [fromVC isKindOfClass:[ResultsViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return [[PushTiltTransition alloc] initWithPushTransition:YES];
        }
    } else if ([toVC isKindOfClass:[ResultsViewController class]] && [fromVC isKindOfClass:[FlightResultsViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return [[PushTiltTransition alloc] initWithPushTransition:NO];
        }
    }

    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransition;
}

- (void)screenPan:(UIScreenEdgePanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];

        [self.navController popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.navController.view];
        CGFloat percentTransitioned = (translation.x / CGRectGetWidth(self.navController.view.bounds));
        [self.interactiveTransition updateInteractiveTransition:percentTransitioned];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:self.navController.view].x > 0) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}

@end
