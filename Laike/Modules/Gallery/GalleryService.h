//
//  GalleryService.h
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"
#import "QHWFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GalleryService : QHWBaseService

@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;

- (void)getGalleryFilterDataWithComplete:(void (^)(void))complete;
- (void)getGalleryListWithType:(NSString *)type Complete:(void (^)(void))complete;

@end

@interface GalleryModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, assign) NSInteger useCount;

@end

NS_ASSUME_NONNULL_END
