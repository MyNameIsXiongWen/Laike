//
//  QSchoolDetailViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSchoolDetailViewController : UIViewController

@property (nonatomic, copy) NSString *schoolId;

@end

@interface QSchoolPDFView : UIView

@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void (^ clickPDFBlock)(void);

@end



NS_ASSUME_NONNULL_END
