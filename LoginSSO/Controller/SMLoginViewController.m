//
//  SMLoginViewController.m
    
//
//  Created by lucifer on 15/10/22.
 
//

#import "SMLoginViewController.h"
#import "SMRegisterView.h"
#import "UMSocial.h"
#import "SMChangePwdViewController.h"

@interface SMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginID;
@property (weak, nonatomic) IBOutlet UITextField *loginPAS;
- (IBAction)login:(UIButton *)sender;

- (IBAction)weixinLogin:(UIButton *)sender;

- (IBAction)regirst:(UIButton *)sender;
- (IBAction)qqLogin:(UIButton *)sender;

- (IBAction)weiboLogin:(UIButton *)sender;

- (IBAction)changePwdBtn:(UIButton *)sender;

@end

@implementation SMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeVC)];
}
-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在拼命加载ing..."];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"login"] = self.loginID.text;
    
    parameters[@"password"] = self.loginPAS.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://club.dituhui.com/api/v2/signin" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //            SMLog(@"%@",responseObject);
        // 1.将服务器返回的字典转换为模型
        
        if (![responseObject[@"status"] isEqual: @true]) {
        [SVProgressHUD showErrorWithStatus:@"登陆出错,请核对登陆账号密码"];
            return ;
        }
        NSDictionary *dic = responseObject[@"user"];
        
        SMAccount *account = [SMAccount objectWithKeyValues:dic];

        [self loadGroup:account];
        
        // 2.将模型保存到沙河中
        //        [account save];
        //
        //        [SVProgressHUD dismiss];
        //
        //
        //        [self removeFromSuperview];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"登陆错误"];
    }];
}

-(void)loadGroup:(SMAccount *)account
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/info",account.user_id];
    [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //            SMLog(@"%@",responseObject);
        // 1.将服务器返回的字典转换为模型
        NSArray *groupModel = responseObject[@"groups"];
        
        account.groups = groupModel;
        
        
        // 2.将模型保存到沙河中
        [account save];
        
        [SVProgressHUD dismiss];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"登陆错误"];
        SMLog(@"%@",error);
    }];
    
    
}
- (IBAction)weixinLogin:(UIButton *)sender {
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
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                } failure:^(NSURLSessionDataTask *task, NSError *error){
                    SMLog(@"%@",error);
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
            
        }
        
    });

}

- (IBAction)regirst:(UIButton *)sender {
    SMRegisterView *vc = [[UIStoryboard storyboardWithName:@"SMRegister" bundle:nil]instantiateInitialViewController];
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:vc];
//    [self.navigationController presen:nav animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)qqLogin:(UIButton *)sender {
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
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [SVProgressHUD dismiss];
                    
                    
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error){
                    SMLog(@"%@",error);
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
            
        }});
}

- (IBAction)weiboLogin:(UIButton *)sender {
    
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
                    [self dismissViewControllerAnimated:YES completion:nil];
                } failure:^(NSURLSessionDataTask *task, NSError *error){
                    SMLog(@"%@",error);
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
            
        }});
}

- (IBAction)changePwdBtn:(UIButton *)sender {
    SMChangePwdViewController *vc = [[UIStoryboard storyboardWithName:@"SMChangePwd" bundle:nil]instantiateInitialViewController];
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    
    [nav addChildViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
@end
