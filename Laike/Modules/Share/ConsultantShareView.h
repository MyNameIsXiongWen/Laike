//
//  ConsultantShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ConsultantShareViewDelegate <NSObject>

@optional
- (void)ConsultantShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image;

@end

@interface ConsultantShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, weak) id<ConsultantShareViewDelegate>delegate;

@end

@interface InfoView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;

@end

NS_ASSUME_NONNULL_END
