//
//  QHWCommunityContentModel.h
//  GoOverSeas
//  海外圈子Model
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWBottomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWCommunityContentModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *consultId;
@property (nonatomic, copy) NSString *consultHead;
@property (nonatomic, copy) NSString *consultName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *videoStatus;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, strong) NSArray *filePathList;
@property (nonatomic, strong) QHWBottomUserModel *subjectData;
///分享时的截图
@property (nonatomic, strong) UIImage *videoImg;

@property (nonatomic, assign) NSInteger browseCount;
@property (nonatomic, assign) NSInteger collectionCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger shareCount;
///点赞状态1-未点赞；2-已点赞
@property (nonatomic, assign) NSInteger likeStatus;
@property (nonatomic, assign) NSInteger fileType;

//处理后的数据
@property (nonatomic, copy) NSString *collectionStr;//收藏数
@property (nonatomic, copy) NSString *commentStr;//评论数
@property (nonatomic, copy) NSString *likeStr;//点赞数
@property (nonatomic, copy) NSString *shareStr;//转发数

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
