//
//  FavoritesViewController.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/10/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FavoritesViewController.h"
#import "City.h"
#import "CityTableViewCell.h"
#import "FavoritesManager.h"
#import "CityDetailsViewController.h"

NSString * const kCityCellIdentifier = @"CityCell";

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cities;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"Favorites";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:kCityCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.cities = [[FavoritesManager sharedInstance] favoritedCities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCellIdentifier];

    cell.city = self.cities[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CityDetailsViewController *cdvc = [[CityDetailsViewController alloc] init];
    cdvc.city = self.cities[indexPath.row];
    [self.navigationController pushViewController:cdvc animated:YES];
}

@end
