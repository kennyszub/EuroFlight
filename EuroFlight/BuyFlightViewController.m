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

@end

@implementation BuyFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
