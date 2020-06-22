//
//  QHWBannerModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/22.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWBannerModel : NSObject

///广告来源（1-内部；2-外部）
@property (nonatomic, assign) NSInteger advertSource;
/*1-房产；2-游学；3-移民；4-留学；5-头条(内容);6-头条（评论）；7-头条(回复)；8-攻略（内容）；9-攻略（评论）；10-攻略（回复）；

11-问答(提问)；12-问答(回答)；13-学校；14-商户店铺；15-顾问主页；16-用户主页；17-活动；

18-内容视频(内容);19-内容视频（评论）；20-内容视频(回复)；21-内容图文(内容);22-内容图文（评论）；23-内容图文(回复)；(ps:业务类型=1821查询视频+内容列表合并)

24-学习模块专业课堂(内容);25- 学习模块专业课堂  （评论）；26- 学习模块专业课堂  (回复)；27-学习模块产品学习(内容);28- 学习模块产品学习    （评论）；29- 学习模块 产品学习    (回复)；*/
///业务类型（参照公共参数定义business_type）advertSource=1时非空
@property (nonatomic, assign) NSInteger businessType;
///业务唯一标识advertSource=1时非空
@property (nonatomic, copy) NSString *businessId;
///广告url地址，advertSource=2时非空
@property (nonatomic, copy) NSString *advertUrl;
///广告图片，七牛云
@property (nonatomic, copy) NSString *advertPath;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *icon;
///banner名称
@property (nonatomic, copy) NSString *name;

- (void)setBannerTapAction;

@end

NS_ASSUME_NONNULL_END
