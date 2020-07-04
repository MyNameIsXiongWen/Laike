//
//  MerchantShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"


#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MerchantShareViewDelegate <NSObject>

@optional
- (void)MerchantShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image;

@end

@interface MerchantShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, weak) id<MerchantShareViewDelegate>delegate;

@end

@interface DataView : UIView

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
