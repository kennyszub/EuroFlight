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
#import "UIImage+Filtering.h"
#import "AFNetworking.h"
#import "CityCustomMiniView.h"

@interface CountryTableViewCell () <CityCustomMiniViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *lowestPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (nonatomic, strong) NSMutableArray *customViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOfCityLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOfCityLabelConstraint;

@end

@implementation CountryTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    [self hideCountryLabels];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        for (CityCustomMiniView *cityview in self.customViews) {
            cityview.backgroundColor = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:0.35]; /*#b2b2b2*/
        }
        // apply state with animation
//        [self showCityViews:YES];
    }
    

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        for (CityCustomMiniView *cityview in self.customViews) {
            cityview.backgroundColor = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:0.35]; /*#b2b2b2*/
        }
    }
}

- (void)prepareForReuse {
    for (UIView *view in [self.contentView subviews]) {
        if ([view isKindOfClass:[CityCustomMiniView class]]) {
            [view removeFromSuperview];
        }
    }

}



- (void)setCountry:(Country *)country {
    _country = country;
    self.countryName.text = country.name;
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:country.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.country.lowestCost]];
    self.lowestPriceLabel.text = [NSString stringWithFormat:@"from: %@", price];

    [self setCountryImage];
    
    self.eventIndex = -1;
    //NSLog(@"%@ %@", [Context currentContext].departureDate, [Context currentContext].returnDate);
    for (Event *event in country.events) {
        if ([event.startDate compare:[Context currentContext].departureDate] == NSOrderedDescending && [event.startDate compare:[Context currentContext].returnDate] == NSOrderedAscending) {
            self.eventIndex = [country.events indexOfObject:event];
        }
    }
    
    self.eventButton.hidden = (self.eventIndex < 0 ? YES : NO);
    
    [self createCityViews];
}

- (void)createCityViews {
    self.customViews = [[NSMutableArray alloc] init];
    
    int countryRowHeight = 300;
    int cityRowHeight = 44;
    for (int i = 1; i <= self.country.cities.count; i++) {
        int y = countryRowHeight - (cityRowHeight * i);
        CityCustomMiniView *cityView = [[CityCustomMiniView alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 44)];
        cityView.backgroundColor = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:0.35]; /*#b2b2b2*/
        cityView.city = self.country.cities[i - 1];
        cityView.delegate = self;
        [self.contentView addSubview:cityView];
        [self.customViews addObject:cityView];
    }
}

- (void)setCountryImage {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.country.countryPhotoURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImageView *countryImage = [[UIImageView alloc] initWithImage:responseObject];
        self.backgroundView = countryImage;
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[countryImage.image brightenWithValue:30]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

- (void)cityView:(CityCustomMiniView *)view didTapCity:(City *)city {
    [self.delegate didTapCity:city];
}



- (void)showCityViews:(BOOL)showViews {
    // apply state with animation

    for (CityCustomMiniView *cityView in self.customViews) {
        [UIView transitionWithView:cityView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            cityView.hidden = !showViews;
        } completion:nil];
    }
    if (showViews) {
        CGFloat constantChange = self.topOfCityLabelConstraint.constant - 5;
        self.topOfCityLabelConstraint.constant -= constantChange;
        self.bottomOfCityLabelConstraint.constant += constantChange;
        [UIView animateWithDuration:0.4 animations:^{
            [self.contentView layoutIfNeeded];
        }];
    } else {
        self.topOfCityLabelConstraint.constant = 138;
        self.bottomOfCityLabelConstraint.constant = 112;
        [UIView animateWithDuration:0.4 animations:^{
            [self.contentView layoutIfNeeded];
        }];
    }
}



- (void)setCountryCellSelected:(BOOL)cellIsSelected {
    // apply state immediately

    _countryCellSelected = cellIsSelected;
    for (CityCustomMiniView *cityView in self.customViews) {
        cityView.hidden = !cellIsSelected;
    }
    if (cellIsSelected) {
        CGFloat constantChange = self.topOfCityLabelConstraint.constant - 5;
        self.topOfCityLabelConstraint.constant -= constantChange;
        self.bottomOfCityLabelConstraint.constant += constantChange;
        [self.contentView layoutIfNeeded];
    } else {
        self.topOfCityLabelConstraint.constant = 138;
        self.bottomOfCityLabelConstraint.constant = 112;
        [self.contentView layoutIfNeeded];
    }
}

- (IBAction)onEventTap:(id)sender {
    [self.delegate didTapEvent:self];
}

@end
