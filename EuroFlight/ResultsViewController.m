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
#import "CityTableViewCell.h"

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *countries;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CountryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountryTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityTableViewCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithResults {
    self = [super init];
    if (self) {
        self.countries = [Country initCountries];
    }
    return self;
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *countryCell = [self.tableView dequeueReusableCellWithIdentifier:@"CountryTableViewCell"];
    countryCell.country = self.countries[indexPath.row];
    
    return countryCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countries.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
