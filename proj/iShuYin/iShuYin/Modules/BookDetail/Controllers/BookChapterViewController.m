//
//  BookChapterViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookChapterViewController.h"
#import "BookChapterCell.h"
#import "BookDetailModel.h"
#import "PlayViewController.h"
#import "BookDownloadBottomView.h"
#import "MCDownloader.h"
#import "BookChapterIntervalView.h"
#import "ISYDownloadChaperCell.h"
#import "ISYDownloadHelper.h"
#import "LoginViewController.h"

@interface BookChapterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BookChapterIntervalView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) UIView *luxianView;
@property (nonatomic, assign) NSInteger luxianIndex; // default 0
@end

@implementation BookChapterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (BookChapterModel *chapterModel in _selectArray) {
        chapterModel.isSelected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MCDownloader sharedDownloader].downloadTimeout = 60;
    [MCDownloader sharedDownloader].maxConcurrentDownloads = 1;
    [self configUI];
    [self configData];
    self.topView.totalCount = self.detailModel.chapters.count;
}

- (void)configUI {
    NSString *text = [NSString stringWithFormat:@"%@",_detailModel.title];
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:text];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(55);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
          make.bottom.equalTo(self.view);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.topView.mas_top);
    }];
}

- (void)configData {
    _dataArray = [NSMutableArray arrayWithCapacity:50];
    _selectArray = [NSMutableArray arrayWithCapacity:50];
    if (_detailModel.chapters.count) {
        [self getChapterWithIndex:0];
    }
}

- (void)getChapterWithIndex:(NSInteger)index {
//    _bottomView.isChooseAll = NO;
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
    static NSString *reuseId = @"ISYDownloadChaperCellId";
    ISYDownloadChaperCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.detailModel = _detailModel;
    BookChapterModel *chapterModel = _dataArray[indexPath.row];
    cell.chapterModel = chapterModel;
    cell.url = [chapterModel.l_url decodePlayURL];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookChapterModel *chapterModel = _dataArray[indexPath.row];
    chapterModel.isSelected = !chapterModel.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if ([_selectArray containsObject:chapterModel]) {
        [_selectArray removeObject:chapterModel];
    }else {
        [_selectArray addObject:chapterModel];
    }
    
    self.selectAllButton.selected = _selectArray.count == self.dataArray.count;
   
}

#pragma mark - Actions
- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteBtnClick {
    if (_selectArray.count == 0) {
        [SVProgressHUD showImage:nil status:@"请选择要删除的章节"];
        return;
    }
    for (BookChapterModel *m in _selectArray) {
        [[ISYDownloadHelper shareInstance] deleteDownloadBookId:self.detailModel.show_id chaper:m];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)downLoadButtonClick:(UIButton *)button {
    if (!APPDELEGATE.loginModel) {
        LoginViewController *vc = SBVC(@"LoginVC");
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    if (![[ISYDBManager shareInstance] hasShareBook:self.detailModel.show_id]) {
        [SVProgressHUD showImage:nil status:@"要分享后才可批量下载哦"];
        __weak __typeof(self)weakSelf = self;
        ZXPopView *view = [[ZXPopView alloc]initWithShareBlock:^(NSInteger idx) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf shareToPlatform:idx];
        }];
        [view showInView:self.navigationController.view animated:ZXPopViewAnimatedSlip];
        return;
    }
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

- (void)download{
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
        [[ISYDownloadHelper shareInstance] downloadChaper:m bookId:self.detailModel.show_id progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            
        } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
            
        }];
        
        NSInteger row = [_dataArray indexOfObject:m];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        
        [SVProgressHUD showImage:nil status:@"开始下载"];
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
    __block id context = nil;
    [self performSelector:@selector(loadingChange:) withObject:context afterDelay:5];
    NSURL *url = [NSURL URLWithString:[model.l_url decodePlayURL]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 60;
    NSURLSession *sessrion = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [sessrion dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        context = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZXProgressHUD hide];
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
            if (r.statusCode == 200) {
                completed(YES);
            } else {
                completed(NO);
            }
        });
    }];
    [task resume];
}

- (void)loadingChange:(id)context {
    if (!context) {
        [ZXProgressHUD showLoading:@"当前网络堵塞请等待..."];
    }
}

- (void)selectAllButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    [_selectArray removeAllObjects];
    for (BookChapterModel *m in _dataArray) {
        m.isSelected = button.selected;
    }
    
    if (button.selected) {
        [_selectArray addObjectsFromArray:_dataArray];
    }
    [_tableView reloadData];
}

