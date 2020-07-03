//
//  CRMAddCustomerViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRMTextFieldView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRMAddCustomerViewController : UIViewController

@property (nonatomic, copy) NSString *customerId;

@end

@interface AddCustomerTFViewCell : UITableViewCell <QHWBaseCellProtocol>

@property (nonatomic, strong) CRMTextFieldView *tfView;

@end

@interface AddCustomerRemarkCell : UITableViewCell <QHWBaseCellProtocol>

@property (nonatomic, strong) UITextView *remarkTextView;

@end

@interface AddCustomerGenderCell : UITableViewCell <QHWBaseCellProtocol>

@end

@interface AddCustomerSelectionCell : UITableViewCell <QHWBaseCellProtocol>

@end

@interface AddCustomerCountryCell : UITableViewCell <QHWBaseCellProtocol>

@end

@interface CountrySubCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void (^ clickDeleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
