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

@property (weak, nonatomic) IBOutlet UIImageView *eventView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
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
}

@end
