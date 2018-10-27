//
//  FeedbackModel.h
//  iShuYin
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackModel : NSObject
@property (nonatomic, strong) NSString *msg_id;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_email;
@property (nonatomic, strong) NSString *msg_title;
@property (nonatomic, strong) NSString *msg_type;
@property (nonatomic, strong) NSString *msg_content;//内容
@property (nonatomic, strong) NSString *msg_time;//添加时间
@property (nonatomic, strong) NSString *message_img;
@property (nonatomic, strong) NSString *msg_area;
@property (nonatomic, strong) FeedbackModel *msg_reply;//回复信息
@end
