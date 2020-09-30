//
//  UICollectionView+HeaderView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/18.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "UICollectionView+HeaderView.h"

static const NSString *kCollectionHeaderViewKey = @"qhw_collectionHeaderView";
static const NSString *kCollectionFooterViewKey = @"qhw_collectionFooterView";
static const NSString *kCollectionHeaderViewOffsetKey = @"qhw_collectionHeaderViewOffset";
static const NSString *kCollectionFooterViewOffsetKey = @"qhw_collectionFooterViewOffset";

@implementation UICollectionView (HeaderView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self method_exchange:@selector(layoutSubviews) with:@selector(qhw_layoutSubviews)];
    });
}

- (void)qhw_layoutSubviews {
    [self qhw_layoutSubviews];
    self.qhw_collectionHeaderView.y = -self.qhw_collectionHeaderView.height - self.qhw_collectionHeaderViewOffset;
    self.qhw_collectionFooterView.y = self.contentSize.height + self.qhw_collectionFooterViewOffset;
}

- (void)setQhw_collectionHeaderView:(UIView *)qhw_collectionHeaderView {
    UIView *headerView = self.qhw_collectionHeaderView;
    if (headerView != qhw_collectionHeaderView) {
        UIEdgeInsets contentInsets = self.contentInset;
        contentInsets.top -=  headerView.height;
        [headerView removeFromSuperview];
        contentInsets.top += qhw_collectionHeaderView.height;
        self.contentInset = contentInsets;
        [self addSubview:qhw_collectionHeaderView];
        objc_setAssociatedObject(self, &(kCollectionHeaderViewKey), qhw_collectionHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setQhw_collectionFooterView:(UIView *)qhw_collectionFooterView {
    UIView *footerView = self.qhw_collectionFooterView;
    if (footerView != qhw_collectionFooterView) {
        UIEdgeInsets contentInsets = self.contentInset;
        contentInsets.bottom -=  footerView.height;
        [footerView removeFromSuperview];
        contentInsets.bottom += qhw_collectionFooterView.height;
        self.contentInset = contentInsets;
        [self addSubview:qhw_collectionFooterView];
        objc_setAssociatedObject(self, &(kCollectionFooterViewKey), qhw_collectionFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setQhw_collectionHeaderViewOffset:(CGFloat)qhw_collectionHeaderViewOffset {
    objc_setAssociatedObject(self, &(kCollectionHeaderViewOffsetKey), @(qhw_collectionHeaderViewOffset), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsLayout];
}

- (void)setQhw_collectionFooterViewOffset:(CGFloat)qhw_collectionFooterViewOffset {
    objc_setAssociatedObject(self, &(kCollectionFooterViewOffsetKey), @(qhw_collectionFooterViewOffset), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsLayout];
}

- (UIView *)qhw_collectionHeaderView {
    return objc_getAssociatedObject(self, &(kCollectionHeaderViewKey));
}

- (UIView *)qhw_collectionFooterView {
    return objc_getAssociatedObject(self, &(kCollectionFooterViewKey));
}

- (CGFloat)qhw_collectionHeaderViewOffset {
    NSNumber *number = objc_getAssociatedObject(self, &(kCollectionHeaderViewOffsetKey));
    return number.floatValue;
}

- (CGFloat)qhw_collectionFooterViewOffset {
    NSNumber *number = objc_getAssociatedObject(self, &(kCollectionFooterViewOffsetKey));
    return number.floatValue;
}

@end
