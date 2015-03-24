//
//  FavoritesViewController.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/10/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "FavoritesViewController.h"
#import "City.h"
#import "FavoritesManager.h"
#import "CityDetailsViewController.h"
#import "FavoritesResultCell.h"
#import "CountryTableViewCell.h"

NSString * const kFavoritesResultCellIdentifier = @"FavoritesResultCell";

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
    [self.tableView registerNib:[UINib nibWithNibName:@"FavoritesResultCell" bundle:nil] forCellReuseIdentifier:kFavoritesResultCellIdentifier];

    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.cities = [[FavoritesManager sharedInstance] favoritedCities];
    [self sortCitiesList];
    
    // set up favorites button
    UIImageView *favoritesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite-on"]];
    favoritesImageView.frame = CGRectMake(0, 0, 20, 20);
    favoritesImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavoritesButton)];
    [favoritesImageView addGestureRecognizer:tapGesture];
    UIBarButtonItem *favoritesButton = [[UIBarButtonItem alloc] initWithCustomView:favoritesImageView];
    self.navigationItem.rightBarButtonItem = favoritesButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFavoritesButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoritesResultCellIdentifier];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

#pragma mark - Private methods

- (void)sortCitiesList {
    self.cities = [self.cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        float price1 = ((City *) obj1).lowestCost;
        float price2 = ((City *) obj2).lowestCost;
        return [@(price1) compare:@(price2)];
    }];
}

@end
