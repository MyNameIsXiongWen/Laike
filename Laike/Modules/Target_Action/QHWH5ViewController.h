//
//  QHWH5ViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/10/9.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWH5ViewController : UIViewController

@property (nonatomic, copy) NSString *h5Url;
@property (nonatomic, copy) NSString *titleName;

@end

@interface QHWWeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate;

@end

NS_ASSUME_NONNULL_END
