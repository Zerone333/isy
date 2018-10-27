//
//  ModifyPswdViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ModifyPswdViewController.h"

@interface ModifyPswdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pswdOldTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdTwoTextField;
@end

@implementation ModifyPswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"修改密码"];
}

- (IBAction)modifyBtnClick:(id)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
