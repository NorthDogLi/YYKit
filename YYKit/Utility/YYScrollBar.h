//
//  YYScrollBar.h
//  Pods-YYKit_Example
//
//  Created by holla on 2024/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YYScrollBar;
 
@protocol YYScrollBarDelegate <NSObject>
 
/// 滚动条滑动代理事件
- (void)yy_scrollBarDidScroll:(YYScrollBar *)scrollBar;
 
/// 滚动条点击代理事件
- (void)yy_scrollBarTouchAction:(YYScrollBar *)scrollBar;
 
@end

@interface YYScrollBar : UIView

/// 背景色
@property (nonatomic, strong) UIColor *backColor;
 
/// 前景色
@property (nonatomic, strong) UIColor *foreColor;
 
/// 滚动动画时长
@property (nonatomic, assign) CGFloat barMoveDuration;
 
/// 限制滚动条最小高度
@property (nonatomic, assign) CGFloat minBarHeight;
 
/// 滚动条实际高度
@property (nonatomic, assign) CGFloat barHeight;
 
/// 滚动条Y向位置
@property (nonatomic, assign) CGFloat yPosition;
 
/// 代理
@property (nonatomic, weak) id <YYScrollBarDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
