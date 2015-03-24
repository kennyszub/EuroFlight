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
#import "GPUImage.h"
#import "AFNetworking.h"

@interface FavoritesResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (nonatomic, strong) GPUImageLevelsFilter *levelsFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;

@end

@implementation FavoritesResultCell

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

    // Configure the view for the selected state
}

- (void)setCity:(City *)city {
    _city = city;

//    [self.cityImageView setImageWithURL:[NSURL URLWithString:city.imageURL]];
    [self setCountryImage];

    self.cityNameLabel.text = city.name;

    NSNumberFormatter *currencyFormatter = [CurrencyFormatter formatterWithCurrencyCode:city.currencyType];
    self.costLabel.text = [NSString stringWithFormat:@"From %@", [currencyFormatter stringFromNumber:@(city.lowestCost)]];
}

- (void)setCountryImage {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.city.imageURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (UIImage *)getBrightenedImage:(UIImage *)image {
    return [self.brightnessFilter imageByFilteringImage:image];
}

- (void)applyFilterToGPUImageView:(GPUImagePicture *)image {
    [image addTarget:self.levelsFilter];
    [self.levelsFilter useNextFrameForImageCapture];
    [image processImage];
}

@end
