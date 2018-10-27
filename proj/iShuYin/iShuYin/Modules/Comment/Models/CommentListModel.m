//
//  CommentListModel.m
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "CommentListModel.h"

@implementation CommentAttachmentModel

@end



@implementation CommentPassportModel

@end



@implementation CommentListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attachments":[CommentAttachmentModel class],
             @"comments":[CommentListModel class],
             };
}

@end
