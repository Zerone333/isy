//
//  RegisterViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "RegisterViewController.h"
#import "ISYRegister3ViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdTwoTextField;
@property (weak, nonatomic) IBOutlet UIButton *goLoginBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
    
}

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"注册"];
    
    [self.goLoginBtn setTitle:@"" forState:UIControlStateNormal];
    
    
    NSString *str1 = @"已有账号，";
    NSString *str2 = @"点此登陆";
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str1.length,str2.length)];
    [self.goLoginBtn setAttributedTitle:noteStr forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - Actions
//同意
- (IBAction)agreeBtnClick:(id)sender {

}

//协议
- (IBAction)agreementBtnClick:(id)sender {

}

- (IBAction)registerBtnClick:(id)sender {
    [_emailTextField resignFirstResponder];
    [_accountTextField resignFirstResponder];
    [_pswdOneTextField resignFirstResponder];
    [_pswdTwoTextField resignFirstResponder];
    if ([NSString isEmpty:_accountTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入账号"];
        return;
    }
    if ([NSString isEmpty:_emailTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入邮箱"];
        return;
    }
    if (![NSString validateEmail:_emailTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入有效的邮箱"];
        return;
    }
    if ([NSString isEmpty:_pswdOneTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    if ([NSString isEmpty:_pswdTwoTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码"];
        return;
    }
    if (![_pswdOneTextField.text isEqualToString:_pswdTwoTextField.text]) {
        [SVProgressHUD showImage:nil status:@"密码不一致"];
        return;
    }
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryRegister];
    NSDictionary *params = @{@"username":_accountTextField.text,
                             @"password":_pswdOneTextField.text,
                             @"email":_emailTextField.text
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showImage:nil status:@"注册成功，请登录。"];
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)qqRegister:(id)sender {
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
            
            ZXNetworkManager *manager = [ZXNetworkManager shareManager];
            NSString *url = [manager URLStringWithQuery2:AddBindInfo];
            NSDictionary *params = @{@"nickname":resp.name,
                                     @"type": @(2),
                                     @"unique_id":resp.uid,
                                     @"headimgurl":resp.iconurl
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
                    
                    [USERDEFAULTS setObject:@(1) forKey:kLoginType];
                    [USERDEFAULTS setObject:model.user_name forKey:kUserName];
                    [USERDEFAULTS setObject:model.headUrl forKey:kHeadUrl];
                    [USERDEFAULTS setObject:resp.iconurl forKey:kUniqueId];
                    
                    //记住密码 自动登录
                    if (YES) {
                        [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                        [USERDEFAULTS setObject:kAutoLogin forKey:kAutoLogin];
                    }else {
                        [USERDEFAULTS removeObjectForKey:kAutoLogin];
                        if (YES) {
                            [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                        }else {
                            [USERDEFAULTS removeObjectForKey:kRememberPswd];
                        }
                    }
                    //登录畅言
                    [ChangyanSDK loginSSO:model.user_id userName:[NSString isEmpty:model.user_name]?@"游客":model.user_name profileUrl:nil imgUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                        DLog(@"%@", responseStr);
                    }];
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD showImage:nil status:@"注册成功"];
                }else {
                    [SVProgressHUD showImage:nil status:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DLog(@"%@", error.localizedDescription);
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
            
            //            ISYRegister3ViewController *vc = [[ISYRegister3ViewController alloc] init];
            //            vc.platformType = UMSocialPlatformType_WechatSession;
        //            vc.unique_id = resp.unionId;
            //            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
- (IBAction)wechatRegister:(id)sender {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
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
            
            ZXNetworkManager *manager = [ZXNetworkManager shareManager];
            NSString *url = [manager URLStringWithQuery2:AddBindInfo];
            NSDictionary *params = @{@"nickname":resp.name,
                                     @"type": @(1),
                                     @"unique_id":resp.uid,
                                     @"headimgurl":resp.iconurl
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
                    
                    [USERDEFAULTS setObject:@(1) forKey:kLoginType];
                    [USERDEFAULTS setObject:model.user_name forKey:kUserName];
                    [USERDEFAULTS setObject:model.headUrl forKey:kHeadUrl];
                    [USERDEFAULTS setObject:resp.iconurl forKey:kUniqueId];
                    
                    //记住密码 自动登录
                    if (YES) {
                        [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                        [USERDEFAULTS setObject:kAutoLogin forKey:kAutoLogin];
                    }else {
                        [USERDEFAULTS removeObjectForKey:kAutoLogin];
                        if (YES) {
                            [USERDEFAULTS setObject:kRememberPswd forKey:kRememberPswd];
                        }else {
                            [USERDEFAULTS removeObjectForKey:kRememberPswd];
                        }
                    }
                    //登录畅言
                    [ChangyanSDK loginSSO:model.user_id userName:[NSString isEmpty:model.user_name]?@"游客":model.user_name profileUrl:nil imgUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                        DLog(@"%@", responseStr);
                    }];
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD showImage:nil status:@"注册成功"];
                }else {
                    [SVProgressHUD showImage:nil status:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DLog(@"%@", error.localizedDescription);
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
            
//            ISYRegister3ViewController *vc = [[ISYRegister3ViewController alloc] init];
//            vc.platformType = UMSocialPlatformType_WechatSession;
//            vc.unique_id = resp.unionId;
//            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}

@end
