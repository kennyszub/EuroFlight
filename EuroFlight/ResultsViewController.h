//
//  ResultsViewController.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController

- (id)initWithResults;
+ (NSComparisonResult) compareFloats:(float)first secondFloat:(float)second;

@end
