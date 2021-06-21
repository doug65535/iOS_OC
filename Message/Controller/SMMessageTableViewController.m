//
//  SMMessageTableViewController.m
    
//
//  Created by lucifer on 15/7/8.
 
//

#import "SMMessageTableViewController.h"

#import "SMDongtaiViewController.h"

#import "SMFollowersTbVc.h"
#import "SMDefaultView.h"
#import "SMRegisterView.h"
#import "UMSocial.h"

@interface SMMessageTableViewController ()<SMDefaultViewDelegate>
@property(nonatomic,strong)SMDefaultView *defatutView;
@end

@implementation SMMessageTableViewController

-(SMDefaultView *)defatutView
{
    if (!_defatutView) {
        _defatutView = [SMDefaultView defaultView];
    }
    return _defatutView;
}

-(void)viewWillAppear:(BOOL)animated
{
    //     取出存储的模型对象
    SMAccount *account = [SMAccount accountFromSandbox];
    
    //判断是否已经授权
    if (account.token != nil) {
        //         已经授权
        [self.defatutView removeFromSuperview];
//        self.defatutView = nil;
        [super viewDidLoad];

    }else
    {
//        if (self.defatutView == nil) {
            _defatutView.delegate = self;
            self.defatutView.frame = CGRectMake(0, 0, kWidth, kHeight - 49 -64);
            [self.view addSubview:self.defatutView];
            
            self.defatutView = _defatutView;
//        }
    }
}
-(void)defaultViewDidClickRegister
{
    SMRegisterView *registVc = [[UIStoryboard storyboardWithName:@"SMRegister" bundle:nil]instantiateInitialViewController];
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:registVc];
    [self presentViewController:nav animated:YES completion:nil];
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
                    [SVProgressHUD dismiss];
                    
                    
                    
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
//    去除多余横线。
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }else
    {
        return 1;
    }
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"与您相关的动态";
//    }else
//    {
//        return @"关注了您的";
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    if (indexPath.section == 0) {
//        cell.textLabel.text = @"动态";
//        [cell.imageView setImage:[UIImage imageNamed:@"me_notice"]];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"评论";
            [cell.imageView setImage:[UIImage imageNamed:@"news_comment"]];
        }else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"@我的";
            [cell.imageView setImage:[UIImage imageNamed:@"news_at"]];
        }else
        {
            cell.textLabel.text =@"点赞";
            [cell.imageView setImage:[UIImage imageNamed:@"news_praise"]];
        }
        
    }else
    {
        cell.textLabel.text = @"粉丝";
        [cell.imageView setImage:[UIImage imageNamed:@"news_fans"]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDongTai" bundle:nil];
        SMDongtaiViewController *dongtaiVc = [sb instantiateInitialViewController];
        
        dongtaiVc.isFormGuanzhu = NO;
        dongtaiVc.isFormDianzan = NO;
        dongtaiVc.isFormPinglun = NO;
        
        if (indexPath.row == 0) {
            dongtaiVc.isFormPinglun = YES;
        }else if(indexPath.row ==1)
        {
            dongtaiVc.isFormGuanzhu = YES;
        }else
        {
            dongtaiVc.isFormDianzan = YES;
        }
        
        dongtaiVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dongtaiVc animated:YES];
    }else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMFollowersTbVc" bundle:nil];
        SMFollowersTbVc *tbvc = [sb instantiateInitialViewController];
        tbvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tbvc animated:YES];
        
    } 
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
}

@end
