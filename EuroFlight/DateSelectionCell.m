//
//  DateSelectionCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "DateSelectionCell.h"

@interface DateSelectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;

@end

@implementation DateSelectionCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    self.dateLabel.text = dateString;
}

- (void)setIsDeparting:(BOOL)isDeparting {
    _isDeparting = isDeparting;
    if (self.isDeparting) {
        self.directionLabel.text = @"Depart";
    } else {
        self.directionLabel.text = @"Return";
    }
}

@end
