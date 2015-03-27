//
//  ZoomTransition.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/22/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "ZoomTransition.h"
#import "BaseTransitionPrivate.h"
#import <UIKit/UIKit.h>

@interface ZoomTransition ()

@property (nonatomic, strong) UIView *blackView;

@end

@implementation ZoomTransition

- (instancetype)init {
    self = [super init];

    if (self) {
        // default scaling factors
        self.xScale = 0.95;
        self.yScale = 0.95;
    }

    return self;
}

- (void)presentTransitionInContainerView:(UIView *)containerView fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    self.blackView = [[UIView alloc] initWithFrame:containerView.frame];
    self.blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.blackView.alpha = 0;
    [containerView addSubview:self.blackView];
    toViewController.view.frame = containerView.frame;
    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:self.duration animations:^{
        toViewController.view.alpha = 1;
        toViewController.view.transform = CGAffineTransformMakeScale(self.xScale, self.yScale);
        self.blackView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:YES];
    }];
}

- (void)dismissTransitionInContainerView:(UIView *)containerView fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    [containerView insertSubview:toViewController.view belowSubview:self.blackView];
    [UIView animateWithDuration:self.duration animations:^{
        fromViewController.view.alpha = 0;
        fromViewController.view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self finish];
    }];
}

@end
