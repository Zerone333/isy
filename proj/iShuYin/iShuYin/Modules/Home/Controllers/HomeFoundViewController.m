//
//  HomeFoundViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "HomeFoundViewController.h"
#import "HomeModel.h"
#import "HomeTableCell.h"
#import "HomeFoundItemModel.h"
#import "ISYBookTableViewCell.h"
#import "ISYBookListHotTableViewCell.h"
#import "ISYBookHeaderFooterView.h"
#import "ISYBookRefreshFooterView.h"
#import "ISYCategoryMoreViewController.h"
#import "ZXCycleView.h"
#import "HomeSlideModel.h"

@interface HomeFoundViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ZXCycleView *cycleView;
@property (nonatomic, strong) UIView *headContentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *announcementLabel;
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation HomeFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestData];
}

#pragma mark - private
- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headContentView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2HomeList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            HomeModel *model = [HomeModel yy_modelWithJSON:responseObject[@"data"]];
            strongSelf.model = model;
            [self converDataSource];
            strongSelf.announcementLabel.text = model.public_content;
            [strongSelf.tableView reloadData];
            [strongSelf.announcementLabel sizeToFit];
            CGFloat width = CGRectGetMinX(self.announcementLabel.frame) -  CGRectGetWidth(self.announcementLabel.frame) - 40;
            
            [UIView animateWithDuration: - width / kScreenWidth * 4.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
                strongSelf.announcementLabel.transform = CGAffineTransformMakeTranslation(width, 0);
            } completion:nil];
            
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
    HomeFoundItemModel *item1 = [self createItem:self.model.recommend keyType:@"推荐"];
    item1.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item2 = [self createItem:self.model.hot keyType:@"热播"];
    item2.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item3 = [self createItem:self.model.newest keyType:@"新作"];
    item3.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item4 = [self createItem:self.model.xiaoshuo keyType:@"小说"];
    item4.cellType = HomeTableCellViewType_Table;
    HomeFoundItemModel *item5 = [self createItem:self.model.entertain keyType:@"娱乐"];
    item5.cellType = HomeTableCellViewType_Table;
    HomeFoundItemModel *item6 = [self createItem:self.model.comment keyType:@"评书"];
    item6.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item7 = [self createItem:self.model.child keyType:@"儿童"];
    item7.cellType = HomeTableCellViewType_Collection;
    HomeFoundItemModel *item8 = [self createItem:self.model.opera keyType:@"戏曲"];
    item8.cellType = HomeTableCellViewType_Collection;
    self.dataSource = @[item1, item2, item3, item4, item5, item6, item7, item8];
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
    HomeFoundItemModel *model = self.dataSource[section];
    if (model.cellType == HomeTableCellViewType_Collection) {
        return 1;
    }  else {
        HomeFoundItemModel *model = self.dataSource[section];
        return model.randarDataSource.count;
    }
}

- (void)pushBookVC:(NSString *)bookID {
    if (self.bookBlock) {
        self.bookBlock(bookID);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    if (model.cellType == HomeTableCellViewType_Collection) {
        ISYBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookTableViewCell cellID]];
        [cell updateDataSource:model.randarDataSource];
        __weak __typeof(self)weakSelf = self;
        cell.itemClickBlock = ^(HomeBookModel *book) {
            //TODO:进入详情
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf pushBookVC:book.show_id];
        };
        return cell;
    } else {
        ISYBookListHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYBookListHotTableViewCell cellID]];
        HomeFoundItemModel *item = self.dataSource[indexPath.section];
        if ([item.keyType isEqualToString:@"小说"]) {
            [cell setModel:model.randarDataSource[indexPath.row] type:@"小说"];
        } else if ([item.keyType isEqualToString:@"娱乐"]) {
            [cell setModel:model.randarDataSource[indexPath.row] type:@"娱乐"];
        } else {
            [cell setModel:model.randarDataSource[indexPath.row] type:nil];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoundItemModel *model = self.dataSource[indexPath.section];
    if (model.cellType == HomeTableCellViewType_Collection) {
        return [ISYBookTableViewCell cellHeightForLineCount:1];
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
        if (section == 0 || section == 1) {
            strongSelf.moreBlock(section);
        } else {
            HomeBookModel *book = item.randarDataSource.firstObject;
            ISYCategoryMoreViewController *vc = [[ISYCategoryMoreViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            CategoryModel *category = [[CategoryModel alloc] init];
            category.cat_id = book.cat_id;
            category.cat_name = item.keyType;
            vc.category = category;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
//        ISYMoreViewController *moreVc = [[ISYMoreViewController alloc] init];
//        [strongSelf.navigationController pushViewController:moreVc animated:YES];
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
    if (model.cellType == HomeTableCellViewType_Collection) {
        return;
    } else {
        HomeBookModel *item = model.randarDataSource[indexPath.row];
        [self pushBookVC:item.show_id];
    }
}

#pragma mark - get/set method
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

- (UILabel *)announcementLabel {
    if (!_announcementLabel) {
        _announcementLabel = [[UILabel alloc] init];
        _announcementLabel.text = @"xxxx";
        _announcementLabel.font = [UIFont systemFontOfSize:11];
        _announcementLabel.textColor = kColorValue(0x282828);
    }
    return _announcementLabel;
}
@end
