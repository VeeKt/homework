//
//  AppDelegate.h
//  CoreData
//
//  Created by user2 on 19.01.18.
//  Copyright © 2018 user2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong) UINavigationController *navigationControloler;

@property (nonatomic, strong) ViewController *rootViewController;

- (void)saveContext;


@end

