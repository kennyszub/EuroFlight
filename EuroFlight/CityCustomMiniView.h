//
//  CityCustomMiniView.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/16/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@class CityCustomMiniView;
@protocol CityCustomMiniViewDelegate <NSObject>

- (void)cityView:(CityCustomMiniView *)view didTapCity:(City *)city;

@end
@interface CityCustomMiniView : UIView

@property (nonatomic, strong) City *city;
@property (nonatomic, weak) id<CityCustomMiniViewDelegate> delegate;

@end
