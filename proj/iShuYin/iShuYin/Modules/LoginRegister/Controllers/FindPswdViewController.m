//
//  FindPswdViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FindPswdViewController.h"

@interface FindPswdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end

@implementation FindPswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"找回密码"];
}

- (IBAction)findPswdBtnClick:(id)sender {
    if ([NSString isEmpty:_accountTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入用户名"];
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
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryFindPassword];
    NSDictionary *params = @{@"email":_emailTextField.text,
                             @"username":_accountTextField.text
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD showImage:nil status:responseObject[@"message"]];
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
