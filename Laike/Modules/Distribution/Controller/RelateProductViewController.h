//
//  RelateProductViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RelateProductViewController : UIViewController

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) void (^ didSelectProductBlock)(NSString *businessId, NSString *businessName);

@end

NS_ASSUME_NONNULL_END
