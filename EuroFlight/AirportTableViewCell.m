//
//  AirportTableViewCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AirportTableViewCell.h"

@interface AirportTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *airportNameLabel;

@end

@implementation AirportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAirport:(Airport *)airport {
    _airport = airport;
    self.airportNameLabel.text = airport.name;
}

@end
