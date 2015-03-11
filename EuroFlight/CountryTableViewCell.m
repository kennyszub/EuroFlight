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
#import "Event.h"
#import "Context.h"
#import "CurrencyFormatter.h"

@interface CountryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *lowestPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;

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
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:country.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.country.lowestCost]];
    self.lowestPriceLabel.text = [NSString stringWithFormat:@"from: %@", price];
    self.countryImage.image = nil;
    [self.countryImage setImageWithURL:[NSURL URLWithString:self.country.countryPhotoURL]];
    self.countryImage.layer.cornerRadius = 3;
    self.eventIndex = -1;
    //NSLog(@"%@ %@", [Context currentContext].departureDate, [Context currentContext].returnDate);
    for (Event *event in country.events) {
        if ([event.startDate compare:[Context currentContext].departureDate] == NSOrderedDescending && [event.startDate compare:[Context currentContext].returnDate] == NSOrderedAscending) {
            self.eventIndex = [country.events indexOfObject:event];
        }
    }
    
    self.eventButton.hidden = (self.eventIndex < 0 ? YES : NO);
    
}

- (IBAction)onEventTap:(id)sender {
    [self.delegate didTapEvent:self];
}

@end
