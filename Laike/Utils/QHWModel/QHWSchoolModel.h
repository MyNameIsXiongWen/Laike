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
@property (nonatomic, copy) NSString *headPath;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *industryName;
///文件类型：1-pdf；2-视频；3-图片(暂时不处理)
@property (nonatomic, assign) NSInteger fileType;
///学习类型：1-专业课堂；2-产品学习
@property (nonatomic, assign) NSInteger learnType;
@property (nonatomic, assign) NSInteger browseCount;
///视频状态：1-横向；2-竖向(fileType=2 必填)
@property (nonatomic, assign) NSInteger videoStatus;
///文件List
@property (nonatomic, strong) NSArray *filePathList;
@property (nonatomic, strong) UIImage *snapShotImage;

@end

NS_ASSUME_NONNULL_END
