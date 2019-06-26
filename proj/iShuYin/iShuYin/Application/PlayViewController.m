//
//  PlayViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/27.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "PlayViewController.h"
#import "BookDetailModel.h"
#import "LoginViewController.h"
#import "CommentListViewController.h"
#import "BookChapterViewController.h"
#import "CommentListModel.h"
#import "ISYCommentTableViewCell.h"
#import "ISYCommentListViewController.h"
#import "ISYPutCommentView.h"
#import "ISYDBManager.h"
#import "ISYDownloadHelper.h"
#import "Const.h"
#import "ISYChaperListView.h"
#import "ZXStarRatingView.h"

#import <FSAudioStream.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayViewController ()<AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (strong, nonatomic) UIImageView *coverImgView;//封面
@property (strong, nonatomic) UIView *startview; //评分
@property (strong, nonatomic) UILabel *chapterLabel;//章节
@property (strong, nonatomic) UIButton *chaperListButton;//章节
@property (strong, nonatomic) UIButton *speedButton;//速度
@property (strong, nonatomic) UISlider *slider;//进度条
@property (strong, nonatomic)  UIButton *playBtn;//播放暂停
@property (strong, nonatomic)  UIButton *previousBtn;//上一首
@property (strong, nonatomic)  UIButton *nextBtn;//下一首
@property (strong, nonatomic)  UIButton *addBtn;//+10
@property (strong, nonatomic)  UIButton *subBtn;//-10
@property (strong, nonatomic)  UIButton *downloadBtn;//下载
@property (strong, nonatomic)  UIButton *orderBtn;//订阅
@property (strong, nonatomic)  UIButton *shareBtn;//分享
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIView *putCommentView;
@property (nonatomic, weak) UIButton *timeButton;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) ZXStarRatingView *starRatingView;

@property (strong, nonatomic) UILabel *playTimeLabel;//播放时间
@property (strong, nonatomic) UILabel *totalTimeLabel;//总时长
@property (strong, nonatomic) UILabel *currentPlayTimeLabel;


@property (weak, nonatomic) IBOutlet UIView *collectionView;//收藏
@property (weak, nonatomic) IBOutlet UIView *shareView;//分享
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论
@property (weak, nonatomic) IBOutlet UIView *sleepView;//睡眠
@property (weak, nonatomic) IBOutlet UIView *listView;//章节

@property (weak, nonatomic) IBOutlet UIImageView *collectionImgView;

@property (nonatomic, strong) BookDetailModel *detailModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *sleepTimer;

@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, copy) NSArray *commentDataSource; //评论
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) CGFloat PlayRate;// 播放速度1。0 - 2.0
@property (nonatomic, assign) ISYPalySort playSortType;
@end

@implementation PlayViewController

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //标题
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:_detailModel.title];
    //封面
    if ([_detailModel.image containsString:kPrefixImageDefault]) {
        NSURL *url = [_detailModel.thumb url];
        APPDELEGATE.currentCoverImageURL = url;
        [_coverImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ph_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self showCurrentCover:image];
        }];
    }else {
        NSURL *url = [[kPrefixImageDefault stringByAppendingString:_detailModel.thumb] url];
        APPDELEGATE.currentCoverImageURL = url;
        [_coverImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ph_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self showCurrentCover:image];
        }];
    }
    //章节
    if (_currentIndex < _detailModel.chapters.count) {
        BookChapterModel *chapterModel = _detailModel.chapters[_currentIndex];
        _chapterLabel.text = chapterModel.l_title;
    }else {
        _chapterLabel.text = @"";
    }
    
    [self getcommentListWithBookId:self.detailModel.show_id];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.PlayRate = 1.0;
    self.playSortType = ISYPalySortshunxu;
    [self configUI];
    [self configEvent];
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerSleepChange:) name:kNotiTimerChange object:nil];
    
}

