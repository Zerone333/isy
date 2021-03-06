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
#import "ISYBookTableViewCell.h"
#import "ISYBookListHotTableViewCell.h"
#import "ISYBookHeaderFooterView.h"
#import "ISYMoreViewController.h"
#import "ISYBookRefreshFooterView.h"
#import "ISYCategoryDetailViewController.h"
#import "BookDetailViewController.h"
#import "ZXCycleView.h"
#import "HomeSlideModel.h"

@interface HomeRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ZXCycleView *cycleView;
@property (nonatomic, strong) UIView *headContentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *announcementLabel;
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
    self.tableView.tableHeaderView = self.headContentView;
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
    HomeFoundItemModel *item6 = [self createItem:self.model.comment keyType:@"评书" cellType:HomeTableCellViewType_Collection];
    HomeFoundItemModel *item7 = [self createItem:self.model.child keyType:@"儿童" cellType:HomeTableCellViewType_Collection];
    HomeFoundItemModel *item4 = [self createItem:self.model.xiaoshuo keyType:@"小说" cellType:HomeTableCellViewType_Table];
    self.dataSource = @[item6, item7, item4];
}
- (HomeFoundItemModel *)createItem:(NSArray *)dataArray keyType:(NSString *)keyType cellType:(HomeTableCellViewType)cellType{
    HomeFoundItemModel *item = [[HomeFoundItemModel alloc] init];
    item.keyType = keyType;
    item.dataSource = dataArray;
    item.cellType = cellType;
    item.randarDataSource = [self makeRandomItems:dataArray count:cellType == HomeTableCellViewType_Table ? 3 : 6];
    return item;
}

// 重新刷新随机item
- (void)refreshRandaItem:(HomeFoundItemModel * )item {
    item.randarDataSource = [self makeRandomItems:item.dataSource count:item.cellType == HomeTableCellViewType_Table ? 3 : 6];
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

- (void)pushBookVC:(NSString *)bookID {
    if (self.navigationController) {
        if ([NSString isEmpty:bookID]) {
            [SVProgressHUD showImage:nil status:@"书本数据有误"];
            return;
        }
        BookDetailViewController *vc = [[BookDetailViewController alloc]init];
        vc.bookid = bookID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (self.bookBlock) {
        self.bookBlock(bookID);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1 ) {
        return 1;
    } else {
        HomeFoundItemModel *model = self.dataSource[section];
        return model.randarDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    if (indexPath.section <= 1) {
        ISYBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookTableViewCell cellID]];
        [cell updateDataSource:model.randarDataSource];
        __weak __typeof(self)weakSelf = self;
        cell.itemClickBlock = ^(HomeBookModel *book) {
            HomeBookModel *item = model.randarDataSource[indexPath.row];
            [weakSelf pushBookVC:item.show_id];
        };
        return cell;
    } else {
        ISYBookListHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookListHotTableViewCell cellID]];
//        cell.model = model.randarDataSource[indexPath.row];
//        
        [cell setModel:model.randarDataSource[indexPath.row] type:@"小说"];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 1) {
        return [ISYBookTableViewCell cellHeightForLineCount:2];
    } else {
        return [ISYBookListTableViewCell cellHeight];
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
        HomeBookModel *book = item.randarDataSource.firstObject;
        CategoryModel *category = [[CategoryModel alloc] init];
        category.cat_name = item.keyType;
        category.cat_id = book.cat_id;
        ISYCategoryDetailViewController *moreVc = [[ISYCategoryDetailViewController alloc] init];
        moreVc.category = category;
        [strongSelf.navigationController pushViewController:moreVc animated:YES];
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
        [strongSelf refreshRandaItem:item];
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
    return view;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    if (model.cellType == HomeTableCellViewType_Table) {
        HomeBookModel *item = model.randarDataSource[indexPath.row];
        [self pushBookVC:item.show_id];
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
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[ISYBookTableViewCell class] forCellReuseIdentifier:[ISYBookTableViewCell cellID]];
        [_tableView registerClass:[ISYBookListHotTableViewCell class] forCellReuseIdentifier:[ISYBookListHotTableViewCell cellID]];
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData];
        }];
    }
    return _tableView;
}


- (void)setSlide:(NSArray *)slide {
    _slide = slide;
    NSMutableArray *slideUrls = [NSMutableArray array];
    for (HomeSlideModel *moel in slide) {
        if ([moel.img containsString:kPrefixImageSlide]) {
            [slideUrls addObject:moel.img];
        }else {
            [slideUrls addObject:[kPrefixImageSlide stringByAppendingString:moel.img]];
        }
    }
    self.cycleView.imageURLs = slideUrls;
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
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kColorValue(0xf3f5f7);
        
        [bottomContentView addSubview:self.announcementLabel];
        [bottomContentView addSubview:bgView];
        [bottomContentView addSubview:announcementImage];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(bottomContentView);
            make.right.equalTo(announcementImage).mas_offset(8);
        }];
        
        [self.announcementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(announcementImage.mas_right).mas_offset(8);
            make.centerY.equalTo(bottomContentView);
        }];
        
        [announcementImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomContentView);
            make.size.mas_equalTo(CGSizeMake(13, 13));
            make.left.equalTo(bottomContentView).mas_offset(12);
        }];
    }
    return _headContentView;
}

- (ZXCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[ZXCycleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*162/375) pageCtrlStyle:ZXPageCtrlStyleDefault timeInterval:5.0];
        _cycleView.placeholder = @"ph_image";
        __weak __typeof(self)weakSelf = self;
        _cycleView.selectBlock = ^(ZXCycleView *cycleView, NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.model.slide.count == 0) {
                return;
            }
            HomeSlideModel *slide = strongSelf.model.slide[index];
            [strongSelf.parentVC pushToBookDetailWithIdentity:slide.show_id];
        };
    }
    return _cycleView;
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

- (void)setAdString:(NSString *)adString {
    _adString = adString;
    [self.announcementLabel setText:adString];
    [self.announcementLabel sizeToFit];
    CGFloat width = CGRectGetMinX(self.announcementLabel.frame) -  CGRectGetWidth(self.announcementLabel.frame) - 40;
    
    [UIView animateWithDuration: - width / kScreenWidth * 4.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.announcementLabel.transform = CGAffineTransformMakeTranslation(width, 0);
    } completion:nil];
}
@end
