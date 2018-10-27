//
//  RegisterViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdTwoTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"注册"];
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

@end
