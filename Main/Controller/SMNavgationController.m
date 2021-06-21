//
//  SMNavgationController.m
    
//
//  Created by lucifer on 15/7/8.
 
//

#import "SMNavgationController.h"
#import "UIBarButtonItem+Extension.h"


@interface SMNavgationController ()

@end

@implementation SMNavgationController
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
// 当类第一次被加载的时调用
+ (void)initialize
{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    UIColor *color1 = [UIColor colorWithRed:255.0 /255.0  green:136.0 /255.0 blue:7.0/255.0 alpha:1];

//    [bar setBackgroundColor:color];
    [bar setBarTintColor:color1];
    
    bar.tintColor = [UIColor whiteColor];

    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    bar.titleTextAttributes = dic;
    
    // 取出导航条item的外观对象(主题对象)
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置默认状态文字的颜色
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:md forState:UIControlStateNormal];
    
    // 设置高亮状态文字的颜色
    NSMutableDictionary *higMd = [NSMutableDictionary dictionary];
    higMd[NSForegroundColorAttributeName] = [UIColor greenColor];
    [item setTitleTextAttributes:higMd forState:UIControlStateHighlighted];
    
    // 设置不可用状态的颜色
    NSMutableDictionary *disMd = [NSMutableDictionary dictionary];
    disMd[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disMd forState:UIControlStateDisabled];
    

    
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    //    DDLogDebug(@"%@", viewController);
//    // 由于每次push到新的界面都会调用pushViewController方法
//    // 而这个方法是属于导航控制器的
//    // 而导航控制器又是我们自定义的
//    // 所以我们只需要重写自定义导航控制器的pushViewController方法, 就可以拿到所有push的控制器统一设置左上角和右上角的按钮
//    
//    // 1.判断导航控制器的栈中是否有控制器, 如果没有代表正在添加是是根控制器
//    // 如果有, 代表是其它子控制器, 只有子控制器才需要设置按钮
//
//    if (self.childViewControllers.count > 0) {
//        
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_unpress" higImage:@"back_press" target:self action:@selector(pop)];
//        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_more" higImage:@"navigationbar_more_highlighted" target:self action:@selector(root)];
//    }
//    
//    [super pushViewController:viewController animated:animated];
//}
//
//- (void)pop
//{
//    // 返回上一个界面
//    [self popViewControllerAnimated:YES];
//}
//
//- (void)root
//{
//    // 返回根界面
//    [self popToRootViewControllerAnimated:YES];
//}


@end
