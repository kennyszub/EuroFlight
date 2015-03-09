//
//  CountryTableViewCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CountryTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ResultsViewController.h"

@interface CountryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *lowestPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;

@end

@implementation CountryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCountry:(Country *)country {
    _country = country;
    self.countryName.text = country.name;
    NSNumberFormatter *formatter = [ResultsViewController currencyFormatterWithCurrencyCode:country.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.country.lowestCost]];
    self.lowestPriceLabel.text = [NSString stringWithFormat:@"from: %@", price];
    [self.countryImage setImageWithURL:[NSURL URLWithString:self.country.countryPhotoURL]];
    self.countryImage.layer.cornerRadius = 3;
}

@end
