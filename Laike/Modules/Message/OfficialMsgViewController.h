//
//  OfficialMsgViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OfficialMsgViewController : UIViewController

@end

@interface OfficialMsgTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *btmLine;

@end

NS_ASSUME_NONNULL_END
