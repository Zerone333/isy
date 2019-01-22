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
#import "BookDetailViewController.h"
#import "HomeSlideModel.h"
#import "ZXCycleView.h"

#define kHomeHotViewControllerItemCount 4

@interface HomeHotViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ZXCycleView *cycleView;
@property (nonatomic, strong) UIView *headContentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *announcementLabel;
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation HomeHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热播";
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
