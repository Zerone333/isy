//
//  ISYDownloadFinishViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownloadFinishViewController.h"
#import "ISYDownloadChaperStatusCell.h"
#import "BookDetailModel.h"
#import "ISYDBManager.h"
#import "ISYDownloadHelper.h"

@interface ISYDownloadFinishViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ISYDownloadFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已下载";
    [self setupUI];
    [self queryData];
}

#pragma mark - private
- (void)queryData {
    self.dataSource = [NSMutableArray arrayWithArray:[[ISYDBManager shareInstance] queryDownloadChapers:4 bookId:self.bookId]];
    [self.tableView reloadData];
}

- (void)setupUI {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)deleteChaper:(BookChapterModel *)chaper {
    [[ISYDownloadHelper shareInstance] deleteDownloadBookId:self.bookId chaper:chaper];
    [self.dataSource removeObject:chaper];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookChapterModel *model = self.dataSource[indexPath.row];
    
    ISYDownloadChaperStatusCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ISYDownloadChaperStatusCellid"];
    if (cell == nil) {
        cell = [[ISYDownloadChaperStatusCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ISYDownloadChaperStatusCellid"];
    }
    cell.status = 1;
    __weak __typeof(self)weakSelf = self;
    cell.deleteCb = ^(id  _Nonnull chaper) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteChaper:chaper];
    };
    cell.chaper = model;
    return cell;
}

#pragma mark - get/set method

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
    }
    return _headView;
}

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
    }
    return _tableView;
}
@end
