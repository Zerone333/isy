//
//  BookDetailViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailModel.h"
#import "BookDetailInfoView.h"
#import "BookDetailDescOneView.h"
#import "BookDetailDescTwoView.h"
#import "BookDetailOthersView.h"
#import "MoreListViewController.h"
#import "BookChapterViewController.h"
#import "BookDownloadViewController.h"
#import "LoginViewController.h"
#import "BookSubDetailViewController.h"
#import "BookDetailSubDownLoadViewController.h"
#import "ISYDBManager.h"
#import "AppDelegate.h"

@interface BookDetailViewController ()
@property (nonatomic, strong) BookDetailInfoView *infoView;//书本信息
@property (nonatomic, strong) BookDetailDescOneView *descOneView;//内容简介
//@property (nonatomic, strong) BookDetailOthersView *authorView;//作者其他作品
//@property (nonatomic, strong) BookDetailOthersView *directorView;//播音其他作品
@property (nonatomic, strong) BookDetailModel *detailModel;


@property (nonatomic, strong) UIView *currentPlayContentView;
@property (nonatomic, strong) UIButton *playStatuButton;
@property (nonatomic, strong) UILabel *currentChaperlabel;
@property (nonatomic, strong) UIButton *sortingButton;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) BookDetailSubDownLoadViewController *vc1;
@property (nonatomic, strong) BookSubDetailViewController *vc2;
@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"详情"];
    [self requestData];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playChange) name:kNotiNamePlayChange object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playChange {
    
    //如果出于当前正在播放的详情页，则显示当前内容，否则，显示历史内容
    if ([APPDELEGATE.playVC.detailModel.show_id isEqualToString:self.detailModel.show_id]) {
        
        BookDetailModel *book = self.detailModel;
        BookChapterModel *chapter = self.detailModel.chapters[APPDELEGATE.playVC.currentIndex];
        self.currentChaperlabel.text = [NSString stringWithFormat:@"正在播放：%@-%@", book.title, chapter.l_title];
    } else {
        NSArray <ISYHistoryListenModel *> *historyArr = [[ISYDBManager shareInstance] queryBookHistoryListen];
        __block ISYHistoryListenModel *selfHistory = nil;
        [historyArr enumerateObjectsUsingBlock:^(ISYHistoryListenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.bookModel.show_id isEqualToString: self.detailModel.show_id]) {
                selfHistory = obj;
                *stop = YES;
            }
        }];
        if (selfHistory) {
            
            BookDetailModel *book = selfHistory.bookModel;
            BookChapterModel *chapter = book.chapters[selfHistory.chaperNumber];
            self.currentChaperlabel.text = [NSString stringWithFormat:@"上次播放：%@-%@", book.title, chapter.l_title];
        } else {
            self.currentChaperlabel.text = @"正在播放：无播放";
        }
    }
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryBookDetail];
    NSDictionary *params = @{@"book_id":_bookid};
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            BookDetailModel *detailModel = [BookDetailModel yy_modelWithJSON:responseObject[@"data"]];
            strongSelf.detailModel = detailModel;
            strongSelf.vc1.detailModel = detailModel;
            strongSelf.vc2.detailModel = detailModel;
            [strongSelf reloadUI];
            
            //本地缓存
            [[ISYDBManager shareInstance] insertBook:detailModel];
            [strongSelf playChange];
            
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reloadUI {
    [self initInfoView];
    [self initDescView];
    
    [self.view addSubview:self.currentPlayContentView];
    [self.view addSubview:self.scrollView];
    
    [self.currentPlayContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descOneView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(67);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPlayContentView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.scrollView addSubview:self.scrollContentView];
    
    [self.scrollContentView addSubview:self.vc1.view];
    [self.scrollContentView addSubview:self.vc2.view];
//    [contentView addSubview:self.vc3.view];
//    [contentView addSubview:self.vc4.view];
    
    [self addChildViewController:self.vc1];
    [self addChildViewController:self.vc2];
    
    [self.vc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.scrollContentView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollContentView);
        make.left.equalTo(self.vc1.view.mas_right);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
//    [self initAuthorView];
//    [self initDirectorView];
//
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.right.equalTo(self.vc2.view);
    }];

}

