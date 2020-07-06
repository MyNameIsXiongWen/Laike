//
//  PDFDetailViewController.h
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <QuickLook/QuickLook.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFDetailViewController : QLPreviewController

@property (nonatomic, copy) NSString *filePath;

@end

NS_ASSUME_NONNULL_END
