//
//  SMComunityViewController.m
    
//
//  Created by lucifer on 15/7/7.
 
//

#import "SMComunityViewController.h"

#import "SMTableViewCell.h"

#import "UMSocial.h"
#import "DockMenuView.h"
#import "SMDefaultView.h"
#import "SMRegisterView.h"
#import "SMSegmentViewController.h"

#import "SMMComposeViewController.h"

#import "SMTabBarController.h"
#import "SMMapViewController.h"
#import "CZSqliteTools.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface SMComunityViewController ()<SMTableViewCellDelegate,SMSegmentViewControllerDelegate,SMDefaultViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>


/**
 *  内容数组(里面存储的是所有内容的模型)
 */
@property (nonatomic, strong) NSMutableArray *statuses;


@property (nonatomic, strong) NSMutableArray *followStatuses;


@property (nonatomic,strong) SMTableViewCell *cell;
/**
 *  是否切换为关注列表
 */
//@property(nonatomic,setter=isChangeView:) BOOL isChangeView;


@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@property (nonatomic,strong)SMDefaultView *defalutView;


@property (nonatomic,strong)SMSegmentViewController *segementVC;

@property(nonatomic,getter=isZan)BOOL isZan;
@property(nonatomic,getter=isFover)BOOL isFover;


@property(nonatomic,strong)SMStatus *status;

@property (nonatomic,strong)SMPhotoCollectViewCell *collectCell;
@end

@implementation SMComunityViewController



#pragma mark -懒加载


- (NSMutableArray *)statuses
{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (NSMutableArray *)followStatuses
{
    if (!_followStatuses) {
        _followStatuses = [NSMutableArray array];
    }
    return _followStatuses;
}

-(SMDefaultView *)defalutView
{
    if (!_defalutView) {
        _defalutView = [SMDefaultView defaultView];
    }
    return _defalutView;
}

-(void)didClickUnLoginZan
{
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
}

-(void)didclickunloginShoucang
{
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
}


-(void)getfromDB
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00000000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *models = [[CZSqliteTools shareSqliteTools] statusesFromComu];
        if (models.count > 0 ) {
            // 加载本地缓存数据
            [self.statuses addObjectsFromArray:models];
            [self.tableView reloadData];
            
        }

    });
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
// 解决状态栏不能回到顶部问题 --- collectionview禁用scoll属性
    
    self.title = @"社区";
    [SVProgressHUD showWithStatus:@"正在加载中……"];
    
       [self getfromDB];
    [self loadStatuses];

    self.tableView.hidden = NO;
    
    self.tableView2.hidden = YES;

    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadStatuses];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    
    self.tableView2.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFollowStatuses];
    }];
    
    self.tableView2.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreFollowStauts];
    } ];
    
    
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishCOmpose) name:SMFinishCompose object:nil];
    
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSroll) name:SMComuReloadNotification object:nil];
    
}


- (void)loadStatuses
{
    
    //    [SVProgressHUD showWithStatus:@"努力加载中..."];
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    // 发送请求
    NSString *urlString = @"http://club.dituhui.com/api/v2/messages";
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject];
//        存入数据库
        [[CZSqliteTools shareSqliteTools] deleteComuDict];
        for (NSDictionary *dict in responseObject) {
            // 存储帖子数据
            BOOL success = [[CZSqliteTools shareSqliteTools] insertComuDict:dict];
            if (success) {
//                SMLog(@"插入成功");
            }else
            {
                SMLog(@"插入失败");
            }
        }
        
 
        
        [self.statuses removeAllObjects];
        [self.statuses addObjectsFromArray:modle];
        
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        [self.tableView.header endRefreshing];
        
    }];
}


- (void)loadFollowStatuses
{
    
    // 创建网络管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    // 发送请求
    NSString *urlString =[NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followed_messages",account.user_id];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modelArr = responseObject[@"messages"];
        
        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:modelArr];
        
        
        [self.followStatuses addObjectsFromArray:modle];
        
        
        [self.tableView2 reloadData];
        
        [SVProgressHUD dismiss];
        [self.tableView2.header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];
}





