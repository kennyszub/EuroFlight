//
//  AirportSearchResultsControllerViewController.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airport.h"

@class AirportSearchResultsControllerViewController;

@protocol AirportSearchResultsControllerViewControllerDelegate <NSObject>

- (void)airportSearchResultsControllerViewController:(AirportSearchResultsControllerViewController *)airportsController didSelectAirport:(Airport *)airport;

@end

@interface AirportSearchResultsControllerViewController : UIViewController

@property (nonatomic, weak) id<AirportSearchResultsControllerViewControllerDelegate> delegate;

@end
