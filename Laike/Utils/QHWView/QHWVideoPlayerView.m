//
//  QHWVideoPlayerView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWVideoPlayerView.h"

@interface QHWVideoPlayerView ()

@end

@implementation QHWVideoPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setVideoPath:(NSString *)videoPath {
    _videoPath = videoPath;
    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:kFilePath(videoPath)]];
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = player;
    self.playerVC.view.frame = self.bounds;
    self.playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self addSubview:self.playerVC.view];
}

@end
