//
//  QHWVideoPlayerView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWVideoPlayerView : UIView

@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, strong, nullable) AVPlayerViewController *playerVC;

@end

NS_ASSUME_NONNULL_END
