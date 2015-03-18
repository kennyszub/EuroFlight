//
//  CityCustomMiniView.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/16/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CityCustomMiniView.h"

@interface CityCustomMiniView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end

@implementation CityCustomMiniView

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
    UINib *nib = [UINib nibWithNibName:@"CityCustomMiniView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)setCity:(City *)city {
    _city = city;
    self.cityNameLabel.text = city.name;
}

- (IBAction)didTapCityView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.delegate cityView:self didTapCity:self.city];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