- (void)initInfoView {
    _infoView = [[BookDetailInfoView alloc] init];
    __weak __typeof(self)weakSelf = self;
    _infoView.collectionBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf collectionBtnClick];
    };
    _infoView.shareBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf shareBtnClick];
    };
    [self.view addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.equalTo(@140);
    }];
    _infoView.model = _detailModel;
}

- (void)initDescView {
    NSString *desc = [NSString isEmpty:_detailModel.desc]?@"暂无简介":_detailModel.desc;
        _descOneView = [BookDetailDescOneView loadFromNib];
        __weak __typeof(self)weakSelf = self;
    _descOneView.chapter1Block = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, CGRectGetWidth(strongSelf.scrollView.frame)) animated:YES];
    };
        _descOneView.chapterBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.scrollView scrollRectToVisible:CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetWidth(strongSelf.scrollView.frame)) animated:YES];
        };
        _descOneView.downloadBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf pushToBookChapterList];
        };
        [self.view addSubview:_descOneView];
        [_descOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(_infoView.mas_bottom).offset(8);
            make.height.equalTo(@(40));
        }];
        _descOneView.desc = desc;
}

#pragma mark - Action
//详情
- (void)pushToBookDetailWithIdentity:(NSString *)bookid {
    if ([NSString isEmpty:bookid]) {
        [SVProgressHUD showImage:nil status:@"书本数据有误"];
        return;
    }
    BookDetailViewController *vc = [[BookDetailViewController alloc]init];
    vc.bookid = bookid;
    [self.navigationController pushViewController:vc animated:YES];
}

//其他作品
- (void)moreBooksWithKeyword:(NSString *)keyword {
    MoreListViewController *vc = [[MoreListViewController alloc]init];
    vc.keyword = keyword;
    [self.navigationController pushViewController:vc animated:YES];
}

//章节
- (void)pushToBookChapterList {
    BookChapterViewController *vc = [[BookChapterViewController alloc]init];
    vc.detailModel = _detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}

//下载
- (void)pushToBookDownloadList {
    BookDownloadViewController *vc = [[BookDownloadViewController alloc]init];
    vc.detailModel = _detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}

//收藏
- (void)collectionBtnClick {
    if (!APPDELEGATE.loginModel) {
        LoginViewController *vc = SBVC(@"LoginVC");
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    NSString *operate = _detailModel.is_collected.boolValue ? @"2" : @"1";
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryCollectionOperate];
    NSDictionary *params = @{@"book_id":_detailModel.show_id,
                             @"operate":operate,//1 收藏 2取消收藏
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([operate isEqualToString:@"1"]) {
                strongSelf.detailModel.is_collected = @"1";
            }else {
                strongSelf.detailModel.is_collected = @"0";
            }
            strongSelf.infoView.model = strongSelf.detailModel;
        }
        [SVProgressHUD showImage:nil status:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

//分享
- (void)shareBtnClick {
    __weak __typeof(self)weakSelf = self;
    ZXPopView *view = [[ZXPopView alloc]initWithShareBlock:^(NSInteger idx) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf shareToPlatform:idx];
    }];
    [view showInView:self.navigationController.view animated:ZXPopViewAnimatedSlip];
}

- (void)shareToPlatform:(NSInteger)idx {
    NSString *title = self.detailModel.title;
    NSString *content = self.detailModel.desc;
    NSString *url = [NSString stringWithFormat:@"http://m.aikeu.com/show-%@.html",self.detailModel.show_id];
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
        }
    }];
}

- (void)sortingButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    self.vc1.zhengxu = button.selected;
}

