//
//  FeedbackAddViewController.m
//  iShuYin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackAddViewController.h"
#import "ZXTextView.h"

@interface FeedbackAddViewController ()
{
    NSInteger _type;//0留言 1咨询 2报错 3求书
}
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet ZXTextView *contentTextView;
@end

@implementation FeedbackAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _type = -1;
    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"添加留言"];
    [self addNavBtnWithTitle:@"发送" color:[UIColor whiteColor] target:self action:@selector(submitBtnClick) isLeft:NO];
    _contentTextView.placeholder = @"内容";
    [_typeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeViewTap)]];
}

#pragma mark - Action
- (void)typeViewTap {
    [_titleTextField resignFirstResponder];
    [_contentTextView resignFirstResponder];
    __weak __typeof(self)weakSelf = self;
    ZXPopView *view = [[ZXPopView alloc]initWithFeedbackTypeSelectBlock:^(NSDictionary *dict) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSString *title = dict[@"title"];
        NSString *type = dict[@"type"];
        strongSelf->_type = type.integerValue;
        strongSelf.typeLabel.text = title;
    }];
    [view showInView:self.navigationController.view animated:ZXPopViewAnimatedSlip];
}

- (void)submitBtnClick {
    if ([NSString isEmpty:_titleTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入标题"];
        return;
    }
    if (_type == -1) {
        [SVProgressHUD showImage:nil status:@"请选择留言类型"];
        return;
    }
    if ([NSString isEmpty:_contentTextView.text]) {
        [SVProgressHUD showImage:nil status:@"请输入内容"];
        return;
    }
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryFeedBackAdd];
    NSDictionary *params = @{@"msg_type":@(_type),
                             @"msg_title":_titleTextField.text,
                             @"msg_content":_contentTextView.text,
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
