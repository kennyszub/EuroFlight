//
//  NavigationControllerDelegate.h
//  EuroFlight
//
//  Created by Calvin Tuong on 3/24/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) UINavigationController *navController;

@end
