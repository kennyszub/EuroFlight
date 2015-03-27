//
//  PushTiltTransition.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/25/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PushTiltTransition.h"

#define TRANSITION_DURATION 0.55
#define TILT_ANGLE 50.0f
#define VIEWS_GAP -10.0f

@interface PushTiltTransition ()
@property (nonatomic, assign) BOOL isPushTransition;

@end

@implementation PushTiltTransition

- (id)initWithPushTransition:(BOOL)isPushTransition {
    self = [super init];
    
    if (self) {
        self.isPushTransition = isPushTransition;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return TRANSITION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView]; // contains source and destination views
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform.m34 = 1.0 / -500;
    rotationTransform = CATransform3DRotate(rotationTransform, - TILT_ANGLE * M_PI / 180.0f, 0, 1, 0.0f);
    
    CATransform3D reverseRotationTransform = CATransform3DIdentity;
    reverseRotationTransform.m34 = 1.0 / -500;
    reverseRotationTransform = CATransform3DRotate(reverseRotationTransform, TILT_ANGLE * M_PI / 180.0f, 0, 1, 0.0f);
    
    CATransform3D noTransform = CATransform3DIdentity;
    noTransform = CATransform3DRotate(noTransform, 0, 0, 0, 0.0f);
    
    // TODO should be using bounds, not frame
    
    if (self.isPushTransition) { // is presenting
        [containerView addSubview:toViewController.view];
        toViewController.view.frame = CGRectMake(toViewController.view.bounds.size.width + VIEWS_GAP, 0, toViewController.view.bounds.size.width, toViewController.view.bounds.size.height);
        
        toViewController.view.layer.transform = reverseRotationTransform;
        
        [UIView animateWithDuration:TRANSITION_DURATION animations:^{
            toViewController.view.frame = CGRectMake(0, 0, toViewController.view.bounds.size.width, toViewController.view.bounds.size.height);
            fromViewController.view.frame = CGRectMake(-fromViewController.view.bounds.size.width - VIEWS_GAP, 0, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
            
            fromViewController.view.layer.transform = rotationTransform;
            toViewController.view.layer.transform = noTransform;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else { // must be dismissing
        [containerView addSubview:toViewController.view];
        toViewController.view.frame = CGRectMake(- toViewController.view.bounds.size.width - VIEWS_GAP, 0, toViewController.view.bounds.size.width, toViewController.view.bounds.size.height);
        
        toViewController.view.layer.transform = rotationTransform;
        
        [UIView animateWithDuration:TRANSITION_DURATION animations:^{
            toViewController.view.frame = CGRectMake(0, 0, toViewController.view.bounds.size.width, toViewController.view.bounds.size.height);
            fromViewController.view.frame = CGRectMake(fromViewController.view.bounds.size.width + VIEWS_GAP, 0, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
            
            fromViewController.view.layer.transform = reverseRotationTransform;
            toViewController.view.layer.transform = noTransform;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
