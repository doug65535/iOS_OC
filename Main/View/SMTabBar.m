//
//  SMTabBar2.m
    
//
//  Created by lucifer on 15/7/7.
 
//

#import "SMTabBar.h"
#import "SMTabBarButton.h"
#import "SMMComposeViewController.h"

@interface SMTabBar()
/**
 *  保存当前选中按钮
 */
@property (nonatomic, weak) SMTabBarButton *currenSelectedBtn;
/**
 *  加号按钮
 */
@property (nonatomic, weak) UIButton *plusBtn;
/**
 *  存储所有的选项卡按钮
 */
@property (nonatomic, strong) NSMutableArray *btns;
@end

@implementation SMTabBar


#pragma mark - 懒加载
- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}



// 通过代码创建控件时会调用
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// 通过xib/Storboard创建时调用
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 1.设置背景颜色
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.75;
//
//    // 2.创建加号按钮
    [self addPlushBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishCompose) name:SMFinishCompose object:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)didFinishCompose
{
    for (SMTabBarButton *btn in self.btns) {
        if (btn.tag == 1) {
            [self btnOnClick:btn];
        }
    }
    
}
/**
 *  创建加号按钮
 */
- (void)addPlushBtn
{
    // 1.创建按钮
    UIButton *plusBtn = [[UIButton alloc] init];
    plusBtn.tag = 111;
    // 2.设置背景图片
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"add_press"]  forState:UIControlStateHighlighted];
//    [plusBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    [plusBtn setImage:[UIImage imageNamed:@"add_press"] forState:UIControlStateHighlighted];
//    [plusBtn setBackgroundImage:[UIImage imageNamed:@"add_press"] forState:UIControlStateHighlighted];

    // 4.添加
    [self addSubview:plusBtn];
    
    [plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.plusBtn = plusBtn;

}

- (void)addItem:(UITabBarItem *)item
{
    
    
    
    // 1.创建选项卡按钮
    SMTabBarButton *btn = [[SMTabBarButton alloc] init];
    
    // 2.设置按钮属性
    btn.item = item;
    
    // 3.添加监听事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 3.添加按钮到当前view
    [self addSubview:btn];
    
    // 4.将按钮添加到数组中
    btn.tag = self.btns.count;//  1 2 3 4
    [self.btns addObject:btn]; // 1
//    
    if (self.btns.count == 1) {
        [self btnOnClick:btn];
    }
    
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置其他选项卡按钮的frame
    NSUInteger index = 0;
    for (UIView *child in self.subviews) {
        
        if (child.tag != 111) {
        
            // 2.计算每个按钮的frame
            CGFloat childW = self.frame.size.width / 5;
            CGFloat childH = self.frame.size.height;
            CGFloat childX = index * childW;
            CGFloat childY = 0;
            
            // 判断是否是中间一个按钮
            if (index == 2) {
                index++;
                childX = index * childW;
            }
            index++;
            child.frame = CGRectMake(childX, childY, childW, childH);
        }
    }

     //设置加号按钮的frame
    self.plusBtn.size = self.plusBtn.currentBackgroundImage.size;
//    self.plusBtn.size = self.plusBtn.currentImage.size;
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
}


- (void)plusBtnClick:(UIButton *)plusBtn
{

    
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedPlusBtn:)]) {
        [self.delegate tabBar:self selectedPlusBtn:plusBtn];
    }
    
}


- (void)btnOnClick:(SMTabBarButton *)btn
{
        [UIView animateWithDuration:0.2 animations:^{
            // 缩小
            // sx / sy 如果是1代表不缩放, 如果大于1代表放大 如果小于1代表缩小
            btn.transform = CGAffineTransformMakeScale(0.9, 0.9);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                // 放大
                btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    // 还原
                    btn.transform = CGAffineTransformIdentity;
                }];
            }];
        }];

        // 1.切换控制器, 通知tabbarcontroller
        if ([self.delegate respondsToSelector:@selector(tabBar:selectedBtnFrom:to:)]) {
            [self.delegate tabBar:self selectedBtnFrom:self.currenSelectedBtn.tag to:btn.tag];
        }
        // 2.切换按钮的状态
        // 取消上一次选中
        self.currenSelectedBtn.selected = NO;
        // 选中当前点击的按钮
        btn.selected = YES;
        // 记录当前选中的按钮
        self.currenSelectedBtn = btn;
    
    }


@end
