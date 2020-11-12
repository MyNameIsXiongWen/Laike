//
//  WithdrawAccountViewController.h
//  Laike
//
//  Created by xiaobu on 2020/11/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawAccountViewController : UIViewController

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void (^ bindSuccessBlock)(NSString *name);

@end

NS_ASSUME_NONNULL_END
