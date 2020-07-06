//
//  AdvisoryDetailViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvisoryDetailViewController : UIViewController

@property (nonatomic, copy) NSString *customerId;

@end

@interface AdvisoryDetailBottomView : UIView

@property (nonatomic, strong) UIButton *convertCRMBtn;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) void (^ clickLeftBtnBlock)(void);
@property (nonatomic, copy) void (^ clickRightBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
