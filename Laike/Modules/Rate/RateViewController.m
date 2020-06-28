//
//  RateViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RateViewController.h"
#import "RateMoneyView.h"
#import "RateKeyBoardView.h"
#import "RateModel.h"

@interface RateViewController ()

@property (nonatomic, strong) RateMoneyView *moneyView;
@property (nonatomic, strong) RateKeyBoardView *keyboardView;
@property (nonatomic, strong) NSMutableArray <RateModel *>*rateArray;

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"汇率转换";
    [self.view addSubview:self.moneyView];
    [self.view addSubview:self.keyboardView];
    [self.view addSubview:UIView.viewFrame(CGRectMake(10, self.moneyView.bottom, kScreenW-20, 0.5)).bkgColor(kColorThemeeee)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (RateMoneyView *)moneyView {
    if (!_moneyView) {
        _moneyView = [[RateMoneyView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, (kScreenH-kTopBarHeight)*0.4)];
    }
    return _moneyView;
}

- (RateKeyBoardView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[RateKeyBoardView alloc] initWithFrame:CGRectMake(0, self.moneyView.bottom, kScreenW, (kScreenH-kTopBarHeight)*0.6)];
        WEAKSELF
        _keyboardView.clickKeyBoardBlock = ^(NSString * _Nonnull title) {
            MoneySubView *subView = weakSelf.moneyView.viewArray[weakSelf.moneyView.selectedMoneyViewIndex];
            if ([subView.moneyLabel.text isEqualToString:@"0"]) {
                weakSelf.moneyView.currentMoney = title;
            } else {
                weakSelf.moneyView.currentMoney = kFormat(@"%@%@", subView.moneyLabel.text ?: @"", title ?: @"");
            }
        };
        _keyboardView.rightView.clickClearBlock = ^{
            weakSelf.moneyView.currentMoney = @"0";
        };
        _keyboardView.rightView.clickDeleteBlock = ^{
            NSString *correctMoney = [weakSelf.moneyView getCorrectString:weakSelf.moneyView.currentMoney];
            if (correctMoney.length > 1 && correctMoney.floatValue > 0) {
                weakSelf.moneyView.currentMoney = [correctMoney substringToIndex:correctMoney.length-1];
            } else if (correctMoney.length == 1) {
                weakSelf.moneyView.currentMoney = @"0";
            }
        };
    }
    return _keyboardView;
}

- (NSMutableArray<RateModel *> *)rateArray {
    if (!_rateArray) {
        _rateArray = NSMutableArray.array;
    }
    return _rateArray;
}

@end