- (void)shareToPlatform:(NSInteger)idx {
    NSString *title = self.detailModel.title;
    NSString *content = self.detailModel.desc;
    NSString *url = (idx < 2) ? [NSString stringWithFormat:@"http://weixin.mp3book.cn/show-%@.html",self.detailModel.show_id] :  [NSString stringWithFormat:@"http://m.ishuyin.com/show-%@.html",self.detailModel.show_id];
    NSData *imgData = nil;
    if ([self.detailModel.thumb containsString:kPrefixImageDefault]) {
        imgData = [NSData dataWithContentsOfURL:[self.detailModel.thumb url]];
    }else {
        imgData = [NSData dataWithContentsOfURL:[[kPrefixImageDefault stringByAppendingString:self.detailModel.thumb] url]];
    }
    UMSocialPlatformType platformType = UMSocialPlatformType_UnKnown;//平台
    UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];//创建分享消息对象
    switch (idx) {
        case 0:platformType = UMSocialPlatformType_WechatSession;break;//微信好友
        case 1:platformType = UMSocialPlatformType_WechatTimeLine;break;//朋友圈
        case 2:platformType = UMSocialPlatformType_Qzone;break;//空间
        case 3:platformType = UMSocialPlatformType_QQ;break;//QQ
        default:break;
    }
    if (platformType == UMSocialPlatformType_UnKnown) {
        return;
    }
    //创建网页内容对象
    UMShareWebpageObject *shareWebObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:imgData];
    shareWebObject.webpageUrl = url;
    shareMessage.shareObject = shareWebObject;
    [[UMSocialManager defaultManager]shareToPlatform:platformType messageObject:shareMessage currentViewController:self completion:^(id result, NSError *error) {
        if (error.localizedDescription) {
            DLog(@"%@", error.localizedDescription);
        }else {
            DLog(@"%@", result);
            [[ISYDBManager shareInstance] updateShareBookId:self.detailModel.show_id];
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
    [self downLoadButtonClick:nil];
}

- (void)closeLuxian {
    [self.luxianView removeFromSuperview];
    self.luxianView = nil;
}

#pragma mark - Getter

- (BookChapterIntervalView *)topView {
    if (!_topView) {
        _topView = [[BookChapterIntervalView alloc] init];
        __weak __typeof(self)weakSelf = self;
        _topView.itemBlock = ^(NSInteger index) {
            [weakSelf getChapterWithIndex:index];
        };
    }
    return _topView;
}

- (UIButton *)selectAllButton {
    if (!_selectAllButton) {
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        [_selectAllButton setTitle:@" 全选本页" forState:UIControlStateNormal];
        [_selectAllButton setImage:[UIImage imageNamed:@"download_choose_nor"] forState:UIControlStateNormal];
        [_selectAllButton setImage:[UIImage imageNamed:@"download_choose_sel"] forState:UIControlStateSelected];
        [_selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllButton;
}

- (UIView *)bottomView {
    if (!_bottomView ) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.selectAllButton];
        [self.selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView).mas_offset(12);
            make.centerY.equalTo(_bottomView);
        }];
        
        if (self.isDelete) {
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancleBtnClick)
                forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.backgroundColor = [UIColor redColor];
            cancelBtn.titleLabel.textColor = [UIColor whiteColor];
            cancelBtn.layer.masksToBounds = YES;
            cancelBtn.layer.cornerRadius = 4.0;
            
            [_bottomView addSubview:cancelBtn];
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_bottomView).mas_offset(-12);
                make.centerY.equalTo(_bottomView);
                make.size.mas_equalTo(CGSizeMake(90, 33));
            }];
            UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deletebtn setTitle:@"删除" forState:UIControlStateNormal];
            [deletebtn addTarget:self action:@selector(deleteBtnClick)
                     forControlEvents:UIControlEventTouchUpInside];
            deletebtn.backgroundColor = [UIColor redColor];
            deletebtn.titleLabel.textColor = [UIColor whiteColor];
            deletebtn.layer.masksToBounds = YES;
            deletebtn.layer.cornerRadius = 4.0;
            
            [_bottomView addSubview:deletebtn];
            [deletebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cancelBtn.mas_left).mas_offset(-12);
                make.centerY.equalTo(_bottomView);
                make.size.mas_equalTo(CGSizeMake(90, 33));
            }];
           
        } else {
            UIButton *downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [downLoadButton setTitle:@"立即下载" forState:UIControlStateNormal];
            [downLoadButton addTarget:self action:@selector(downLoadButtonClick:)
                     forControlEvents:UIControlEventTouchUpInside];
            downLoadButton.backgroundColor = [UIColor redColor];
            downLoadButton.titleLabel.textColor = [UIColor whiteColor];
            downLoadButton.layer.masksToBounds = YES;
            downLoadButton.layer.cornerRadius = 4.0;
            
            [_bottomView addSubview:downLoadButton];
            [downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_bottomView).mas_offset(-12);
                make.centerY.equalTo(_bottomView);
                make.size.mas_equalTo(CGSizeMake(90, 33));
            }];
        }
    }
    return _bottomView;
}

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
        [_tableView registerClass:[ISYDownloadChaperCell class] forCellReuseIdentifier:@"ISYDownloadChaperCellId"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
