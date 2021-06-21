
#import "SMInputToolbar.h"


@implementation SMInputToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

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
    // 1.创建2个按钮


    
    
    //添加 表情
    [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted"  actionName:@selector(emotionbutton)];
//
    
    // 添加 @关联
    [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" actionName:@selector(mentionbutton)];
}
/**
 * 创建一个按钮
 */
- (void)setupBtn:(NSString *)image highImage:(NSString *)highImage actionName:(SEL)acname
{
    // 1.创建按钮
    UIButton *btn = [[UIButton alloc] init];
    
    // 2.设置按钮默认状态图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    // 3.设置按钮高亮状态图片
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 4.监听按钮的点击
    [btn addTarget:self action:acname forControlEvents:UIControlEventTouchUpInside];
    // 5.将按钮添加到view中
    [self addSubview:btn];
}
-(void)emotionbutton
{
    if ([self.delegate respondsToSelector:@selector(didClickEmoji)]) {
        [self.delegate didClickEmoji];
    }
}

-(void)mentionbutton
{
    if ([self.delegate respondsToSelector:@selector(didclickmentionbutton)]) {
        [self.delegate didclickmentionbutton];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 2.调整5个按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat width = self.width / count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.height = self.height;
        btn.width = width;
        btn.y = 0;
        btn.x = i * width;
    }
}
@end
