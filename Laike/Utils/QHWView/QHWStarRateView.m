//
//  QHWStarRateView.m
//  Guider
//
//  Created by manku on 2019/9/3.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWStarRateView.h"

#define ANIMATION_TIME_INTERVAL 0.25

@interface QHWStarRateView ()
@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) CGFloat spaceWidth;
@end
@implementation QHWStarRateView
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars backStarImage:(NSString *)backStarImage foreStarImage:(NSString *)foreStarImage spaceWidth:(CGFloat)spaceWidth{
    if (self = [super initWithFrame:frame]) {
        _scorePercent = numberOfStars;//默认为5
        _hasAnimation = NO;//默认为NO
        _allowIncompleteStar = NO;//默认为NO
        _numberOfStars = numberOfStars;
        _canTap = NO;//默认为NO
        _spaceWidth = spaceWidth;
        self.foregroundStarView = [self createStarViewWithImage:foreStarImage];
        self.backgroundStarView = [self createStarViewWithImage:backStarImage];
        
        [self addSubview:self.backgroundStarView];
        [self addSubview:self.foregroundStarView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setCanTap:(BOOL)canTap{
    _canTap = canTap;
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake((self.spaceWidth + self.height)*i, 0, self.height, self.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imageView];
    }
    return view;
}

- (void)comment:(UITapGestureRecognizer *)gesture {
    if (self.canTap) {
        CGPoint tapPoint = [gesture locationInView:self];
        CGFloat offset = tapPoint.x;
        CGFloat realStarScore = offset / (self.width / self.numberOfStars);
        CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
        self.scorePercent = starScore;
        NSLog(@"scorePercent---%.1f",self.scorePercent);
    }
}

- (void)setScorePercent:(CGFloat)scroePercent {
    if (_scorePercent == scroePercent) {
        return;
    }
    
    if (scroePercent < 0) {
        _scorePercent = 0;
    } else if (scroePercent > self.numberOfStars) {
        _scorePercent = self.numberOfStars;
    } else {
        _scorePercent = scroePercent;
    }
    
    if ([self.delegate respondsToSelector:@selector(scroePercentDidChange:)]) {
        [self.delegate scroePercentDidChange:_scorePercent];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak QHWStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.width = (weakSelf.spaceWidth + weakSelf.height) * floor(weakSelf.scorePercent) + weakSelf.height * (weakSelf.scorePercent - floor(weakSelf.scorePercent));
        NSLog(@"输出=%ld",(long)floor(weakSelf.scorePercent));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
