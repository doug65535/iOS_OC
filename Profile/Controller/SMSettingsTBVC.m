//
//  SMSettingsTBVC.m
    
//
//  Created by lucifer on 15/8/11.
  
//

#import "SMSettingsTBVC.h"
#import <MessageUI/MFMailComposeViewController.h>

#import "SMAboutViewController.h"
#import "SMMComposeViewController.h"
#import "SMBindingTableViewController.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import "SMBianJiVCViewController.h"
@interface SMSettingsTBVC ()<MFMailComposeViewControllerDelegate,UMSocialUIDelegate>

{
    NSString *shareTitle;
    UIImage * ShrareImageUrl;
    NSString* ShrareContent;

}
@end

@implementation SMSettingsTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    shareTitle = @"一个有料的APP推荐给你–【地图慧】";
//    ShrareImageUrl = @"http://c.imgs.us/i/cbc530e.png";
    ShrareContent = @"在这里，你可以制作自己的工作/生活地图，结识各路地理豪杰，互动畅聊地图趣事\n(点击直接进入下载页面)";
    ShrareImageUrl = [UIImage imageNamed:@"Icon-60"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0) {
//        检查更新被拒   此处直接省略
        return 1;
    }else if (section == 1){
        return 2;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 2;
    }else
    {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    switch (indexPath.section) {
            
            
            case 0:
            
            cell.textLabel.text = @"编辑个人资料";
            break;
            
            
        case 1:
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"绑定账号";
            }else
            {
                cell.textLabel.text = @"推荐给好友";
            }
            
            
                       break;
        case 2:
            if (indexPath.row == 0 ) {
                cell.textLabel.text = @"清除缓存";
                NSUInteger size = [[SDWebImageManager sharedManager].imageCache getSize];
                double kbSzie = size / 1000.0;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"(%.1fKB)",kbSzie ];
                if (kbSzie > 1000) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%.1fM)",kbSzie / 1000.0];
                }
                
                
            }else{
                cell.textLabel.text = @"检查更新";
            }

        
            break;
            
            case 3:
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"意见反馈";
                
            }else
            {
                cell.textLabel.text = @"关于";
            }
            break;
            
            case 4:
              cell.textLabel.text = @"退出";
            break;
        default:
            break;
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(void)coverClick
{
    _window.hidden  =  YES;
}

static UIWindow *_window;
-(void)sharetofriends
{
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

    [UMSocialData defaultData].extConfig.qqData.url =@"http://c.dituhui.com/client";
    
    _window.hidden  =  YES;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareTitle image:ShrareImageUrl location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
            
        }
    }];
}


// 分享到微信
-(void)shareToWechat
{

        [UMSocialData defaultData].extConfig.wechatSessionData.url =@"http://c.dituhui.com/client";
    
    
    _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareTitle image:ShrareImageUrl location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
        }
    }];
    
}

// 分享到朋友圈
-(void)shareToWechatZone
{
  
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =@"http://c.dituhui.com/client";
    
    
    _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareTitle image:ShrareImageUrl location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
        }
    }];
    
}
//   分享到新浪微博
-(void)shareToSinaBlog
{
    _window.hidden  =  YES;
    [[UMSocialControllerService defaultControllerService] setShareText:shareTitle shareImage:ShrareImageUrl socialUIDelegate:self];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}


// 分享到QQ空间
-(void)shareToQQZone
{
  
        [UMSocialData defaultData].extConfig.qzoneData.url =@"http://c.dituhui.com/client";

    _window.hidden  =  YES;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareTitle image:ShrareImageUrl location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
            
        }
    }];
    
}


#define SMAccountFileName @"account.data"
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    
    switch (indexPath.section) {
            case 0:
        {
            SMBianJiVCViewController *bianjiVc = [[UIStoryboard storyboardWithName:@"SMBianJiVC" bundle:nil]instantiateInitialViewController];
            
            bianjiVc.userModel = self.userModel;

            [self.navigationController pushViewController:bianjiVc animated:YES];
            
        }
            break;
            
            case 1:
            if (indexPath.row == 0) {
                SMAccount *acount =[SMAccount accountFromSandbox];
                if (acount) {
                    SMBindingTableViewController *tb =[[UIStoryboard storyboardWithName:@"SMBingding" bundle:nil]instantiateInitialViewController];
                    [self.navigationController pushViewController:tb animated:YES];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"您还没有登录"];
                }
               
                
            }else
            {
                [self sharetofriends];
            }
            break;
        case 2:
            
            
            if (indexPath.row == 0 ) {
     
                    // 清空缓存
        [[SDWebImageManager sharedManager].imageCache clearDisk];
                cell.detailTextLabel.text = nil;
                    
                [self.tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"缓存已清除"];
                
            }else{
                
//                // 1获取当前软件版本号
//                 NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
//
//                
//                // 2获取沙盒中存储的软件版本号
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSString *sandboxVersion = [defaults objectForKey:@"CFBundleShortVersionString"];
//                SMLog(@"%@",sandboxVersion);
//                 // 3比较两个软件版本号
////                降序为真 表明软件是老的
//                if ([currentVersion compare:sandboxVersion] == NSOrderedDescending) {
//                
//                    
////                    // 存储当前的版本号
//                    [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
//                    [defaults synchronize];
////                    打开外部应用去下载更新
//                
//                }else
//                {
//                    [SVProgressHUD showSuccessWithStatus:@"您已是最新版本"];
//                }
                
            }
                break;
            
            
        case 3:
            
            if (indexPath.row == 0) {

                
                SMMComposeViewController *vc = [[UIStoryboard storyboardWithName:@"SMDongtaiCompose" bundle:nil]instantiateInitialViewController];
                //        vc.delegate = self;
                
                SMNavgationController *nav =[[SMNavgationController alloc]init];
                [nav addChildViewController:vc];
                
                vc.isFromSuggestion = YES;
                [self presentViewController:nav animated:YES completion:nil];
                
                
            }else
            {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAbout" bundle:nil];
                
                SMAboutViewController *aboucVc = [sb instantiateInitialViewController];
                
                [self addChildViewController:aboucVc];
                
                [self.navigationController pushViewController:aboucVc animated:YES];
                
            }
            break;
        
        case 4:
            
           [SVProgressHUD showWithStatus:@"正在退出ing..." ];
            
            NSString *accountPath = [SMAccountFileName appendDocumentDir];
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            
            [fileManager removeItemAtPath:accountPath error:nil];
            
            [SVProgressHUD dismiss];
            
            //重新调用viewwillapper 考虑进去account = nil的情况
            //        [super viewWillAppear:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];

            break;
        
            
//        default:
//            
//            break;
    }
    
    

}

@end
