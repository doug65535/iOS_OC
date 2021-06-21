

#import "SMInputTextView.h"

@interface SMInputTextView()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation SMInputTextView


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 1.创建用于显示提醒文本的Label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        
        
        [placeholderLabel sizeToFit];
        placeholderLabel.x = 5;
        placeholderLabel.y = 7;
        // 设置字体大小
        self.font = [UIFont systemFontOfSize:14];
        placeholderLabel.font = self.font;
        
        placeholderLabel.alpha = 0.5;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        // 2.监听文本框输入事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    //    self.backgroundColor = [UIColor lightGrayColor];
    return self;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.创建用于显示提醒文本的Label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        
        
        [placeholderLabel sizeToFit];
        placeholderLabel.x = 5;
        placeholderLabel.y = 7;
        // 设置字体大小
        self.font = [UIFont systemFontOfSize:14];
        placeholderLabel.font = self.font;
        
        placeholderLabel.alpha = 0.5;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        // 2.监听文本框输入事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
//    self.backgroundColor = [UIColor lightGrayColor];
    return self;
}

- (void)textChange
{
    // 判断是否输入了内容 , 如果有内容就隐藏label, 如果没有内容就显示label
    self.placeholderLabel.hidden = (self.text.length > 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{

    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = _placeholder;
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.placeholderLabel sizeToFit];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
}
@end
