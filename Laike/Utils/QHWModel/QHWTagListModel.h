//
//  QHWTagListModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/25.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWTagListModel : NSObject
@property (nonatomic, copy) NSString *labelItemCode;//标签项编码
@property (nonatomic, copy) NSString *labelItemName;//标签项名称
@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
