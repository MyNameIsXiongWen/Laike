//
//  GalleryShareView.h
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "QHWShareBottomViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GalleryShareView : QHWPopView

@property (nonatomic, weak) id<QHWShareBottomViewProtocol>delegate;

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) id galleryImg;

@end

NS_ASSUME_NONNULL_END
