//
//  QHWContentTableViewCell.h
//  GoOverSeas
//
//  Created by 熊文 on 2020/5/17.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWCommunityContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWContentTableViewCell : UITableViewCell

@property (nonatomic, strong) QHWCommunityContentModel *contentModel;
@property (nonatomic, copy) void (^ longPressBlock)(NSString *contentId);

@end

NS_ASSUME_NONNULL_END
