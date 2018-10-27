//
//  CommentListModel.h
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentAttachmentModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;//图片地址
@property (nonatomic, strong) NSString *description;
@end



@interface CommentPassportModel : NSObject
@property (nonatomic, strong) NSString *img_url;//头像地址
@property (nonatomic, strong) NSString *nickname;//用户昵称
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *grant;
@property (nonatomic, strong) NSString *expired;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *platform_id;
@property (nonatomic, strong) NSString *followers_count;
@property (nonatomic, strong) NSString *is_shared;
@property (nonatomic, strong) NSString *is_official;
@end



@interface CommentListModel : NSObject
@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *reply_id;
@property (nonatomic, strong) NSString *comment_id;//评论id
@property (nonatomic, strong) NSString *from;//来源
@property (nonatomic, strong) NSString *status;//状态 0=正常 1=删除
@property (nonatomic, strong) NSString *content;//评论内容
@property (nonatomic, strong) NSString *create_time;//发表时间

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *ip_location;//地域信息

@property (nonatomic, strong) NSString *top;//是否置顶
@property (nonatomic, strong) NSString *hide;//是否隐藏当前评论
@property (nonatomic, strong) NSString *quick;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *elite;//是否加精
@property (nonatomic, strong) NSString *highlight;//是否高亮评论
@property (nonatomic, strong) NSString *hide_floor;//是否隐藏重复盖楼

@property (nonatomic, strong) NSString *support_count;//顶数
@property (nonatomic, strong) NSString *oppose_count;//参数
@property (nonatomic, strong) NSString *reply_count;//回复数
@property (nonatomic, strong) NSString *floor_count;//

@property (nonatomic, strong) NSArray *attachments;//发表图片
@property (nonatomic, strong) NSArray *comments;//盖楼列表
@property (nonatomic, strong) CommentPassportModel *passport;//评论用户信息

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) CGFloat cellHeight;
@end
