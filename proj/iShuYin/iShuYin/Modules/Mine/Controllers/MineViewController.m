//
//  MineViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "MineHeader.h"
#import "MineFooter.h"
#import "ZXMainViewController.h"
#import "HistoryViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MineHeader *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MineViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
//    self.header.coin = APPDELEGATE.loginModel.user_point;
//    self.header.point = APPDELEGATE.loginModel.pay_point;
//    self.header.balance = APPDELEGATE.loginModel.user_money;
//    self.header.name = APPDELEGATE.loginModel.user_name;
    self.header.loginModel = APPDELEGATE.loginModel;
    self.header.config = [USERDEFAULTS objectForKey:kUserConfigHeader];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"我的"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"MineCell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.dict = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 332;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 76.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MineFooter *footer = [MineFooter loadFromNib];
    __weak __typeof(self)weakSelf = self;
    footer.logoutBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf logoutBtnClick];
    };
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [self requestAppUpdate];
        return;
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    [self pushWithClassString:dict[@"ctrl"]];
}
//版本检测
- (void)requestAppUpdate {
    [ZXProgressHUD showLoading:@""];
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2AppVersion];
    NSDictionary *params = @{@"type":@"2"};
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        [ZXProgressHUD hide];
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            NSDictionary *data = responseObject[@"data"];
            if ([data isKindOfClass:[NSNull class]]) {
                [SVProgressHUD showImage:nil status:@"最新版本啦～"];
                return ;
            }
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
        [ZXProgressHUD hide];
        DLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Methods
- (void)pushWithStoryboardIdentity:(NSString *)identity {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:identity bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identity];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWithClassString:(NSString *)string {
    if ([NSString isEmpty:string]) {
        [SVProgressHUD showImage:nil status:@"敬请期待～"];
        return;
    }
    if ([string isEqualToString:@"FindPswdViewController"]) {
        UIViewController *vc = SBVC(@"FindPswdVC");
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    Class cls = NSClassFromString(string);
    UIViewController *vc = [[cls alloc]init];
    if ([vc isKindOfClass:[UIViewController class]]) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action
- (void)logoutBtnClick {
    //退出接口
    [USERDEFAULTS removeObjectForKey:kAutoLogin];
    [USERDEFAULTS removeObjectForKey:kRememberPswd];
    [USERDEFAULTS removeObjectForKey:kLoginType];
    [USERDEFAULTS removeObjectForKey:kUserName];
    [USERDEFAULTS removeObjectForKey:kUniqueId];
    [USERDEFAULTS removeObjectForKey:kHeadUrl];

    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    [manager clearCache];
    APPDELEGATE.loginModel = nil;
    [self.navigationController.tabBarController setSelectedIndex:0];
    NSString *url = [manager URLStringWithQuery:QueryLogout];
    [manager GETWithURLString:url parameters:nil progress:nil success:nil failure:nil];
}

#pragma mark - Getter
- (NSArray *)dataArray {
    return @[
//             @{@"title":@"vip",@"image":@"mine_vip",@"ctrl":@""},
             @{@"title":@"留言",@"image":@"mine_liuyan",@"ctrl":@"FeedbackManageViewController"},
             @{@"title":@"修改密码",@"image":@"mine_password",@"ctrl":@"FindPswdViewController"},
             @{@"title":@"检测更新",@"image":@"mine_version",@"ctrl":@""},
//             @{@"title":@"点播记录",@"image":@"mine_broadcast",@"ctrl":@"RecentPlayViewController"},
             @{@"title":@"设置",@"image":@"mine_setting",@"ctrl":@"SettingViewController"},
             @{@"title":@"帮助",@"image":@"mine_help",@"ctrl":@""}
             ];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];

    }
    return _tableView;
}

- (MineHeader *)header {
    if (!_header) {
        _header = [MineHeader loadFromNib];
        
        __weak typeof(self) weakSelf = self;
        _header.clickCB = ^(NSInteger index) {
            if (index == 1) {
                ZXMainViewController *mian = [UIApplication sharedApplication].keyWindow.rootViewController;
                mian.selectedIndex = 1;
            } else if (index == 2) {
                ZXMainViewController *mian = [UIApplication sharedApplication].keyWindow.rootViewController;
                mian.selectedIndex = 2;
            } else {
                HistoryViewController *vc = [[HistoryViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return _header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
