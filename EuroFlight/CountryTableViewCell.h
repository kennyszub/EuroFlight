//
//  CountryTableViewCell.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@class CountryTableViewCell;

@protocol CountryTableViewCellDelegate <NSObject>

- (void)didTapEvent:(CountryTableViewCell *)cell;
@end

@interface CountryTableViewCell : UITableViewCell

@property (nonatomic, strong) Country *country;
@property (nonatomic, weak) id<CountryTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger eventIndex;

@end