//定时变化
- (void)timerSleepChange:(NSNotification *)notif {
//    (m.sleepType*60
    SleepModel *model = notif.object;
    if (model.sleepType == SleepType0) {
        UIImage *image = [UIImage imageNamed:@"定时"];
        [_timeButton setImage:image forState:UIControlStateNormal];
        [_timeButton setTitle:@"定时" forState:UIControlStateNormal];
        [_timeButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        CGSize size = [@"定时" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        [_timeButton setImageEdgeInsets:UIEdgeInsetsMake(12, size.width /2, 0, 0)];
        [_timeButton setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 12, -image.size.width/2, 0, -image.size.width/2 )];
        
        [self.sleepTimer invalidate];
        _sleepTimer = nil;
    } else {
        [self startSleepTimer];
    }
}

- (void)configUI {
    //导航
    [self addNavBtnsWithImages:@[@"play_error",@"play_urge"] target:self actions:@[@"errorBtnClick",@"cuiGenBtnClick"] isLeft:NO];
    
    //内容
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomView];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.coverImgView];
    [self.contentView addSubview:self.startview];
    [self.contentView addSubview:self.chapterLabel];
    [self.contentView addSubview:self.chaperListButton];
    [self.contentView addSubview:self.speedButton];
    [self.contentView addSubview:self.slider];
    [self.contentView addSubview:self.playTimeLabel];
    [self.contentView addSubview:self.totalTimeLabel];
    [self.contentView addSubview:self.playBtn];
    [self.contentView addSubview:self.previousBtn];
    [self.contentView addSubview:self.nextBtn];
    [self.contentView addSubview:self.subBtn];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.downloadBtn];
    [self.contentView addSubview:self.orderBtn];
    [self.contentView addSubview:self.shareBtn];
    [self.contentView addSubview:self.tableView];
    
    [self.bottomView addSubview:self.adImageView];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(50);
    }];
    
    [self.bottomView addSubview:self.putCommentView];
    [self.putCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.adImageView.mas_bottom);
    }];
    
    [self.scrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(22);
        make.height.width.mas_equalTo(205);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.startview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImgView.mas_bottom).mas_offset(22);
        make.height.mas_equalTo(13);
        make.width.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.startview.mas_bottom).mas_offset(24);
    }];
    
    [self.chaperListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(12);
        make.centerY.equalTo(self.chapterLabel);
    }];
    
    [self.speedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-12);
        make.centerY.equalTo(self.chapterLabel);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(60);
        make.right.equalTo(self.contentView).mas_offset(-60);
        make.top.equalTo(self.chapterLabel.mas_bottom).mas_offset(25);
        make.height.mas_equalTo(15);
    }];
    
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider);
        make.right.equalTo(self.slider.mas_left).mas_offset(-4);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider);
        make.left.equalTo(self.slider.mas_right).mas_offset(4);
        
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).mas_offset(15);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playBtn.mas_left).mas_offset(-40);
        make.centerY.equalTo(self.playBtn);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).mas_offset(40);
        make.centerY.equalTo(self.playBtn);
    }];
    
    [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.contentView).mas_offset(20);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.right.equalTo(self.contentView).mas_offset(-20);
    }];
    
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(20);
        make.top.equalTo(self.playBtn.mas_bottom).mas_offset(20);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.downloadBtn);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-20);
        make.top.equalTo(self.downloadBtn);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downloadBtn.mas_bottom).mas_offset(23);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(8);
    }];
    
    UIImageView *commentsImageView = [[UIImageView alloc] init];
    commentsImageView.image = [UIImage imageNamed:@"play_comment"];
    
    UILabel *commentsLabel = [[UILabel alloc] init];
    commentsLabel.text = @"听友评论";
    [self.contentView addSubview:commentsImageView];
    [self.contentView addSubview:commentsLabel];
    [commentsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(12);
        make.top.equalTo(lineView.mas_bottom).mas_offset(12);
    }];
    [commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentsImageView.mas_right).mas_offset(14);
        make.centerY.equalTo(commentsImageView);
    }];
    
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(12);
        make.top.equalTo(commentsImageView.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(self.contentView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom);
        make.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(60);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.bottom.equalTo(self.tableView).mas_offset(20);
    }];
    
    
    //封面
    if (self.audioPlayer || self.audioStream) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationAdd object:nil];
    }else {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationDel object:nil];
    }
    //章节
    if (_currentIndex < _detailModel.chapters.count) {
        BookChapterModel *chapterModel = _detailModel.chapters[_currentIndex];
        _chapterLabel.text = chapterModel.l_title;
    }else {
        _chapterLabel.text = @"";
    }
    //进度
    [self.slider setThumbImage:[UIImage imageNamed:@"play_slider"] forState:UIControlStateNormal];
    //收藏
    _collectionImgView.image = [UIImage imageNamed:_detailModel.is_collected.boolValue?@"play_collect_sel":@"play_collect_nor"];
}

- (void)configEvent {
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionViewTap)]];
    [self.shareView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewTap)]];
    [self.commentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentViewTap)]];
    [self.sleepView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sleepViewTap)]];
    [self.listView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(listViewTap)]];
}

- (void)getcommentListWithBookId:(NSString *)bookId {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2getCommentList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    NSDictionary *params = @{@"show_id":bookId};
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            NSArray *commentDataSource = [NSArray yy_modelArrayWithClass:[CommentListModel class] json:responseObject[@"data"]];
            strongSelf.commentDataSource = commentDataSource;
            [strongSelf.tableView reloadData];
            [strongSelf.tableView layoutIfNeeded];
            [strongSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(strongSelf.tableView.contentSize.height);
            }];
            
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

- (void)addcommentListWithBookId:(NSString *)bookId content:(NSString *)des {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2AddComment];
    __weak __typeof(self)weakSelf = self;
    NSDictionary *params = @{@"show_id":bookId,
                             @"content" : des
                             };
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            [SVProgressHUD showImage:nil status:@"发表评论成功"];
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf getcommentListWithBookId:self.detailModel.show_id];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - Timer

- (void)startSleepTimer {
    _sleepTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sleepTimerAction) userInfo:nil repeats:YES];
}

