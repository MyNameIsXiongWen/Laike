//
//  MerchantShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "UserModel.h"
#import "QHWShareBottomViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MerchantShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, weak) id<QHWShareBottomViewProtocol>delegate;

@end

@interface DataView : UIView

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
