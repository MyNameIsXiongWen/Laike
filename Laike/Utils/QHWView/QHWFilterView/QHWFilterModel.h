//
//  QHWFilterModel.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/19.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FilterCellModel;
@interface QHWFilterModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSArray <FilterCellModel *>*content;
@property (nonatomic, assign) BOOL mutableSelected;

+ (instancetype)modelWithTitle:(NSString *)title Key:(NSString *)key Content:(NSArray *)content MutableSelected:(BOOL)mutableSelected;

@end

typedef enum : NSUInteger {
    CellTypeLabel = 0,
    CellTypeTextField,
    CellTypeWord,
} CellType;

@interface FilterCellModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) CellType cellType;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSMutableArray <FilterCellModel *>*data;

+ (instancetype)modelWithName:(NSString *)name Code:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
