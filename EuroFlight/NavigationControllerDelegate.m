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
    }

    return nil;
}

@end
