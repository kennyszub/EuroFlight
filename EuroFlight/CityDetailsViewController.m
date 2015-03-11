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

@interface CityDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation CityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlaceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlaceCollectionViewCell"];
    
    self.nameLabel.text = self.city.name;
    self.descriptionLabel.text = self.city.summary;
    
    [self setFavoriteButtonImage];
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
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite-off"] forState:UIControlStateNormal];
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



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
