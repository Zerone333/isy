//
//  SettingViewController.m
//  iShuYin
//
//  Created by Apple on 2017/10/18.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "MCDownloader.h"
#import "ISYSettingModel.h"
#import "ISYSettingTableViewCell.h"
#import "ISYUserConfigManager.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) ISYSettingConfgModel *confgModel;
@end

@implementation SettingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"设置"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *reuseId = @"SettingCell";
//    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
//    NSArray *sectionArray = self.dataArray[indexPath.section];
//    cell.dict = sectionArray[indexPath.row];
//    return cell;
    ISYSettingModel *model = self.dataArray[indexPath.row];
    ISYSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYSettingTableViewCell cellId]];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.dataArray.count -1) {
        ISYSettingModel *model = self.dataArray[indexPath.row];
        model.switchValueChagneBlock(0);
    }
  
}

#pragma mark - Methods
//清除缓存
- (void)clearLoacalCache {
    [ZXProgressHUD showLoading:@""];
    [USERDEFAULTS setObject:@"" forKey:kDownloadBooks];
    [USERDEFAULTS setObject:@"" forKey:kRecentBooks];
    
    [[MCDownloader sharedDownloader]removeAndClearAll];
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                       NSString *downloadPath = [NSString stringWithFormat:@"%@/downloads",document];

                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:downloadPath];
                       for (NSString *subpath in files) {
                           NSError *error;
                           NSString *path = [downloadPath stringByAppendingPathComponent:subpath];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearSuccess) withObject:nil waitUntilDone:YES];}
                   );
    
    [ZXProgressHUD hide];
}

- (void)clearSuccess {
    self.dataArray = nil;
    [self.tableView reloadData];
    [SVProgressHUD showImage:nil status:@"清除成功"];
}

//计算缓存大小
- (NSString *)calculateCacheSize {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *downloadPath = [NSString stringWithFormat:@"%@/downloads",document];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:downloadPath]) {
        NSDictionary *attr = [manager attributesOfItemAtPath:downloadPath error:nil];
        if (![attr.fileType isEqualToString:NSFileTypeDirectory]) {
            return @"0.00M";
        }
        unsigned long long size = 0;
        NSString *sizeText = nil;
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:downloadPath];
        for (NSString *subpath in enumerator) {
            NSString *fullSubpath = [downloadPath stringByAppendingPathComponent:subpath];
            size += [manager attributesOfItemAtPath:fullSubpath error:nil].fileSize;

            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
        }
        return [NSString isEmpty:sizeText]?@"0.00M":sizeText;
    }
    return @"0.00M";
}

- (void)showSleepSheet {
    ZXPopView *view = [[ZXPopView alloc]initSleepCountDownView];
    [view showInView:self.navigationController.view animated:ZXPopViewAnimatedSlip];
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[ISYSettingTableViewCell class] forCellReuseIdentifier:[ISYSettingTableViewCell cellId]];
    }
    return _tableView;
}

- (NSArray *)dataArray {
        __weak typeof(self) weakSelf = self;
        ISYSettingConfgModel *model = self.confgModel;
        ISYSettingModel *model1 = [ISYSettingModel modelTitle:@"流量收听" imageName:@"setting_liuliang" settingType:ISYSettingModelSettingType_Swich block:^(BOOL switchValue) {
            weakSelf.confgModel.allowTraffic = switchValue == YES;
            [[ISYUserConfigManager shareInstance] updateSettingConfig:weakSelf.confgModel];
            [weakSelf.tableView reloadData];
        }];
        model1.valueString = model.allowTraffic ? @"1" : @"0";
        
        ISYSettingModel *model2 = [ISYSettingModel modelTitle:@"仅在wifi网络下载" imageName:@"setting_wifi" settingType:ISYSettingModelSettingType_Swich block:^(BOOL switchValue) {
            weakSelf.confgModel.allowWifiDownload = switchValue == YES;
            [[ISYUserConfigManager shareInstance] updateSettingConfig:weakSelf.confgModel];
            [weakSelf.tableView reloadData];
            
        }];
        model2.valueString = model.allowWifiDownload ? @"1" : @"0";
        
        ISYSettingModel *model3 = [ISYSettingModel modelTitle:@"拔出耳机暂停播放" imageName:@"setting_erji" settingType:ISYSettingModelSettingType_Swich block:^(BOOL switchValue) {
            weakSelf.confgModel.outputHeadsetPlay = switchValue == YES;
            [[ISYUserConfigManager shareInstance] updateSettingConfig:weakSelf.confgModel];
            [weakSelf.tableView reloadData];
            
        }];
        model3.valueString = model.outputHeadsetPlay ? @"1" : @"0";
        ISYSettingModel *model4 = [ISYSettingModel modelTitle:@"插入耳机自动播放" imageName:@"setting_erji" settingType:ISYSettingModelSettingType_Swich block:^(BOOL switchValue) {
            weakSelf.confgModel.inputHeadsetPlay = switchValue == YES;
            [[ISYUserConfigManager shareInstance] updateSettingConfig:weakSelf.confgModel];
            [weakSelf.tableView reloadData];
            
        }];
        model4.valueString = model.inputHeadsetPlay ? @"1" : @"0";
        
        ISYSettingModel *model5= [ISYSettingModel modelTitle:@"清空缓存" imageName:@"setting_clear" settingType:ISYSettingModelSettingType_info block:^(BOOL switchValue) {
            [weakSelf clearLoacalCache];
            
        }];
        model5.valueString = [self calculateCacheSize];
        
        return  @[model1, model2, model3, model4, model5];
    
  
}

- (ISYSettingConfgModel *)confgModel {
    if (!_confgModel) {
        _confgModel = [[ISYUserConfigManager shareInstance] currentSettingConfig];
    }
    return _confgModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
