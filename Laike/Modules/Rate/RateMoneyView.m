//
//  RateMoneyView.m
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RateMoneyView.h"
#import "QHWActionSheetView.h"

@interface RateMoneyView () <QHWActionSheetViewDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray <MoneySubView *> *viewArray;
@property (nonatomic, strong, readwrite) NSMutableArray <RateModel *>*rateArray;


@end

@implementation RateMoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self getMainData];
    }
    return self;
}

- (void)setSelectedMoneyViewIndex:(NSInteger)selectedMoneyViewIndex {
    _selectedMoneyViewIndex = selectedMoneyViewIndex;
    for (MoneySubView *subView in self.viewArray) {
        subView.moneyLabel.textColor = kColorTheme2a303c;
    }
    self.viewArray[selectedMoneyViewIndex].moneyLabel.textColor = kColorThemefb4d56;
}

- (NSString *)getCorrectString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@"," withString:@""];
}

- (void)setCurrentMoney:(NSString *)currentMoney {
    _currentMoney = currentMoney;
    MoneySubView *subView = self.viewArray[self.selectedMoneyViewIndex];
    subView.moneyLabel.text = [self setNewMoney:[self getCorrectString:currentMoney]];
    [self configMoneyView];
}

- (NSString *)setNewMoney:(NSString *)money {
    NSArray *array = [money componentsSeparatedByString:@"."];
    NSMutableArray *moneyArray = NSMutableArray.array;
    [self moneyArray:moneyArray money:array.firstObject];
    NSString *result;
    if (moneyArray.count > 1) {
        for (NSString *str in moneyArray) {
            if (result.length == 0) {
                result = str;
            } else {
                result = [result stringByAppendingFormat:@",%@", str];
            }
        }
    } else {
        result = moneyArray.firstObject;
    }
    if (array.count > 1) {
        result = [result stringByAppendingFormat:@".%@", array.lastObject];
    }
    return result;
}

- (void)moneyArray:(NSMutableArray *)array money:(NSString *)money {
    if (money.length > 3) {
        NSString *sourceMoney = [money substringToIndex:money.length-3];
        NSString *targetMoney = [money substringFromIndex:money.length-3];
        [array insertObject:targetMoney atIndex:0];
        [self moneyArray:array money:sourceMoney];
    } else {
        [array insertObject:money atIndex:0];
    }
}

- (void)configMoneyView {
    MoneySubView *subView = self.viewArray[self.selectedMoneyViewIndex];
    NSString *moneyString = [self getCorrectString:subView.moneyLabel.text];
    CGFloat cnyMoney = moneyString.floatValue;
//    如果不是人民币的话，先把它转成人民币的金额， 再转一遍转成目标币种
    if (subView.currencySelectedIndex != 0) {
        cnyMoney = moneyString.floatValue / self.rateArray[subView.currencySelectedIndex].rate.floatValue;
    }
    
    for (int i=0; i<self.viewArray.count; i++) {
        if (self.selectedMoneyViewIndex != i) {
            MoneySubView *tempSubView = self.viewArray[i];
            CGFloat rate = self.rateArray[tempSubView.currencySelectedIndex].rate.floatValue;
            tempSubView.moneyLabel.text = [self setNewMoney:[NSString formatterWithValue:cnyMoney * rate]];
        }
    }
}

- (void)getMainData {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kRateUrl parameters:@{} success:^(id responseObject) {
        RateModel *model = RateModel.new;
        model.currencyName = @"人民币 CNY";
        model.rate = @"1";
        [self.rateArray addObject:model];
        for (NSDictionary *dic in responseObject[@"result"][@"lists"]) {
            RateModel *tempModel = RateModel.new;
            NSString *name = [dic[@"ratenm"] componentsSeparatedByString:@"/"].lastObject;
            tempModel.currencyName = kFormat(@"%@ %@", name, dic[@"tcur"]);
            tempModel.rate = dic[@"rate"];
            [self.rateArray addObject:tempModel];
        }
        
        NSInteger viewCount = MIN(self.height / 40.0, self.rateArray.count);
        CGFloat spaceHeight = (self.height - viewCount * 40.0) / viewCount;
        for (int i=0; i<viewCount; i++) {
            MoneySubView *subView = [self createMoneySubViewWithFrame:CGRectMake(0, (40+spaceHeight)*i, self.width, 40) Tag:100+i];
            subView.currencySelectedIndex = i;
            [self addSubview:subView];
            [self.viewArray addObject:subView];
        }
        self.selectedMoneyViewIndex = 0;
        
        [self.viewArray enumerateObjectsUsingBlock:^(MoneySubView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RateModel *rateModel = self.rateArray[idx];
            obj.currencyView.currencyLabel.text = rateModel.currencyName;
        }];
        self.currentMoney = @"100";
    } failure:^(NSError *error) {
        
    }];
}

- (void)showActionSheetView:(NSInteger)tag {
    QHWActionSheetView *sheetView = [[QHWActionSheetView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44*MIN(5, (self.rateArray.count+1))+7) title:@""];
    sheetView.tag = tag;
    sheetView.dataArray = [self.rateArray convertToTitleArrayWithKeyName:@"currencyName"];
    sheetView.sheetDelegate = self;
    [sheetView show];
}

- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView {
    MoneySubView *subView = self.viewArray[actionsheetView.tag];
    subView.currencySelectedIndex = index;
    subView.currencyView.currencyLabel.text = self.rateArray[index].currencyName;
    [self configMoneyView];
}

#pragma mark ------------UI-------------
- (MoneySubView *)createMoneySubViewWithFrame:(CGRect)rect Tag:(NSInteger)tag {
    MoneySubView *subView = [[MoneySubView alloc] initWithFrame:rect];
    WEAKSELF
    subView.clickSubViewBlock = ^{
        weakSelf.selectedMoneyViewIndex = tag-100;
    };
    subView.clickCurrencyBlock = ^{
        [weakSelf showActionSheetView:tag-100];
    };
    return subView;
}

- (NSMutableArray<RateModel *> *)rateArray {
    if (!_rateArray) {
        _rateArray = NSMutableArray.array;
    }
    return _rateArray;
}

- (NSMutableArray<MoneySubView *> *)viewArray {
    if (!_viewArray) {
        _viewArray = NSMutableArray.array;
    }
    return _viewArray;
}

@end

@implementation MoneySubView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.viewAction(self, @selector(tapSubView));
        
        self.currencyView = [[CurrencyView alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
        self.currencyView.viewAction(self, @selector(tapCurrencyView));
        [self addSubview:self.currencyView];
        
        self.moneyLabel = UILabel.labelFrame(CGRectMake(self.currencyView.right + 10, 0, self.width-30-self.currencyView.width, 40)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentRight);
        [self addSubview:self.moneyLabel];
    }
    return self;
}

- (void)tapSubView {
    if (self.clickSubViewBlock) {
        self.clickSubViewBlock();
    }
}

- (void)tapCurrencyView {
    if (self.clickCurrencyBlock) {
        self.clickCurrencyBlock();
    }
}

@end

@implementation CurrencyView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.currencyLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme18);
        [self addSubview:self.currencyLabel];
        
        self.imgView = UIImageView.ivInit().ivImage(kImageMake(@"global_down"));
        [self addSubview:self.imgView];
        
        [self.currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currencyLabel.mas_right).offset(5);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