- (void)startTimer {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sleepTimerAction {
    
    NSInteger minute = APPDELEGATE.sleepInterval / 60;
    NSInteger second = APPDELEGATE.sleepInterval % 60;
    NSString *text = [NSString stringWithFormat:@"%02li:%02li",minute,second];
    
    UIImage *image = [UIImage imageNamed:@"定时"];
    [_timeButton setImage:image forState:UIControlStateNormal];
    [_timeButton setTitle:text forState:UIControlStateNormal];
    [_timeButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
    _timeButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _timeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
    [_timeButton setImageEdgeInsets:UIEdgeInsetsMake(12, size.width /2, 0, 0)];
    [_timeButton setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 12, -image.size.width/2, 0, -image.size.width/2 )];
}

- (void)timerAction {
    NSInteger progress;
    if (self.audioStream) {
        //获取当前播放音频的总时间时间
        [_audioStream setPlayRate:self.PlayRate];
        int duration = self.audioStream.duration.minute*60+self.audioStream.duration.second;
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",duration/60,duration%60];
        //当前播放的时间
        progress = self.audioStream.currentTimePlayed.minute*60+self.audioStream.currentTimePlayed.second;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",progress/60,progress%60];
        //进度条
        self.slider.value = 1.0*progress/duration;
        //锁屏进度条
        [self showCurrentProgress:progress];
    }else if (self.audioPlayer) {
        self.audioPlayer.rate = self.PlayRate;
        //获取当前播放音频的总时间时间
        int duration = self.audioPlayer.duration;
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",duration/60,duration%60];
        //当前播放的时间
        progress = self.audioPlayer.currentTime;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",progress/60,progress%60];
        //进度条
        self.slider.value = 1.0*progress/duration;
        //锁屏进度条
        [self showCurrentProgress:progress];
    }
    
    // 插入播放记录
    [self insertHistoryListenBook:_detailModel chaperNumber:_currentIndex time:progress listentime:[[NSDate date] timeIntervalSince1970]];
    
}

#pragma mark - Control
//播放暂停
- (IBAction)playBtnClick:(id)sender {
    [self pauseOrPlay];
}

//上一首
- (IBAction)previousBtnClick:(id)sender {
    [self playPrevious];
}

//下一首
- (IBAction)nextBtnClick:(id)sender {
    [self playNext];
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
    if (self.audioStream) {
        int duration = self.audioStream.duration.minute*60+self.audioStream.duration.second;
        int seconds = duration * slider.value;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
    }else if (self.audioPlayer) {
        int duration = self.audioPlayer.duration;
        int seconds = duration * slider.value;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
    }
}

- (IBAction)sliderTouchUpInside:(UISlider *)slider {
    if (self.audioStream) {
        int duration = self.audioStream.duration.minute*60+self.audioStream.duration.second;
        int seconds = duration * slider.value;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
        FSStreamPosition p;
        p.minute = seconds/60;
        p.second = seconds%60;
        p.playbackTimeInSeconds = seconds;
        p.position = slider.value;
        [self.audioStream seekToPosition:p];
    }else if (self.audioPlayer) {
        int duration = self.audioPlayer.duration;
        int seconds = duration * slider.value;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
        self.audioPlayer.currentTime = seconds;
    }
}

- (IBAction)sliderTouchUpOutside:(UISlider *)slider {
    if (self.audioStream) {
        int duration = self.audioStream.duration.minute*60+self.audioStream.duration.second;
        int seconds = duration * slider.value;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
        FSStreamPosition p;
        p.minute = seconds/60;
        p.second = seconds%60;
        p.playbackTimeInSeconds = seconds;
        p.position = slider.value;
        [self.audioStream seekToPosition:p];
    }else if (self.audioPlayer) {
        int duration = self.audioPlayer.duration;
        int seconds = duration * slider.value;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
        self.audioPlayer.currentTime = seconds;
    }
}

#pragma mark - Tap
//收藏
- (void)collectionViewTap {
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
                strongSelf.collectionImgView.image = [UIImage imageNamed:@"play_collect_sel"];
            }else {
                strongSelf.detailModel.is_collected = @"0";
                strongSelf.collectionImgView.image = [UIImage imageNamed:@"play_collect_nor"];
            }
        }
        [SVProgressHUD showImage:nil status:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

//分享
- (void)shareViewTap {
    __weak __typeof(self)weakSelf = self;
    ZXPopView *view = [[ZXPopView alloc]initWithShareBlock:^(NSInteger idx) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf shareToPlatform:idx];
    }];
    [view showInView:self.navigationController.view animated:ZXPopViewAnimatedSlip];
}

//评论
- (void)commentViewTap {
    UIViewController *vc = [ChangyanSDK getListCommentViewController:@"" topicID:nil topicSourceID:self.detailModel.show_id categoryID:nil topicTitle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    /*
    [ZXProgressHUD showLoading:@""];
    __weak __typeof(self)weakSelf = self;
    [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:self.detailModel.show_id topicCategoryID:nil pageSize:nil hotSize:nil orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        [ZXProgressHUD hide];
        if (statusCode == CYSuccess) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            id response = [responseStr jsonParse];
            CommentListViewController *vc = [[CommentListViewController alloc]init];
            vc.topic_id = [NSString stringWithFormat:@"%@",response[@"topic_id"]];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }else {
            [SVProgressHUD showImage:nil status:@"请求失败"];
        }
    }];
     */
}

//睡眠
- (void)sleepViewTap {
    ZXPopView *view = [[ZXPopView alloc]initSleepCountDownView];
    [view showInView:self.navigationController.view animated:ZXPopViewAnimatedSlip];
}

//章节
- (void)listViewTap {
    BookChapterViewController *vc = [[BookChapterViewController alloc]init];
    vc.detailModel = _detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (void)cuiGenBtnClick {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryCuiGeng];
    NSDictionary *params = @{@"mov_id":_detailModel.show_id};
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showImage:nil status:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)errorBtnClick {
    UIViewController *vc = SBVC(@"FeedbackAddVC");
    [self.navigationController pushViewController:vc animated:YES];
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
        }
    }];
}

