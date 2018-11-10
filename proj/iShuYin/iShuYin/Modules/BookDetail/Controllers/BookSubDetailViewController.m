//
//  BookSubDetailViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/21.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "BookSubDetailViewController.h"
#import "ISYBookTableViewCell.h"
#import "ISYBookHeaderFooterView.h"
#import "ISYMoreViewController.h"

@interface BookSubDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *deslabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSouce;
@end

@implementation BookSubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - private
- (void)setupUI {
    self.view.backgroundColor = kColorRGB(247, 247, 247);
//    [self.view addSubview:self.deslabel];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self.headView addSubview:self.deslabel];
    [self.deslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView).mas_offset(10);
        make.left.equalTo(self.headView).mas_offset(12);
        make.right.equalTo(self.headView).mas_offset(-12);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSouce.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISYBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookTableViewCell cellID]];
    NSDictionary *item = self.dataSouce[indexPath.section];
    [cell updateDataSource:item[@"dataSource"]];
    cell.itemClickBlock = ^(HomeBookModel *book) {
        //TODO:进入详情
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ISYBookTableViewCell cellHeightForLineCount:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 94/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    NSDictionary *item = self.dataSouce[section];
    ISYBookHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ISYBookHeaderFooterViewID"];
    if (view == nil) {
        view = [[ISYBookHeaderFooterView alloc] initWithReuseIdentifier:@"ISYBookHeaderFooterViewID"];
       
    }
    view.catogryTitleLabel.text = item[@"titleString"];
    __weak __typeof(self)weakSelf = self;
    view.moreBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        ISYMoreViewController *moreVc = [[ISYMoreViewController alloc] init];
        [strongSelf.navigationController pushViewController:moreVc animated:YES];
    };
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - get/set method
- (void)setDetailModel:(BookDetailModel *)detailModel {
    _detailModel = detailModel;
    self.deslabel.text = detailModel.detail;
    
    CGRect titleRect = [detailModel.detail boundingRectWithSize:CGSizeMake(kScreenWidth - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.deslabel.font} context:nil];
    
    self.headView.frame = CGRectMake(0, 0, kScreenWidth, titleRect.size.height + 20);
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = self.headView;
    [self.tableView endUpdates];
    
    NSDictionary *item1 = @{@"titleString" : @"播音其他作品",
                            @"dataSource" : detailModel.director_books.count == 0 ? @[] :  detailModel.director_books
                            };
    NSDictionary *item2 = @{@"titleString" : @"作者其他作品",
                            @"dataSource" : detailModel.actor_books.count == 0 ? @[] :  detailModel.actor_books
                            };
    self.dataSouce = @[item1, item2];
    [self.tableView reloadData];
    
}

- (UILabel *)deslabel {
    if (!_deslabel) {
        _deslabel = [[UILabel alloc] init];
        _deslabel.backgroundColor = [UIColor whiteColor];
        _deslabel.numberOfLines = 0;
        _deslabel.text = @"";
    }
    return _deslabel;
}

-(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        _headView.backgroundColor = [UIColor whiteColor];
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
        [_tableView registerClass:[ISYBookTableViewCell class] forCellReuseIdentifier:[ISYBookTableViewCell cellID]];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        __weak __typeof(self) weakSelf = self;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            __strong __typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf requestData];
//        }];
    }
    return _tableView;
}
@end
