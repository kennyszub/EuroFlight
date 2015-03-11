//
//  PlaceCollectionViewCell.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/10/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PlaceCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PlaceCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeView;


@end

@implementation PlaceCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setPlace:(Place *)place {
    _place = place;
    self.nameLabel.text = self.place.name;
    self.placeView.image = nil;
    [self.placeView setImageWithURL:[NSURL URLWithString:self.place.photoURL]];
}

@end
