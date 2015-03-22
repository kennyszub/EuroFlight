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
#import "AFNetworking.h"
#import "CityCustomMiniView.h"
#import "GPUImage.h"


@interface CountryTableViewCell () <CityCustomMiniViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *lowestPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (nonatomic, strong) NSMutableArray *customViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOfCityLabelConstraint;
@property (nonatomic, strong) GPUImageLevelsFilter *levelsFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;

@end

@implementation CountryTableViewCell

- (void)awakeFromNib {
    // Initialization code

    GPUImageLevelsFilter *levelsFilter = [[GPUImageLevelsFilter alloc] init];
    
    [levelsFilter setRedMin:0 gamma:1 max:255.0/255.0 minOut:0 maxOut:220/255.0];
    [levelsFilter setGreenMin:0 gamma:1 max:255.0/255.0 minOut:0 maxOut:220/255.0];
    [levelsFilter setBlueMin:0 gamma:1 max:255.0/255.0 minOut:0 maxOut:200/255.0];
    self.levelsFilter = levelsFilter;
    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:0.04];
    self.brightnessFilter = brightnessFilter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        for (CityCustomMiniView *cityview in self.customViews) {
            cityview.backgroundColor = [UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:0.35];
        }
    }
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        for (CityCustomMiniView *cityview in self.customViews) {
            cityview.backgroundColor = [UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:0.35];
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
    
    int cityRowHeight = 44;
    int initialPos = 60;
    for (int i = 0; i < self.country.cities.count; i++) {
        int y = initialPos + (cityRowHeight * i);
        CityCustomMiniView *cityView = [[CityCustomMiniView alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, cityRowHeight)];
        cityView.backgroundColor = [UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:0.35];

        cityView.city = self.country.cities[i];
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
        self.backgroundView = [[UIImageView alloc] initWithImage:responseObject];
        GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:responseObject];
        [self applyFilterToGPUImageView:imageSource];
        
        UIImage *filteredImage = [self.levelsFilter imageFromCurrentFramebuffer];
        UIImage *brightImage = [self getBrightenedImage:filteredImage];
        self.backgroundView = [[UIImageView alloc] initWithImage:filteredImage];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:brightImage];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

- (void)cityView:(CityCustomMiniView *)view didTapCityPrice:(City *)city {
    [self.delegate didTapCityPrice:city];
}

- (void)cityView:(CityCustomMiniView *)view didTapInfo:(City *)city {
    [self.delegate didTapInfo:city];
}

- (void)applyFilterToGPUImageView:(GPUImagePicture *)image {
    [image addTarget:self.levelsFilter];
    [self.levelsFilter useNextFrameForImageCapture];
    [image processImage];
}

- (UIImage *)getFilteredImage:(UIImage *)image {
    return [self.levelsFilter imageByFilteringImage:image];
    // Temperature filters below:
//    UIImage *levelsImage = [levelsFilter imageByFilteringImage:image];
//
//    GPUImageWhiteBalanceFilter *whiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
//    [whiteBalanceFilter setTemperature:9000];
//    
//    return [whiteBalanceFilter imageByFilteringImage:levelsImage];
}

- (UIImage *)getBrightenedImage:(UIImage *)image {
    return [self.brightnessFilter imageByFilteringImage:image];
}



- (void)showCityViews:(BOOL)showViews {
    // apply state with animation

    if (showViews) {
        CGFloat constantChange = self.topOfCityLabelConstraint.constant - 10;
        self.topOfCityLabelConstraint.constant -= constantChange;
        [UIView animateWithDuration:0.4 animations:^{
            [self.contentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            for (CityCustomMiniView *cityView in self.customViews) {
                [UIView transitionWithView:cityView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    cityView.hidden = !showViews;
                } completion:nil];
            }
        }];
    } else {
        
        for (CityCustomMiniView *cityView in self.customViews) {
            [UIView transitionWithView:cityView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                cityView.hidden = !showViews;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.topOfCityLabelConstraint.constant = 127;
                    [self.contentView layoutIfNeeded];
                }];
            }];
        }
    }
}



- (void)setCountryCellSelected:(BOOL)cellIsSelected {
    // apply state immediately

    _countryCellSelected = cellIsSelected;
    for (CityCustomMiniView *cityView in self.customViews) {
        cityView.hidden = !cellIsSelected;
    }
    if (cellIsSelected) {
        CGFloat constantChange = self.topOfCityLabelConstraint.constant - 10;
        self.topOfCityLabelConstraint.constant -= constantChange;
//        self.bottomOfCityLabelConstraint.constant += constantChange;
        [self.contentView layoutIfNeeded];
    } else {
        self.topOfCityLabelConstraint.constant = 127;
//        self.bottomOfCityLabelConstraint.constant = 112;
        [self.contentView layoutIfNeeded];
    }
}

- (IBAction)onEventTap:(id)sender {
    [self.delegate didTapEvent:self];
}

@end
