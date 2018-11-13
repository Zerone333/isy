//
//  HomeViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeSlideModel.h"
#import "HomeTableCell.h"
#import "ZXCycleView.h"
#import "MoreListViewController.h"
#import "MoreManageViewController.h"
#import "FinishManageViewController.h"
#import "SerialListViewController.h"
#import "BookDetailViewController.h"
#import "CategoryViewController.h"
#import "HomeFoundViewController.h"
#import "HomeRecommendViewController.h"
#import "HomeHotViewController.h"
#import "CarHomeViewController.h"
#import "HistoryViewController.h"
#import "ISYDownLoadViewController.h"
#import "ISYSearchViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UIView *headContentView;
@property (nonatomic, strong) ZXCycleView *cycleView;
@property (nonatomic, strong) UILabel *announcementLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, strong) HomeFoundViewController *vc1;
@property (nonatomic, strong) CategoryViewController *vc2;
@property (nonatomic, strong) HomeRecommendViewController *vc3;
@property (nonatomic, strong) HomeHotViewController *vc4;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.seg.selectedSegmentIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [APPLICATION setStatusBarHidden:NO];
//    [self configUI];
    [self setupUI];
    [self requestData];
    [self requestAppUpdate];
    self.seg.selectedSegmentIndex = 0;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.searchBar.frame = CGRectMake(46, 6, kScreenWidth-92, 32);
//}

- (void)setupUI {
    // nav button
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:YES];
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:NO];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"home_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"home_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(46, 6, kScreenWidth-46 * 2, 32);
    [bgView addSubview:self.searchBar];
    self.navigationItem.titleView = bgView;
    
    //
    [self.view addSubview:self.seg];
    [self.view addSubview:self.cycleView];
    [self.view addSubview:self.contentScrollView];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seg.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScreenWidth*162/375);
    }];
    
    [self.contentScrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor redColor];
    [self.contentScrollView addSubview:contentView];
    
    [contentView addSubview:self.vc1.view];
    [contentView addSubview:self.vc2.view];
    [contentView addSubview:self.vc3.view];
    [contentView addSubview:self.vc4.view];
    
    [self addChildViewController:self.vc1];
    [self addChildViewController:self.vc2];
    [self addChildViewController:self.vc3];
    [self addChildViewController:self.vc4];
    
    [self.vc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(contentView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(self.vc1.view.mas_right);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.vc3.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(self.vc2.view.mas_right);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.vc4.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(self.vc3.view.mas_right);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentScrollView);
        make.height.mas_equalTo(self.contentScrollView);
        make.top.equalTo(self.contentScrollView);
        make.right.equalTo(self.vc4.view);
    }];
}

- (void)configUI {
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:YES];
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:NO];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"home_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"home_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(46, 6, kScreenWidth-46 * 2, 32);
    [bgView addSubview:self.searchBar];
    self.navigationItem.titleView = bgView;
    
    [self.view addSubview:self.seg];
    [self.view addSubview:self.tableView];
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kNavBarOffset);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seg.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kTabBarOffset);
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryHomeList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            HomeModel *model = [HomeModel yy_modelWithJSON:responseObject[@"data"]];
            strongSelf.model = model;
            
            NSMutableArray *slideUrls = [NSMutableArray array];
            for (HomeSlideModel *slide in model.slide) {
                if ([slide.img containsString:kPrefixImageSlide]) {
                    [slideUrls addObject:slide.img];
                }else {
                    [slideUrls addObject:[kPrefixImageSlide stringByAppendingString:slide.img]];
                }
            }
            strongSelf.cycleView.imageURLs = slideUrls;
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        [strongSelf pushToBookDetailWithIdentity:book_id];
    };
    cell.moreBlock = ^(HomeTableCellType type) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        MoreManageViewController *vc = [[MoreManageViewController alloc]init];
        vc.index = type;
        vc.hidesBottomBarWhenPushed = YES;
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
//    if (indexPath.section == 0) {
//        cell.type = HomeTableCellTypeRecommend;
////        cell.dataArray = _model.recommend;
//    }else if (indexPath.section == 1) {
//        cell.type = HomeTableCellTypeHot;
////        cell.dataArray = _model.hot;
//    }else if (indexPath.section == 2) {
//        cell.type = HomeTableCellTypeNew;
////        cell.dataArray = _model.newest;
//    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 10+28+54;
    if (indexPath.section == 0) {
        //推荐
        if (!_model || _model.recommend.count == 0) return 28+54;
        CGFloat item_w = (kScreenWidth-32-18) / 4.0;
        CGFloat item_h = item_w*105/80 + 30.5;
        NSInteger row = _model.recommend.count/4 + (_model.recommend.count%4 != 0);
        h += (item_h*row + (row-1)*20);
    }else if (indexPath.section == 1) {
        //热播
        if (!_model || _model.hot.count == 0) return 28+54;
        CGFloat item_w = (kScreenWidth-32-18) / 4.0;
        CGFloat item_h = item_w*105/80 + 30.5;
        NSInteger row = _model.hot.count/4 + (_model.hot.count%4 !=0);
        h += (item_h*row + (row-1)*20);
    }else {
        //最新
        if (!_model || _model.newest.count == 0) return 28+54;
        CGFloat item_w = (kScreenWidth-32-6) / 2.0;
        CGFloat item_h = item_w*105/165 + 37.5;
        NSInteger row = _model.newest.count/2 + (_model.newest.count%2 !=0);
        h += (item_h*row + (row-1)*10);
    }
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kScreenWidth*162/375 + 24;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headContentView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    if (!searchBar.text.length) {
//        return;
//    }
//    [searchBar resignFirstResponder];
//    MoreListViewController *vc = [[MoreListViewController alloc]init];
//    vc.keyword = searchBar.text;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    ISYSearchViewController *vc = [[ISYSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
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

- (void)leftButtonClick {
    //历史记录
    HistoryViewController *vc = [[HistoryViewController alloc] init];
//    ISYDownLoadViewController *vc = [[ISYDownLoadViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightButtonClick {
    //车载
    CarHomeViewController *vc = [[CarHomeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-46 * 2 - 30, 32)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"作者／播音／关键词等";
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

- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"发现",@"分类",@"推荐",@"热播"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
        __weak __typeof(self)weakSelf = self;
        _seg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            if (index == 1) {
////                FinishManageViewController *vc = [[FinishManageViewController alloc]init];
//                CategoryViewController *vc = [[CategoryViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [strongSelf.navigationController pushViewController:vc animated:YES];
//            }else if (index == 2) {
//                SerialListViewController *vc = [[SerialListViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [strongSelf.navigationController pushViewController:vc animated:YES];
//            }
            [self.contentScrollView scrollRectToVisible:CGRectMake(index *kScreenWidth, 0, CGRectGetWidth(self.contentScrollView.frame), CGRectGetHeight(self.contentScrollView.frame)) animated:YES];
        };
    }
    return _seg;
}

- (UIView *)headContentView {
    if (!_headContentView) {
        _headContentView = [[UIView alloc] init];
        _headContentView.backgroundColor = kColorValue(0xf3f5f7);
        _headContentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*162/375  + 24);
        
        [_headContentView addSubview:self.cycleView];
        
        UIView *bottomContentView = [[UIView alloc] init];
        [_headContentView addSubview:bottomContentView];
        
        [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(_headContentView);
            make.height.mas_equalTo(24);
        }];
        
        
        UIImageView *announcementImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_announcement"]];
        [bottomContentView addSubview:announcementImage];
        [bottomContentView addSubview:self.announcementLabel];
        [announcementImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomContentView);
            make.size.mas_equalTo(CGSizeMake(13, 13));
            make.left.equalTo(bottomContentView).mas_offset(12);
        }];
        
        [self.announcementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(announcementImage.mas_right).mas_offset(8);
            make.centerY.equalTo(bottomContentView);
        }];
        
        
    }
    return _headContentView;
}

