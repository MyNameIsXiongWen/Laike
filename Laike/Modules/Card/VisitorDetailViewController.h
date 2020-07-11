//
//  VisitorDetailViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisitorDetailViewController : UIViewController

@property (nonatomic, copy) NSString *userId;

@end

@interface VisitorDetailBottomView : UIView

@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) NSString *mobilePhone;

@end

NS_ASSUME_NONNULL_END
