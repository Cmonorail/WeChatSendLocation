//
//  AppDelegate.h
//  WeChatLocationDemo
//
//  Created by 周英斌 on 2017/6/17.
//  Copyright © 2017年 周英斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

