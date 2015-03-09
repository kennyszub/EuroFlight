//
//  PlaceCell.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PlaceCell.h"
#import "UIImageView+AFNetworking.h"
@interface PlaceCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeView;
    

@end

@implementation PlaceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlace:(Place *)place {
    _place = place;
    self.nameLabel.text = self.place.name;
    self.placeView.image = nil;
    [self.placeView setImageWithURL:[NSURL URLWithString:self.place.photoURL]];
}

@end
