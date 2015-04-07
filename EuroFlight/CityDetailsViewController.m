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
#import "PlacesScrollCustomView.h"
#import "PlaneLoadingView.h"

NSInteger const kHeaderHeight = 150;

@interface CityDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *ticketButton;
@property (strong, nonatomic) UIImageView *headerView;
@property (strong, nonatomic) UIButton *button;
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, strong) UIImageView *transitionView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) NSInteger eventWidth;
@property (nonatomic, assign) NSInteger eventHeight;

@end

@implementation CityDetailsViewController

- (void)dealloc {
    self.tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.city.name;

    NSNumberFormatter *formatter = [CurrencyFormatter formatterWithCurrencyCode:self.city.currencyType];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:self.city.lowestCost]];
    [self.ticketButton setTitle:[NSString stringWithFormat:@"Find flights from %@", price] forState:UIControlStateNormal];
    
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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 42, 20, 22, 22)];
    [button addTarget:self
               action:@selector(onFavoriteButton:)
     forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    headerView.userInteractionEnabled = YES;
    self.button = button;
    [self setFavoriteButtonImage];
    [headerView addSubview:button];
    [self.tableView insertSubview:headerView atIndex:0];
    
    self.headerView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kHeaderHeight);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.button.frame = CGRectMake(self.headerView.frame.size.width - 42, 20, 22, 22);
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
    [self pushToFlightResults];
}

