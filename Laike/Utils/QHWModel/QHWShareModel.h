//
//  QHWShareModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/23.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWShareModel : NSObject
@property (nonatomic,copy)NSString *mainTitle;//主标题
@property (nonatomic,copy)NSString *subTitle;//副标题
@property (nonatomic,copy)NSString *imgSrc;//图片
@property (nonatomic,copy)NSString *link;//链接
@property (nonatomic,assign)NSInteger shareLogId;//分享记录编号
@end




NS_ASSUME_NONNULL_END
