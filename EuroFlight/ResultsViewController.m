//
//  ResultsViewController.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "ResultsViewController.h"
#import "Country.h"
#import "CountryTableViewCell.h"
#import "City.h"
#import "CityDetailsViewController.h"
#import "Event.h"
#import "EventDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FlightResultsViewController.h"
#import "FavoritesViewController.h"

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate, CountryTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// keeps track of all countries
@property (strong, nonatomic) NSArray *allCountries;
// keeps track of the countries we're currently displaying (i.e. all or favorites-only)
@property (strong, nonatomic) NSArray *countries;
@property (nonatomic, assign) BOOL isFavoritesOnly;
@property (nonatomic, strong) NSMutableSet *indexPathsOfSelectedCells;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CountryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountryTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.title = @"Flight Results";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.indexPathsOfSelectedCells = [[NSMutableSet alloc] init];

    // set up favorites button
    UIImageView *favoritesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite-on"]];
    favoritesImageView.frame = CGRectMake(0, 0, 20, 20);
    favoritesImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavoritesButton)];
    [favoritesImageView addGestureRecognizer:tapGesture];
    UIBarButtonItem *favoritesButton = [[UIBarButtonItem alloc] initWithCustomView:favoritesImageView];
    self.navigationItem.rightBarButtonItem = favoritesButton;
    self.isFavoritesOnly = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithResults {
    self = [super init];
    if (self) {
        self.countries = [Country initCountries];
        self.allCountries = self.countries;
        [self sortCountriesList];
    }
    return self;
}

#pragma mark helper methods
+ (NSComparisonResult)compareFloats:(float)first secondFloat:(float)second {
    if (first == second) {
        return NSOrderedSame;
    } else if (first > second) {
        return NSOrderedDescending;
    } else {
        return NSOrderedAscending;
    }
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *countryCell =  [self.tableView dequeueReusableCellWithIdentifier:@"CountryTableViewCell" forIndexPath:indexPath];
    countryCell.country = (Country *) self.countries[indexPath.row];
    countryCell.delegate = self;
    countryCell.countryCellSelected = [self.indexPathsOfSelectedCells containsObject:indexPath];
    return countryCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countries.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CountryTableViewCell *cell = (CountryTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if ([self.indexPathsOfSelectedCells containsObject:indexPath]) {
        [self.indexPathsOfSelectedCells removeObject:indexPath];
        [cell showCityViews:NO];
    } else {
        [self.indexPathsOfSelectedCells addObject:indexPath];
        [cell showCityViews:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (void)didTapEvent:(CountryTableViewCell *)cell {
    EventDetailViewController *vc = [[EventDetailViewController alloc] init];
    vc.event = [cell.country.events objectAtIndex:cell.eventIndex];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapCityPrice:(City *)city {
    FlightResultsViewController *vc = [[FlightResultsViewController alloc] init];
    vc.city = city;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapInfo:(City *)city {
    CityDetailsViewController *vc = [[CityDetailsViewController alloc] init];
    vc.city = city;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onFavoritesButton {
    FavoritesViewController *fvc = [[FavoritesViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)sortCountriesList {
    self.countries = [self.countries sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        float price1 = ((Country *) obj1).lowestCost;
        float price2 = ((Country *) obj2).lowestCost;
        return [ResultsViewController compareFloats:price1 secondFloat:price2];
    }];
}

@end
