//
//  AppDelegate.m
//  WidgetExample
//
//  Created by Sohail on 02/04/2020.
//  Copyright © 2020 Wrld. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIStoryboard *storyboard;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"TabletLayout" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"PhoneLayout" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