- (UILabel *)announcementLabel {
    if (!_announcementLabel) {
        _announcementLabel = [[UILabel alloc] init];
        _announcementLabel.text = @"xxxx";
        _announcementLabel.font = [UIFont systemFontOfSize:11];
        _announcementLabel.textColor = kColorValue(0x282828);
    }
    return _announcementLabel;
}

- (ZXCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[ZXCycleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*162/375) pageCtrlStyle:ZXPageCtrlStyleDefault timeInterval:5.0];
        _cycleView.placeholder = @"ph_image";
        __weak __typeof(self)weakSelf = self;
        _cycleView.selectBlock = ^(ZXCycleView *cycleView, NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf.model || strongSelf.model.slide.count == 0) {
                return;
            }
            HomeSlideModel *slide = strongSelf.model.slide[index];
            [strongSelf pushToBookDetailWithIdentity:slide.show_id];
        };
    }
    return _cycleView;
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
        [_tableView registerNib:[UINib nibWithNibName:@"HomeTableCell" bundle:nil] forCellReuseIdentifier:@"HomeTableCell"];
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData];
        }];
    }
    return _tableView;
}

- (HomeFoundViewController *)vc1 {
    if (!_vc1) {
        _vc1 = [[HomeFoundViewController alloc] init];
        __weak __typeof(self)weakSelf = self;
        _vc1.bookBlock = ^(NSString *bookId) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf pushToBookDetailWithIdentity:bookId];
        } ;
        _vc1.moreBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (index == 0) {
                [strongSelf.seg setSelectedSegmentIndex:2 animated:YES];
                strongSelf.seg.indexChangeBlock(2);
            } else if (index == 1) {
                [strongSelf.seg setSelectedSegmentIndex:3 animated:YES];
                strongSelf.seg.indexChangeBlock(3);
            }
        };
    }
    return _vc1;
}

- (CategoryViewController *)vc2 {
    if (!_vc2) {
        _vc2 = [[CategoryViewController alloc] init];
    }
    return _vc2;
}

- (HomeRecommendViewController *)vc3 {
    if (!_vc3) {
        _vc3 = [[HomeRecommendViewController alloc] init];
        __weak __typeof(self)weakSelf = self;
        _vc3.bookBlock = ^(NSString *bookId) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf pushToBookDetailWithIdentity:bookId];
        } ;
    }
    return _vc3;
}

- (HomeHotViewController *)vc4 {
    if (!_vc4) {
        _vc4 = [[HomeHotViewController alloc] init];
        __weak __typeof(self)weakSelf = self;
        _vc4.bookBlock = ^(NSString *bookId) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf pushToBookDetailWithIdentity:bookId];
        } ;
    }
    return _vc4;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.scrollEnabled = NO;
    }
    return _contentScrollView;
}
@end