-(void)reloadSroll
{
    if (self.tableView2.hidden) {
        [self.tableView setContentOffset:CGPointMake(0, self.view.y)];

    }else
    {
        [self.tableView2 setContentOffset:CGPointMake(0, self.view.y)]
        ;
    }
 }

-(void)didFinishCOmpose
{
     [self loadStatuses];
     [self didChangeViewAtIndex:0 sender:self.segementVC.segement];
    
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    SMAccount *account = [SMAccount accountFromSandbox];
    
    //判断是否已经授权
    if (account.token != nil) {
        //         已经授权
        
        [self.defalutView removeFromSuperview];
//           [self loadFollowStatuses];
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SMSegmentViewController *segementVC = segue.destinationViewController;
    
    segementVC.delegate = self;
}



-(void)didChangeViewAtIndex:(NSInteger)index sender:(UISegmentedControl *)sender
{
    if (index ==0) {
      
        self.tableView.hidden = NO;
        self.tableView2.hidden = YES;
 
        [self.defalutView removeFromSuperview];
        
    }else{
        
 
        SMAccount *account = [SMAccount accountFromSandbox];
      
        //判断是否已经授权
        if (account.token != nil) {
            //         已经授权
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
            [SVProgressHUD showWithStatus:@"正在努力加载中……"];
                [self loadFollowStatuses];
                
            });
        }else
        {
            self.defalutView.frame = CGRectMake(0, 104, kWidth, kHeight-104 -49);

            [self.view addSubview:self.defalutView];

            self.defalutView.delegate = self;
        }
        self.tableView.hidden = YES;
        self.tableView2.hidden = NO;
    }
    
}



-(void)defaultViewDidCLickWeiboLogin:(UIView *)View
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            SMLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"nickname"] = snsAccount.userName;
            dic[@"avatar"] = snsAccount.iconURL;
            //            dic[@"provider"] = @"weibo";
            dic[@"uid"] = snsAccount.usid;
            dic[@"access_token"] = snsAccount.accessToken;
            
            
            [manager POST:@"http://club.dituhui.com/api/v2/auth/weibo/login" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                
                SMAccount *account = [SMAccount objectWithKeyValues:responseObject];
                
                NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/info",account.user_id];
                [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    //            SMLog(@"%@",responseObject);
                    // 1.将服务器返回的字典转换为模型
                    NSArray *groupModel = responseObject[@"groups"];
                    
                    account.groups = groupModel;
                    
                    
                    // 2.将模型保存到沙河中
                    [account save];
                    [self viewWillAppear:YES];

                } failure:^(NSURLSessionDataTask *task, NSError *error){
                    SMLog(@"%@",error);
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
            
        }});
}


-(void)defaultViewDidCLickQQLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //            /////////////////
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"nickname"] = snsAccount.userName;
            dic[@"avatar"] = snsAccount.iconURL;
            //            dic[@"provider"] = @"weibo";
            dic[@"uid"] = snsAccount.usid;
            dic[@"access_token"] = snsAccount.accessToken;
            
            
            [manager POST:@"http://club.dituhui.com/api/v2/auth/qzone/login" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                
                
                SMAccount *account = [SMAccount objectWithKeyValues:responseObject];
                
                NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/info",account.user_id];
                [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    //            SMLog(@"%@",responseObject);
                    // 1.将服务器返回的字典转换为模型
                    NSArray *groupModel = responseObject[@"groups"];
                    
                    account.groups = groupModel;
                    
                    
                    // 2.将模型保存到沙河中
                    [account save];
                    [self viewWillAppear:YES];
                    [SVProgressHUD dismiss];
                    

                } failure:^(NSURLSessionDataTask *task, NSError *error){
                    SMLog(@"%@",error);
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
            
        }});
}

-(void)defaultViewDidCLickweiXinLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];

            
            SMLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"nickname"] = snsAccount.userName;
            dic[@"avatar"] = snsAccount.iconURL;
            //            dic[@"provider"] = @"weibo";
            dic[@"uid"] = snsAccount.unionId;
            dic[@"access_token"] = snsAccount.accessToken;

			dic[@"unionid"] = snsAccount.unionId;
			dic[@"openid"] = snsAccount.openId;
			dic[@"refresh_token"] = snsAccount.refreshToken;


            [manager POST:@"http://club.dituhui.com/api/v2/auth/weixin/login" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                
                SMAccount *account = [SMAccount objectWithKeyValues:responseObject];
                
                NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/info",account.user_id];
                [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    //            SMLog(@"%@",responseObject);
                    // 1.将服务器返回的字典转换为模型
                    NSArray *groupModel = responseObject[@"groups"];
                    
                    account.groups = groupModel;
                    
                    
                    // 2.将模型保存到沙河中
                    [account save];
                    
                    [self viewWillAppear:YES];
                } failure:^(NSURLSessionDataTask *task, NSError *error){
                    SMLog(@"%@",error);
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
            
        }
        
    });
}

-(void)didClickMapPicture:(SMStatus *)status shareImage:(UIImage *)img
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil];
    SMMapViewController *mapVC = [sb instantiateInitialViewController];
    mapVC.modle = status;
    
//    mapVC.mapImage = img;
    
    
    SMNavgationController *nav = [[SMNavgationController alloc] init];
    
    [nav addChildViewController:mapVC];

    // 3.弹出授权控制器
    [self presentViewController:nav animated:YES completion:nil];
}


-(void)defaultViewDidCLickLogin
{
//    [self.tableView reloadData];
//       [self loadStatuses];
      [self loadFollowStatuses];
}

-(void)defaultViewDidClickRegister
{
    SMRegisterView *vc = [[UIStoryboard storyboardWithName:@"SMRegister" bundle:nil]instantiateInitialViewController];
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    
//    SMAccount *account = [SMAccount accountFromSandbox];
//
//    if (account.token != nil) {
//        //         已经授权
//        
//        [self.tableView reloadData];
//        
//    }else
//    {
//        
//        [SVProgressHUD showErrorWithStatus:@"请先登陆"];
//        
//        SMDefaultView *defaultView = [SMDefaultView defaultView];
//        [self.view addSubview:defaultView];
//        
//    }
//    
//
//}

//
-(void)loadMoreFollowStauts
{
    
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.followStatuses lastObject] Lid];
  
      if (lastStatusIdstr != nil) {
    parameters[@"last_id"] = lastStatusIdstr;
    
      }
    
    // 发送请求
    NSString *urlString =[NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followed_messages",account.user_id];
    [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modeleArr = responseObject[@"messages"];
        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:modeleArr];
        [self.followStatuses addObjectsFromArray:modle];
        
        [self.tableView2 reloadData];
        
        [self.tableView2.footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];
    
}




-(void)loadMore
{
    
    // 创建网络管理者
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    
 NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.statuses lastObject] Lid];
    if (lastStatusIdstr != nil) {
        
        parameters[@"last_id"] = lastStatusIdstr;
    }
    
    
    // 发送请求
    NSString *urlString = @"http://club.dituhui.com/api/v2/messages";
    [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        for (NSDictionary *dict in responseObject) {
           
            // 存储微博数据
            BOOL success =  [[CZSqliteTools shareSqliteTools] insertComuDict:dict];
            if (success) {
//                SMLog(@"插入成功");
            }else
            {
                SMLog(@"插入失败");
            }
        }

        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject];
        [self.statuses addObjectsFromArray:modle];
        
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];

}




