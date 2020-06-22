//
//  QHWFilterView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWFilterView : QHWPopView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *buttonBgView;

@property (nonatomic, strong) NSMutableDictionary *conditionDic;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^ clickResetBlock)(void);
@property (nonatomic, copy) void (^ clickConfirmBlock)(void);

@end

NS_ASSUME_NONNULL_END
