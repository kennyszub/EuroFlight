//
//  EventCell.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/17/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "EventCell.h"
#import "UIImageView+AFNetworking.h"

@interface EventCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingLabel;


@end

@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
    self.eventView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEvent:(Event *)event {
    _event = event;
    self.eventView.image = nil;
    [self.eventView setImageWithURL:[NSURL URLWithString:event.photoURL]];
    self.dateLabel.text = event.dateString;
    self.nameLabel.text = event.name;
    if ([[NSDate dateWithTimeIntervalSinceNow:60*60*24*30] compare:event.startDate] == NSOrderedDescending) {
        self.upcomingLabel.hidden = NO;
    } else {
        self.upcomingLabel.hidden = YES;
    }
}

@end
