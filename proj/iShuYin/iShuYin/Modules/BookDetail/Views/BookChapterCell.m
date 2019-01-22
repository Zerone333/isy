//
//  BookChapterCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookChapterCell.h"
#import "BookDetailModel.h"
#import "MCDownloader.h"
#import "ISYDownloadHelper.h"

@interface BookChapterCell ()
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;//下载暂停
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//进度

@property (nonatomic, strong) NSString *filePath;
@end

@implementation BookChapterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.chooseBtn setImage:[UIImage imageNamed:@"download_choose_nor"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"download_choose_sel"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setChapterModel:(BookChapterModel *)chapterModel {
    _chapterModel = chapterModel;
    _chooseBtn.selected = chapterModel.isSelected;
    _titleLabel.text = chapterModel.l_title;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
    receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document,_detailModel.show_id,_detailModel.title];
        return [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",self.chapterModel.l_id,url.lastPathComponent]];
    };
    
    self.progressView.progress = 0;
    self.progressView.progress = receipt.progress.fractionCompleted;
    
    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
        [self.actionBtn setTitle:@"停止" forState:UIControlStateNormal];
        [self.actionBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateCompleted) {

        if (self.progressView.progress == 1.0) {
            [self.actionBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"已下载"] forState:UIControlStateNormal];
        }else {
            [self.actionBtn setTitle:@"下载" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        }
        
    }else {
        if (self.progressView.progress == 1.0) {
            [self.actionBtn setImage:[UIImage imageNamed:@"已下载"] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"删除" forState:UIControlStateNormal];
        }else {
            [self.actionBtn setTitle:@"下载" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        }
    }
    
    receipt.downloaderProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        if ([targetURL.absoluteString isEqualToString:self.url]) {
            [self.actionBtn setTitle:@"停止" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
            self.progressView.progress = (receivedSize/1024.0/1024) / (expectedSize/1024.0/1024);
        }
    };
    
    receipt.downloaderCompletedBlock = ^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
        if (error) {
            [self.actionBtn setTitle:@"下载" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        }else {
            [self saveAfterDownload];
            [self.actionBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"已下载"] forState:UIControlStateNormal];
        }
    };
}

#pragma mark - Action
- (IBAction)actionBtnClick:(id)sender {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
        
        [[MCDownloader sharedDownloader] cancel:receipt completed:^{
            [self.actionBtn setTitle:@"下载" forState:UIControlStateNormal];
            [self.actionBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        }];
    }else if (receipt.state == MCDownloadStateCompleted) {
        if ([self.actionBtn.currentTitle isEqualToString:@"删除"]) {
            receipt.state = MCDownloadStateNone;
            [self delete];
        }else if ([self.actionBtn.currentTitle isEqualToString:@"下载"]) {
            receipt.state = MCDownloadStateNone;
            [self download];
        }
    }else {
        [self.actionBtn setTitle:@"停止" forState:UIControlStateNormal];
        [self.actionBtn setImage:[UIImage imageNamed:@"下载中"] forState:UIControlStateNormal];
        receipt.state = MCDownloadStateNone;
        [self download];
    }
}

- (IBAction)chooseBtnClick:(id)sender {
    _chooseBtn.selected = !_chooseBtn.isSelected;
    _chapterModel.isSelected = _chooseBtn.isSelected;
    !_chooseBlock?:_chooseBlock(_chapterModel);
}

#pragma mark - Methods
- (void)download {
//     [[ISYDownloadHelper shareInstance] downloadDataWithURL:[NSURL URLWithString:self.url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
//        
//    } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
//        
//    }];
}

- (void)delete {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    [[MCDownloader sharedDownloader]remove:receipt completed:nil];
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document,_detailModel.show_id,_detailModel.title];
    NSString *path = [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",self.chapterModel.l_id,self.url.lastPathComponent]];
    [[ZXTools shareTools] removeFileAtPath:path];
    self.progressView.progress = 0.0;
    [self.actionBtn setTitle:@"下载" forState:UIControlStateNormal];
    [self.actionBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
}

- (void)saveAfterDownload {
    //把下载的书本信息保存到本地
    NSString *downloadString = [USERDEFAULTS objectForKey:kDownloadBooks];
    if ([NSString isEmpty:downloadString]) {
        [self saveFirstBook];
    }else {
        NSArray *temp = [NSArray yy_modelArrayWithClass:[BookDetailModel class] json:downloadString];
        if (![temp isKindOfClass:[NSArray class]] || temp.count == 0) {
            [self saveFirstBook];
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
                //已经有该本书，新增一个章节
                [self saveNewChapterWithBookArray:bookArray];
            }else {
                //没有该本书，新增一本书
                [self saveNewBookWithBookArray:bookArray];
            }
            
        }
    }
}

#pragma mark - Local Save
//保存第一本书
- (void)saveFirstBook {
    NSMutableArray *bookArray = [NSMutableArray array];
    NSString *json = [_detailModel yy_modelToJSONString];
    BookDetailModel *newModel = [BookDetailModel yy_modelWithJSON:json];
    NSMutableArray *idArray = [NSMutableArray array];
    [idArray addObject:_chapterModel.l_id];
    newModel.download_chapter_idArray = idArray;
    [bookArray addObject:newModel];
    NSString *down_json = [bookArray yy_modelToJSONString];
    [USERDEFAULTS setObject:down_json forKey:kDownloadBooks];
    [USERDEFAULTS synchronize];
}

//已经有该本书，新增一个章节
- (void)saveNewChapterWithBookArray:(NSMutableArray *)bookArray {
    BOOL ret = NO;//是否有找到该本书
    for (BookDetailModel *m in bookArray) {
        if ([m.show_id isEqualToString:_detailModel.show_id]) {
            NSMutableArray *idArray = [NSMutableArray arrayWithArray:m.download_chapter_idArray];
            if (![idArray containsObject:_chapterModel.l_id]) {
                ret = YES;
                [idArray addObject:_chapterModel.l_id];
                m.download_chapter_idArray = idArray;
            }
            break;
        }
    }
    if (ret) {
        NSString *down_json = [bookArray yy_modelToJSONString];
        [USERDEFAULTS setObject:down_json forKey:kDownloadBooks];
        [USERDEFAULTS synchronize];
    }
}

//没有该本书，新增一本书
- (void)saveNewBookWithBookArray:(NSMutableArray *)bookArray {
    NSString *json = [_detailModel yy_modelToJSONString];
    BookDetailModel *newModel = [BookDetailModel yy_modelWithJSON:json];
    NSMutableArray *idArray = [NSMutableArray array];
    [idArray addObject:_chapterModel.l_id];
    newModel.download_chapter_idArray = idArray;
    [bookArray addObject:newModel];
    NSString *down_json = [bookArray yy_modelToJSONString];
    [USERDEFAULTS setObject:down_json forKey:kDownloadBooks];
    [USERDEFAULTS synchronize];
}

@end

