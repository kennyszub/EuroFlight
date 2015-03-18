//
//  CityCustomMiniView.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/16/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CityCustomMiniView.h"
#import "CurrencyFormatter.h"

@interface CityCustomMiniView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

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
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:city.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.city.lowestCost]];
    self.priceLabel.text = [NSString stringWithFormat:@"from: %@", price];
    [self setFavoriteButtonImageForCity:city];
}

- (IBAction)didTapCityView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.delegate cityView:self didTapCity:self.city];
    }
}

- (IBAction)onFavoriteButton:(id)sender {
    [self.city setFavoritedState:!self.city.isFavorited];
    [self setFavoriteButtonImageForCity:self.city];
}

- (void)setFavoriteButtonImageForCity:(City *)city {
    if (city.isFavorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-white-on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-white-off"] forState:UIControlStateNormal];
    }
}
- (IBAction)onInfoButton:(id)sender {
    [self.delegate cityView:self didTapInfo:self.city];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
