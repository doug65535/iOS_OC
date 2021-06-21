//
//  SMDefaultView.m
    
//
//  Created by lucifer on 15/7/19.
  
//

#import "SMDefaultView.h"

#import "SMRegisterView.h"

#import "SMChangePwdViewController.h"

@interface SMDefaultView ()
- (IBAction)loginBtn:(UIButton *)sender;

- (IBAction)registerBtn:(UIButton *)sender;

- (IBAction)changePWD:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UITextField *loginID;
@property (strong, nonatomic) IBOutlet UITextField *loginPWD;


@end
@implementation SMDefaultView

- (IBAction)weiboLogin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(defaultViewDidCLickWeiboLogin:)]) {
        [self.delegate defaultViewDidCLickWeiboLogin:self];
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
}

- (IBAction)qqLogin:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(defaultViewDidCLickQQLogin)]) {
        [self.delegate defaultViewDidCLickQQLogin];
    }
  
}
- (IBAction)wechatLogin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(defaultViewDidCLickweiXinLogin)]) {
        [self.delegate defaultViewDidCLickweiXinLogin];
    }
}


- (IBAction)loginBtn:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"正在拼命加载ing..."];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"login"] = self.loginID.text;
    
    parameters[@"password"] = self.loginPWD.text;
    
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

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [self.loginPWD resignFirstResponder];
//    [self.loginID resignFirstResponder];
//    return YES;
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.loginPWD resignFirstResponder];
//    [self.loginID resignFirstResponder];
//}
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
        
        
        if ([self.delegate respondsToSelector:@selector(defaultViewDidCLickLogin)]) {
            [self.delegate defaultViewDidCLickLogin];
        }
        [self removeFromSuperview];
        
 
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"登陆错误"];
        SMLog(@"%@",error);
    }];
    

}

- (IBAction)registerBtn:(UIButton *)sender {
  
    if ([self.delegate respondsToSelector:@selector(defaultViewDidClickRegister)]) {
        [self.delegate defaultViewDidClickRegister];
    }
}

//找到view所在的控制器

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (IBAction)changePWD:(UIButton *)sender {
    UIViewController *vc = [self getCurrentVC];
    
    SMChangePwdViewController *changePWDVC = [[UIStoryboard storyboardWithName:@"SMChangePwd" bundle:nil]instantiateInitialViewController];
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:changePWDVC];
    [vc presentViewController:nav animated:YES completion:nil];
}

+(instancetype)defaultView
{
    
 return [[[NSBundle mainBundle] loadNibNamed:@"SMDefault" owner:nil options:nil] lastObject];
    
}
@end
