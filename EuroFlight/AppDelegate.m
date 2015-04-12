//
//  AppDelegate.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

#import "CityDetailsViewController.h"
#import "Country.h"
#import "City.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:hvc];

    self.window.rootViewController = nvc;
    
    [self.window makeKeyAndVisible];
    [self configureNavBar];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        NSString *cityName = notification.userInfo[@"cityName"];
        NSString *eventName = notification.userInfo[@"eventName"];

        //    HomeViewController *hvc = [[HomeViewController alloc] init];
        //    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:hvc];
        // TODO this doesn't work if the user navigates to home view before backgrounding app
        UINavigationController *nvc = (UINavigationController *)self.window.rootViewController;
        CityDetailsViewController *cdvc = [[CityDetailsViewController alloc] init];

        NSArray *countries = [Country initCountries];
        for (Country *country in countries) {
            for (City *city in country.cities) {
                if ([city.name isEqualToString:cityName]) {
                    cdvc.city = city;
                    cdvc.eventName = eventName;
                    NSLog(@"Pushing city details for %@", city.name);
                    [nvc pushViewController:cdvc animated:YES];
                    return;
                }
            }
        }

        NSLog(@"Couldn't find the proper city... pushing CityDetailsViewController anyway");
        [nvc pushViewController:cdvc animated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configureNavBar {
    // set navigation bar colors
    //to set navigation bar to transparent
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    [[UINavigationBar appearance] setTranslucent:YES];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBarTintColor:[[UIColor alloc] initWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0]];

    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [[UIColor alloc] initWithRed:39/255.0 green:159/255.0 blue:190/255.0 alpha:1.0], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f], NSFontAttributeName,
      
      nil]];
    [[UINavigationBar appearance] setTranslucent:YES]; // this fixes the UISearchBar overlapping the status bar for some reason??
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
