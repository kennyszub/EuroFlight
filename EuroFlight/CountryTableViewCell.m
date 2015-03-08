//
//  CountryTableViewCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CountryTableViewCell.h"

@interface CountryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *countryName;

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
}

@end
