//
//  ISYDownloadingViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownloadingViewController.h"
#import "ISYDownloadChaperStatusCell.h"
#import "BookDetailModel.h"
#import "ISYDBManager.h"
#import "ISYDownloadHelper.h"

@interface ISYDownloadingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ISYDownloadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@下载", self.bookName];
    [self setupUI];
    [self queryData];
}

#pragma mark - Action

- (void)stopDownloadButtonClick:(UIButton *)btn {
    for (BookChapterModel *model in self.dataSource) {
        if (self.isSuspended) {
            //暂停状态，即将执行 下载功能
            [[ISYDownloadHelper shareInstance] downloadChaper:model bookId:self.bookId progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
                
            } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
                
            }];
            [btn setTitle:@"暂停下载" forState:UIControlStateNormal];
        }else{
            //下载状态，即将执行 暂停功能
            [[ISYDownloadHelper shareInstance] stopDownloadBookId:self.bookId chaper:model];
            [btn setTitle:@"继续下载" forState:UIControlStateNormal];
        }
    }

    self.isSuspended = !self.isSuspended;
    [self queryData];
}

- (void)cancelDownloadButtonClick {
    for (BookChapterModel *model in self.dataSource) {
        [[ISYDownloadHelper shareInstance] deleteDownloadBookId:self.bookId chaper:model];
    }
    [self queryData];
}

#pragma mark - private
- (void)queryData {
    self.dataSource = [NSMutableArray arrayWithArray:[[ISYDBManager shareInstance] queryDownloadingChapersBookId:self.bookId]];
    [self.tableView reloadData];
}

- (void)setupUI {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
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
    cell.status = 2;
    __weak __typeof(self)weakSelf = self;
    cell.deleteCb = ^(id  _Nonnull chaper) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteChaper:chaper];
    };
    cell.downLoadFinishCb = ^(id  _Nonnull chaper) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf queryData];
    };
    cell.isLoading = YES;
    cell.chaper = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookChapterModel *model = self.dataSource[indexPath.row];
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:[model.l_url decodePlayURL]];
    if (receipt.state == MCDownloadStateDownloading) {
       
    } else if (receipt.state == MCDownloadStateCompleted) {
    } else if (receipt.state == MCDownloadStateWillResume || receipt.state == MCDownloadStateFailed || receipt.state == MCDownloadStateNone) {
        [[ISYDownloadHelper shareInstance] downloadChaper:model bookId:self.bookId progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            
        } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
            
        }];
        [self.tableView reloadData];
    }
}
#pragma mark - get/set method

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIButton *stopDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [stopDownloadButton setTitle:self.isSuspended?@"继续下载":@"暂停下载" forState:UIControlStateNormal];
        [stopDownloadButton setTitleColor:kMainTone forState:UIControlStateNormal];
        stopDownloadButton.layer.masksToBounds = YES;
        stopDownloadButton.layer.borderColor = kMainTone.CGColor;
        stopDownloadButton.layer.cornerRadius = 4;
        stopDownloadButton.layer.borderWidth = 1;
        [stopDownloadButton addTarget:self action:@selector(stopDownloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:stopDownloadButton];
        [stopDownloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView);
            make.left.equalTo(_headView).mas_offset(12);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(80);
        }];
        
        UIButton *cancelDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelDownloadButton setTitle:@"取消下载" forState:UIControlStateNormal];
        [cancelDownloadButton setTitleColor:kMainTone forState:UIControlStateNormal];
        cancelDownloadButton.layer.masksToBounds = YES;
        cancelDownloadButton.layer.borderColor = kMainTone.CGColor;
        cancelDownloadButton.layer.cornerRadius = 4;
        cancelDownloadButton.layer.borderWidth = 1;
        [cancelDownloadButton addTarget:self action:@selector(cancelDownloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:cancelDownloadButton];
        [cancelDownloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView);
            make.right.equalTo(_headView).mas_offset(-12);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(80);
        }];
        
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
