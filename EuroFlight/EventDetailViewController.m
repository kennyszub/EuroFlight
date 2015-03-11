//
//  EventDetailViewController.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "EventDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.index < self.events.count) {
    self.event = self.events[self.index];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = self.event.name;
    self.dateLabel.text = self.event.dateString;
    self.cityLabel.text = self.event.city;
    self.countryLabel.text = self.event.country;
    self.descriptionLabel.text = self.event.summary;
    [self.eventView setImageWithURL:[NSURL URLWithString:self.event.photoURL]];
    }
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
- (IBAction)onNext:(id)sender {
    self.index += 1;
    [self viewDidLoad];
}

@end
