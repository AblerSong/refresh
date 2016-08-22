//
//  YYRrefreshControl.m
//  自定义刷新
//
//  Created by song on 16/8/22.
//  Copyright © 2016年 song. All rights reserved.
//

#import "YYRrefreshControl.h"
typedef NS_ENUM(NSInteger,YYRrefreshControlState) {
    Normal = 0,
    Pulling = 1,
    Rrefreshing = 2,
};


@interface YYRrefreshControl()

// 获取全局scrollView进行监听
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  本次demo中以下拉改变label显示文字为例;
 */
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) YYRrefreshControlState refreshState;

@end

@implementation YYRrefreshControl

/**
 *  刷新状态发生改变,进行对应的修改
 *
 *  @param refreshState 刷新状态
 */
-(void)setRefreshState:(YYRrefreshControlState)refreshState{
    // 这句话千万不能少,
    _refreshState = refreshState;
    UIEdgeInsets inset = self.scrollView.contentInset;
    
    switch (refreshState) {
        case Normal:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(inset.top - 64, inset.left, inset.bottom, inset.right);
            } completion:^(BOOL finished) {
                
            }];
        }
            
            break;
        case Pulling:
            
            break;
        case Rrefreshing:

        {
            // 告知外界刷新了,相当于发送通知
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            
            // 动画效果
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(inset.top + 64, inset.left, inset.bottom, inset.right);
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    
}

/**
 *  提供给外界调用的方法,  .h文件里面有这个方法
 */
- (void)endRefreshing{
    // 1.把状态改为正常
    self.refreshState = Normal;
    // 2.恢复contentInset
        // 2.1在set方法里面修改

}


/**
 *  重写initWithFrame,设置下拉刷新尺寸
 *
 *  @param frame 控件大小
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    //设置控件frame
    CGFloat refreshX = 0;
    CGFloat refreshH = 64;
    CGFloat refreshY = -refreshH;
    CGFloat refreshW = [UIScreen mainScreen].bounds.size.width;

    self = [super initWithFrame:CGRectMake(refreshX, refreshY, refreshW, refreshH)];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        //自定义View
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.label.text = @"下拉";
    [self addSubview:self.label];
    
    
}

/**
 *  该控件将要加载到哪个父类视图
 *
 *  @param newSuperview 父View
 */
-(void)willMoveToSuperview:(UIView *)newSuperview{
    //通过kvo,监听滚动
    if (newSuperview) {
        // 获取View进行强转, 通过kvo监听滚动
        self.scrollView = (UIScrollView *)newSuperview;
        // 监听scrollView的contentOffset
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}

/**
 *  监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self refreshChangeState:self.scrollView.contentOffset.y];
}

/**
 *  通过监听当前scrollView的状态,来改变refreshControl控件的状态
 */
- (void)refreshChangeState:(CGFloat)offsetY{

    // 用户是否在拖动
    if (self.scrollView.dragging) {
        if (offsetY > -128 && (self.refreshState == Pulling)) {

            self.label.text = @"正常";
            self.refreshState = Normal;
        }else if(offsetY <= -128 && (self.refreshState == Normal)){
  
            self.label.text = @"下拉中";
            self.refreshState = Pulling;
            
        }
    }else{

        if (self.refreshState == Pulling) {
            self.refreshState = Rrefreshing;
            self.label.text = @"刷新";
        }
    }
}

/**
 *  移除监听方法
 */
- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - 懒加载控件 -
- (UILabel *)label{
    if (_label == nil) {
        // 这里就不做约束了, 直接 用frame代替
        CGFloat labelW = 100;
        CGFloat labelX = ([UIScreen mainScreen].bounds.size.width - labelW) / 2;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 10, labelW, 44)];
        
        // 文字居中
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
