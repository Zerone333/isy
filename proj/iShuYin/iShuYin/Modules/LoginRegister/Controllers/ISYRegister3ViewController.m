//
//  ISYRegister3ViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/11/22.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYRegister3ViewController.h"

@interface ISYRegister3ViewController ()
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@end

@implementation ISYRegister3ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self setupUI];
}


#pragma mark - private
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
    registerBtn.backgroundColor = [UIColor grayColor];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 22;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
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

- (UITextField *)textField1 {
    if (!_textField1) {
        _textField1 = [[UITextField alloc] init];
        _textField1.placeholder = @"第三方授权登陆名";
    }
    return _textField1;
}

- (UITextField *)textField2 {
    if (!_textField2) {
        _textField2 = [[UITextField alloc] init];
        _textField2.placeholder = @"请输入密码";
    }
    return _textField2;
}

- (UITextField *)textField3 {
    if (!_textField3) {
        _textField3 = [[UITextField alloc] init];
        _textField3.placeholder = @"请再次输入密码";
    }
    return _textField3;
}
@end
