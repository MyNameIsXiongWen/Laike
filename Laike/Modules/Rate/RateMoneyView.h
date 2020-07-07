//
//  RateMoneyView.h
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MoneySubView;
@interface RateMoneyView : UIView

@property (nonatomic, assign) NSInteger selectedMoneyViewIndex;
@property (nonatomic, strong, readonly) NSMutableArray <MoneySubView *> *viewArray;
@property (nonatomic, strong, readonly) NSMutableArray <RateModel *>*rateArray;

@property (nonatomic, copy) NSString *currentMoney;
- (NSString *)getCorrectString:(NSString *)string;

@end

@class CurrencyView;
@interface MoneySubView : UIView

@property (nonatomic, strong) CurrencyView *currencyView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, assign) NSInteger currencySelectedIndex;
@property (nonatomic, copy) void (^ clickCurrencyBlock)(void);
@property (nonatomic, copy) void (^ clickSubViewBlock)(void);

@end

@interface CurrencyView : UIView

@property (nonatomic, strong) UILabel *currencyLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
