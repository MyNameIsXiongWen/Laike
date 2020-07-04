//  底部view（店铺logo+名字+线上咨询+电话咨询）
//  MainBusinessDetailBottomView.h
//  GoOverSeas
//
//  Created by manku on 2019/7/30.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWMainBusinessDetailBaseModel.h"
#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainBusinessDetailBottomView : UIView

@property (nonatomic, strong, readonly) UIButton *onlineButton;
///1-房产；2-游学；3-移民；4-留学  17:活动详情  102001:医疗  103001:直播详情
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *detailModel;

@end

@interface ActivityRegisterView : QHWPopView

@property (nonatomic, strong) NSArray *registerModeList;
@property (nonatomic, copy) void (^ confirmBlock)(NSArray *columnList);

@end

NS_ASSUME_NONNULL_END
