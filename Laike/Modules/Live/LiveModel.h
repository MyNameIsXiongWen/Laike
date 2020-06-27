//
//  LiveModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWBottomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *mainDescribe;
@property (nonatomic, copy) NSString *mainHead;
@property (nonatomic, copy) NSString *mainName;
@property (nonatomic, copy) NSString *subjectName;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, strong) QHWBottomUserModel *bottomData;

@property (nonatomic, assign) NSInteger browseCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger businessType;
///上架状态：1-上架；2-下架（默认上架）
@property (nonatomic, assign) NSInteger shelfStatus;
///点赞状态1-未点赞；2-已点赞
@property (nonatomic, assign) NSInteger likeStatus;
@property (nonatomic, assign) NSInteger videoStatus;
@property (nonatomic, assign) NSInteger liveStatus;
@property (nonatomic, assign) NSInteger concernStatus;
///报名状态：1-可以报名；2-报名已结束
@property (nonatomic, assign) NSInteger entryStatus;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) UIImage *snapShotImage;

@end

NS_ASSUME_NONNULL_END
