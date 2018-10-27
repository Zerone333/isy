//
//  ZXMainViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXMainViewController.h"
#import "LoginViewController.h"

@interface ZXMainViewController ()<UITabBarControllerDelegate>

@end

@implementation ZXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBar.translucent = NO; 
    self.delegate = self;
    [self configViewControllers];
}

- (void)configViewControllers{
    NSArray *itemArray = @[
                           @{CYLTabBarItemTitle:@"发现",
                             CYLTabBarItemImage:@"tabbar_find_nor",
                             CYLTabBarItemSelectedImage:@"tabbar_find_sel",
                             },
                           @{CYLTabBarItemTitle:@"订阅",
                             CYLTabBarItemImage:@"tabbar_subscribe_nor",
                             CYLTabBarItemSelectedImage:@"tabbar_subscribe_sel",
                             },
                           @{CYLTabBarItemTitle:@"下载",
                             CYLTabBarItemImage:@"tabbar_download_nor",
                             CYLTabBarItemSelectedImage:@"tabbar_download_sel",
                             },
                           @{CYLTabBarItemTitle:@"我的",
                             CYLTabBarItemImage:@"tabbar_mine_nor",
                             CYLTabBarItemSelectedImage:@"tabbar_mine_sel",
                             },
                           ];
    self.tabBarItemsAttributes = itemArray;
    
    NSArray *vcArray = @[@"HomeViewController",@"SubscribeViewController",
                         @"SubscribeViewController",@"MineViewController"];
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:vcArray.count];
    for (NSString *str in vcArray) {
        Class cls = NSClassFromString(str);
        UIViewController *vc = [[cls alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [mArray addObject:nav];
    }
    [self setViewControllers:mArray];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 0 || index == 1) {
        return YES;
    }
    if (APPDELEGATE.loginModel) {
        return YES;
    }
    LoginViewController *vc = SBVC(@"LoginVC");
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    return NO;
}

- (void)dealloc {
    self.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
