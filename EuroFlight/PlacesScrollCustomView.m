//
//  PlacesScrollCustomView.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/21/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PlacesScrollCustomView.h"
#import "UIImageView+AFNetworking.h"

@interface PlacesScrollCustomView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *placeView;
@property (weak, nonatomic) IBOutlet UILabel *placeName;

@end

@implementation PlacesScrollCustomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UINib *nib = [UINib nibWithNibName:@"PlacesScrollCustomView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
}

- (void)setPlace:(Place *)place {
    _place = place;
    [self.placeView setImageWithURL:[NSURL URLWithString:place.photoURL]];
    self.placeName.text = place.name;
}

@end
