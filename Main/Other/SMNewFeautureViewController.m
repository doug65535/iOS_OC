//
//  SMNewFeautureViewController.m
    
//
//  Created by lucifer on 15/9/25.
 
//

#import "SMNewFeautureViewController.h"
#import "SMTabBarController.h"
@interface SMNewFeautureViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;

@end

@implementation SMNewFeautureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //    图片的宽
        CGFloat imageW = self.mScrollView.frame.size.width;

   //    图片高
        CGFloat imageH = self.mScrollView.frame.size.height;
    //    图片的Y
     CGFloat imageY = 0;
//    图片中数
         NSInteger totalCount = 3;
    //   1.添加3张图片
        for (int i = 0; i < totalCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
            CGFloat imageX = i * imageW;
        //        设置frame
             imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
     //        设置图片
                NSString *name = [NSString stringWithFormat:@"img_%d", i + 1];
                 imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
              self.mScrollView.showsHorizontalScrollIndicator = NO;
        
                 [self.mScrollView addSubview:imageView];
            
         
            }
  
    //    2.设置scrollview的滚动范围
        CGFloat contentW = totalCount *imageW;
        //不允许在垂直方向上进行滚动
        self.mScrollView.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
       self.mScrollView.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
         self.mScrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        CGFloat page = (x + scrollviewW / 2.0) /  scrollviewW ;
    
    if (page >2.0) {
        UIButton *btn = [[UIButton alloc]init];
        
        btn.frame = CGRectMake(kWidth/2 -114.5/2+2*kWidth,kHeight - 40 -37, 114.5, 37);
        
        [btn setImage:[UIImage imageNamed:@"enter_normal"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickEnter) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollView addSubview:btn];
        
    }
    if (page > 2.6) {
        // 1.创建Tabbarcontroller
        SMTabBarController *tabbarVc = [[SMTabBarController alloc] init];
        // 2.切换根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController =  tabbarVc;
    }
    
}

-(void)didClickEnter

{
    // 1.创建Tabbarcontroller
    SMTabBarController *tabbarVc = [[SMTabBarController alloc] init];
    // 2.切换根控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController =  tabbarVc;
}

@end
