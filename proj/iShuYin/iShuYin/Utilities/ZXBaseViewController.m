//
//  ZXBaseViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXBaseViewController ()

@end

@implementation ZXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout =UIRectEdgeNone;  //tabar遮挡问题
    [self initialize];
    [self baseNavBar];
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor whiteColor],
    NSFontAttributeName:[UIFont systemFontOfSize:16]};
}

- (void)initialize {
    self.view.backgroundColor = kBackgroundColor;
}

- (void)baseNavBar {
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = kMainTone;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //[self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor *color = [kMainTone colorWithAlphaComponent:1];
    UIImage *img = [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:img
                                                  forBarMetrics:UIBarMetricsDefault];
    if (![NSStringFromClass([self class]) isEqualToString:@"HomeViewController"] &&
//        ![NSStringFromClass([self class]) isEqualToString:@"CategoryViewController"] &&
        ![NSStringFromClass([self class]) isEqualToString:@"SubscribeViewController"] &&
        ![NSStringFromClass([self class]) isEqualToString:@"MineViewController"]
        ) {
        [self addBackBtn];
    }
}

- (void)addBackBtn {
    [self addNavBtnWithImage:@"nav_back" target:self action:@selector(popBack:) isLeft:YES];
}

- (void)popBack:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public
- (void)addNavBtnWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    UIButton *btn = [UIButton buttonWithFrame:CGRectZero
                                         font:kFontSystem(14)
                                        title:title
                                   titleColor:color
                                       target:target
                                       action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addNavBtnWithImage:(NSString *)imgName target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
    UIButton *btn = [UIButton buttonWithFrame:CGRectZero
                                        image:imgName
                                       target:target
                                       action:action];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addNavBtnsWithImages:(NSArray *)images target:(id)target actions:(NSArray *)actions isLeft:(BOOL)isLeft {
    NSMutableArray *mArray = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(NSString * _Nonnull imgName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithFrame:CGRectZero
                                            image:imgName
                                           target:target
                                           action:NSSelectorFromString(actions[idx])];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [mArray addObject:item];
    }];
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = [mArray copy];
    }else {
        self.navigationItem.rightBarButtonItems = [mArray copy];
    }
}

//版本检测
- (void)requestAppUpdate {
    if (APPDELEGATE.hasShowVersionRemindAlert == YES) return;
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2AppVersion];
    NSDictionary *params = @{@"type":@"2"};
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            return;
            NSDictionary *data = responseObject[@"data"];
            NSString *version_name = data[@"version_name"];
            NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            NSComparisonResult result = [currentVersion compare:version_name options:NSNumericSearch];
            if (result == NSOrderedAscending) {
                //强制更新
                if ([data[@"is_force"]boolValue] == YES) {
                    BOOL ret = NO;
                    for (UIView *view in APPDELEGATE.window.subviews) {
                        if ([view isKindOfClass:[ZXPopView class]] && ((ZXPopView *)view).style == ZXPopViewStyleVersionForce) {
                            ret = YES;
                            break;
                        }
                    }
                    if (!ret) {
                        ZXPopView *view = [[ZXPopView alloc]initWithVersionInfoForce:responseObject[@"data"]];
                        [view showInView:APPDELEGATE.window animated:ZXPopViewAnimatedScale];
                    }
                }
                //提示更新
                else {
                    ZXPopView *view = [[ZXPopView alloc]initWithVersionInfoRemind:data];
                    [view showInView:APPDELEGATE.window animated:ZXPopViewAnimatedScale];
                    APPDELEGATE.hasShowVersionRemindAlert = YES;
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
