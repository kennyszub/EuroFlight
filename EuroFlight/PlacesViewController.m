//
//  PlacesViewController.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/21/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "PlacesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Place.h"
#import "PlacesScrollCustomView.h"

@interface PlacesViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.toolBar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [self.toolBar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
    self.navigationController.navigationBar.translucent = YES;
    for (int i = 0; i < self.places.count; i++) {
        CGFloat xOrigin = i *self.view.frame.size.width;
        PlacesScrollCustomView *placeView = [[PlacesScrollCustomView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        placeView.place = self.places[i];
        [self.scrollView addSubview:placeView];
    }
}

- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *subview = self.scrollView.subviews[i];
        CGFloat xOrigin = i *self.view.frame.size.width;
        [subview setFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
     [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*self.startingIndex, 0)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.places.count, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
