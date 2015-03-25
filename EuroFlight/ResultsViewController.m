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

#define TRANSITION_DURATION 0.55

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate, CountryTableViewCellDelegate, UIViewControllerAnimatedTransitioning>
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

#pragma mark transition methods
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return TRANSITION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView]; // contains source and destination views
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform.m34 = 1.0 / -500;
    rotationTransform = CATransform3DRotate(rotationTransform, - 40.0f * M_PI / 180.0f, 0, 1, 0.0f);
    
    CATransform3D reverseRotationTransform = CATransform3DIdentity;
    reverseRotationTransform.m34 = 1.0 / -500;
    reverseRotationTransform = CATransform3DRotate(reverseRotationTransform, 40.0f * M_PI / 180.0f, 0, 1, 0.0f);
    
    CATransform3D noTransform = CATransform3DIdentity;
    noTransform = CATransform3DRotate(noTransform, 0, 0, 0, 0.0f);
    
    // TODO should be using bounds, not frame
    
    if ([fromViewController isKindOfClass:[ResultsViewController class]]) { // is presenting
        [containerView addSubview:toViewController.view];
        toViewController.view.frame = CGRectMake(self.view.frame.size.width + 18, 0, self.view.frame.size.width, self.view.frame.size.height);

        toViewController.view.layer.transform = reverseRotationTransform;
        
        [UIView animateWithDuration:TRANSITION_DURATION animations:^{
            toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            fromViewController.view.frame = CGRectMake(-self.view.frame.size.width - 18, 0, self.view.frame.size.width, self.view.frame.size.height);
            
            fromViewController.view.layer.transform = rotationTransform;
            toViewController.view.layer.transform = noTransform;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else { // must be dismissing
        [containerView addSubview:toViewController.view];
        toViewController.view.frame = CGRectMake(- fromViewController.view.frame.size.width - 18, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
        
        toViewController.view.layer.transform = rotationTransform;
        
        [UIView animateWithDuration:TRANSITION_DURATION animations:^{
            toViewController.view.frame = CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
            fromViewController.view.frame = CGRectMake(fromViewController.view.frame.size.width + 18, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
            
            fromViewController.view.layer.transform = reverseRotationTransform;
            toViewController.view.layer.transform = noTransform;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
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

- (void)didTapEvent:(CountryTableViewCell *)cell { // FIXME not being used, can be deleted
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
