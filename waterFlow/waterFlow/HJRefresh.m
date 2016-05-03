//
//  HJRefresh.m
//  waterFlow
//
//  Created by HJ on 16/5/2.
//  Copyright © 2016年 hujun. All rights reserved.
//

#import "HJRefresh.h"
#import "Masonry.h"

typedef enum{
    Normal,
    Pulling,
    Refreshing
} Status;

@interface HJRefresh()
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIImageView *rotationImg;
@property (nonatomic, strong) UILabel *textLbl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) Status status;
@property (nonatomic, assign) Status lastStatus;
@end


@implementation HJRefresh
- (void)beginRefreshing
{
    self.status = Refreshing;
}
- (void)endRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.status = Normal;

    });
}
- (void)setStatus:(Status)status
{
    _status = status;
    
    if (status == Normal) {
        self.textLbl.text = @"下拉刷新";
        if (self.lastStatus == Refreshing) {
            [UIView animateWithDuration:0.25 animations:^{
                            UIEdgeInsets insets = self.scrollView.contentInset;
                            insets.top -= 60;
                            self.scrollView.contentInset = insets;
                        }];
            self.rotationImg.image = [UIImage imageNamed:@"ratation"];

        }
//


    }else if (status == Pulling)
    {
        self.textLbl.text = @"松手刷新";

    } else if(status == Refreshing)
    {
        self.textLbl.text = @"加载中...";
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.top += 60;
            self.scrollView.contentInset = insets;
        }];
        [UIView animateWithDuration:1 animations:^{
            self.rotationImg.transform = CGAffineTransformRotate(self.rotationImg.transform, M_PI);
             self.rotationImg.transform = CGAffineTransformRotate(self.rotationImg.transform, M_PI);
            
        }completion:^(BOOL finished) {
            self.textLbl.text = @"加载完成";
            self.rotationImg.image = [UIImage imageNamed:@"finish"];
        }];
        
    }
    
    self.lastStatus = status;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
        self.backgroundColor = [UIColor redColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 添加背景图片
    self.backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self addSubview:self.backImg];
    
    // 添加旋转图片
    self.rotationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ratation"]];
    [self.backImg addSubview:self.rotationImg];
    
    // 添加文字标签
    self.textLbl = [[UILabel alloc] init];
    self.textLbl.text = @"下拉刷新";
    self.textLbl.font = [UIFont systemFontOfSize:13];
    self.textLbl.textColor = [UIColor redColor];
    [self.textLbl sizeToFit];
    [self.backImg addSubview:self.textLbl];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)layoutSubviews
{
   [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.mas_equalTo(self.mas_centerX);
       make.centerY.mas_equalTo(self.mas_centerY);
       
   }];
    
    [self.rotationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backImg.mas_centerY);
        make.left.mas_equalTo(8);
    }];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backImg.mas_centerY);
        make.left.mas_equalTo(self.rotationImg.mas_right).offset(5);
    }];
}

// 实现KVO 方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat y = self.scrollView.contentOffset.y;
    if (self.scrollView.dragging) {
        // 正在拖拽
        if (self.status == Pulling && y > -60) {
            NSLog(@"下拉刷新==");
            self.status = Normal;
        }else if(self.status == Normal && y < -60)
        {
            NSLog(@"松手刷新");
            self.status = Pulling;

        }
    } else if(self.status == Pulling)
    {
        // 不在拖拽
        self.status = Refreshing;
        NSLog(@"加载中");
    }
   
}

// 移除观察者
- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