- (void)moreCommentBtnClick:(UIButton *)btn {
    ISYCommentListViewController *vc = [[ISYCommentListViewController alloc] init];
    vc.bookId = self.detailModel.show_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//输入评论
- (void) showPutCommentView {
    
      __weak __typeof(self)weakSelf = self;
    [ISYPutCommentView showWithCallBack:^(NSString *des) {
       //提价评论
        [weakSelf addcommentListWithBookId:self.detailModel.show_id content:des];
    }];
}

- (void)speedButtonClick:(UIButton *)button {
    if (self.PlayRate == 1.0) {
        self.PlayRate = 1.2;
        UIImage *image = [UIImage imageNamed:@"speed12"];
        [self.speedButton setImage:image forState:UIControlStateNormal];
    } else if (self.PlayRate == 1.2) {
        self.PlayRate = 1.5;
        UIImage *image = [UIImage imageNamed:@"speed15"];
        [self.speedButton setImage:image forState:UIControlStateNormal];
    } else if (self.PlayRate == 1.5) {
        self.PlayRate = 2.0;
        UIImage *image = [UIImage imageNamed:@"speed1"];
        [self.speedButton setImage:image forState:UIControlStateNormal];
        button.selected = YES;
    } else if (self.PlayRate == 2.0) {
        self.PlayRate = 1.0;
        UIImage *image = [UIImage imageNamed:@"speed2"];
        [self.speedButton setImage:image forState:UIControlStateNormal];
        button.selected = NO;
    }
    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"切换为%.1f倍速播放", self.PlayRate]];
    
    [self.audioStream setPlayRate:self.PlayRate];
    self.audioPlayer.rate = self.PlayRate;
}

- (void)downloadChaper {
    [SVProgressHUD showImage:nil status:@"添加到下载列表成功～"];
    BookChapterModel *chapterModel = _detailModel.chapters[_currentIndex];
    [[ISYDownloadHelper shareInstance] downloadChaper:chapterModel bookId:self.detailModel.show_id progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        
    } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
    
    }];
    
}

//播放列表
- (void)chaperListButtonClick {
    ISYChaperListView *view = [ISYChaperListView showWithBook:self.detailModel];
    view.playSort = self.playSortType;
    __weak typeof(self) weakSelf = self;
    view.sortCallBack = ^(ISYPalySort sort) {
        weakSelf.playSortType = sort;
    };
    view.selectChaperCB = ^(NSInteger charpetIndex) {
        [weakSelf playWithBook:self.detailModel index:charpetIndex];
    };
}

#pragma mark - Methods
//本地是否存在该章节
- (BOOL)isLocalChapter:(BookChapterModel *)chapterModel {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@",document,_detailModel.show_id,_detailModel.title];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:bookPath]) {
        return NO;
    }
    BOOL ret = NO;
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:bookPath];
    for (NSString *fileName in enumerator) {
        if ([NSString isEmpty:fileName]) {
            continue;
        }
        NSString *cid = [[fileName componentsSeparatedByString:@"_"]firstObject];//章节id
        if ([cid isEqualToString:chapterModel.l_id]) {
            chapterModel.l_path = [bookPath stringByAppendingPathComponent:fileName];
            ret = YES;
            break;
        }
    }
    return ret;
}

//播放音频
- (void)playChapterAtIndex:(NSInteger)index {
    if (_audioStream) {
        [_audioStream stop];
        _audioStream = nil;
    }
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    self.slider.value = 0;
    _playTimeLabel.text = @"00:00";
    _totalTimeLabel.text = @"00:00";
    if (index >= _detailModel.chapters.count) {
        _chapterLabel.text = @"";
        return;
    }
    _currentIndex = index;
    BookChapterModel *chapterModel = _detailModel.chapters[index];
    
    _chapterLabel.text = chapterModel.l_title;
    
    BOOL ret = [self isLocalChapter:chapterModel];
    if (ret) {
        //播放本地音频
        [self playChapterLocal:chapterModel];
    }else {
        //播放网络音频
        [self playChapterNetwork:chapterModel];
    }
    //展示控制中心
    [self showPlayingInfo];
    
    // 播放变化通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNamePlayChange object:nil];
}

//播放网络音频
- (void)playChapterNetwork:(BookChapterModel *)chapterModel {
    FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
    config.httpConnectionBufferSize *= 2;
    config.enableTimeAndPitchConversion = YES;
    
    NSURL *url = [[chapterModel.l_url decodePlayURL] url];
//    _audioStream = [[FSAudioStream alloc]initWithUrl:url];
     _audioStream = [[FSAudioStream alloc]initWithConfiguration:config];
    [_audioStream playFromURL:url];
    __weak __typeof(self)weakSelf = self;
    _audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
        DLog(@"网络播放过程中发生错误，错误信息：%@",description);
        [SVProgressHUD showImage:nil status:description];
    };
    _audioStream.onCompletion = ^{
        DLog(@"网络播放完成!");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf playNext];