#pragma mark - 数据源方法



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tableView2) {
        return self.followStatuses.count;
    }else{
    return self.statuses.count;
}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    
    if (tableView == self.tableView2) {
        
         SMTableViewCell *cell = [self.tableView2  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        cell.delegate = self;
        SMStatus *stauts = self.followStatuses[indexPath.row];
        cell.status = stauts;
        return cell;
        
    }else{
        
        SMTableViewCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:@"cutomCell" forIndexPath:indexPath];
        cell.delegate = self;
    SMStatus *status = self.statuses[indexPath.row];
    // 2.设置数据
    cell.status = status;
          return cell;
    }
   
    // 3.返回cell
  
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取 -- > 自定义cell
    // 1.拿到对应行的cell
    
    if (tableView ==self.tableView2) {
        SMTableViewCell *cell = [self.tableView2  dequeueReusableCellWithIdentifier:@"cell"];
        
        return [cell cellHeightWithStatus:self.followStatuses[indexPath.row]];
    }else{
        
        SMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cutomCell"];
        if (self.statuses.count) {
              return [cell cellHeightWithStatus:self.statuses[indexPath.row]];
        }else{
            return 0;
        }
  
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    
    SMDetailViewController *vc = [sb instantiateInitialViewController];
    
    
    if (tableView == self.tableView2) {
        vc.modle = self.followStatuses[indexPath.row];
    }else{
    vc.modle = self.statuses[indexPath.row];
    }
    
//    SMNavgationController *nav = [[SMNavgationController alloc]initWithRootViewController:vc];
    
    vc.hidesBottomBarWhenPushed = YES;
    
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];

}



-(void)cell:(SMTableViewCell *)cell didClickpinglun:(UIButton *)pinglunBtn status:(SMStatus *)status
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    SMDetailViewController *vc = [sb instantiateInitialViewController];

    vc.modle = status;
   
    vc.isneedset = YES;
    
     vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



static UIWindow *_window;

-(void)cell:(SMTableViewCell *)cell didClickfenxaing:(UIButton *)fenxiangBtn status:(SMStatus *)status icon:(SMPhotoCollectViewCell *)collectCell
{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                appKey:@"55af5f7ae0f55a1ddf003d57"
//                                      shareText:status.body
//                                     shareImage:icon.image
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToWechatFavorite,nil]
//                                       delegate:nil];
    self.status = status;
    self.collectCell = collectCell;
    
    
    // 1.创建window
    _window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.hidden = NO;
    _window.windowLevel = UIWindowLevelAlert;
    
    // 2.创建蒙版
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //将蒙版添加到window上
    [_window addSubview:cover];
    
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 160, kWidth, 160)];
    coverView.backgroundColor = [UIColor clearColor];
    //    [cover addSubview:coverView];
    [_window addSubview:coverView];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 160 - 44 -8, kWidth, 44 +8)];
    cancel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    //    cancel.titleLabel.textColor = [UIColor redColor];
    
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    [cancel addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:cancel];
    
    /* ************************************** */
    
    
    //  ////////////////////////////////////////////////
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 60;
    CGFloat btnMagin = 20;
    CGFloat btnYMagin = 8;
    

    
    UIScrollView *scr2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 160 - 64- 96, kWidth,96)];
    
    scr2.backgroundColor = [UIColor groupTableViewBackgroundColor];

    

    [coverView addSubview:scr2];
    
    //    [_window addSubview:scr2];
    //    [self.mapView addSubview:scr2];
    
    ////////////////////////////////////////
    
    
    
    //////////分享到微信
    UIButton *Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin , btnYMagin , btnWidth, btnHeight)];
    UILabel *Laber2 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin, btnYMagin + btnWidth, btnWidth, 20)];
    Laber2.text = @"微信";
    Laber2.textAlignment = NSTextAlignmentCenter;
    Laber2.font = [UIFont systemFontOfSize:14];
    
    [Btn2 setImage:[UIImage imageNamed:@"share_weichat"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn2];
    [scr2 addSubview:Laber2];
    
    [Btn2 addTarget:self action:@selector(shareToWechat) forControlEvents:UIControlEventTouchUpInside];
    
    //////////分享到朋友圈
    
    UIButton *Btn3 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin*2 +btnWidth , btnYMagin ,btnWidth, btnHeight)];
    
    UILabel *Laber3 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin*2 +btnWidth , btnYMagin + btnWidth, btnWidth, 20)];
    
    Laber3.text = @"朋友圈";
    Laber3.textAlignment = NSTextAlignmentCenter;
    Laber3.font = [UIFont systemFontOfSize:14];
    
    
    [Btn3 setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn3];
    [scr2 addSubview:Laber3];
    
    
    
    [Btn3 addTarget:self action:@selector(shareToWechatZone) forControlEvents:UIControlEventTouchUpInside];
    //////////////////分享到微博
    UIButton *Btn4 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *3 +btnWidth *2, btnYMagin, btnWidth,btnHeight)];
    
    UILabel *Laber4 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *3 +btnWidth *2, btnYMagin + btnWidth, btnWidth, 20)];
    Laber4.text = @"微博";
    Laber4.textAlignment = NSTextAlignmentCenter;
    Laber4.font = [UIFont systemFontOfSize:14];
    
    [Btn4 setImage:[UIImage imageNamed:@"share_weibo"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn4];
    [scr2 addSubview:Laber4];
    
    [Btn4 addTarget:self action:@selector(shareToSinaBlog) forControlEvents:UIControlEventTouchUpInside];
    ///////////////分享到qq空间
    if ([QQApiInterface isQQInstalled]) {
        UIButton *Btn5 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *4+ btnWidth *3, btnYMagin, btnWidth,btnHeight)];
        UILabel *Laber5 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *4+ btnWidth *3, btnYMagin + btnWidth, btnWidth, 20)];
        Laber5.text = @"QQ空间";
        Laber5.textAlignment = NSTextAlignmentCenter;
        Laber5.font = [UIFont systemFontOfSize:14];
        
        [Btn5 setImage:[UIImage imageNamed:@"share_qqzone"] forState:UIControlStateNormal];
        [scr2 addSubview:Btn5];
        [scr2 addSubview:Laber5];
        
        [Btn5 addTarget:self action:@selector(shareToQQZone) forControlEvents:UIControlEventTouchUpInside];
        
        scr2.userInteractionEnabled = YES;
        scr2.contentSize = CGSizeMake(kWidth +20, 96);
    }
    
