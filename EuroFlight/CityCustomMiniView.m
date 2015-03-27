//
//  CityCustomMiniView.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/16/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CityCustomMiniView.h"
#import "CurrencyFormatter.h"

@interface CityCustomMiniView () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, assign) CGPoint initialPressPosition;
@property (nonatomic, assign) BOOL touchIsValid;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@end

@implementation CityCustomMiniView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UINib *nib = [UINib nibWithNibName:@"CityCustomMiniView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.longPressGestureRecognizer.delegate = self;
}

- (void)setCity:(City *)city {
    _city = city;
    self.cityNameLabel.text = city.name;
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:city.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.city.lowestCost]];
    [self.priceButton setTitle:[NSString stringWithFormat:@"from %@", price] forState:UIControlStateNormal];
    [self setFavoriteButtonImageForCity:city];
}

- (IBAction)didTapPrice:(id)sender {
    [self.delegate cityView:self didTapCityPrice:self.city];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.favoriteButton || touch.view == self.priceButton) {
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)onCellLongPress:(UILongPressGestureRecognizer *)sender {
    CGPoint currentPoint = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.initialPressPosition = currentPoint;
        self.touchIsValid = YES;
        self.backgroundColor= [UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:0.65];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        int changeInX = abs(self.initialPressPosition.x - [sender locationInView:self].x);
        int changeInY = abs(self.initialPressPosition.y - [sender locationInView:self].y);
        
        if (changeInX > 5 || changeInY > 5) {
            self.backgroundColor= [UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:0.35];
            self.touchIsValid = NO;
        }

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        int changeInX = abs(self.initialPressPosition.x - [sender locationInView:self].x);
        int changeInY = abs(self.initialPressPosition.y - [sender locationInView:self].y);
        
        self.backgroundColor= [UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:0.35];
        if ((changeInX <= 5 || changeInY <= 5) && self.touchIsValid) {
            [self.delegate cityView:self didTapInfo:self.city];
        }
    }

}

- (IBAction)onFavoriteButton:(id)sender {
    [self.city setFavoritedState:!self.city.isFavorited];
    [self setFavoriteButtonImageForCity:self.city];
}

- (void)setFavoriteButtonImageForCity:(City *)city {
    if (city.isFavorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-white-on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-white-off"] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
