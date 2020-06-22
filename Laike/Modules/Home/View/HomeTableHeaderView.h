//
//  HomeTableHeaderView.h
//  Laike
//
//  Created by xiaobu on 2020/6/22.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeTableHeaderViewDelegate <NSObject>

@required
- (void)HomeTableHeaderView_selectedTabScrollView:(NSInteger)index;

@end

@interface HomeTableHeaderView : UIView

@property (nonatomic, weak) id <HomeTableHeaderViewDelegate>delegate;

@end

@interface UserInfoView : UIView

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIButton *shareBtn;

@end

NS_ASSUME_NONNULL_END
