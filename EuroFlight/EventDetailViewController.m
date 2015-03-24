//
//  EventDetailViewController.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "EventDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FlightResultsViewController.h"

NSInteger const kScrollHeaderHeight = 200;

@interface EventDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.toolBar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [self.toolBar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
    self.title = self.event.name;
    self.dateLabel.text = self.event.dateString;
    self.cityLabel.text = self.event.locationString;
    self.descriptionLabel.text = self.event.summary;
    [self.eventView setImageWithURL:[NSURL URLWithString:self.event.photoURL]];
    self.nameLabel.text = self.event.name;
    self.scrollView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateHeaderView {
    CGRect headerRect = CGRectMake(0, 0, self.view.bounds.size.width, kScrollHeaderHeight);
    if (self.scrollView.contentOffset.y < 0) {
        headerRect.origin.y = self.scrollView.contentOffset.y;
        headerRect.size.height = -self.scrollView.contentOffset.y + kScrollHeaderHeight;
    }
    self.eventView.frame = headerRect;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTickets:(id)sender {
    FlightResultsViewController *vc = [[FlightResultsViewController alloc] init];
    vc.city = self.event.city;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
