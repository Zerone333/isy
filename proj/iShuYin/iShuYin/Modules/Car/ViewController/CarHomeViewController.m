//
//  CarHomeViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "CarHomeViewController.h"
#import "HomeModel.h"
#import "HomeFoundItemModel.h"
#import "ISYBookListTableViewCell.h"
#import "CarMoreViewController.h"
#import "ISYBookHeaderFooterView.h"
#import "ISYBookListTableCarViewCell.h"
#import "ISYBookTableViewCell.h"
#import "ISYBookRefreshFooterView.h"
#import "HomeFoundItemModel.h"
#import "ISYBookListHotTableViewCell.h"
#import "ISYMoreViewController.h"
#import "HomeHotViewController.h"
#import "ISYCategoryDetailViewController.h"
#import "CategoryModel.h"
#import "BookDetailViewController.h"

@interface CarHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation CarHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestData];
}

#pragma mark - private
- (void)setupUI {
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 6, kScreenWidth-46 * 2, 32);
    [bgView addSubview:self.searchBar];
    self.navigationItem.titleView = bgView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2Car];
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
    HomeFoundItemModel *item1 = [self createItem:self.model.recommend keyType:@"推荐" cellType:HomeTableCellViewType_Table];
    HomeFoundItemModel *item2 = [self createItem:self.model.hot keyType:@"热播" cellType:HomeTableCellViewType_Collection];
     HomeFoundItemModel *item3 = [self createItem:self.model.playlet keyType:@"短剧" cellType:HomeTableCellViewType_Collection];
    HomeFoundItemModel *item4 = [self createItem:self.model.music keyType:@"音乐" cellType:HomeTableCellViewType_Collection];
    HomeFoundItemModel *item5 = [self createItem:self.model.funny keyType:@"搞笑" cellType:HomeTableCellViewType_Collection];
    HomeFoundItemModel *item6 = [self createItem:self.model.news keyType:@"资讯" cellType:HomeTableCellViewType_Collection];
     HomeFoundItemModel *item7 = [self createItem:self.model.car keyType:@"汽车" cellType:HomeTableCellViewType_Collection];
    HomeFoundItemModel *item8 = [self createItem:self.model.essay keyType:@"相声小品" cellType:HomeTableCellViewType_Collection];
    self.dataSource = @[item1, item2, item3, item4, item5, item6, item7, item8];
}

- (HomeFoundItemModel *)createItem:(NSArray *)dataArray keyType:(NSString *)keyType cellType:(HomeTableCellViewType)cellType{
    HomeFoundItemModel *item = [[HomeFoundItemModel alloc] init];
    item.keyType = keyType;
    item.dataSource = dataArray;
    item.cellType = cellType;
    item.randarDataSource = [self makeRandomItems:dataArray count:item.cellType == HomeTableCellViewType_Collection ? 3 : 5];
    return item;
}

// 重新刷新随机item
- (void)refreshRandaItem:(HomeFoundItemModel * )item count:(NSInteger)count{
    item.randarDataSource = [self makeRandomItems:item.dataSource count:count];
}

/**
 随机抽取3个item
 */
- (NSArray *)makeRandomItems:(NSArray *)array count:(NSInteger)count{
    if (array.count < count) {
        return array;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger inedx = 0;
    while (inedx != count) {
        int y = 0 + (arc4random() % array.count);
        [tempArray addObject:array[y]];
        ++inedx;
    }
    return tempArray;
}

#pragma mark - Action
- (void)moreBtnClick {
    CarMoreViewController *vc = [[CarMoreViewController alloc] init];
    vc.type = 1;
    vc.pCategory = 66;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomeFoundItemModel *model = self.dataSource[section];
    if (model.cellType == HomeTableCellViewType_Collection) {
        return 1;
    } else {
        return model.randarDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    if (model.cellType == HomeTableCellViewType_Collection) {
        ISYBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookTableViewCell cellID]];
        [cell updateDataSource:model.randarDataSource];
                __weak __typeof(self)weakSelf = self;
        cell.itemClickBlock = ^(HomeBookModel *book) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            BookDetailViewController *vc = [[BookDetailViewController alloc]init];
            vc.bookid = book.show_id;
            vc.hidesBottomBarWhenPushed = YES;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        ISYBookListTableCarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookListTableCarViewCell cellID]];
        cell.model = model.randarDataSource[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoundItemModel *item = self.dataSource[indexPath.section];
    if (item.cellType == HomeTableCellViewType_Collection) {
        return [ISYBookTableViewCell cellHeightForLineCount:1];
    } else {
        return [ISYBookListTableViewCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    if (model.cellType == HomeTableCellViewType_Table) {
        HomeBookModel *book = model.randarDataSource[indexPath.row];
        BookDetailViewController *vc = [[BookDetailViewController alloc]init];
        vc.bookid = book.show_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 94/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [ISYBookRefreshFooterView height];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeFoundItemModel *item = self.dataSource[section];
    ISYBookHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ISYBookHeaderFooterViewID"];
    if (view == nil) {
        view = [[ISYBookHeaderFooterView alloc] initWithReuseIdentifier:@"ISYBookHeaderFooterViewID"];
        
    }
    view.catogryTitleLabel.text = item.keyType;
    __weak __typeof(self)weakSelf = self;
    view.moreBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (section == 0) {
            [strongSelf moreBtnClick];
        } else if (section == 1) {
            HomeHotViewController *vc = [[HomeHotViewController alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
        else {
            HomeBookModel *first = [item.randarDataSource firstObject];
            CategoryModel *model = [[CategoryModel alloc] init];
            model.cat_id = first.cat_id;
            model.cat_name = item.keyType;
            ISYCategoryDetailViewController *vc = [[ISYCategoryDetailViewController alloc] init];
            vc.category = model;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HomeFoundItemModel *item = self.dataSource[section];
    ISYBookRefreshFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ISYBookRefreshFooterViewID"];
    if (view == nil) {
        view = [[ISYBookRefreshFooterView alloc] initWithReuseIdentifier:@"ISYBookRefreshFooterViewID"];
    }
    __weak __typeof(self)weakSelf = self;
    view.refreshBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshRandaItem:item count:item.cellType == HomeTableCellViewType_Collection ? 3 : 5];
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
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
        [_tableView registerClass:[ISYBookTableViewCell class] forCellReuseIdentifier:[ISYBookTableViewCell cellID]];
        [_tableView registerClass:[ISYBookListTableCarViewCell class] forCellReuseIdentifier:[ISYBookListTableCarViewCell cellID]];
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

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-46 * 2, 32)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor whiteColor];
        
        UIColor *color = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        UIImage *bgImage = [UIImage imageWithColor:color size:CGSizeMake(kScreenWidth-46 * 2, 32)];
        [_searchBar setSearchFieldBackgroundImage:bgImage forState:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"home_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"home_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"home_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 4.0;
        searchField.textColor= [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}
@end
