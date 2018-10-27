//
//  FeedbackDetailViewController.m
//  iShuYin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackDetailViewController.h"
#import "FeedbackModel.h"
#import "FeedbackUserCell.h"
#import "FeedbackAdminCell.h"
#import "FeedbackAddViewController.h"

@interface FeedbackDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:_model.msg_title];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarOffset, 0, 0, 0));
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model.msg_reply) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *reuseUserId = @"FeedbackUserCell";
        FeedbackUserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseUserId];
        cell.model = _model;
        return cell;
    }else {
        static NSString *reuseAdminId = @"FeedbackAdminCell";
        FeedbackAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseAdminId];
        cell.model = _model.msg_reply;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat h1 = [_model.msg_content boundingRectWithSize:CGSizeMake(150-20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSystem(14)} context:nil].size.height;
        return 118-17+h1;
    }else {
        CGFloat h2 = [_model.msg_reply.msg_content boundingRectWithSize:CGSizeMake(150-20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSystem(14)} context:nil].size.height;
        return 118-17+h2;
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"FeedbackUserCell" bundle:nil] forCellReuseIdentifier:@"FeedbackUserCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"FeedbackAdminCell" bundle:nil] forCellReuseIdentifier:@"FeedbackAdminCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
