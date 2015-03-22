//
//  OneWayRoundTripCell.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "OneWayRoundTripCell.h"
#import "UIImage+Util.h"

@interface OneWayRoundTripCell ()
@property (nonatomic, strong) UIButton *oneWayButton;
@property (nonatomic, strong) UIButton *roundTripButton;

@end

@implementation OneWayRoundTripCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    UIImage *grayColor = [UIImage imageWithColor:[UIColor colorWithRed:0.839 green:0.839 blue:0.839 alpha:0.2]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:grayColor]; /*#d6d6d6*/
    
    [self setUpOneWayButton];
    [self setUpRoundTripButton];

    self.roundTripButton.selected = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.roundTripButton.frame = CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height);
    self.oneWayButton.frame = CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpRoundTripButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"Round-trip" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"Verdana" size:15];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.clipsToBounds = YES;
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]] forState:UIControlStateSelected];

    [button addTarget:self action:@selector(onRoundTripButton) forControlEvents:UIControlEventTouchUpInside];
    self.roundTripButton = button;
    [self addSubview:button];
}

- (void)setUpOneWayButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"One-way" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"Verdana" size:15];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.clipsToBounds = YES;
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]] forState:UIControlStateSelected];

    button.selected = NO;
    self.oneWayButton = button;
    [button addTarget:self action:@selector(onOneWayButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)onOneWayButton {
    if (self.roundTripButton.selected) {
        self.roundTripButton.selected = NO;
        self.oneWayButton.selected = YES;
        [self.delegate oneWayRoundTripCellDelegate:self didSelectRoundTrip:NO];
    }
}

- (void)onRoundTripButton {
    if (self.oneWayButton.selected) {
        self.oneWayButton.selected = NO;
        self.roundTripButton.selected = YES;
        [self.delegate oneWayRoundTripCellDelegate:self didSelectRoundTrip:YES];
    }
}

@end
