//
//  HomeViewController.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "HomeViewController.h"
#import "ResultsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearchButton:(id)sender {
    ResultsViewController *rvc = [[ResultsViewController alloc] initWithResults];
    [self.navigationController pushViewController:rvc animated:YES];
}

@end
