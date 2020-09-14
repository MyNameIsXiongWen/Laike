//
//  ChatCommonWordView.h
//  XuanWoJia
//
//  Created by jason on 2019/9/27.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCommonWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatCommonWordViewDelegate <NSObject>

- (void)commonWordView_didClickSettingBtn;
- (void)commonWordView_didClickAddBtn;
- (void)commonWordView_didClickTableViewIndexpath:(ChatCommonWordModel *)model;

@end

@interface ChatCommonWordView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id <ChatCommonWordViewDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *addLabel;
- (void)getCommonWordListRequest;

@end

NS_ASSUME_NONNULL_END
