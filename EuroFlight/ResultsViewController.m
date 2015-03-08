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
#import "City.h"

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *countries;
@property (nonatomic, assign) NSInteger currentExpandedIndex;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CountryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountryTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithResults {
    self = [super init];
    if (self) {
        self.countries = [Country initCountries];
        self.currentExpandedIndex = -1;
    }
    return self;
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChild = self.currentExpandedIndex > -1
        && indexPath.row > self.currentExpandedIndex
        && indexPath.row <= self.currentExpandedIndex + ((Country *) self.countries[self.currentExpandedIndex]).cities.count;
    UITableViewCell *cell;
    if (isChild) {
        CityTableViewCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell"];
        cityCell.city = ((Country *) self.countries[self.currentExpandedIndex]).cities[indexPath.row - self.currentExpandedIndex - 1];
        cell = cityCell;

    } else {
        CountryTableViewCell *countryCell =  [self.tableView dequeueReusableCellWithIdentifier:@"CountryTableViewCell"];
        NSInteger topIndex;
        if (self.currentExpandedIndex > -1 && indexPath.row > self.currentExpandedIndex) {
            topIndex = indexPath.row - ((Country *) self.countries[self.currentExpandedIndex]).cities.count;
        } else {
            topIndex = indexPath.row;
        }
        countryCell.country = (Country *) self.countries[topIndex];
        cell = countryCell;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentExpandedIndex > -1) {
        return ((Country *) self.countries[self.currentExpandedIndex]).cities.count + self.countries.count;
    } else {
        return self.countries.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChild = self.currentExpandedIndex > -1
    && indexPath.row > self.currentExpandedIndex
    && indexPath.row <= self.currentExpandedIndex + ((Country *) self.countries[self.currentExpandedIndex]).cities.count;
    if (isChild) {
        return;
    }
    
    [self.tableView beginUpdates];

    if (self.currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:self.currentExpandedIndex];
        self.currentExpandedIndex = -1;
    }  else {
        BOOL shouldCollapse = self.currentExpandedIndex > -1;
        if (shouldCollapse) {
            [self collapseSubItemsAtIndex:self.currentExpandedIndex];
        }
        if (shouldCollapse && indexPath.row > self.currentExpandedIndex) {
            self.currentExpandedIndex = indexPath.row - ((Country *) self.countries[self.currentExpandedIndex]).cities.count;
        } else {
            self.currentExpandedIndex = indexPath.row;
        }
        [self expandItemAtIndex:self.currentExpandedIndex];
    }
    
    [self.tableView endUpdates];
    
}

- (void)collapseSubItemsAtIndex:(NSInteger)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSInteger i = index + 1; i <= index + ((Country *) self.countries[index]).cities.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)expandItemAtIndex:(NSInteger)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = ((Country *) self.countries[index]).cities;
    NSInteger insertPos = index + 1;
    for (int i = 0; i < currentSubItems.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
