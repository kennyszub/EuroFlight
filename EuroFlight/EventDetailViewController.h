//
//  EventDetailViewController.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSArray *events;

@end
