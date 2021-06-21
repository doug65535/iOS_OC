//
//  SMChangePwdViewController.m
    
//
//  Created by lucifer on 15/12/3.
 
//

#import "SMChangePwdViewController.h"

@interface SMChangePwdViewController ()

{
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
    UILabel *lbaer;

}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextFiled;
- (IBAction)getCheakNum:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *checkNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *setPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *reSetPWDTextFiled;
- (IBAction)changeNow:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *getCheckNum;


@end

@implementation SMChangePwdViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeVC)];
    self.title = @"忘记密码";
    
    UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.getCheckNum.width,self.getCheckNum.height)];
    laber.text = @"获取验证码";
    laber.textAlignment = NSTextAlignmentCenter;
    laber.textColor = [UIColor whiteColor];
    laber.font = [UIFont systemFontOfSize:12];
    lbaer = laber;
    [self.getCheckNum addSubview:lbaer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getCheakNum:(UIButton *)sender {

    
  
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"phone"] = self.phoneNumTextFiled.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://club.dituhui.com/api/v2/sms/captcha" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] isEqualToNumber:@1]) {
            
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            secondsCountDown = 180;//180秒倒计时
//            sender.titleLabel.text = [NSString stringWithFormat:@"%d",secondsCountDown];
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
            self.getCheckNum.userInteractionEnabled = NO;
            //当倒计时到0时，做需要的操作，比如验证码过期不能提交
            if(secondsCountDown==0){
                [countDownTimer invalidate];

//                self.getCheckNum.titleLabel.text = @"获取验证码";
                lbaer.text = @"获取验证码";
                self.getCheckNum.userInteractionEnabled = YES;
            }
}
- (IBAction)changeNow:(UIButton *)sender {
    
    if (self.setPWDTextField.text != nil && self.reSetPWDTextFiled.text != nil) {
        if ([self.setPWDTextField.text isEqualToString:self.reSetPWDTextFiled.text] ) {
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            SMAccount *account = [SMAccount accountFromSandbox];
            
            [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"captcha"] = self.checkNumTextField.text;
            dic[@"phone"] = self.phoneNumTextFiled.text;
            dic[@"password"] = self.setPWDTextField.text;
            dic[@"password_confirmation"] = self.reSetPWDTextFiled.text;
            [manager POST:@"http://club.dituhui.com/api/v2/sms/reset_password" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"status"] isEqualToNumber:@1]) {
                    [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"更改请求失败"];
            }];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    }
    }
@end
