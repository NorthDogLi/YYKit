//
//  YYScrollBar.m
//  Pods-YYKit_Example
//
//  Created by holla on 2024/1/17.
//

#import "YYScrollBar.h"

@interface YYScrollBar ()

@property (nonatomic, weak) UIView *scrollBar;
@property (nonatomic, weak) UIView *backView;

@end

@implementation YYScrollBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化设置
        [self initInfo];
        // 创建控件
        [self creatControl];
        
        // 添加手势
        [self addSwipeGesture];
    }
    
    return self;
}

- (void)initInfo {
    _minBarHeight = 40.0f;
    _barMoveDuration = 0.25f;
    _foreColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _backColor = UIColor.clearColor;
    
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = _backColor;
}

- (void)creatControl {
    // 背景视图
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:backView];
    _backView = backView;
    
    // 滚动条
    UIView *scrollBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    scrollBar.backgroundColor = _foreColor;
    scrollBar.layer.cornerRadius = self.bounds.size.width * 0.5;
    scrollBar.layer.masksToBounds = YES;
    [self addSubview:scrollBar];
    _scrollBar = scrollBar;
}

- (void)addSwipeGesture {
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_backView addGestureRecognizer:tap];
    
    // 添加滚动条滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_scrollBar addGestureRecognizer:pan];
}

- (void)setForeColor:(UIColor *)foreColor {
    _foreColor = foreColor;
    
    _scrollBar.backgroundColor = _foreColor;
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    
    self.backgroundColor = backColor;
}

- (void)setBarHeight:(CGFloat)barHeight {
    _barHeight = barHeight > _minBarHeight ? barHeight : _minBarHeight;
    
    CGRect temFrame = _scrollBar.frame;
    temFrame.size.height = _barHeight;
    _scrollBar.frame = temFrame;
}

- (void)setYPosition:(CGFloat)yPosition {
    _yPosition = yPosition;
    
    CGRect temFrame = _scrollBar.frame;
    temFrame.origin.y = yPosition;
    _scrollBar.frame = temFrame;
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    // 获取偏移量
    CGFloat moveY = [sender translationInView:self].y;
    
    // 重置偏移量，避免下次获取到的是原基础的增量
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    // 在顶部上滑或底部下滑直接返回
    if ((_yPosition <= 0 && moveY <= 0) || (_yPosition >= self.bounds.size.height - _barHeight && moveY >= 0)) return;
    
    // 赋值
    self.yPosition += moveY;
    
    // 防止瞬间大偏移量滑动影响显示效果
    if (_yPosition < 0) self.yPosition = 0;
    if (_yPosition > self.bounds.size.height - _barHeight && moveY >= 0) self.yPosition = self.bounds.size.height - _barHeight;
    
    // 代理
    if (_delegate && [_delegate respondsToSelector:@selector(yy_scrollBarDidScroll:)]) {
        [_delegate yy_scrollBarDidScroll:self];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    // 点击滚动条返回
    if (sender.view == _scrollBar) return;
    
    // 获取点击的位置
    CGFloat positionY = [sender locationInView:self].y;
    
    // 赋值
    [UIView animateWithDuration:_barMoveDuration animations:^{
        self.yPosition = positionY > self.yPosition ? positionY - self.barHeight : positionY;
    }];
    
    // 代理
    if (_delegate && [_delegate respondsToSelector:@selector(yy_scrollBarTouchAction:)]) {
        [_delegate yy_scrollBarTouchAction:self];
    }
}


@end
