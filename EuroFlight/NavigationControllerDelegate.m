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

@implementation NavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  {
    if ([fromVC isKindOfClass:[FlightResultsViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return [[FlightDetailsTransition alloc] init];
        }
    } else if ([fromVC isKindOfClass:[FlightDetailViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return [[FlightDetailsTransition alloc] init];
        }
    } else if ([fromVC isKindOfClass:[ResultsViewController class]] && [toVC isKindOfClass:[CityDetailsViewController class]]) {
        if (operation == UINavigationControllerOperationPush) {
            return (id <UIViewControllerAnimatedTransitioning>) fromVC; // tells the navigationController that fromVC implements UIViewControllerAnimatedTransitioning and can handle the transition. Same effect as doing vc.transitioningDelegate = self; for modal transitions.
        }
    } else if ([toVC isKindOfClass:[ResultsViewController class]] && [fromVC isKindOfClass:[CityDetailsViewController class]]) {
        if (operation == UINavigationControllerOperationPop) {
            return (id <UIViewControllerAnimatedTransitioning>) toVC;
        }
    }

    return nil;
}

@end
