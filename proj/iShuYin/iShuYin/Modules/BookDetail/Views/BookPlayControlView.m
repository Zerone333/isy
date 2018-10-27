//
//  BookPlayControlView.m
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookPlayControlView.h"


@interface BookPlayControlView ()
@property (weak, nonatomic) IBOutlet UIButton *midBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@end

@implementation BookPlayControlView

- (IBAction)midBtnClick:(id)sender {
    !_playPauseBlock?:_playPauseBlock();
}

- (IBAction)previousBtnClick:(id)sender {
    !_previousBlock?:_previousBlock();
}

- (IBAction)nextBtnClick:(id)sender {
    !_nextBlock?:_nextBlock();
}

@end
