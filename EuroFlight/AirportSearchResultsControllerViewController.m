//
//  AirportSearchResultsControllerViewController.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/9/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AirportSearchResultsControllerViewController.h"
#import "AirportTableViewCell.h"
#import "AirportClient.h"
#import "LocationManager.h"

@interface AirportSearchResultsControllerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIBarPositioningDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *filteredAirports;

@end

@implementation AirportSearchResultsControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AirportTableViewCell" bundle:nil] forCellReuseIdentifier:@"AirportTableViewCell"];
    
    self.filteredAirports = @[];
    self.title = @"Search Airports";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelTapped)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // TODO should not be initializing here, only setting the frame
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.searchBar.tintColor = [[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    
    // auto populate with closest airports
    [[LocationManager sharedInstance] getCurrentLocationWithCompletion:^(CLLocation *location) {
        [[AirportClient sharedInstance] searchAirportByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude completion:^(NSMutableArray *airports, NSError *error) {
            if (airports.count > 0) {
                self.filteredAirports = airports;
                [self.tableView reloadData];
            }
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length < 2) {
        return;
    }
    [[AirportClient sharedInstance] searchAirportByName:searchText completion:^(NSMutableArray *airports, NSError *error) {
        if (error != nil || airports.count == 0) {
            self.filteredAirports = @[];
            return;
        }
        self.filteredAirports = airports;
        [self.tableView reloadData];
    }];
}

- (void)cancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AirportTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AirportTableViewCell"];
    cell.airport = self.filteredAirports[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredAirports.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AirportTableViewCell *cell = (AirportTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [self.delegate airportSearchResultsControllerViewController:self didSelectAirport:cell.airport];
    [self.searchController setActive:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}



@end
