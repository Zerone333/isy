//
//  ISYDownLoadListViewController.m
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownLoadListViewController.h"
#import "ISYDownLoadTableViewCell.h"
#import "ISYDBManager.h"
#import "ISYDownloadFinishViewController.h"
#import "ISYDownloadingViewController.h"
#import "ISYDownloadHelper.h"

@interface ISYDownLoadListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation ISYDownLoadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryData];
}

#pragma mark - private

- (void)queryData {
    if (self.dowmloadType == 1) {
        self.dataSource = [[ISYDBManager shareInstance] queryDownloadBooks:4];
        __block long long totalSize = 0;
        [self.dataSource enumerateObjectsUsingBlock:^(BookDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalSize += obj.totaldownloadSize;
        }];
        self.sizeChangeBlock ? self.sizeChangeBlock(totalSize): nil;
    } else if (self.dowmloadType == 2) {
        self.dataSource = [[ISYDBManager shareInstance] queryDownloadingBooks];
    }
    [self.tableView reloadData];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)deleteAllChaper:(BookDetailModel *)book {
    [ZXProgressHUD showLoading:@""];
    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:[[ISYDBManager shareInstance] queryDownloadChapers:4 bookId:book.show_id]];
    for (BookChapterModel *model in dataSource) {
        [[ISYDownloadHelper shareInstance] deleteDownloadBookId:book.show_id chaper:model];
    }
    [ZXProgressHUD hide];
    [self queryData];
}

- (void)cancelAllChaper:(BookDetailModel *)book {
    [ZXProgressHUD showLoading:@""];
    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:[[ISYDBManager shareInstance] queryDownloadingChapersBookId:book.show_id]];
    for (BookChapterModel *model in dataSource) {
        if (book.isSuspended) {
            //暂停状态，即将执行 下载功能
            [[ISYDownloadHelper shareInstance] downloadChaper:model bookId:book.show_id progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
                
            } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
                
            }];
        }else{
            //下载状态，即将执行 暂停功能
            [[ISYDownloadHelper shareInstance] stopDownloadBookId:book.show_id chaper:model];
        }
    }
    [ZXProgressHUD hide];
    [self queryData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookDetailModel *book = self.dataSource[indexPath.row];
    ISYDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYDownLoadTableViewCell cellID]];
    cell.bookDetailModel = book;
    cell.type = self.dowmloadType;
    
    __weak typeof(self) weakSelf = self;
    cell.editCb = ^(BookDetailModel *bookDetailModel) {
        if (weakSelf.dowmloadType == 1) {
            [weakSelf deleteAllChaper:bookDetailModel];
        } else {
            [weakSelf cancelAllChaper:bookDetailModel];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ISYDownLoadTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookDetailModel *book = self.dataSource[indexPath.row];
    if (self.dowmloadType == 1) {
        ISYDownloadFinishViewController *vc = [[ISYDownloadFinishViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bookId = book.show_id;
        vc.book = book;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ISYDownloadingViewController *vc = [[ISYDownloadingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bookId = book.show_id;
        vc.bookName = book.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [_tableView registerClass:[ISYDownLoadTableViewCell class] forCellReuseIdentifier:[ISYDownLoadTableViewCell cellID]];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        __weak __typeof(self) weakSelf = self;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            __strong __typeof(weakSelf) strongSelf = weakSelf;        }];
    }
    return _tableView;
}
@end

