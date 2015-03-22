//
//  PlaneLoadingView.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/22/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PlaneLoadingView.h"

@implementation PlaneLoadingView

// duration for each animation frame during the rotation
#define kFrameDuration 0.1
// duration for the initial "pull back" motion
#define kInitialBounceBackDuration 0.08
// duration for returning to neutral after the initial "pull back"
#define kInitialBounceForwardDuration 0.06
#define kInitialBounceDuration (kInitialBounceBackDuration + kInitialBounceForwardDuration)
// duration for the bounce after rotation
#define kFinalBounceForwardDuration 0.06
// duration for returning to neutral after bounce
#define kFinalBounceBackDuration 0.12

- (instancetype)init {
    self = [super init];

    if (self) {
        UIImageView *hudImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plane-logo-default"]];
        hudImage.frame = CGRectMake(0, 0, 37, 37);
        self.customView = hudImage;
        self.mode = MBProgressHUDModeCustomView;
    }

    return self;
}

- (void)show:(BOOL)animated {
    [super show:animated];

    [UIView animateKeyframesWithDuration:1.6 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:kInitialBounceBackDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, -45 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceBackDuration relativeDuration:kInitialBounceForwardDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, 45 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceDuration relativeDuration:kFrameDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, 90 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceDuration + kFrameDuration relativeDuration:kFrameDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, 90 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceDuration + (kFrameDuration * 2) relativeDuration:kFrameDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, 90 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceDuration + (kFrameDuration * 3) relativeDuration:kFrameDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, 90 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceDuration + (kFrameDuration * 4) relativeDuration:kFinalBounceForwardDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, 35 * M_PI / 180);
        }];
        [UIView addKeyframeWithRelativeStartTime:kInitialBounceDuration + kFinalBounceForwardDuration + (kFrameDuration * 4) relativeDuration:kFinalBounceBackDuration animations:^{
            self.transform = CGAffineTransformRotate(self.transform, -35 * M_PI / 180);
        }];
    } completion:^(BOOL finished) {
    }];
}

- (void)hide:(BOOL)animated {
    [self.layer removeAllAnimations];
    [super hide:animated];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
