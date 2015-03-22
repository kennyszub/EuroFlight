//
//  PlaceCollectionViewCell.h
//  EuroFlight
//
//  Created by Helen Kuo on 3/10/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PlaceCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Place *place;
@property (weak, nonatomic) IBOutlet UIImageView *placeView;
@end