//        [strongSelf playChapterAtIndex:strongSelf->_currentIndex+1];
    };
    
    _audioStream.onStateChange = ^(FSAudioStreamState state) {
        if (self.duration != 0 && state == kFsAudioStreamPlaying) {
            int duration = weakSelf.audioStream.duration.minute*60+weakSelf.audioStream.duration.second;
            int seconds = weakSelf.duration;
            weakSelf.playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",seconds/60,seconds%60];
            FSStreamPosition p;
            p.minute = seconds/60;
            p.second = seconds%60;
            p.playbackTimeInSeconds = seconds;
            p.position = seconds * 1.0 / duration;
            [weakSelf.audioStream seekToPosition:p];
            weakSelf.duration = 0;
        }
    };
    [_audioStream setVolume:0.5];//设置声音
    [_audioStream play];
    [_audioStream setPlayRate:self.PlayRate];
    [self startTimer];
    [self saveRecentChapter:chapterModel];
}

//播放本地音频
- (void)playChapterLocal:(BookChapterModel *)chapterModel {
    NSURL *url = [NSURL fileURLWithPath:chapterModel.l_path];
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    _audioPlayer.numberOfLoops = 0;//设置为0不循环
    _audioPlayer.delegate = self;
    _audioPlayer.enableRate = YES;
    [_audioPlayer prepareToPlay];//加载音频文件到缓存
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        return;
    }
    [_audioPlayer play];
    _audioPlayer.rate = self.PlayRate;
    [self startTimer];
    [self saveRecentChapter:chapterModel];
}

//保存最近播放
- (void)saveRecentChapter:(BookChapterModel *)chapterModel {
    NSString *recentString = [USERDEFAULTS objectForKey:kRecentBooks];
    if ([NSString isEmpty:recentString]) {
        [self saveFirstBookWithRecentChapter:chapterModel];
    }else {
        NSArray *temp = [NSArray yy_modelArrayWithClass:[BookDetailModel class] json:recentString];
        if (![temp isKindOfClass:[NSArray class]] || temp.count == 0) {
            [self saveFirstBookWithRecentChapter:chapterModel];
        }else {
            NSMutableArray *bookArray = [NSMutableArray arrayWithArray:temp];
            BOOL ret = NO;//是否已经有该本书
            for (BookDetailModel *m in bookArray) {
                if ([m.show_id isEqualToString:_detailModel.show_id]) {
                    ret = YES;
                    break;
                }
            }
            if (ret) {
                //已经有该本书，记录当前播放章节
                [self saveNewChapterWithBookArray:bookArray recentChapter:chapterModel];
            }else {
                //没有该本书，新增一本书
                [self saveNewBookWithBookArray:bookArray recentChapter:chapterModel];
            }
        }
    }
}

//保存第一本书
- (void)saveFirstBookWithRecentChapter:(BookChapterModel *)chapterModel {
    NSMutableArray *bookArray = [NSMutableArray array];
    NSString *json = [_detailModel yy_modelToJSONString];
    BookDetailModel *newModel = [BookDetailModel yy_modelWithJSON:json];
    newModel.recent_chapter = chapterModel;
    [bookArray addObject:newModel];
    NSString *recent_json = [bookArray yy_modelToJSONString];
    [USERDEFAULTS setObject:recent_json forKey:kRecentBooks];
    [USERDEFAULTS synchronize];
}

//已经有该本书，新增一个章节
- (void)saveNewChapterWithBookArray:(NSMutableArray *)bookArray recentChapter:(BookChapterModel *)chapterModel {
    BOOL ret = NO;//是否有找到该本书
    for (BookDetailModel *m in bookArray) {
        if ([m.show_id isEqualToString:_detailModel.show_id]) {
            ret = YES;
            m.recent_chapter = chapterModel;
            break;
        }
    }
    if (ret) {
        NSString *recent_json = [bookArray yy_modelToJSONString];
        [USERDEFAULTS setObject:recent_json forKey:kRecentBooks];
        [USERDEFAULTS synchronize];
    }
}

//没有该本书，新增一本书
- (void)saveNewBookWithBookArray:(NSMutableArray *)bookArray recentChapter:(BookChapterModel *)chapterModel {
    NSString *json = [_detailModel yy_modelToJSONString];
    BookDetailModel *newModel = [BookDetailModel yy_modelWithJSON:json];
    newModel.recent_chapter = chapterModel;
    [bookArray addObject:newModel];
    NSString *recent_json = [bookArray yy_modelToJSONString];
    [USERDEFAULTS setObject:recent_json forKey:kRecentBooks];
    [USERDEFAULTS synchronize];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    self.audioPlayer.currentTime =  self.duration;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    DLog(@"本地播放完成!");
    [self playNext];
//    [self playChapterAtIndex:_currentIndex+1];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    DLog(@"本地播放过程中发生错误，错误信息：%@",error.description);
}


