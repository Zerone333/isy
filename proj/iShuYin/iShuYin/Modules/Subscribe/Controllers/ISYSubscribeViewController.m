//
//  ISYSubscribeViewController.m
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYSubscribeViewController.h"
#import "HomeModel.h"
#import "HomeTableCell.h"
#import "HomeFoundItemModel.h"
#import "ISYBookTableViewCell.h"
#import "ISYBookListHotTableViewCell.h"
#import "ISYBookHeaderFooterView.h"
#import "ISYMoreViewController.h"
#import "ISYBookRefreshFooterView.h"
#import "ISYDBManager.h"
#import "ISYBookingTableViewCell.h"

@interface ISYSubscribeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation ISYSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"订阅"];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self queryData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
#pragma mark - private
- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)queryData {
    self.dataSource =  [[ISYDBManager shareInstance] queryBookHistoryListen];
    [self.tableView reloadData];
}
- (void)continuPlay:(ISYHistoryListenModel *)model {
    
    //    BookChapterModel *chapterModel = model.bookModel.chapters[model.chaperNumber];
    [APPDELEGATE.playVC playWithBook:model.bookModel index:model.chaperNumber];
    if ([self.navigationController.viewControllers containsObject:APPDELEGATE.playVC]) {
        [self.navigationController popToViewController:APPDELEGATE.playVC animated:YES];
    }else {
        [self.navigationController pushViewController:APPDELEGATE.playVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISYHistoryListenModel *model = self.dataSource[indexPath.row];
    ISYBookingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookingTableViewCell cellID]];
    cell.historyListenModel = model;
    
    __weak typeof(self) weakSelf = self;
    cell.playBlock = ^(ISYHistoryListenModel *model) {
        [weakSelf continuPlay: model];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [ISYBookListTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - get/set method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[ISYBookingTableViewCell class] forCellReuseIdentifier:[ISYBookingTableViewCell cellID]];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HistoryViewControllerHeadID"];
    }
    return _tableView;
}

@end
