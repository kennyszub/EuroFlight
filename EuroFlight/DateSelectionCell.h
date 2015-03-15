//
//  DateSelectionCell.h
//  EuroFlight
//
//  Created by Ken Szubzda on 3/14/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectionCell : UITableViewCell
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, assign) BOOL isDeparting;

@end
