//
//  BookDetailSubDownLoadViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/21.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "BookDetailSubDownLoadViewController.h"
#import "BookChapterCell.h"
#import "BookDetailModel.h"
#import "PlayViewController.h"
#import "BookDownloadBottomView.h"
#import "MCDownloader.h"
#import "BookChapterIntervalView.h"
#import "ISYDownloadHelper.h"

@interface BookDetailSubDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) BookChapterIntervalView *chapterView;
@property (nonatomic, weak) UIButton *listButton;
@property (nonatomic, strong) UIView *luxianView;
@property (nonatomic, assign) NSInteger luxianIndex; // default 0
@end

@implementation BookDetailSubDownLoadViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (BookChapterModel *chapterModel in _selectArray) {
        chapterModel.isSelected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _zhengxu = YES;
    // Do any additional setup after loading the view.
    [MCDownloader sharedDownloader].downloadTimeout = 60;
    [MCDownloader sharedDownloader].maxConcurrentDownloads = 1;
    [self configUI];
    [self configData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    NSString *text = [NSString stringWithFormat:@"%@",_detailModel.title];
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:text];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view).mas_offset(-115/2);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(115/2);
    }];
    
    [self.bottomView addSubview:self.chapterView];
    [self.chapterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView).mas_offset(-56);
    }];
}

- (void)configData {
    _dataArray = [NSMutableArray arrayWithCapacity:50];
    _selectArray = [NSMutableArray arrayWithCapacity:50];
    if (_detailModel.chapters.count) {
        [self getChapterWithIndex:0];
    }
    self.chapterView.totalCount = _detailModel.chapters.count;
}

- (void)getChapterWithIndex:(NSInteger)index {
    for (BookChapterModel *chapterModel in _selectArray) {
        chapterModel.isSelected = NO;
    }
    [_selectArray removeAllObjects];
    [_dataArray removeAllObjects];
    
    NSInteger count = (index + 1) * 50;
    if (count > _detailModel.chapters.count) {
        count = index * 50 + _detailModel.chapters.count%50;
    }
    for (NSInteger i = index * 50; i < count ; i++) {
        BookChapterModel *m = _detailModel.chapters[i];
        [_dataArray addObject:[m yy_modelCopy]];
    }
    [_tableView reloadData];
    if (_dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"BookChapterCell";
    BookChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    __weak __typeof(self)weakSelf = self;
    cell.chooseBlock = ^(BookChapterModel *chapterModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf chooseBtnClick:chapterModel];
    };
    cell.detailModel = _detailModel;
    
    BookChapterModel *chapterModel;
    if (self.zhengxu) {
        chapterModel = _dataArray[indexPath.row];
    } else {
        NSInteger count = _dataArray.count - indexPath.row - 1;
        chapterModel = _dataArray[count];
    }
    
    cell.chapterModel = chapterModel;
    cell.url = [chapterModel.l_url decodePlayURL];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.userInteractionEnabled = YES;
    imgView.image = [UIImage imageNamed:@"download_ad"];
    return imgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookChapterModel *chapterModel;
    if (self.zhengxu) {
        chapterModel = _dataArray[indexPath.row];
    } else {
        NSInteger count = _dataArray.count - indexPath.row - 1;
        chapterModel = _dataArray[count];
    }
    [APPDELEGATE.playVC playWithBook:_detailModel index:chapterModel.l_id.integerValue-1];
    if ([self.navigationController.viewControllers containsObject:APPDELEGATE.playVC]) {
        [self.navigationController popToViewController:APPDELEGATE.playVC animated:YES];
    }else {
        [self.navigationController pushViewController:APPDELEGATE.playVC animated:YES];
    }
}

#pragma mark - Actions
//切换章节
- (void)chapterItemSelect:(NSInteger)idx {
    [self getChapterWithIndex:idx];
}

//单选
- (void)chooseBtnClick:(BookChapterModel *)chapterModel {
    if ([_selectArray containsObject:chapterModel]) {
        [_selectArray removeObject:chapterModel];
    }else {
        [_selectArray addObject:chapterModel];
    }
}

//全选
- (void)allBtnClick:(BOOL)isAll {
    [_selectArray removeAllObjects];
    for (BookChapterModel *m in _dataArray) {
        m.isSelected = isAll;
    }
    if (isAll) {
        [_selectArray addObjectsFromArray:_dataArray];
    }
    [_tableView reloadData];
}

//下载
- (void)downloadBtnClick {
    if (_selectArray.count == 0) {
        [SVProgressHUD showImage:nil status:@"请选择要下载的章节"];
        return;
    }
    
    [self checkAvailabilityWithModel:_selectArray.firstObject completed:^(BOOL available) {
        if (available) {
            [self download];
        }else{
            //切换线路
            [self showLuxian];
        }
    }];
}

