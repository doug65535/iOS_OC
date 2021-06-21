//
//  UIBarButtonItem+Extension.h
//  12期微博
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  创建UIBarButtonItem
 *
 *  @param image    默认状态图片
 *  @param higImage 高亮状态图片
 *  @param action  监听方法
 *  @param target 监听对象
 *  @return item
 */
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higImage:(NSString *)higImage  target:(id)target action:(SEL)action;
@end
