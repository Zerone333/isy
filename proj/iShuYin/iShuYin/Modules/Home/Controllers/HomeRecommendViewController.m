//
//  HomeRecommendViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "HomeRecommendViewController.h"
#import "HomeModel.h"
#import "HomeTableCell.h"
#import "HomeFoundItemModel.h"

@interface HomeRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation HomeRecommendViewController

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
    NSString *url = [manager URLStringWithQuery2:Query2IndexRecom];
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
    HomeFoundItemModel *item6 = [self createItem:self.model.comment keyType:@"评书"];
    item6.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item7 = [self createItem:self.model.child keyType:@"儿童"];
    item7.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item4 = [self createItem:self.model.xiaoshuo keyType:@"小说"];
    item4.cellType = HomeTableCellViewType_Table;
    self.dataSource = @[item6, item7, item4];
}
- (HomeFoundItemModel *)createItem:(NSArray *)dataArray keyType:(NSString *)keyType {
    HomeFoundItemModel *item = [[HomeFoundItemModel alloc] init];
    item.keyType = keyType;
    item.dataSource = dataArray;
    item.randarDataSource = [self makeRandomItems:dataArray];
    return item;
}

// 重新刷新随机item
- (void)refreshRandaItem:(HomeFoundItemModel * )item{
    item.randarDataSource = [self makeRandomItems:item.dataSource];
}

/**
 随机抽取3个item
 */
- (NSArray *)makeRandomItems:(NSArray *)array {
    if (array.count < 3) {
        return array;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger inedx = 0;
    while (inedx != 3) {
        int y = 0 + (arc4random() % array.count);
        [tempArray addObject:array[y]];
        ++inedx;
    }
    return tempArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"HomeTableCell";
    HomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    __weak __typeof(self)weakSelf = self;
    cell.bookBlock = ^(NSString *book_id) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        [strongSelf pushToBookDetailWithIdentity:book_id];
    };
    cell.moreBlock = ^(HomeTableCellType type) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        MoreManageViewController *vc = [[MoreManageViewController alloc]init];
        //        vc.index = type;
        //        vc.hidesBottomBarWhenPushed = YES;
        //        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    [cell updateDataSource: model.randarDataSource cellType:model.cellType];
    [cell refreshCategoryTitle:model.keyType];
    cell.refreshBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshRandaItem:model];
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    return [HomeTableCell cellHeight:model.cellType];
    //    CGFloat h = 10+28+54;
    //    CGFloat itemW = (kScreenWidth-32-18) / 3.0;
    //    CGFloat itemH = itemW*105/80 + 30.5;
    //    if (indexPath.section == 0) {
    //        //推荐
    //        if (!_model || _model.recommend.count == 0) return 28+54;
    //        CGFloat item_w = (kScreenWidth-32-18) / 4.0;
    //        CGFloat item_h = item_w*105/80 + 30.5;
    //        NSInteger row = _model.recommend.count/4 + (_model.recommend.count%4 != 0);
    //        h += (item_h*row + (row-1)*20);
    //    }else if (indexPath.section == 1) {
    //        //热播
    //        if (!_model || _model.hot.count == 0) return 28+54;
    //        CGFloat item_w = (kScreenWidth-32-18) / 4.0;
    //        CGFloat item_h = item_w*105/80 + 30.5;
    //        NSInteger row = _model.hot.count/4 + (_model.hot.count%4 !=0);
    //        h += (item_h*row + (row-1)*20);
    //    }else {
    //        //最新
    //        if (!_model || _model.newest.count == 0) return 28+54;
    //        CGFloat item_w = (kScreenWidth-32-6) / 2.0;
    //        CGFloat item_h = item_w*105/165 + 37.5;
    //        NSInteger row = _model.newest.count/2 + (_model.newest.count%2 !=0);
    //        h += (item_h*row + (row-1)*10);
    //    }
    //    return itemH +10+28+54 ;
    //    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
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
        [_tableView registerClass:[HomeTableCell class] forCellReuseIdentifier:@"HomeTableCell"];
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData];
        }];
    }
    return _tableView;
}

@end
