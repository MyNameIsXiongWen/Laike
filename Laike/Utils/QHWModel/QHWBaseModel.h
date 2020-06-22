//
//  QHWBaseModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/6/4.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWBaseModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;//collectioncell会用到宽度
@property (nonatomic, strong) id data;
@property (nonatomic, assign) BOOL showMoreBtn;

- (instancetype)configModelIdentifier:(NSString *)identifier Height:(CGFloat)height Data:(id)data;
- (instancetype)configModelIdentifier:(NSString *)identifier Height:(CGFloat)height Width:(CGFloat)width Data:(id)data;

@end

NS_ASSUME_NONNULL_END
