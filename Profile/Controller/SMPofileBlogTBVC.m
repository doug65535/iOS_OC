//
//  SMPofileBlogTBVC.m
    
//
//  Created by lucifer on 15/8/20.
  
//

#import "SMPofileBlogTBVC.h"


#import "SMTableViewCell.h"
#import "UMSocial.h"
#import "DockMenuView.h"
#import "SMMapViewController.h"

#import <TencentOpenAPI/QQApiInterface.h>
//#import "HZPhotoBrowser.h"

@interface SMPofileBlogTBVC ()<SMTableViewCellDelegate,UMSocialUIDelegate>
/**
 *  内容数组(里面存储的是所有内容的模型)
 */
@property (nonatomic, strong) NSMutableArray *statuses;


@property (nonatomic,strong) SMTableViewCell *cell;

@property (nonatomic,strong)SMStatus *status;

@property (nonatomic,strong)SMPhotoCollectViewCell *collectCell;


@end

@implementation SMPofileBlogTBVC
- (NSMutableArray *)statuses
{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadBlogStatus];
    }];
    
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreBlogStatus];
        
    }];
    


    [self loadBlogStatus];

   
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource= self;

}


-(void)loadBlogStatus
{
    if (self.userModel) {
        [SVProgressHUD showWithStatus:@"努力加载中..."];
        
      
        // 创建网络管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        // 发送请求
        NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/messages",self.userModel.user_id];
        [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject[@"messages"]];
              [self.statuses removeAllObjects];
            [self.statuses addObjectsFromArray:modle];
            
            //        SMLog(@"%@",responseObject);
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            [self.tableView.header endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
            
        }];
    }

    else{
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    [self.statuses removeAllObjects];
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

    // 发送请求
    NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/messages",account.user_id];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject[@"messages"]];
        [self.statuses addObjectsFromArray:modle];
        
//        SMLog(@"%@",responseObject);
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];
    }
}

-(void)loadMoreBlogStatus
{
    if (self.userModel) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSString *lastStatusIdstr = [[self.statuses lastObject] Lid];
        if (lastStatusIdstr != nil) {
            
            parameters[@"last_id"] = lastStatusIdstr;
        }
        
        
        // 发送请求
        NSString *urlString =[NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/messages",self.userModel.user_id];
        
        [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject[@"messages"]];
            
            [self.statuses addObjectsFromArray:modle];
            
            [self.tableView reloadData];
            
            [self.tableView.footer endRefreshing];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
            
        }];

    }else{
    
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
    NSString *urlString =[NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/messages",account.user_id];
    
    [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject[@"messages"]];
        
        [self.statuses addObjectsFromArray:modle];
        
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];

}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *header = @"customHeader";
    UITableViewHeaderFooterView *vHeader;
    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    if (self.statuses.count == 0) {
        vHeader.textLabel.textColor = [UIColor lightGrayColor];
      
        vHeader.textLabel.text = @"还没有发布过的的帖子";
    }else
    {
        vHeader = nil;
    }
    return vHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.statuses.count ==0) {
        return 30;
    }else
    {
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
    UITableViewHeaderFooterView *vHeader = (UITableViewHeaderFooterView *)view;
    vHeader.textLabel.font = [UIFont systemFontOfSize:12];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    
    SMTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.isFromBlog = YES;
    
    SMStatus *status = self.statuses[indexPath.row];
        // 2.设置数据
    cell.status = status;
    // 3.返回cell
    return cell;
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取 -- > 自定义cell
    // 1.拿到对应行的cell
    SMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cutomCell"];
   
        return [cell cellHeightWithStatus:self.statuses[indexPath.row]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    
    SMDetailViewController *vc = [[SMDetailViewController alloc] init];
    
    vc = [sb instantiateInitialViewController];
    

    vc.modle = self.statuses[indexPath.row];
    
//    
//    SMNavgationController *nav = [[SMNavgationController alloc]initWithRootViewController:vc];

//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -cell的回调方法

-(void)didDelegateBlog:(SMStatus *)status
{
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"是否确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        
        NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@",status.Lid];
        [manager DELETE:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self.statuses removeObject:status];
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@",error);
        }];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
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


-(void)cell:(SMTableViewCell *)cell didClickpinglun:(UIButton *)pinglunBtn status:(SMStatus *)status
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    SMDetailViewController *vc = [[SMDetailViewController alloc] init];
    vc = [sb instantiateInitialViewController];
    
    vc.modle = status;
    
    vc.isneedset = YES;
    
    SMNavgationController *nav = [[SMNavgationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 160 - 44, kWidth, 44)];
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
        
    
        
    }
    
    if ([QQApiInterface isQQInstalled]) {
        UIButton *Btn6 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin, btnWidth,btnHeight)];
        UILabel *Laber6 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin + btnWidth, btnWidth, 20)];
        Laber6.text = @"QQ好友";
        Laber6.textAlignment = NSTextAlignmentCenter;
        Laber6.font = [UIFont systemFontOfSize:14];
        
        [Btn6 setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
        [scr2 addSubview:Btn6];
        [scr2 addSubview:Laber6];
        
        [Btn6 addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
        
       
        
    }
    scr2.userInteractionEnabled = YES;
    scr2.contentSize = CGSizeMake(kWidth +20 +btnWidth, 96);
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

-(NSString *)segmentTitle
{
    return @"帖子";
}


@end
