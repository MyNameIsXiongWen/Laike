//
//  MineInfoViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/15.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@class MineInfoTimeView;
@interface MineInfoViewController : UIViewController

@end


@protocol MineInfoTimeViewDelegate <NSObject>

@optional
- (void)mineInfoTimeView_cancel;
- (void)mineInfoTimeView_confirm:(NSString *)time;

@end
@interface MineInfoTimeView : QHWPopView

@property (nonatomic, weak) id <MineInfoTimeViewDelegate>timeDelegate;
@property (nonatomic, copy) NSString *currentDate;

@end

NS_ASSUME_NONNULL_END
