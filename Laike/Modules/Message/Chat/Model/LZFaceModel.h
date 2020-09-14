//
//  LZFaceModel.h
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LZFaceImgModel;
@interface LZFaceModel : NSObject

///表情包类型名称
@property (nonatomic, copy) NSString *typeName;
///表情包类型图片
@property (nonatomic, copy) NSString *typeImage;
///表情包类型编码
@property (nonatomic, assign) NSInteger typeCode;
///表情包集合
@property (nonatomic, strong) NSArray <LZFaceImgModel*>*list;
///装list的数组
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) BOOL faceSelected;

@end

@interface LZFaceImgModel : NSObject

///图片地址
@property (nonatomic, copy) NSString *imageSrc;
@property (nonatomic, copy) NSString *imageName;
///图片类型 1gif 2jpg 3png
@property (nonatomic, assign) NSInteger imageType;
///唯一识别码
@property (nonatomic, assign) NSInteger identityCode;

@end

NS_ASSUME_NONNULL_END
