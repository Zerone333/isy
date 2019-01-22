//
//  MineHeader.m
//  iShuYin
//
//  Created by Apple on 2017/9/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "MineHeader.h"

@interface MineHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;//听币
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//余额
@end

@implementation MineHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [_imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTap)]];
    //[_coinLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coinLabelTap)]];
    //[_pointLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pointLabelTap)]];
    //[_balanceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(balanceLabelTap)]];
}

#pragma mark - Setter

//头像
- (void)setConfig:(NSString *)config {
    _config = config;
    if (![NSString isEmpty:config] && config.integerValue == 1) {
        _imgView.image = [UIImage imageNamed:@"mine_girl"];
    }else {
        _imgView.image = [UIImage imageNamed:@"mine_boy"];
    }
}


- (void)setLoginModel:(LoginModel *)loginModel {
    _loginModel = loginModel;
    _nameLabel.text = loginModel.user_name;
    
    if (![NSString isEmpty:loginModel.user_point] && loginModel.user_point.integerValue == 1) {
        _imgView.image = [UIImage imageNamed:@"mine_girl"];
    }else {
        _imgView.image = [UIImage imageNamed:@"mine_boy"];
    }
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:kColorValue(0x666666),NSFontAttributeName:kFontSystem(12)};
    NSDictionary *dict2 = @{NSForegroundColorAttributeName:kColorValue(0x9b9b9b),NSFontAttributeName:kFontBold(15)};
    NSString *str1 = [NSString stringWithFormat:@"%@\n听币",loginModel.user_point];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:str1 attributes:dict1];
    [attr1 addAttributes:dict2 range:NSMakeRange(0, str1.length-2)];
    self.coinLabel.attributedText = attr1;
    
     NSString *str2 = [NSString stringWithFormat:@"%@\n积分",loginModel.pay_point];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:str2 attributes:dict1];
    [attr2 addAttributes:dict2 range:NSMakeRange(0, str2.length-2)];
    self.pointLabel.attributedText = attr2;
    
    NSString *str3 = [NSString stringWithFormat:@"%@\n余额",loginModel.user_money];
    NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc]initWithString:str3 attributes:dict1];
    [attr3 addAttributes:dict2 range:NSMakeRange(0, str3.length-2)];
    self.balanceLabel.attributedText = attr3;
}

/*
//听币
- (void)setCoin:(NSString *)coin {
    _coin = coin;
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:kColorValue(0x666666),NSFontAttributeName:kFontSystem(12)};
    NSDictionary *dict2 = @{NSForegroundColorAttributeName:kColorValue(0x9b9b9b),NSFontAttributeName:kFontBold(15)};
    NSString *str1 = [NSString stringWithFormat:@"%@\n听币",coin];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:str1 attributes:dict1];
    [attr1 addAttributes:dict2 range:NSMakeRange(0, str1.length-2)];
    _coinLabel.attributedText = attr1;
}

//积分
- (void)setPoint:(NSString *)point {
    _point = point;
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:kColorValue(0x666666),NSFontAttributeName:kFontSystem(12)};
    NSDictionary *dict2 = @{NSForegroundColorAttributeName:kColorValue(0x9b9b9b),NSFontAttributeName:kFontBold(15)};
    NSString *str2 = [NSString stringWithFormat:@"%@\n积分",point];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:str2 attributes:dict1];
    [attr2 addAttributes:dict2 range:NSMakeRange(0, str2.length-2)];
    _pointLabel.attributedText = attr2;
}

//余额
- (void)setBalance:(NSString *)balance {
    _balance = balance;
    NSDictionary *dict1 = @{NSForegroundColorAttributeName:kColorValue(0x666666),NSFontAttributeName:kFontSystem(12)};
    NSDictionary *dict2 = @{NSForegroundColorAttributeName:kColorValue(0x9b9b9b),NSFontAttributeName:kFontBold(15)};
    NSString *str3 = [NSString stringWithFormat:@"%@\n余额",balance];
    NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc]initWithString:str3 attributes:dict1];
    [attr3 addAttributes:dict2 range:NSMakeRange(0, str3.length-2)];
    _balanceLabel.attributedText = attr3;
}
 */

#pragma mark - Actions
- (void)imgViewTap {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self)weakSelf = self;
    [sheet addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.imgView.image = [UIImage imageNamed:@"mine_boy"];
        [USERDEFAULTS setObject:@"0" forKey:kUserConfigHeader];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.imgView.image = [UIImage imageNamed:@"mine_girl"];
        [USERDEFAULTS setObject:@"1" forKey:kUserConfigHeader];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    UIViewController *vc = [[ZXTools shareTools]appVisibleViewController];
    [vc presentViewController:sheet animated:YES completion:nil];
}

/*
- (void)coinLabelTap {
    [SVProgressHUD showImage:nil status:@"敬请期待～"];
}

- (void)pointLabelTap {
    [SVProgressHUD showImage:nil status:@"敬请期待～"];
}

- (void)balanceLabelTap {
    [SVProgressHUD showImage:nil status:@"敬请期待～"];
}
 */
- (IBAction)bookingButtonClick:(id)sender {
    if (self.clickCB) {
        self.clickCB(1);
    }
}

- (IBAction)downloadButtonClick:(id)sender {
    if (self.clickCB) {
        self.clickCB(2);
    }
}

- (IBAction)histroyButtonClick:(id)sender {
    if (self.clickCB) {
        self.clickCB(3);
    }
}
@end