#pragma mark - RemoteEvent(远程控制)
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if(event.type==UIEventTypeRemoteControl){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                [self pauseOrPlay];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:{
                [self playNext];
            }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:{
                [self playPrevious];
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                DLog(@"Begin seek forward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                DLog(@"End seek forward...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                DLog(@"Begin seek backward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                DLog(@"End seek backward...");
                break;
            default:
                break;
        }
    }
}

#pragma mark - routeChange(耳机拨出来的通知)
- (void)routeChange:(NSNotification*)notice {
    NSDictionary *dic = notice.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
}

#pragma mark - 控制中心的播放信息
-(void)showPlayingInfo {
    BookChapterModel *chapterModel = _detailModel.chapters[_currentIndex];
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:chapterModel.l_title forKey:MPMediaItemPropertyTitle];
    //歌手名
    [songDict setObject:_detailModel.title forKey:MPMediaItemPropertyArtist];
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

//锁屏进度条
- (void)showCurrentProgress:(int)progress {
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    //总时长
    int duration = 0;
    if (self.audioStream) {
        duration = self.audioStream.duration.minute*60+self.audioStream.duration.second;
    }else if (self.audioPlayer) {
        duration = self.audioPlayer.duration;
    }
    [dict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(CMTimeMake(duration, 1))] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //当前进度
    [dict setObject:@(progress) forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //封面
    UIImage *image = _coverImgView.image?_coverImgView.image:[UIImage imageNamed:@"ph_image"];
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:image];
    [dict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    //展示
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

//锁屏专辑封面
- (void)showCurrentCover:(UIImage *)image {
    if (image == nil) return;
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:image];
    [dict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

#pragma mark - Public
- (BOOL)hasBook {
    return _detailModel != nil;
}

- (void)playWithBook:(BookDetailModel *)detailModel index:(NSInteger)idx {
    if ([_detailModel.show_id isEqualToString:detailModel.show_id] &&
        _currentIndex == idx && (self.audioPlayer.isPlaying || self.audioStream.isPlaying)) {
        return;
    }
    _currentIndex = idx;
    _detailModel = detailModel;
    if ([_detailModel.image containsString:kPrefixImageDefault]) {
        NSURL *url = [_detailModel.thumb url];
        APPDELEGATE.currentCoverImageURL = url;
    }else {
        NSURL *url = [[kPrefixImageDefault stringByAppendingString:_detailModel.thumb] url];
        APPDELEGATE.currentCoverImageURL = url;
    }
    
    NSNumber *index = @(idx);
    NSString *bookJson = [detailModel yy_modelToJSONString];
    [USERDEFAULTS setObject:index forKey:kLastIndex];
    [USERDEFAULTS setObject:bookJson forKey:kLastBook];
    [USERDEFAULTS synchronize];
    
    //播放
    [self playChapterAtIndex:idx];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationAdd object:nil];
    self.duration = 0;
}

- (void)playWithBook:(BookDetailModel *)detailModel index:(NSInteger)idx duration:(NSInteger)duration {
    [self playWithBook:detailModel index:idx];
    self.duration = duration;
}

- (void)pauseOrPlay {
    if (_playBtn.isSelected) {
        _playBtn.selected = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationAdd object:nil];
        //播放
        if (self.audioStream) {
            [self.audioStream play];
        }
        if (self.audioPlayer) {
            [self.audioPlayer play];
        }
    }else {
        _playBtn.selected = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationDel object:nil];
        //暂停
        if (self.audioStream) {
            [self.audioStream pause];
        }
        if (self.audioPlayer) {
            [self.audioPlayer pause];
        }
    }
}

- (void)pause {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_playBtn.selected) {
            return;
        }
        _playBtn.selected = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationDel object:nil];
        //暂停
        if (self.audioStream) {
            [self.audioStream pause];
        }
        if (self.audioPlayer) {
            [self.audioPlayer pause];
        }
    });
}

- (void)playPrevious {
    switch (self.playSortType) {
        case ISYPalySortshunxu:
        {
            if (_currentIndex == 0) {
                [SVProgressHUD showImage:nil status:@"已经是第一章了"];
                return;
            }
            self.playBtn.selected = NO;
            [self playChapterAtIndex:_currentIndex-1];
        }
            break;
        case ISYPalySortReverse:
        {
            if (_currentIndex == self.detailModel.chapters.count - 1) {
                //已经是最后一章了
                [SVProgressHUD showImage:nil status:@"已经是最后一章了"];
                return;
            }
            self.playBtn.selected = NO;
            [self playChapterAtIndex:_currentIndex + 1];
        }
            break;
        case ISYPalySortSingle:
        {
            self.playBtn.selected = NO;
            [self playChapterAtIndex:_currentIndex];
        }
            break;
        case ISYPalySortRandam:
        {
            NSInteger randam = arc4random_uniform(self.detailModel.chapters.count);
            self.playBtn.selected = NO;
            [self playChapterAtIndex:randam];
        }
            break;
            
        default:
            break;
    }
}

