//
//  FavoritesResultCell.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/17/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FavoritesResultCell.h"
#import <UIImageView+AFNetworking.h>
#import "CurrencyFormatter.h"

@interface FavoritesResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation FavoritesResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCity:(City *)city {
    _city = city;

    [self.cityImageView setImageWithURL:[NSURL URLWithString:city.imageURL]];
    self.cityNameLabel.text = city.name;

    NSNumberFormatter *currencyFormatter = [CurrencyFormatter formatterWithCurrencyCode:city.currencyType];
    self.costLabel.text = [NSString stringWithFormat:@"From %@", [currencyFormatter stringFromNumber:@(city.lowestCost)]];
}

@end
