//
//  MainBusinessShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "QHWMainBusinessDetailBaseModel.h"
#import "LiveModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MainBusinessShareViewDelegate <NSObject>

@optional
- (void)MainBusinessShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image;

@end

@interface MainBusinessShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *mainBusinessDetailModel;
@property (nonatomic, strong) LiveModel *liveModel;
@property (nonatomic, weak) id<MainBusinessShareViewDelegate>delegate;

@end

@interface ShareBottomView : UIView

@property (nonatomic, copy) void (^ clickBtnBlock)(NSInteger index);

@end

@interface ShareBottomBtnView : UIView

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *logoLabel;

@end

NS_ASSUME_NONNULL_END
