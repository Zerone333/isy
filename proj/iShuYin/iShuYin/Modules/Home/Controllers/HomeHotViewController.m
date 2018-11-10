//
//  HomeHotViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "HomeHotViewController.h"
#import "HomeModel.h"
#import "HomeFoundItemModel.h"
#import "ISYBookListHotTableViewCell.h"

#define kHomeHotViewControllerItemCount 4

@interface HomeHotViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation HomeHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestData];
}

#pragma mark - private
- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2IndexHot];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            HomeModel *model = [HomeModel yy_modelWithJSON:responseObject[@"data"]];
            strongSelf.model = model;
            [self converDataSource];
            [strongSelf.tableView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
        [strongSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)converDataSource {
    HomeFoundItemModel *item6 = [self createItem:self.model.today keyType:@"今日热播"];
    HomeFoundItemModel *item7 = [self createItem:self.model.week keyType:@"周热播"];
    HomeFoundItemModel *item4 = [self createItem:self.model.month keyType:@"月热播"];
    self.dataSource = @[item6, item7, item4];
}

- (HomeFoundItemModel *)createItem:(NSArray *)dataArray keyType:(NSString *)keyType {
    HomeFoundItemModel *item = [[HomeFoundItemModel alloc] init];
    item.keyType = keyType;
    item.dataSource = dataArray;
    [item refreshDataWithCount:kHomeHotViewControllerItemCount];
    return item;
}
- (void)pushBookVC:(NSString *)bookID {
    if (self.bookBlock) {
        self.bookBlock(bookID);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomeFoundItemModel *model = self.dataSource[section];
    return model.randarDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    ISYBookListHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookListHotTableViewCell cellID]];
    cell.model = model.randarDataSource[indexPath.row];
    return cell;
}

- (void)refreshBtnClick:(UIButton *)button {
    NSInteger inex = button.tag - 11111;
    HomeFoundItemModel *model = self.dataSource[inex];
    [model refreshDataWithCount:kHomeHotViewControllerItemCount];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:inex] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    HomeBookModel *item = model.randarDataSource[indexPath.row];
    [self pushBookVC:item.show_id];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ISYBookListTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeFoundItemModel *model = self.dataSource[section];
    UITableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"homeHotHeadid"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"homeHotHeadid"];
        view.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        [view.contentView addSubview:titleLabel];
        titleLabel.tag = 5352324;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.contentView);
            make.left.mas_equalTo(view.contentView).mas_offset(12);
        }];
    }
    UILabel *label = [view.contentView viewWithTag:5352324];
    label.text = model.keyType;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"homeHotfooterid"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"homeHotfooterid"];
        view.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    [view.contentView removeAllSubviews];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"换一换btn"] forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.contentView addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view.contentView);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    refreshButton.tag = 11111+ section;
    return view;
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
        [_tableView registerClass:[ISYBookListHotTableViewCell class] forCellReuseIdentifier:[ISYBookListHotTableViewCell cellID]];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData];
        }];
    }
    return _tableView;
}

@end
