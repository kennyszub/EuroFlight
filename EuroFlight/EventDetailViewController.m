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

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventView;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.event.name;
    self.dateLabel.text = self.event.dateString;
    self.cityLabel.text = self.event.locationString;
    self.descriptionLabel.text = self.event.summary;
    [self.eventView setImageWithURL:[NSURL URLWithString:self.event.photoURL]];
    
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
- (IBAction)onTickets:(id)sender {
    FlightResultsViewController *vc = [[FlightResultsViewController alloc] init];
    vc.city = self.event.city;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
