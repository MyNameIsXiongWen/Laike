//
//  PublishRelateProductViewController.h
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishRelateProductViewController : UIViewController

@property (nonatomic, copy) void (^ selectProductBlock)(void);

@end

//@interface RelatedProductCell : UITableViewCell
//
//@property (nonatomic, strong) UIImageView *selectedImgView;
//@property (nonatomic, strong) UILabel *nameLabel;
//
//@end

NS_ASSUME_NONNULL_END
