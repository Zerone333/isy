//
//  ISYCategoryMoreViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCategoryMoreViewController.h"
#import "ISYBookListTableViewCell.h"
#import "HomeModel.h"
#import "ISYCategoryDetailTableViewCell.h"
#import "BookDetailViewController.h"
#import "ISYCategoryFilterView.h"
#import "ISYCategoryMoreHeadView.h"
#import "ISYBookListHotTableViewCell.h"
#import "ISYSearchViewController.h"

@interface ISYCategoryMoreViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) HMSegmentedControl *sortseg;

@property (nonatomic, strong) UIView *catogryMoreView;
@property (nonatomic, strong) UIView *sortMoreView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger typeIndex;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSArray *categryData;
@property (nonatomic, copy) NSArray *sortTypeArray;
@property (nonatomic, assign) NSInteger categorySelectIndex;
@property (nonatomic, assign) NSInteger sortSelectIndex;
@end

@implementation ISYCategoryMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类详情";
    self.typeIndex = 0;
    self.pageIndex = 1;
    [self setupUI];
    
    //初始化数据
    
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dict in self.sortTypeArray) {
        [titles addObject:dict[@"sortTitle"]];
    }
    self.sortseg.sectionTitles = titles;
    
    [self requestCategoryData];
}

- (void)setupUI {
    
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:YES];
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:NO];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftButton setTitle:[NSString stringWithFormat:@"  %@", self.category.cat_name] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(46, 6, kScreenWidth-46 * 2, 32);
    [bgView addSubview:self.searchBar];
    self.navigationItem.titleView = bgView;
    
    [self.view addSubview:self.seg];
    [self.view addSubview:self.catogryMoreView];
    [self.view addSubview:self.sortseg];
    [self.view addSubview:self.sortMoreView];
    [self.view addSubview:self.tableView];
    
    [self.catogryMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.equalTo(@44);
    }];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.catogryMoreView.mas_left);
        make.height.equalTo(@44);
    }];
    
    [self.sortMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.catogryMoreView.mas_bottom);
        make.right.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.equalTo(@44);
    }];
    
    [self.sortseg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seg.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.sortMoreView.mas_left);
        make.height.equalTo(@44);
    }];
    
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.image = [UIImage imageNamed:@"download_ad"];
    adImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:adImageView];
    [adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sortseg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adImageView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)requestCategoryData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2Category];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@"加载中"];
    [manager GETWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            [strongSelf.dataSource removeAllObjects];
            NSArray *temp = [NSArray yy_modelArrayWithClass:[CategoryModel class] json:responseObject[@"data"]];
            
            // segdata
            strongSelf.categryData = temp;
            NSMutableArray *titles = [NSMutableArray array];
            for (CategoryModel *model in strongSelf.categryData) {
                [titles addObject:model.cat_name];
            }
            
            strongSelf.seg.sectionTitles = [titles copy];
            
            CategoryModel *model = strongSelf.categryData[strongSelf.categorySelectIndex];
            NSDictionary *dict = strongSelf.sortTypeArray[strongSelf.sortSelectIndex];
            NSNumber *sortValue = dict[@"sortValue"];
            [strongSelf requestData:1 page:1 category:model.cat_id sortType:sortValue];
        } else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}