- (void)download {
    for (BookChapterModel *m in _selectArray) {
        NSString *urlString = [m.l_url decodePlayURL];
        if (self.luxianIndex != 0) {
            NSString *luxian = [[self luxianData] objectAtIndex:self.luxianIndex];
            NSArray *items = [luxian componentsSeparatedByString:@"#"];
            NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@", items[0], _detailModel.show_id,items[1], m.l_id, items[2]];
            m.l_url = str;
            urlString = str;
        }
        MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:urlString];
        if (receipt.progress.fractionCompleted == 1.0) {
            continue;
        }else {
            receipt.state = MCDownloadStateNone;
            receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
                NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document,_detailModel.show_id,_detailModel.title];
                return [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",m.l_id,urlString.lastPathComponent]];
            };
            
        }
        
        NSInteger row = [_dataArray indexOfObject:m];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

- (void)checkAvailabilityWithModel:(BookChapterModel *)model completed:(void(^)(BOOL))completed {
    if (self.luxianIndex != 0) {
        NSString *luxian = [[self luxianData] objectAtIndex:self.luxianIndex];
        NSArray *items = [luxian componentsSeparatedByString:@"#"];
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@", items[0], _detailModel.show_id,items[1], model.l_id, items[2]];
        model.l_url = urlString;
    }
    [ZXProgressHUD showLoading:@""];
    [[ISYDownloadHelper shareInstance] downloadChaper:model bookId:self.detailModel.show_id progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        if (expectedSize > 0 && speed > 0) {
            completed(YES);
            [ZXProgressHUD hide];
        }
    } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
        if (error) {
            completed(NO);
            [ZXProgressHUD hide];
        }
    }];
}

- (void)showLuxian {
    if (self.luxianView) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [window addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    NSArray *data = [self luxianData];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8;
    [bgView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MAX(300, kScreenWidth * 0.8));
        make.height.mas_equalTo((data.count + 2) * 44);
        make.center.equalTo(bgView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"当前路线无法播放，请选择其他路线";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
        make.height.mas_equalTo(44);
    }];
    UIView *upview = titleLabel;
    for (NSInteger index = 0; index < data.count; ++index) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        [btn addTarget:self action:@selector(luxianChange:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"路线%ld", index + 1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (self.luxianIndex == index) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.height.mas_equalTo(44);
            make.top.equalTo(upview.mas_bottom);
        }];
        
        UIView *lineview = [UIView new];
        lineview.backgroundColor = [UIColor grayColor];
        [contentView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(upview);
            make.height.mas_equalTo(0.5);
        }];
        
        upview = btn;
    }
    
    UIView *lineview = [UIView new];
    lineview.backgroundColor = [UIColor grayColor];
    [contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(upview);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(closeLuxian) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(44);
        make.top.equalTo(upview.mas_bottom);
    }];
    self.luxianView = bgView;
}

- (NSArray *)luxianData {
    return @[@"",
             @"http://mp3.aikeu.com/#/#.mp3",
             @"http://mp3.aikeu.com/#/#.m4a",
             @"http://mp31.aikeu.com/#/#.mp3",
             @"http://mp31.aikeu.com/#/#.m4a"];
}

- (void)luxianChange:(UIButton *)btn {
    [self closeLuxian];
    NSInteger index = btn.tag;
    self.luxianIndex = index;
    [self downloadBtnClick];
}

- (void)closeLuxian {
    [self.luxianView removeFromSuperview];
    self.luxianView = nil;
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"BookChapterCell" bundle:nil] forCellReuseIdentifier:@"BookChapterCell"];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [listButton setImage:[UIImage imageNamed:@"detail_down"] forState:UIControlStateNormal];
        [listButton setImage:[UIImage imageNamed:@"detail_up"] forState:UIControlStateSelected];
        [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:listButton];
        [listButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(_bottomView).mas_offset((115/ 2- 44)/ 2);
            make.right.equalTo(_bottomView).mas_offset(-12);
        }];
        _listButton = listButton;
        
    }
    return _bottomView;
}

- (void)listButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view);
            make.height.top.equalTo(self.view);
            [self.chapterView updatesCrollDirection:UICollectionViewScrollDirectionVertical];
        }];
    } else {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(115/2);
        }];
        [self.chapterView updatesCrollDirection:UICollectionViewScrollDirectionHorizontal];
        
    }
}

- (BookChapterIntervalView *)chapterView {
    if (!_chapterView) {
        _chapterView = [[BookChapterIntervalView alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        _chapterView.itemBlock = ^(NSInteger index) {
            [weakSelf getChapterWithIndex:index];
            if (weakSelf.listButton.isSelected) {
                [weakSelf listButtonClick:weakSelf.listButton];
            }
        };
        
    }
    return _chapterView;
}

- (void)setZhengxu:(BOOL)zhengxu {
    _zhengxu = zhengxu;
    [self.tableView reloadData];
}
@end
