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
@property (weak, nonatomic) IBOutlet UIView *labelBackgroundView;
@end

@implementation PlaceCollectionViewCell

- (void)awakeFromNib {
    //self.placeView.layer.cornerRadius = 3;
    // Initialization code
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.labelBackgroundView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       nil];
    [gradient setStartPoint:CGPointMake(0.0f, 1.0f)];
    [gradient setEndPoint:CGPointMake(0.0f, 0.0f)];
    [self.labelBackgroundView.layer setMask:gradient];
}

- (void)setPlace:(Place *)place {
    _place = place;
    self.nameLabel.text = self.place.name;
    self.placeView.image = nil;
    self.placeView.backgroundColor = [UIColor lightGrayColor];
    [self.placeView setImageWithURL:[NSURL URLWithString:self.place.photoURL]];
}

@end
