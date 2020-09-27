//
//  CRMTopOperationView.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TopOperationModel;
@interface CRMTopOperationView : UIView

@property (nonatomic, strong) NSArray <TopOperationModel *>*dataArray;

@end

@interface OperationCollectionSubView : UICollectionViewCell

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) TopOperationModel *model;

@end

@interface TopOperationModel : NSObject

@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *identifier;

+ (instancetype)initialWithLogo:(NSString *)logo Title:(NSString *)title SubTitle:(NSString *)subTitle Identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
