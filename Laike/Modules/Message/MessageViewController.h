//
//  MessageViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/14.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController

@end

@interface SearchView : UIView

@property (nonatomic, copy) void (^ tapBlock)(void);

@end

NS_ASSUME_NONNULL_END
