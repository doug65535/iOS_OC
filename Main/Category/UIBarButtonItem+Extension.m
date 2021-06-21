//
//  UIBarButtonItem+Extension.m
//  12期微博
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建UIBarButtonItem
 *
 *  @param image    默认状态图片
 *  @param higImage 高亮状态图片
 *
 *  @return item
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higImage:(NSString *)higImage target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    // 设置对应状态图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    // 设置frame
    btn.size = btn.currentImage.size;
    // 添加监听事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
