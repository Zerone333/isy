//
//  BookPlayControlView.h
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookPlayControlView : UIView

@property (nonatomic, strong) void (^previousBlock)();

@property (nonatomic, strong) void (^nextBlock)();

@property (nonatomic, strong) void (^playPauseBlock)();

@end
