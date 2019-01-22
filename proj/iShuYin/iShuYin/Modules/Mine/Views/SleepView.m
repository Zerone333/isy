//
//  SleepView.m
//  iShuYin
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 angxun. All rights reserved.
//

#import "SleepView.h"
#import "SleepCell.h"
#import "SleepModel.h"
#import "Const.h"

@interface SleepView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SleepView

- (void)awakeFromNib {
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"SleepCell" bundle:nil] forCellReuseIdentifier:@"SleepCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"SleepCell";
    SleepCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.sleepModel = self.dataArray[indexPath.row];
    if (cell.sleepModel.isSelected) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
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
    SleepModel *m = self.dataArray[indexPath.row];
    if (m.isSelected) {
        return;
    }
    m.isSelected = YES;
    APPDELEGATE.sleepType = m.sleepType;
    [APPDELEGATE startSleepTimerWithInterval:(m.sleepType*60)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiTimerChange object:m];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SleepModel *m = self.dataArray[indexPath.row];
    m.isSelected = NO;
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

#pragma mark - Action
- (IBAction)cancelBtnClick:(id)sender {
    for (SleepCell *cell in self.tableView.visibleCells) {
        [cell stopTimer];
    }
    !_dismissBlock?:_dismissBlock();
}

#pragma mark - Getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (NSNumber *obj in @[@(SleepType0),@(SleepType15),@(SleepType20),@(SleepType30),@(SleepType45),@(SleepType60),@(SleepType90)]) {
            SleepModel *m = [[SleepModel alloc]init];
            m.sleepType = obj.integerValue;
            if (APPDELEGATE.sleepType == m.sleepType) {
                m.isSelected = YES;
            }else {
                m.isSelected = NO;
            }
            [_dataArray addObject:m];
        }
    }
    return _dataArray;
}

@end
