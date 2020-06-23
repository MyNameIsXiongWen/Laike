//
//  MineUpdateNameViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/18.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineUpdateNameViewController : UIViewController

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) void (^ updateNameBlock)(NSString *name);

@end

NS_ASSUME_NONNULL_END
