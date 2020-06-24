//
//  QHWSchoolModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWSchoolModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *createTime;
///文件类型：1-pdf；2-视频；3-图片(暂时不处理)
@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, assign) NSInteger browseCount;

@end

NS_ASSUME_NONNULL_END
