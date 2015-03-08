//
//  CityTableViewCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CityTableViewCell.h"

@interface CityTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

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
}

@end
