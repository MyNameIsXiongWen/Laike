//
//  WalletViewController.h
//  Laike
//
//  Created by xiaobu on 2020/11/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataView.h"
#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletViewController : UIViewController

@end

@interface WallerHeaderView : UIView

@property (nonatomic, strong) UIImageView *bkgImgView;
@property (nonatomic, strong) UIButton *withdrawBtn;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *balanceSubtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UserDataView *userDataView;
@property (nonatomic, copy) void (^ clickWithdrawBlock)(void);

@end

@interface WalletTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *line;

@end

@interface RuleView : QHWPopView

@end

NS_ASSUME_NONNULL_END
