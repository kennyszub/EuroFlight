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

@interface HomeViewController () <THDatePickerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *outboundDateField;
@property (nonatomic, strong) THDatePickerViewController *datePicker;
@property (nonatomic, strong) NSDate *outboundDate;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, retain) NSDateFormatter *formatter;

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
    self.outboundDateField.delegate = self;
    self.outboundDate = [self getNextWeekdayDate:FRIDAY];
    self.returnDate = [self getNextWeekdayDate:SUNDAY];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"MMM d, y"];
    [self refreshOutboundDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearchButton:(id)sender {
    ResultsViewController *rvc = [[ResultsViewController alloc] initWithResults];
    [self.navigationController pushViewController:rvc animated:YES];
}



#pragma mark Date picker methods
- (void)refreshOutboundDate {
    self.outboundDateField.text = [self.formatter stringFromDate:self.outboundDate];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.outboundDate = datePicker.date;
    [self refreshOutboundDate];
    [self dismissSemiModalView];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.datePicker) {
        self.datePicker = [THDatePickerViewController datePicker];
    }
    self.datePicker.date = [NSDate date];
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableHistorySelection:YES];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
//    __weak typeof(self) weakSelf = self;
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        // FIXME uncheck to make markers appear on dates, but these aren't called each time calendar displayed
//        return [weakSelf isSameDayWithDate1:weakSelf.outboundDate date2:date]
//        || [weakSelf isSameDayWithDate1:weakSelf.returnDate date2:date];
        return NO;
    }];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.4),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
    return NO;
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
