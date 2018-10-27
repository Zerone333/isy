//
//  FeedbackTypeView.m
//  iShuYin
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackTypeView.h"

@interface FeedbackTypeView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *array;
@end

@implementation FeedbackTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _array = @[
                   @{@"title":@"留言",@"type":@"0"},
                   @{@"title":@"咨询",@"type":@"1"},
                   @{@"title":@"报错",@"type":@"2"},
                   @{@"title":@"求书",@"type":@"3"},
                   ];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _array = @[
                   @{@"title":@"留言",@"type":@"0"},
                   @{@"title":@"咨询",@"type":@"1"},
                   @{@"title":@"报错",@"type":@"2"},
                   @{@"title":@"求书",@"type":@"3"},
                   ];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.array.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dict = self.array[row];
    return dict[@"title"];
}

#pragma mark - Action
- (IBAction)sureBtnClick:(id)sender {
    NSInteger row = [_pickerView selectedRowInComponent:0];
    NSDictionary *dict = self.array[row];
    !_selectBlock?:_selectBlock(dict);
    !_dismissBlock?:_dismissBlock();
}

- (IBAction)cancelBtnClick:(id)sender {
    !_dismissBlock?:_dismissBlock();
}

@end
