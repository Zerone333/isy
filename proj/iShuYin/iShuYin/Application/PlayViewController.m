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

#import <FSAudioStream.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;//封面
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;//章节
@property (weak, nonatomic) IBOutlet UISlider *slider;//进度条
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;//播放时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;//总时长

@property (weak, nonatomic) IBOutlet UIButton *playBtn;//播放暂停
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;//上一首
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;//下一首

@property (weak, nonatomic) IBOutlet UIView *collectionView;//收藏
@property (weak, nonatomic) IBOutlet UIView *shareView;//分享
@property (weak, nonatomic) IBOutlet UIView *commentView;//评论
@property (weak, nonatomic) IBOutlet UIView *sleepView;//睡眠
@property (weak, nonatomic) IBOutlet UIView *listView;//章节

@property (weak, nonatomic) IBOutlet UIImageView *collectionImgView;

@property (nonatomic, strong) BookDetailModel *detailModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
    [self configEvent];
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)configUI {
    //导航
    [self addNavBtnsWithImages:@[@"play_error",@"play_urge"] target:self actions:@[@"errorBtnClick",@"cuiGenBtnClick"] isLeft:NO];
    //封面
    _coverImgView.layer.cornerRadius = (kScreenWidth-120)/2.0;
    _coverImgView.layer.masksToBounds = YES;
    if (self.audioPlayer || self.audioStream) {
        [self addCoverAnimation];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationAdd object:nil];
    }else {
        [self removeCoverAnimation];
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
    [_slider setThumbImage:[UIImage imageNamed:@"play_slider"] forState:UIControlStateNormal];
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

- (void)addCoverAnimation {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotateAnimation.autoreverses = NO;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.repeatCount = MAXFLOAT;
    rotateAnimation.duration = 20.0;
    [_coverImgView.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

- (void)removeCoverAnimation {
    [_coverImgView.layer removeAllAnimations];
}

#pragma mark - Timer
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

- (void)timerAction {
    if (self.audioStream) {
        //获取当前播放音频的总时间时间
        int duration = self.audioStream.duration.minute*60+self.audioStream.duration.second;
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",duration/60,duration%60];
        //当前播放的时间
        int progress = self.audioStream.currentTimePlayed.minute*60+self.audioStream.currentTimePlayed.second;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",progress/60,progress%60];
        //进度条
        _slider.value = 1.0*progress/duration;
        //锁屏进度条
        [self showCurrentProgress:progress];
    }else if (self.audioPlayer) {
        //获取当前播放音频的总时间时间
        int duration = self.audioPlayer.duration;
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",duration/60,duration%60];
        //当前播放的时间
        int progress = self.audioPlayer.currentTime;
        _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i",progress/60,progress%60];
        //进度条
        _slider.value = 1.0*progress/duration;
        //锁屏进度条
        [self showCurrentProgress:progress];
    }
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
    _slider.value = 0;
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
}

//播放网络音频
- (void)playChapterNetwork:(BookChapterModel *)chapterModel {
    NSURL *url = [[chapterModel.l_url decodePlayURL] url];
    _audioStream = [[FSAudioStream alloc]initWithUrl:url];
    __weak __typeof(self)weakSelf = self;
    _audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
        DLog(@"网络播放过程中发生错误，错误信息：%@",description);
        [SVProgressHUD showImage:nil status:description];
    };
    _audioStream.onCompletion = ^{
        DLog(@"网络播放完成!");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf playChapterAtIndex:strongSelf->_currentIndex+1];
    };
    _audioStream.onStateChange = ^(FSAudioStreamState state) {
        
    };
    [_audioStream setVolume:0.5];//设置声音
    [_audioStream play];
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
    [_audioPlayer prepareToPlay];//加载音频文件到缓存
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        return;
    }
    [_audioPlayer play];
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
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    DLog(@"本地播放完成!");
    [self playChapterAtIndex:_currentIndex+1];
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
}

- (void)pauseOrPlay {
    if (_playBtn.isSelected) {
        _playBtn.selected = NO;
        [self addCoverAnimation];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiNameAnimationAdd object:nil];
        //播放
        if (self.audioStream) {
            [self.audioStream pause];
        }
        if (self.audioPlayer) {
            [self.audioPlayer play];
        }
    }else {
        _playBtn.selected = YES;
        [self removeCoverAnimation];
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
        [self removeCoverAnimation];
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
    if (_currentIndex == 0) {
        [SVProgressHUD showImage:nil status:@"已经是第一章了"];
        return;
    }
    [self playChapterAtIndex:_currentIndex-1];
}

- (void)playNext {
    if (_currentIndex == _detailModel.chapters.count - 1) {
        [SVProgressHUD showImage:nil status:@"已经是最后一章了"];
        return;
    }
    [self playChapterAtIndex:_currentIndex+1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

@end
