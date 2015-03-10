//
//  CityTableViewCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CityTableViewCell.h"
#import "ResultsViewController.h"

@interface CityTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation CityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCity:(City *)city {
    _city = city;
    self.cityNameLabel.text = city.name;
    NSNumberFormatter *formatter = [ResultsViewController currencyFormatterWithCurrencyCode:city.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.city.lowestCost]];
    self.priceLabel.text = [NSString stringWithFormat:@"from: %@", price];
    [self setFavoriteButtonImageForCity:city];
}

- (IBAction)onFavoriteButton:(id)sender {
    [self.city setFavoritedState:!self.city.isFavorited];
    [self setFavoriteButtonImageForCity:self.city];
}

- (void)setFavoriteButtonImageForCity:(City *)city {
    if (city.isFavorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-off"] forState:UIControlStateNormal];
    }
}

@end
