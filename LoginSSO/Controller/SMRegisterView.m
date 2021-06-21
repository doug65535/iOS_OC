//
//  SMRegisterView.m
    
//
//  Created by lucifer on 15/7/15.
  
//

#import "SMRegisterView.h"
#import "SVProgressHUD.h"


@interface SMRegisterView ()

{
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
    UILabel *lbaer;
    
}
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *checkNum;
@property (strong, nonatomic) IBOutlet UITextField *setPWD;
- (IBAction)registerNow;
- (IBAction)getCheakNum:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *getCheakNum;

@end

@implementation SMRegisterView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeself)];
    
    
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.getCheakNum.width,self.getCheakNum.height)];
    laber.text = @"获取验证码";
    laber.textAlignment = NSTextAlignmentCenter;
    laber.textColor = [UIColor whiteColor];
    laber.font = [UIFont systemFontOfSize:12];
    lbaer = laber;
    [self.getCheakNum addSubview:lbaer];
    
}
-(void)closeself
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerNow {
    //提醒用户
    [SVProgressHUD showWithStatus:@"正在拼命注册中..."];
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"phone"] = self.phoneNum.text;
    
    parameters[@"captcha"] = self.checkNum.text;
    parameters[@"password"] = self.setPWD.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://www.dituhui.com/mobile/register" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        SMLog(@"%@",responseObject);
        
        if (![responseObject[@"status"] isEqual:@200]) {
            [SVProgressHUD dismiss];
         
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];

        }else{
        // 1.将服务器返回的字典转换为模型
//        NSDictionary *dic = responseObject[@"user"];
//        
//        SMAccount *account = [SMAccount objectWithKeyValues:dic];
//        
//        
//        //                SMLog(@"%@",account.token);
//        //                SMLog(@"%@",account.user_id);
//        
//        //             SMLog(@"%@",dic);
//        
//        
//        // 2.将模型保存到沙河中
//        [account save];
//        
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
        //跳转到登陆控制器
   
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (IBAction)getCheakNum:(UIButton *)sender {
    //提醒用户
    
    
//    [SVProgressHUD showWithStatus:@"正在获取验证码..."];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"phone"] = self.phoneNum.text;
    parameters[@"token"] = @"MIICWjCCAcMCAgGlMA0GCSqGSIb3DQEBBAUAMHU";
    parameters[@"source"] = @"dituhui";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://www.dituhui.com/mobile/yanzhengma" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
        if ([responseObject[@"status"] isEqualToNumber:@200]) {
          
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            secondsCountDown = 180;//180秒倒计时
        }
        else
        {
            if ([responseObject[@"message"] isKindOfClass:[NSNumber class]]) {
                
                if ([responseObject[@"message"] isEqualToNumber:@180]) {
                    [SVProgressHUD showErrorWithStatus:@"发送次数已到达上限"];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"验证码已发送请稍后再试"];
                }

            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
           
        }
        
        
        SMLog(@"%@",responseObject);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);

    }];

}

-(void)timeFireMethod
{
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    
    lbaer.text = [NSString stringWithFormat:@"%d秒后重新发送",secondsCountDown];
    self.getCheakNum.userInteractionEnabled = NO;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        
        //                self.getCheckNum.titleLabel.text = @"获取验证码";
        lbaer.text = @"获取验证码";
        self.getCheakNum.userInteractionEnabled = YES;
    }
}

@end
