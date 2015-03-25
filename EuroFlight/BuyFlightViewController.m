//
//  BuyFlightViewController.m
//  EuroFlight
//
//  Created by Calvin Tuong on 3/11/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "BuyFlightViewController.h"
#import <WebKit/WebKit.h>

@interface BuyFlightViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)onCloseButton:(id)sender;

@end

@implementation BuyFlightViewController

// TODO the nib is currently set up as iPhone 6 because of the weird clipping issue
// don't think it's worth my time to figure out right now so just setting it to iPhone 6 by default

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
}

- (void)viewWillAppear:(BOOL)animated {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.containerView addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
