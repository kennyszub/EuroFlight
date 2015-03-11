//
//  HomeViewController.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "HomeViewController.h"
#import "ResultsViewController.h"
#import "THDatePickerViewController.h"
#import "Country.h"
#import "PlacesClient.h"
#import "KimonoClient.h"
#import "Event.h"
#import "FavoritesViewController.h"
#import "AirportSearchResultsControllerViewController.h"
#import "Context.h"

@interface HomeViewController () <THDatePickerDelegate, UITextFieldDelegate, AirportSearchResultsControllerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *outboundDateField;
@property (weak, nonatomic) IBOutlet UITextField *returnDateField;
@property (weak, nonatomic) IBOutlet UITextField *airportTextField;
@property (nonatomic, strong) THDatePickerViewController *outboundDatePicker;
@property (nonatomic, strong) THDatePickerViewController *returnDatePicker;
@property (nonatomic, strong) NSDate *outboundDate;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UILabel *dateErrorLabel;

enum Weeks {
    SUNDAY = 1,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
};

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //this is kind of a hack, but whatever (kimono stuff needs to be initialized before Cities are created)
    [KimonoClient sharedInstance];
    
    self.airportTextField.delegate = self;
    
    self.dateErrorLabel.hidden = YES;
    self.outboundDateField.delegate = self;
    self.outboundDate = [self getNextWeekdayDate:FRIDAY];
    [Context currentContext].departureDate = self.outboundDate;
    
    self.returnDateField.delegate = self;
    self.returnDate = [self getNextWeekdayDate:SUNDAY];
    [Context currentContext].returnDate = self.returnDate;
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"MMM d, y"];
    [self refreshDates];
    
    self.title = @"EuroFlight";

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

- (IBAction)onSearchButton:(id)sender {
    if ([self.outboundDate compare:self.returnDate] == NSOrderedDescending) {
        self.dateErrorLabel.hidden = NO;
    } else {
        self.dateErrorLabel.hidden = YES;
        ResultsViewController *rvc = [[ResultsViewController alloc] initWithResults];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

- (void)onFavoritesButton {
    FavoritesViewController *fvc = [[FavoritesViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)airportSearchResultsControllerViewController:(AirportSearchResultsControllerViewController *)airportsController didSelectAirport:(Airport *)airport {
    self.airportTextField.text = airport.code;
}

#pragma mark Date picker methods
- (void)refreshDates {
    self.outboundDateField.text = [self.formatter stringFromDate:self.outboundDate];
    self.returnDateField.text = [self.formatter stringFromDate:self.returnDate];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    if (datePicker == self.outboundDatePicker) {
        self.outboundDate = datePicker.date;
        [Context currentContext].departureDate = self.outboundDate;
    } else if (datePicker == self.returnDatePicker) {
        self.returnDate = datePicker.date;
        [Context currentContext].returnDate = self.returnDate;
    }
    [self refreshDates];
    [self dismissSemiModalView];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.dateErrorLabel.hidden = YES;
    if ([textField isEqual:self.outboundDateField]) {
        if (!self.outboundDatePicker) {
            self.outboundDatePicker = [THDatePickerViewController datePicker];
        }
        [self configureDatePicker:self.outboundDatePicker];
        [self presentSemiViewController:self.outboundDatePicker withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
    } else if ([textField isEqual:self.returnDateField]) {
        if (!self.returnDatePicker) {
            self.returnDatePicker = [THDatePickerViewController datePicker];
        }
        [self configureDatePicker:self.returnDatePicker];
        [self presentSemiViewController:self.returnDatePicker withOptions:@{
                                                                              KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                              KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                              }];
    } else if ([textField isEqual:self.airportTextField]) {
        AirportSearchResultsControllerViewController *avc = [[AirportSearchResultsControllerViewController alloc] init];
        avc.delegate = self;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:avc];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
    }
    
    return NO;
}

- (void)configureDatePicker:(THDatePickerViewController *)datePicker {
    if (datePicker == self.outboundDatePicker) {
        datePicker.date = self.outboundDate;
    } else if (datePicker == self.returnDatePicker) {
        datePicker.date = self.returnDate;
    }
    datePicker.delegate = self;
    [datePicker setAllowClearDate:NO];
    [datePicker setClearAsToday:YES];
    [datePicker setAutoCloseOnSelectDate:YES];
    [datePicker setAllowSelectionOfSelectedDate:YES];
    [datePicker setDisableHistorySelection:YES];
    [datePicker setDisableFutureSelection:NO];
    [datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
    //    __weak typeof(self) weakSelf = self;
    
    [datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        // FIXME uncheck to make markers appear on dates, but these aren't called each time calendar displayed
        //        return [weakSelf isSameDayWithDate1:weakSelf.outboundDate date2:date]
        //        || [weakSelf isSameDayWithDate1:weakSelf.returnDate date2:date];
        return NO;
    }];
}

- (NSDate *)getNextWeekdayDate:(enum Weeks)weekday {
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger todayWeekday = [weekdayComponents weekday];
    
    NSInteger moveDays = weekday - todayWeekday;
    if (moveDays <= 0) {
        moveDays += 7;
    }
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = moveDays;
    
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate* newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    return newDate;
}

- (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
