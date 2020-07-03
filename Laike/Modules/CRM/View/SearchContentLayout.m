//
//  SearchContentLayout.m
//  ManKuIPad
//
//  Created by jason on 2018/9/20.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "SearchContentLayout.h"

@interface SearchContentLayout () {
    float h;
    NSInteger section;
}

@end

@implementation SearchContentLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        h = 30;
        section = 0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 15;
        self.minimumInteritemSpacing = 15;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ? nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
            } else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                [layoutAttributesTemp removeAllObjects];
            } else {
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个cell不在本行，则开始调整当前这一行cell的Frame
        else if(currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

//调整属于同一行的cell的位置frame
-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes {
    CGFloat nowWidth = self.sectionInset.left;
    if (self.skuAttrWidth > 0) {
        UICollectionViewLayoutAttributes *layout = layoutAttributes.firstObject;
        if (layout.indexPath.section > section) {
            section = layout.indexPath.section;
            h = layout.frame.origin.y;
        }
//        等于1说明是单独一行的，那肯定要往右移一部分
        if (layoutAttributes.count == 1) {
            h = layout.frame.origin.y;
            nowWidth += self.skuAttrWidth + 15;
        }
//        如果纵坐标大于上一个h，说明是另起一行的，所以要右移一部分
        if (layout.frame.origin.y > h) {
            nowWidth += self.skuAttrWidth + 15;
        }
    }
    for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
        CGRect nowFrame = attributes.frame;
        nowFrame.origin.x = nowWidth;
        attributes.frame = nowFrame;
        nowWidth += nowFrame.size.width + 15;
    }
    [layoutAttributes removeAllObjects];
}

@end