- (void)playLastChapter {
    NSArray <ISYHistoryListenModel *> *historyArr = [[ISYDBManager shareInstance] queryBookHistoryListen];
    __block ISYHistoryListenModel *selfHistory = nil;
    [historyArr enumerateObjectsUsingBlock:^(ISYHistoryListenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bookModel.show_id isEqualToString: self.detailModel.show_id]) {
            selfHistory = obj;
            *stop = YES;
        }
    }];
    if (selfHistory) {
        
        BookDetailModel *book = selfHistory.bookModel;
        [APPDELEGATE.playVC playWithBook:book index:selfHistory.chaperNumber];
        if ([self.navigationController.viewControllers containsObject:APPDELEGATE.playVC]) {
            [self.navigationController popToViewController:APPDELEGATE.playVC animated:YES];
        }else {
            [self.navigationController pushViewController:APPDELEGATE.playVC animated:YES];
        }
    }
    
}

#pragma mark - get/set method

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (BookDetailSubDownLoadViewController *)vc1 {
    if (!_vc1) {
        _vc1 = [[BookDetailSubDownLoadViewController alloc] init];
    }
    return _vc1;
}

- (BookSubDetailViewController *)vc2 {
    if (!_vc2) {
        _vc2 = [[BookSubDetailViewController alloc] init];
    }
    return _vc2;
}
- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
    }
    return _scrollContentView;
}

- (UIView *)currentPlayContentView {
    if (!_currentPlayContentView) {
        _currentPlayContentView = [[UIView alloc] init];
        _currentPlayContentView.backgroundColor = [UIColor whiteColor];
     
        UILabel *label = [[ UILabel alloc] init];
        label.text = @"排序";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = kColorValue(0x282828);
        
        [_currentPlayContentView addSubview:self.playStatuButton];
        [_currentPlayContentView addSubview:self.currentChaperlabel];
        [_currentPlayContentView addSubview:label];
        [_currentPlayContentView addSubview:self.sortingButton];
        
        [self.playStatuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(_currentPlayContentView);
            make.left.equalTo(_currentPlayContentView).mas_offset(20);
        }];
        [self.currentChaperlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_currentPlayContentView);
            make.left.equalTo(self.playStatuButton.mas_right).mas_offset(16);
        }];
        
        [self.sortingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_currentPlayContentView);
            make.right.equalTo(_currentPlayContentView).mas_offset(-15);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(_currentPlayContentView);
            make.right.equalTo(self.sortingButton.mas_left).mas_offset(-15);
        }];
        
        UIView *lineView  = [[UIView alloc] init];
        lineView.backgroundColor = kColorValue(0x999999);
        [_currentPlayContentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.right.bottom.equalTo(_currentPlayContentView);
            make.left.equalTo(self.currentChaperlabel);
        }];
    }
    return _currentPlayContentView;
}

- (UIButton *)playStatuButton {
    if (!_playStatuButton) {
        _playStatuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playStatuButton setImage:[UIImage imageNamed:@"正在播放icon"] forState:UIControlStateNormal];
        [_playStatuButton addTarget:self action:@selector(playLastChapter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playStatuButton;
}

- (UILabel *)currentChaperlabel {
    if (!_currentChaperlabel) {
        _currentChaperlabel = [[ UILabel alloc] init];
        _currentChaperlabel.text = @"正在播放：无";
        _currentChaperlabel.font = [UIFont systemFontOfSize:14];
        _currentChaperlabel.textColor = kColorValue(0x282828);
    }
    return _currentChaperlabel;
}

- (UIButton *)sortingButton {
    if (!_sortingButton) {
        _sortingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortingButton setSelected:YES];
        [_sortingButton setImage:[UIImage imageNamed:@"正序"] forState:UIControlStateSelected];
        [_sortingButton setImage:[UIImage imageNamed:@"倒序"] forState:UIControlStateNormal];
        [_sortingButton addTarget:self action:@selector(sortingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortingButton;
}

@end