- (void)playNext {
    switch (self.playSortType) {
        case ISYPalySortshunxu:
            {
                if (_currentIndex == _detailModel.chapters.count - 1) {
                    [SVProgressHUD showImage:nil status:@"已经是最后一章了"];
                    return;
                }
                self.playBtn.selected = NO;
                [self playChapterAtIndex:_currentIndex+1];
            }
            break;
        case ISYPalySortReverse:
        {
            if (_currentIndex == 0) {
                [SVProgressHUD showImage:nil status:@"已经是第一章了"];
                return;
            }
            self.playBtn.selected = NO;
            [self playChapterAtIndex:_currentIndex - 1];
        }
            break;
        case ISYPalySortSingle:
        {
            self.playBtn.selected = NO;
            [self playChapterAtIndex:_currentIndex];
        }
            break;
        case ISYPalySortRandam:
        {
            NSInteger randam = arc4random_uniform(self.detailModel.chapters.count);
            self.playBtn.selected = NO;
            [self playChapterAtIndex:randam];
        }
            break;
            
        default:
            break;
    }
}

- (void)goForward {
    if (self.audioStream) {
        FSStreamPosition current = self.audioStream.currentTimePlayed;
        int totalTime = self.audioStream.duration.minute * 60 + self.audioStream.duration.second;
        
        if (totalTime - (current.minute * 60 + current.second) < 10) {
            //可快进时间不足10s
            current.minute = self.audioStream.duration.minute;
            current.second = self.audioStream.duration.second;
            current.playbackTimeInSeconds = totalTime;
        } else {
            
            if (current.second > 49) {
                current.minute += 1;
                current.second = current.second + 10 - 60;
            } else {
                current.second += 10;
            }
            current.playbackTimeInSeconds += 10.0;
        }
        current.position = current.playbackTimeInSeconds / totalTime;
        [self.audioStream seekToPosition:current];
    }else if (self.audioPlayer) {
        self.audioPlayer.currentTime += 10;
    }
}

- (void)backward {
    if (self.audioStream) {
        FSStreamPosition current = self.audioStream.currentTimePlayed;
        if (current.minute == 0 && current.second < 10) {
            //可后退时间不足10s
            current.second = 0;
            current.playbackTimeInSeconds = 0.0;
        } else {
            if (current.second < 9) {
                current.minute -= 1;
                current.second = current.second + 60 - 10;
            } else {
                current.second -= 10;
            }
            current.playbackTimeInSeconds -= 10.0;
        }
        int totalTime = self.audioStream.duration.minute * 60 + self.audioStream.duration.second;
        current.position = current.playbackTimeInSeconds / totalTime;
        [self.audioStream seekToPosition:current];
    }else if (self.audioPlayer) {
        self.audioPlayer.currentTime -= 10;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma makr - DB
- (void)insertHistoryListenBook:(BookDetailModel *)book chaperNumber:(NSInteger)chaperNumber time:(NSInteger)time listentime:(NSInteger)listentime{
    [[ISYDBManager shareInstance] insertHistoryListenBook:book chaperNumber:chaperNumber time:time listentime:listentime];
}


#pragma mark - getter
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
    }
    return _coverImgView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return  _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)chapterLabel {
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] init];
        _chapterLabel.font = [UIFont systemFontOfSize:16];
        _chapterLabel.textColor = kColorValue(0x282828);
    }
    return _chapterLabel;
}

- (UIView *)startview {
    if (!_startview) {
        _startview = [[UIView alloc] init];
        _startview.backgroundColor = [UIColor whiteColor];
        
        [_startview addSubview:self.starRatingView];
        [_startview addSubview:self.scoreLabel];
        
        [self.starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_startview).mas_offset(-20);
            make.centerY.equalTo(_startview);
            make.size.mas_equalTo(CGSizeMake(91, 15));
        }];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starRatingView.mas_right).mas_offset(8);
            make.centerY.equalTo(_startview);
        }];
    }
    return _startview;
}

- (ZXStarRatingView *)starRatingView {
    if (!_starRatingView) {
        //TODO: 替换图片
        _starRatingView = [[ZXStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 91, 15)
                                                         backStar:@"play_star_nor" foreStar:@"play_star_sel" number:5 width:15 height:15 space:4];
        [_starRatingView setScore:0.8 withAnimation:NO];
    }
    return _starRatingView;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.text = @"4分";
    }
    return _scoreLabel;
}

- (UIButton *)chaperListButton {
    if (!_chaperListButton) {
        UIImage *image = [UIImage imageNamed:@"play_chaper_list"];
        _chaperListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chaperListButton setImage:image forState:UIControlStateNormal];
        [_chaperListButton setTitle:@"播放列表" forState:UIControlStateNormal];
        [_chaperListButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        _chaperListButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _chaperListButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chaperListButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        CGSize size = [@"播放列表" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        [_chaperListButton addTarget:self action:@selector(chaperListButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_chaperListButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width /2, 0, 0)];
        [_chaperListButton setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, -image.size.width/2, 0, -image.size.width/2 )];
    }
    return _chaperListButton;
}