#pragma mark - Event
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData:(NSInteger)typeIndex page:(NSInteger)page category:(NSString *)category sortType:(NSNumber*)sortType {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2BookList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    NSDictionary *parameter;
    parameter = @{@"type" : sortType,
                  @"category" : category,
                  @"page" : @(page),
                  @"jishu_show" : @(1)
                  };
    
    [manager GETWithURLString:url parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[HomeBookModel class] json:responseObject[@"data"]];
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            [strongSelf.dataSource addObjectsFromArray:temp];
            [strongSelf.tableView reloadData];
            strongSelf.pageIndex = page;
            strongSelf.typeIndex = typeIndex;
            if (temp.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)pushToBookDetailWithIdentity:(NSString *)bookid {
    if ([NSString isEmpty:bookid]) {
        [SVProgressHUD showImage:nil status:@"书本数据有误"];
        return;
    }
    BookDetailViewController *vc = [[BookDetailViewController alloc]init];
    vc.bookid = bookid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonClick:(UIButton *)button {
    if (button.tag == 1) { //分类
        ISYCategoryFilterView *view = [ISYCategoryFilterView viewWithArray:self.seg.sectionTitles selectIndex:self.categorySelectIndex title:@"分类" icon:@"detail_like_nor"];
        
        __weak typeof(view) weakView = view;
        __weak typeof(self) weakSelf = self;
        view.dismissBlock = ^(NSInteger sortSelectIndex) {
            // 请求新数据
            weakSelf.seg.selectedSegmentIndex = sortSelectIndex;
            weakSelf.categorySelectIndex = sortSelectIndex;
            [weakView removeFromSuperview];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.seg);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
    } else {
        ISYCategoryFilterView *view = [ISYCategoryFilterView viewWithArray:self.sortseg.sectionTitles selectIndex:self.categorySelectIndex title:@"排序" icon:@"detail_like_nor"];
        
        __weak typeof(view) weakView = view;
        __weak typeof(self) weakSelf = self;
        view.dismissBlock = ^(NSInteger sortSelectIndex) {
            // 请求新数据
            weakSelf.sortseg.selectedSegmentIndex = sortSelectIndex;
            weakSelf.sortSelectIndex = sortSelectIndex;
            [weakView removeFromSuperview];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.sortseg);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookModel *model = self.dataSource[indexPath.row];
    ISYBookListHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookListHotTableViewCell cellID]];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookModel *model = self.dataSource[indexPath.row];
    [self pushToBookDetailWithIdentity:model.show_id];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ISYBookListTableViewCell cellHeight];
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

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    if (!searchBar.text.length) {
    //        return;
    //    }
    //    [searchBar resignFirstResponder];
    //    MoreListViewController *vc = [[MoreListViewController alloc]init];
    //    vc.keyword = searchBar.text;
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
    ISYSearchViewController *vc = [[ISYSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
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
            
            
            CategoryModel *model = strongSelf.categryData[strongSelf.categorySelectIndex];
            NSDictionary *dict = strongSelf.sortTypeArray[strongSelf.sortSelectIndex];
            NSNumber *sortValue = dict[@"sortValue"];
            [strongSelf requestData:1 page:1 category:model.cat_id sortType:sortValue];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            CategoryModel *model = strongSelf.categryData[strongSelf.categorySelectIndex];
            NSDictionary *dict = strongSelf.sortTypeArray[strongSelf.sortSelectIndex];
            NSNumber *sortValue = dict[@"sortValue"];
            [strongSelf requestData:1 page:strongSelf.pageIndex + 1 category:model.cat_id sortType:sortValue];
        }];
    }
    return _tableView;
}

- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
        __weak __typeof(self)weakSelf = self;
        _seg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.categorySelectIndex = index;
            [strongSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _seg;
}

- (HMSegmentedControl *)sortseg {
    if (!_sortseg) {
        _sortseg = [[HMSegmentedControl alloc]init];
        _sortseg.backgroundColor = [UIColor whiteColor];
        _sortseg.selectionIndicatorColor = kMainTone;
        _sortseg.selectionIndicatorHeight = 1.0;
        _sortseg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _sortseg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _sortseg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _sortseg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kMainTone};
        _sortseg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
        __weak __typeof(self)weakSelf = self;
        _sortseg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.categorySelectIndex = index;
            [strongSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _sortseg;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-46 * 2 - 30, 32)];
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

- (UIView *)catogryMoreView {
    if (!_catogryMoreView) {
        _catogryMoreView = [[UIView alloc] init];
        _catogryMoreView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kColorValue(0x999999);
        [_catogryMoreView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(38);
            make.width.mas_equalTo(2);
            make.left.centerY.equalTo(_catogryMoreView);
            
        }];
        
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ph_down"]];
        [_catogryMoreView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_catogryMoreView);
            make.right.equalTo(_catogryMoreView).mas_offset(-4);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1;
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = kFontSystem(14);
        [_catogryMoreView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_catogryMoreView);
        }];
    }
    return _catogryMoreView;
}

- (UIView *)sortMoreView {
    if (!_sortMoreView) {
        _sortMoreView = [[UIView alloc] init];
        _sortMoreView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kColorValue(0x999999);
        [_sortMoreView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(38);
            make.width.mas_equalTo(2);
            make.left.centerY.equalTo(_sortMoreView);
            
        }];
        
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ph_down"]];
        [_sortMoreView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_sortMoreView);
            make.right.equalTo(_sortMoreView).mas_offset(-4);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2;
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"排序" forState:UIControlStateNormal];
        button.titleLabel.font = kFontSystem(14);
        [button setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        [_sortMoreView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_sortMoreView);
        }];
    }
    return _sortMoreView;
}

- (NSArray *)sortTypeArray {
    if (!_sortTypeArray) {
        _sortTypeArray = @[@{@"sortTitle" : @"推荐", @"sortValue" : @(1),},
                           @{@"sortTitle" : @"热播", @"sortValue" : @(2)},
                           @{@"sortTitle" : @"最新", @"sortValue" : @(3)},
                           @{@"sortTitle" : @"完结", @"sortValue" : @(4)},
                           @{@"sortTitle" : @"连载", @"sortValue" : @(5)}];
    }
    return _sortTypeArray;
}
@end