- (void)pushToFlightResults {
    FlightResultsViewController *vc = [[FlightResultsViewController alloc] init];
    vc.city = self.city;
    vc.showHUD = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onFavoriteButton:(id)sender {
    [self.city setFavoritedState:!self.city.isFavorited];
    [self setFavoriteButtonImage];

    [[NSNotificationCenter defaultCenter] postNotificationName:FavoritedNotification object:self];
}

- (void)setFavoriteButtonImage {
    if (self.city.isFavorited) {
        [self.button setBackgroundImage:[UIImage imageNamed:@"favorite-white-on"] forState:UIControlStateNormal];
    } else {
        [self.button setBackgroundImage:[UIImage imageNamed:@"favorite-white-off"] forState:UIControlStateNormal];
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
    UIImageView *placeView =((PlaceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]).placeView;
    self.transitionView = [[UIImageView alloc] initWithImage:placeView.image];
    self.transitionView.frame = [collectionView convertRect:[collectionView layoutAttributesForItemAtIndexPath:indexPath].frame toView:self.view];
    self.transitionView.contentMode = UIViewContentModeScaleAspectFill;
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

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPresenting) {
        if ([toViewController isKindOfClass:[PlacesViewController class]]) {
            self.blackView = [[UIView alloc] initWithFrame:fromViewController.view.frame];
            self.blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
            self.transitionView.clipsToBounds = YES;
            [containerView addSubview:self.blackView];
            [containerView addSubview:self.transitionView];
            self.blackView.alpha = 0;
            toViewController.view.frame = fromViewController.view.bounds;
            [containerView addSubview:toViewController.view];
            toViewController.view.alpha = 0;
            CGFloat widthScale = self.view.frame.size.width / self.transitionView.image.size.width;
            CGFloat heightScale = (self.view.frame.size.height - 200) / self.transitionView.image.size.height;
            CGFloat scale = (widthScale > heightScale) ? heightScale : widthScale;
            [UIView animateWithDuration:0.4 animations:^{
                self.blackView.alpha = 1;
                self.transitionView.center = self.view.center;
                self.transitionView.bounds = CGRectMake(0, 0, self.transitionView.image.size.width, self.transitionView.image.size.height);
                self.transitionView.transform = CGAffineTransformMakeScale(scale, scale);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    toViewController.view.alpha = 1;
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                    [self.transitionView removeFromSuperview];
                }];
            }];
        } else {
            toViewController.view.alpha = 0;
            self.blackView = [[UIView alloc] initWithFrame:fromViewController.view.frame];
            self.blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            self.blackView.alpha = 0;
            self.transitionView.clipsToBounds = YES;
            self.transitionView.layer.cornerRadius = 3;
            self.originalFrame = self.transitionView.frame;
            toViewController.view.clipsToBounds = YES;
            self.eventHeight = self.view.frame.size.height - 75;
            if (self.eventHeight > 550) self.eventHeight = 550;
            self.eventWidth = self.view.frame.size.width - 75;
            if (self.eventWidth % 2 == 1) self.eventWidth++;
            CGFloat scale = self.eventWidth / self.transitionView.frame.size.width;
            toViewController.view.frame = CGRectMake(0, 0, self.eventWidth, self.eventHeight);
            toViewController.view.center = self.view.center;
            [containerView addSubview:self.blackView];
            self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(self.transitionView.frame.origin.x, self.transitionView.frame.origin.y, self.transitionView.frame.size.width, self.transitionView.frame.size.height)];
            self.whiteView.backgroundColor = [UIColor whiteColor];
            self.blueView = [[UIView alloc] initWithFrame:CGRectMake(0, self.eventHeight/scale, self.whiteView.frame.size.width, 0)];
            self.blueView.backgroundColor = [[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0];
            self.whiteView.clipsToBounds = YES;
            [containerView addSubview:self.whiteView];
            [self.whiteView addSubview:self.blueView];
            [containerView addSubview:self.transitionView];
            [containerView addSubview:toViewController.view];
            [UIView animateWithDuration:0.4 animations:^{
                self.blackView.alpha = 1;
                self.transitionView.transform = CGAffineTransformMakeScale(scale, scale);
                self.transitionView.center = CGPointMake(self.view.center.x, self.view.center.y - (self.eventHeight / 2) + 100);
                self.transitionView.bounds = CGRectMake(0, 0, self.eventWidth/scale, 200/scale);
                self.whiteView.center = CGPointMake(self.view.center.x, self.view.center.y);
                self.whiteView.frame = CGRectMake(self.view.center.x - self.eventWidth / 2, self.view.center.y- self.eventHeight / 2, self.eventWidth, self.eventHeight);
                self.blueView.frame = CGRectMake(0, self.eventHeight - 50, self.eventWidth, 50);
                self.whiteView.layer.cornerRadius = 5;
                self.transitionView.layer.cornerRadius = 5 / scale;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    toViewController.view.alpha = 1;
                    toViewController.view.layer.cornerRadius = 5;
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
            }];
        }
    } else {
        if ([fromViewController isKindOfClass:[EventDetailViewController class]]) {
                [UIView animateWithDuration:0.1 animations:^{
                    fromViewController.view.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        self.blackView.alpha = 0;
                        self.transitionView.transform = CGAffineTransformIdentity;
                        self.transitionView.frame = self.originalFrame;
                        self.blueView.frame = CGRectMake(0, self.eventHeight/(self.eventWidth / self.originalFrame.size.width), self.originalFrame.size.width, 0);
                        self.whiteView.frame = self.transitionView.frame;
                    } completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                        [fromViewController.view removeFromSuperview];
                        [self.blackView removeFromSuperview];
                        [self.whiteView removeFromSuperview];
                        [self.blueView removeFromSuperview];
                        if ([fromViewController isKindOfClass:[EventDetailViewController class]] && ((EventDetailViewController *) fromViewController).selectedTickets) {
                            [self pushToFlightResults];
                        }
                    }];
                }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                fromViewController.view.alpha = 0;
                self.blackView.alpha = 0;
                self.transitionView.alpha = 0;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
                [fromViewController.view removeFromSuperview];
                [self.blackView removeFromSuperview];
            }];
        }
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
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    UIImageView *eventView =((EventCell *)[tableView cellForRowAtIndexPath:indexPath]).eventView;
    self.transitionView = [[UIImageView alloc] initWithImage:eventView.image];
    self.transitionView.frame = [[tableView cellForRowAtIndexPath:indexPath] convertRect:eventView.frame toView:self.view];
    self.transitionView.contentMode = UIViewContentModeScaleAspectFill;
    [self presentViewController:vc animated:YES completion:nil];
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
