//
//  CityDetailsViewController.m
//  EuroFlight
//
//  Created by Helen Kuo on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "CityDetailsViewController.h"
#import "PlaceCollectionViewCell.h"
#import "FlightResultsViewController.h"
#import "FavoritesManager.h"
#import "UIImageView+AFNetworking.h"
#import "CurrencyFormatter.h"
#import "EventCell.h"
#import "DescriptionCell.h"
#import "EventDetailViewController.h"
#import "PlaceCollectionCell.h"
#import "PlacesViewController.h"

NSInteger const kHeaderHeight = 150;

@interface CityDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *ticketButton;
@property (strong, nonatomic) UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation CityDetailsViewController

- (void)dealloc {
    self.tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView registerNib:[UINib nibWithNibName:@"PlaceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlaceCollectionViewCell"];
    
    self.title = self.city.name;
//    self.descriptionLabel.text = self.city.summary;
//    [self.cityView setImageWithURL:[NSURL URLWithString:self.city.imageURL]];

    [self setFavoriteButtonImage];
    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:self.city.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.city.lowestCost]];
    [self.ticketButton setTitle:[NSString stringWithFormat:@"Find tickets from %@", price] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EventCell" bundle:nil] forCellReuseIdentifier:@"EventCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DescriptionCell" bundle:nil] forCellReuseIdentifier:@"DescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceCollectionCell" bundle:nil] forCellReuseIdentifier:@"PlaceCollectionCell"];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, self.tableView.bounds.size.width, kHeaderHeight)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.clipsToBounds = YES;
    
    [headerView setImageWithURL:[NSURL URLWithString:self.city.imageURL]];
    [self.tableView insertSubview:headerView atIndex:0];
    
    self.headerView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kHeaderHeight);
    
    [self.view insertSubview:self.favoriteButton aboveSubview:self.tableView];

}

-(void)updateHeaderView {
    CGRect headerRect = CGRectMake(0, -kHeaderHeight, self.tableView.bounds.size.width, kHeaderHeight);
    if (self.tableView.contentOffset.y < -kHeaderHeight) {
        headerRect.origin.y = self.tableView.contentOffset.y;
        headerRect.size.height = -self.tableView.contentOffset.y;
    }
    self.headerView.frame = headerRect;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

- (IBAction)onTickets:(id)sender {
    FlightResultsViewController *vc = [[FlightResultsViewController alloc] init];
    vc.city = self.city;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onFavoriteButton:(id)sender {
    [self.city setFavoritedState:!self.city.isFavorited];
    [self setFavoriteButtonImage];
}

- (void)setFavoriteButtonImage {
    if (self.city.isFavorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-white-on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-white-off"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCollectionViewCell" forIndexPath:indexPath];
    cell.place = self.city.places[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.city.places.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlacesViewController *vc = [[PlacesViewController alloc] init];
    vc.places = self.city.places;
    vc.startingIndex = indexPath.row;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
//    
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
//    
//}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPresenting) {
        toViewController.view.frame = fromViewController.view.bounds;
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        //toViewController.view.transform = CGAffineTransformMakeScale(0,0);
        [UIView animateWithDuration:0.5 animations:^{
            toViewController.view.alpha = 1;
            //toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.city.events.count == 0) {
        return 2;
    } else {
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && self.city.events.count > 0) {
        return self.city.events.count;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DescriptionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
        cell.descriptionLabel.text = self.city.summary;
        return cell;
    } else if (indexPath.section == 1 && self.city.events.count > 0) {
        EventCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
        cell.event = self.city.events[indexPath.row];
        return cell;
    } else {
        PlaceCollectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceCollectionCell"];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        [cell.collectionView registerNib:[UINib nibWithNibName:@"PlaceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlaceCollectionViewCell"];
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Overview";
    } else if (section == 1 && self.city.events.count > 0){
        return @"Events";
    } else {
        return @"Attractions";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventDetailViewController *vc = [[EventDetailViewController alloc] init];
    vc.event = [self.city.events objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
