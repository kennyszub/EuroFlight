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

    [self getCities];
    
    // set up favorites button
    UIImageView *favoritesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite-off"]];
    favoritesImageView.frame = CGRectMake(0, 0, 20, 20);
    favoritesImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavoritesButton)];
    [favoritesImageView addGestureRecognizer:tapGesture];
    UIBarButtonItem *favoritesButton = [[UIBarButtonItem alloc] initWithCustomView:favoritesImageView];
    self.navigationItem.rightBarButtonItem = favoritesButton;

    // add observer for when cities get favorited
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityWasFavorited) name:FavoritedNotification object:nil];
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

- (void)getCities {
    self.cities = [[FavoritesManager sharedInstance] favoritedCities];

    if (self.cities.count == 0) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

        messageLabel.text = @"You don't have any favorites yet.";
        messageLabel.textColor = [[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        [messageLabel sizeToFit];

        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self sortCitiesList];
    }
}

- (void)sortCitiesList {
    self.cities = [self.cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        float price1 = ((City *) obj1).lowestCost;
        float price2 = ((City *) obj2).lowestCost;
        return [@(price1) compare:@(price2)];
    }];
}

- (void)cityWasFavorited {
    [self getCities];
    [self.tableView reloadData];
}

@end
