//
//  LoginViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *rememberPswdBtn;//记住密码
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;//自动登录
@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor =  [UIColor greenColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:1];
    UIImage *img = [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:img
                                                  forBarMetrics:UIBarMetricsDefault];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    if (![USERDEFAULTS objectForKey:kVersion]) {
        _accountTextField.text = @"";
        _pswdTextField.text = @"";
    }else {
        NSString *mobile = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecAttrAccount];
        _accountTextField.text = ([mobile isKindOfClass:[NSString class]]) ? mobile : @"";
        if ([USERDEFAULTS objectForKey:kAutoLogin]) {
            NSString *passwd = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecValueData];
            _pswdTextField.text = ([passwd isKindOfClass:[NSString class]]) ? passwd : @"";
            _rememberPswdBtn.selected = YES;
            _autoLoginBtn.selected = YES;
        }else {
            if ([USERDEFAULTS objectForKey:kRememberPswd]) {
                NSString *passwd = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecValueData];
                _pswdTextField.text = ([passwd isKindOfClass:[NSString class]]) ? passwd : @"";
                _rememberPswdBtn.selected = YES;
                _autoLoginBtn.selected = NO;
            }else {
                _pswdTextField.text = @"";
                _rememberPswdBtn.selected = NO;
                _autoLoginBtn.selected = NO;
            }
        }
    }
    [USERDEFAULTS setObject:[[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"] forKey:kVersion];
    [USERDEFAULTS synchronize];
}

- (void)addBackBtn {
    [self addNavBtnWithImage:@"back_hover" target:self action:@selector(popBack:) isLeft:YES];
}

- (void)popBack:(UIButton *)btn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.backgroundColor = [UIColor redColor];
//    [leftBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:leftBtn];
//    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        } else {
//             make.top.equalTo(self.view.mas_top);
//        }
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//        make.left.equalTo(self.view).mas_offset(12);
//    }];
//
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"登录"];
    [self.registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
//    _registerBtn.layer.borderWidth = 1.0f;
//    _registerBtn.layer.borderColor = kColorValue(0x8dc44b).CGColor;
    self.rememberPswdBtn.hidden = YES;
    self.autoLoginBtn.hidden = YES;
    self.rememberPswdBtn.selected = YES;
    self.autoLoginBtn.selected = YES;
}

#pragma mark - Actions
//注册
- (IBAction)registerBtnClick:(id)sender {
    [self.navigationController pushViewController:SBVC(@"RegisterVC") animated:YES];
}

//忘记密码
- (IBAction)forgetBtnClick:(UIButton *)btn {
    [self.navigationController pushViewController:SBVC(@"FindPswdVC") animated:YES];
}

//记住密码
- (IBAction)rememberBtnClick:(UIButton *)btn {
    if (_rememberPswdBtn.isSelected) {
        _rememberPswdBtn.selected = NO;
        _autoLoginBtn.selected = NO;
    }else {
        _rememberPswdBtn.selected = YES;
    }
}

//自动登录
- (IBAction)autoLoginBtnClick:(UIButton *)btn {
    if (_autoLoginBtn.isSelected) {
        _autoLoginBtn.selected = NO;
    }else {
        _autoLoginBtn.selected = YES;
        _rememberPswdBtn.selected = YES;
    }
}

//登录
- (IBAction)loginBtnClick:(id)sender {
    [_accountTextField resignFirstResponder];
    [_pswdTextField resignFirstResponder];
    if ([NSString isEmpty:_accountTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入账号"];
        return;
    }
    if ([NSString isEmpty:_pswdTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryLogin];
    NSDictionary *params = @{@"username":_accountTextField.text,
                             @"password":_pswdTextField.text,
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //登录信息
            LoginModel *model = [LoginModel yy_modelWithJSON:responseObject[@"data"]];
            APPDELEGATE.loginModel = model;
            [APPDELEGATE.keyWrapper setObject:strongSelf.accountTextField.text forKey:(__bridge id)kSecAttrAccount];
            [APPDELEGATE.keyWrapper setObject:strongSelf.pswdTextField.text forKey:(__bridge id)kSecValueData];
            
            //记住密码 自动登录
            if (strongSelf.autoLoginBtn.isSelected) {
                [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                [USERDEFAULTS setObject:kAutoLogin forKey:kAutoLogin];
            }else {
                [USERDEFAULTS removeObjectForKey:kAutoLogin];
                if (strongSelf.rememberPswdBtn.isSelected) {
                    [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                }else {
                    [USERDEFAULTS removeObjectForKey:kRememberPswd];
                }
            }
            //登录畅言
            [ChangyanSDK loginSSO:model.user_id userName:[NSString isEmpty:model.user_name]?@"游客":model.user_name profileUrl:nil imgUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                DLog(@"%@", responseStr);
            }];
            
            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else {
            ZXNetworkManager *manager = [ZXNetworkManager shareManager];
            [manager clearCache];
            NSString *url = [manager URLStringWithQuery:QueryLogout];
            [manager GETWithURLString:url parameters:nil progress:nil success:nil failure:nil];
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}
- (IBAction)qqlogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
        
    }];
}
- (IBAction)wechatLogin:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
//
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat unionid: %@", resp.unionId);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.unionGender);
//
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            ZXNetworkManager *manager = [ZXNetworkManager shareManager];
            NSString *url = [manager URLStringWithQuery2:Query2AddBindInfo];
            NSDictionary *params = @{@"type":@(1),
                                     @"unique_id":resp.unionId
                                     };
            __weak __typeof(self)weakSelf = self;
            [ZXProgressHUD showLoading:@""];
            [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                DLog(@"%@", responseObject);
                if ([responseObject[@"statusCode"]integerValue] == 200) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    //登录信息
                    LoginModel *model = [LoginModel yy_modelWithJSON:responseObject[@"data"]];
                    APPDELEGATE.loginModel = model;
                    [APPDELEGATE.keyWrapper setObject:strongSelf.accountTextField.text forKey:(__bridge id)kSecAttrAccount];
                    [APPDELEGATE.keyWrapper setObject:strongSelf.pswdTextField.text forKey:(__bridge id)kSecValueData];
                    
                    //记住密码 自动登录
                    if (YES) {
                        [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                        [USERDEFAULTS setObject:kAutoLogin forKey:kAutoLogin];
                    }else {
                        [USERDEFAULTS removeObjectForKey:kAutoLogin];
                        if (strongSelf.rememberPswdBtn.isSelected) {
                            [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                        }else {
                            [USERDEFAULTS removeObjectForKey:kRememberPswd];
                        }
                    }
                    //登录畅言
                    [ChangyanSDK loginSSO:model.user_id userName:[NSString isEmpty:model.user_name]?@"游客":model.user_name profileUrl:nil imgUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                        DLog(@"%@", responseStr);
                    }];
                    
                    [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                    [SVProgressHUD showImage:nil status:@"登陆成功"];
                }else {
                    [SVProgressHUD showImage:nil status:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DLog(@"%@", error.localizedDescription);
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
