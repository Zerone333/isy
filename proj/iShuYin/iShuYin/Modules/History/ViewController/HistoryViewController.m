//
//  HistoryViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "HistoryViewController.h"
#import "HomeModel.h"
#import "HomeTableCell.h"
#import "HomeFoundItemModel.h"
#import "ISYBookTableViewCell.h"
#import "ISYBookListHotTableViewCell.h"
#import "ISYBookHeaderFooterView.h"
#import "ISYMoreViewController.h"
#import "ISYBookRefreshFooterView.h"
#import "ISYDBManager.h"
#import "ISYHisotyLisenBookListTableViewCell.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryData];
}

#pragma mark - private
- (void)setupUI {
    self.title = @"历史";
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
    [APPDELEGATE.playVC playWithBook:model.bookModel index:model.chaperNumber duration:model.time];
    if ([self.navigationController.viewControllers containsObject:APPDELEGATE.playVC]) {
        [self.navigationController popToViewController:APPDELEGATE.playVC animated:YES];
    }else {
        [self.navigationController pushViewController:APPDELEGATE.playVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return self.dataSource.count;
//    } else if (section == 1 ) {
//        return 1;
//    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISYHistoryListenModel *model = self.dataSource[indexPath.row];
    ISYHisotyLisenBookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYHisotyLisenBookListTableViewCell cellID]];
    cell.historyListenModel = model;
    
    __weak typeof(self) weakSelf = self;
    cell.playBlock = ^(ISYHistoryListenModel *model) {
        [self continuPlay: model];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return  [ISYBookListTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ISYBookRefreshFooterView height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HistoryViewControllerHeadID"];
    if (view == nil) {
        view = [[ISYBookHeaderFooterView alloc] initWithReuseIdentifier:@"HistoryViewControllerHeadID"];
        view.backgroundColor = [UIColor whiteColor];

    }
    if (section == 0) {
        view.textLabel.text = @"最近";
    } else {
        view.textLabel.text = @"历史";
    }
    view.textLabel.font = [UIFont boldSystemFontOfSize:16];
    view.textLabel.textColor = kColorValue(0x282828);
    return view;
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
        [_tableView registerClass:[ISYHisotyLisenBookListTableViewCell class] forCellReuseIdentifier:[ISYHisotyLisenBookListTableViewCell cellID]];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HistoryViewControllerHeadID"];
    }
    return _tableView;
}

@end