//    分享到QQ
    if ([QQApiInterface isQQInstalled]) {
        UIButton *Btn6 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin, btnWidth,btnHeight)];
        UILabel *Laber6 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin + btnWidth, btnWidth, 20)];
        Laber6.text = @"QQ";
        Laber6.textAlignment = NSTextAlignmentCenter;
        Laber6.font = [UIFont systemFontOfSize:14];
        
        [Btn6 setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
        [scr2 addSubview:Btn6];
        [scr2 addSubview:Laber6];
        
        [Btn6 addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
        
        scr2.userInteractionEnabled = YES;
        scr2.contentSize = CGSizeMake(kWidth +20 + btnWidth, 96);
    }

   
    
    /* ************************************** */
    // 6.显示菜单
    _window.hidden = NO;
    


}
-(void)shareToQQ
{
    if (self.status.map.map_id) {
        [UMSocialData defaultData].extConfig.qqData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.status.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.qqData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.status.Lid];
    }
    _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.status.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
            
        }
    }];
}

-(void)coverClick
{
    _window.hidden  =  YES;
}

// 分享到微信
-(void)shareToWechat
{
    if (self.status.map.map_id) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.status.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.status.Lid];
    }

    
        _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.status.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
        }
    }];

}

// 分享到朋友圈
-(void)shareToWechatZone
{
    if (self.status.map.map_id) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.status.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.status.Lid];
    }

       _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.status.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
        }
    }];
 
}
//   分享到新浪微博
-(void)shareToSinaBlog
{
      _window.hidden  =  YES;
    [[UMSocialControllerService defaultControllerService] setShareText:self.status.body shareImage:self.collectCell.photoView.image socialUIDelegate:self];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}


// 分享到QQ空间
-(void)shareToQQZone
{
    if (self.status.map.map_id) {
        [UMSocialData defaultData].extConfig.qzoneData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.status.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.qzoneData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.status.Lid];
    }
    _window.hidden  =  YES;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.status.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
            
        }
    }];

}


@end