- (UIButton *)speedButton {
    if (!_speedButton) {
        UIImage *image = [UIImage imageNamed:@"speed1"];
        _speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speedButton addTarget:self action:@selector(speedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_speedButton setImage:image forState:UIControlStateNormal];
//        [_speedButton setImage:[UIImage imageNamed:@"speed2"] forState:UIControlStateSelected];
        [_speedButton setTitle:@"倍数播放" forState:UIControlStateNormal];
        [_speedButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        _speedButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _speedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _speedButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
         CGSize size = [@"倍数播放" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        [_speedButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width /2, 0, 0)];
        [_speedButton setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, -image.size.width/2, 0, -image.size.width/2 )];
    }
    return _speedButton;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.tintColor = [UIColor redColor];
        _slider.thumbTintColor = [UIColor greenColor];
        [_slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(sliderTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
    
}

- (UIButton *)previousBtn {
    if (!_previousBtn) {
        _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_previousBtn addTarget:self action:@selector(previousBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_previousBtn setImage:[UIImage imageNamed:@"play_previous"] forState:UIControlStateNormal];
    }
    return _previousBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];
    }
    return _nextBtn;
    
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setImage:[UIImage imageNamed:@"play_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"play_pause"] forState:UIControlStateSelected];
    }
    return _playBtn;
    
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_addBtn addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[UIImage imageNamed:@"快进10s"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UIButton *)subBtn {
    if (!_subBtn) {
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_subBtn addTarget:self action:@selector(backward) forControlEvents:UIControlEventTouchUpInside];
        [_subBtn setImage:[UIImage imageNamed:@"快退10s"] forState:UIControlStateNormal];
    }
    return _subBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setImage:[UIImage imageNamed:@"play_download1"] forState:UIControlStateNormal];
        [_downloadBtn setTitle:@" 下载" forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadChaper) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _downloadBtn;
}

- (UIButton *)orderBtn {
    if (!_orderBtn) {
        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderBtn setImage:[UIImage imageNamed:@"订阅"] forState:UIControlStateNormal];
        [_orderBtn setTitle:@" 订阅" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_orderBtn addTarget:self action:@selector(collectionViewTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareBtn setTitle:@" 分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_shareBtn addTarget:self action:@selector(shareViewTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.image = [UIImage imageNamed:@"download_ad"];
    }
    return _adImageView;
}


- (UILabel *)playTimeLabel {
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.font = [UIFont systemFontOfSize:12];
        _playTimeLabel.textColor = kColorValue(0x666666);
        _playTimeLabel.text = @"00:00";
    }
    return _playTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textColor = kColorValue(0x666666);
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIView *)putCommentView {
    if (!_putCommentView) {
        _putCommentView = [[UIView alloc] init];
        
        UIImage *image = [UIImage imageNamed:@"定时"];
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeBtn addTarget:self action:@selector(sleepViewTap) forControlEvents:UIControlEventTouchUpInside];
        [timeBtn setImage:image forState:UIControlStateNormal];
        [timeBtn setTitle:@"定时" forState:UIControlStateNormal];
        [timeBtn setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        timeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        CGSize size = [@"定时" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        [timeBtn setImageEdgeInsets:UIEdgeInsetsMake(12, size.width /2, 0, 0)];
        [timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 12, -image.size.width/2, 0, -image.size.width/2 )];
        _timeButton = timeBtn;
        UIButton *dowmladBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dowmladBtn addTarget:self action:@selector(listViewTap) forControlEvents:UIControlEventTouchUpInside];
        [dowmladBtn setImage:[UIImage imageNamed:@"下载章节"] forState:UIControlStateNormal];
        [dowmladBtn setTitle:@"下载" forState:UIControlStateNormal];
        [dowmladBtn setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        dowmladBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        dowmladBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        dowmladBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        CGSize size1 = [@"下载" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        [dowmladBtn setImageEdgeInsets:UIEdgeInsetsMake(12, size1.width /2, 0, 0)];
        [dowmladBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 12, -image.size.width/2, 0, -image.size.width/2 )];

        [_putCommentView addSubview:timeBtn];
        [_putCommentView addSubview:dowmladBtn];
        
        [dowmladBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_putCommentView);
            make.width.mas_offset(50);
        }];
        [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_putCommentView);
            make.width.mas_offset(50);
            make.right.equalTo(dowmladBtn.mas_left);
        }];
        
        UIView *bvView = [[UIView alloc] init];
        bvView.backgroundColor = [UIColor grayColor];
        bvView.layer.masksToBounds = YES;
        bvView.layer.cornerRadius = 4;
        [_putCommentView addSubview:bvView];
        [bvView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_putCommentView).mas_offset(12);
            make.height.equalTo(_putCommentView).mas_equalTo(-12);
            make.centerY.equalTo(_putCommentView);
            make.right.equalTo(timeBtn.mas_left).mas_offset(-12);
        }];
        
        UIImageView *icom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发表评论"]];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"发表评论";
        
        [bvView addSubview:icom];
        [bvView addSubview:label];
        [icom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bvView);
            make.left.equalTo(bvView).mas_offset(12);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bvView);
            make.left.equalTo(icom.mas_right).mas_offset(12);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bvView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bvView);
        }];
        [btn addTarget:self action:@selector(showPutCommentView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _putCommentView;
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.commentDataSource.count, 5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListModel *model;
    if (self.commentDataSource.count != 0) {
        model = self.commentDataSource[indexPath.row];
    }
    ISYCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ISYCommentTableViewCellID"];
    if (cell == nil) {
        cell = [[ISYCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ISYCommentTableViewCellID"];
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"查看所有评论" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_offset(CGSizeMake(150, 30));
    }];
    return footerView;
    
}
@end


