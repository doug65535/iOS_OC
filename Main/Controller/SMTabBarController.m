//
//  SMTabBarController.m
    
//
//  Created by lucifer on 15/7/7.
 
//

#import "SMTabBarController.h"
#import "SMTabBar.h"
#import "SMDiscoverViewController.h"


#import "SMMapCommposeVC.h"
#import "SMNavgationController.h"

#import "CHTumblrMenuView.h"

#import "SMMComposeViewController.h"
#import "SMComunityViewController.h"

@interface SMTabBarController ()<SMTabBarDelegate>
/**
 *  自定义TabBar
 */
@property (nonatomic, weak) SMTabBar *customTabBar;

@end

@implementation SMTabBarController



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 4.创建子控制器


[self addControllerWithVcName:@"SMDiscover" title:@"发现" image:@"tab_faxian" selectedImage:@"tab_faxian_press"];

[self addControllerWithVcName:@"SMComunityViewController" title:@"社区" image:@"tab_shequ" selectedImage:@"tab_faxian_press@2x-7"];
        

        
[self addControllerWithVcName:@"SMMessage" title:@"消息" image:@"tab_xiaoxi" selectedImage:@"tab_xiaoxi_press"];

        
[self addControllerWithVcName:@"SMProfileViewController" title:@"我" image:@"tab_me" selectedImage:@"tab_me_press"];
       

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//     1.创建自定义SMTabBar
    SMTabBar *tabBar = [[SMTabBar alloc] init];
    tabBar.delegate = self;
    
//     2.设置SMTabBar的frame
    tabBar.frame = self.tabBar.bounds;
    
//     3.添加SMTabBar到父控件
    [self.tabBar addSubview:tabBar];
     self.customTabBar = tabBar;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 1.删除系统自带tabbar中不需要的其它控件
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [child removeFromSuperview];
        }
    }
////    [self.tabBar addSubview:self.customTabBar];
//    
//
}
//

- (UIViewController *)addControllerWithVcName:(NSString *)vcName title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:vcName bundle:nil];
    
    UIViewController *vc = [sb instantiateInitialViewController];
    
    return [self addControllerWithVc:vc title:title image:image selectedImage:selectedImage];
}

/**
 *  根据一个类创建一个控制器
 *
 *  @param class         控制器对应的类
 *  @param title         标题
 *  @param image         默认状态的图片
 *  @param selectedImage 选择状态图片
 *
 *  @return 创建好的控制器
 */
- (UIViewController *)addControllerWithClass:(Class)class title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIViewController *vc = [[class alloc] init];
    return [self addControllerWithVc:vc title:title image:image selectedImage:selectedImage];
}

/**
 *  根据一个创建好的控制器初始化控制器
 *
 *  @param vc            控制器
 *  @param title         标题
 *  @param image         默认图片
 *  @param selectedImage 选中图片
 *
 *  @return 初始化之后的控制器
 */
- (UIViewController *)addControllerWithVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    /*
     iOS7需要通过代码告诉系统不要用tabBar.tintColor来渲染选中图片
     */
    // 1.创建图片
    UIImage *newImage =  [UIImage imageNamed:selectedImage];
    // 2.告诉系统原样显示
    newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 3.设置图片
    vc.tabBarItem.selectedImage = newImage;
    
    // 设置tabBarButton的标题颜色
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    
    // 包装一个导航控制器
    SMNavgationController *nav = [[SMNavgationController alloc] initWithRootViewController:vc];
    
    // 添加控制器到tabbarcontroller
    [self addChildViewController:nav];
   
    // 每添加一个子控制器就要创建一个对应的按钮
    [self.customTabBar addItem: vc.tabBarItem];
    
    return vc;
}
#pragma mark - SMTabBarDelegate
- (void)tabBar:(SMTabBar *)tabBar selectedBtnFrom:(NSInteger)from to:(NSInteger)to
{
    
    
    if (from == to && from == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SMDisReloadNotification object:nil userInfo:nil];
    }
    
    
    if (from == to && from == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SMComuReloadNotification object:nil userInfo:nil];
    }
    
//    SMLog(@"from = %tu  to = %tu", from, to);
    // 切换控制器
    // 1.取出当前选中按钮对应的控制器
//        UIViewController *vc = self.childViewControllers[to];
//    self.selectedViewController = vc;
      self.selectedIndex = to;
//
   
}


- (void)tabBar:(SMTabBar *)tabBar selectedPlusBtn:(UIButton *)plusBtn
{
    
//    SMAccount *acc = [SMAccount accountFromSandbox];
//    
//    if (!acc.token) {
////        [SVProgressHUD showErrorWithStatus:@"您尚未登陆"];
////        return;
//        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [alertVC dismissViewControllerAnimated:YES completion:nil];
//        }]];
//        
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
//            SMNavgationController *nav = [[SMNavgationController alloc]init];
//            [nav addChildViewController:logVc];
//            [self presentViewController:nav animated:YES completion:nil];
//        }]];
//
//        
//        [self presentViewController:alertVC animated:YES completion:nil];
//    }else{
//
    
    // 1.创建发送界面
  
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMCompose" bundle:nil];
//    SMComposeViewController *composeVc = [sb instantiateInitialViewController];
////    
//    SMNavgationController *nav = [[SMNavgationController alloc] initWithRootViewController:composeVc];
//    
//    // 2.弹出发送界面
//    [self presentViewController:nav animated:YES completion:nil];
    
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    
    //    self.view = menuView;
    
    [menuView addMenuItemWithTitle:@"发布动态" andIcon:[UIImage imageNamed:@"article"] andSelectedBlock:^{
            SMAccount *acc = [SMAccount accountFromSandbox];
        
            if (!acc.token) {
        //        [SVProgressHUD showErrorWithStatus:@"您尚未登陆"];
        //        return;
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }]];
        
                [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:logVc];
                    [self presentViewController:nav animated:YES completion:nil];
                }]];
        
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
        SMMComposeViewController *vc = [[UIStoryboard storyboardWithName:@"SMDongtaiCompose" bundle:nil]instantiateInitialViewController];
//        vc.delegate = self;
        
        SMNavgationController *nav =[[SMNavgationController alloc]init];
        [nav addChildViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
            }
    }];
    
    [menuView addMenuItemWithTitle:@"创建地图" andIcon:[UIImage imageNamed:@"map"] andSelectedBlock:^{
            SMAccount *acc = [SMAccount accountFromSandbox];
        
            if (!acc.token) {
        //        [SVProgressHUD showErrorWithStatus:@"您尚未登陆"];
        //        return;
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }]];
        
                [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:logVc];
                    [self presentViewController:nav animated:YES completion:nil];
                }]];
        
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapPush" bundle:nil];
        SMMapCommposeVC *mapVc = [sb instantiateInitialViewController];
        
        SMNavgationController *nav = [[SMNavgationController alloc]init];
        
        [nav addChildViewController:mapVc];
        
        [self presentViewController:nav animated:YES completion:nil];
//        [self  pushViewController:mapVc animated:YES];
        }
    }];
    
    
    [menuView.backgroundImgView setImage:[UIImage imageNamed:@"bg"]];
    [menuView show];
//    }
}




@end
