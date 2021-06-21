//
//  SMTabBarButton.m
    
//
//  Created by lucifer on 15/7/7.
 
//

#import "SMTabBarButton.h"



@implementation SMTabBarButton

-(void)setHighlighted:(BOOL)highlighted
{
    
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
    // 设置图片居中
    self.imageView.contentMode = UIViewContentModeCenter;
    // 设置标题居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置文字字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    
    // 设置按钮标题颜色
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height *0.8;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{

    CGFloat titleY = contentRect.size.height* 0.7;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - contentRect.size.height * 0.7;
    CGFloat titleX = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
}




@end
