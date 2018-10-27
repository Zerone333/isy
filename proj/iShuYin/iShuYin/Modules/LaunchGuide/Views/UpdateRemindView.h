//
//  UpdateRemindView.h
//  JWXUserClient
//
//  Created by Apple on 16/11/1.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateRemindView : UIView

@property (nonatomic, strong) NSString *content;//更新的内容

@property (nonatomic, strong) NSString *link_url;//下载地址(app store)

@property (nonatomic, strong)void (^dismissBlock)(void);

@end
