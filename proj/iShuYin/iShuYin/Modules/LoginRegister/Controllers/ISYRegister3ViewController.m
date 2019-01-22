//
//  ISYRegister3ViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/11/22.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYRegister3ViewController.h"

@interface ISYRegister3ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@property (nonatomic, strong) UIButton *registerButton;
@end

@implementation ISYRegister3ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setupUI];
}

#pragma mark - private

- (void)textFieldChanged:(UITextField*)textField {
    if (self.textField1.text.length != 0 && self.textField2.text.length != 0 && self.textField3.text.length != 0) {
        self.registerButton.enabled = YES;
        self.registerButton.backgroundColor = kMainTone;
    } else {
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = kColorRGB(222, 222, 222);
    }
}

- (void) setupUI {
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor grayColor];
    UIView *lineView2 =  [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor grayColor];
    UIView *lineView3 =  [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:lineView1];
    [self.view addSubview:lineView2];
    [self.view addSubview:lineView3];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(120);
        make.left.equalTo(self.view).mas_offset(44);
        make.right.equalTo(self.view).mas_offset(-44);
        make.height.mas_equalTo(0.5);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(170);
        make.left.equalTo(self.view).mas_offset(44);
        make.right.equalTo(self.view).mas_offset(-44);
        make.height.mas_equalTo(0.5);
    }];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(220);
        make.left.equalTo(self.view).mas_offset(44);
        make.right.equalTo(self.view).mas_offset(-44);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_account"]];
    [self.view addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pswd"]];
    [self.view addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pswd"]];
    [self.view addSubview:image3];
    
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView1).mas_offset(-4);
        make.left.equalTo(lineView1).mas_offset(12);
    }];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView2).mas_offset(-4);
        make.left.equalTo(lineView1).mas_offset(12);
    }];
    [image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView3).mas_offset(-4);
        make.left.equalTo(lineView1).mas_offset(12);
    }];
    
    [self.view addSubview:self.textField1];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(image1.mas_centerY);
        make.left.equalTo(image1).mas_offset(20);
        make.right.equalTo(lineView1);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.textField2];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(image2.mas_centerY);
        make.left.equalTo(image2).mas_offset(20);
        make.right.equalTo(lineView2);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.textField3];
    [self.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(image3.mas_centerY);
        make.left.equalTo(image3).mas_offset(20);
        make.right.equalTo(lineView3);
        make.height.mas_equalTo(44);
    }];

    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = kColorRGB(222, 222, 222);
    registerBtn.backgroundColor = kMainTone;
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 22;
    [registerBtn addTarget: self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    self.registerButton = registerBtn;
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(44);
        make.right.equalTo(self.view).mas_offset(-44);
        make.height.mas_equalTo(44);
        make.top.equalTo(lineView3).mas_offset(22);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(registerBtn);
        make.top.equalTo(registerBtn.mas_bottom).mas_offset(25);
    }];
    NSString *str1 = @"已有账号，";
    NSString *str2 = @"点此登陆";
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str1.length,str2.length)];
    [loginBtn setAttributedTitle:noteStr forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)registerUser {
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    if ([NSString isEmpty:_textField1.text]) {
        [SVProgressHUD showImage:nil status:@"请输入账号"];
        return;
    }
    if ([NSString isEmpty:_textField2.text]) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    if ([NSString isEmpty:_textField2.text]) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    if ([NSString isEmpty:_textField3.text]) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码"];
        return;
    }
    if (![_textField3.text isEqualToString:_textField2.text]) {
        [SVProgressHUD showImage:nil status:@"密码不一致"];
        return;
    }
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryRegister];
    NSDictionary *params = @{@"username":_textField1.text,
                             @"password":_textField2.text,
                             @"third_type":self.platformType == UMSocialPlatformType_QQ ? @(2) : @(1), //1 微信 2qq 3微博
                             @"unique_id":self.unique_id
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

#pragma mark  get/set method
- (UITextField *)textField1 {
    if (!_textField1) {
        _textField1 = [[UITextField alloc] init];
        _textField1.placeholder = @"第三方授权登陆名";
        _textField1.delegate = self;//添加方法
        [_textField1 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField1;
}

- (UITextField *)textField2 {
    if (!_textField2) {
        _textField2 = [[UITextField alloc] init];
        _textField2.placeholder = @"请输入密码";
        [_textField2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField2;
}

- (UITextField *)textField3 {
    if (!_textField3) {
        _textField3 = [[UITextField alloc] init];
        _textField3.placeholder = @"请再次输入密码";
        _textField3.delegate = self;
        [_textField3 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField3;
}
@end
