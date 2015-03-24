//
//  EventCell.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/17/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell

@property (nonatomic, strong) Event *event;
@property (weak, nonatomic) IBOutlet UIImageView *eventView;
@end
