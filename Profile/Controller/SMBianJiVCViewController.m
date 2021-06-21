//
//  SMBianJiVCViewController.m
    
//
//  Created by lucifer on 16/3/10.
   
//

#import "SMBianJiVCViewController.h"

@interface SMBianJiVCViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SMBianJiVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.userModel) {
        self.textView.text = self.userModel.tagline;
        self.textFiled.text = self.userModel.login;
    }else
    {
        SMAccount *acount =[SMAccount accountFromSandbox];
        self.textView.text = acount.tagline;
        self.textFiled.text = acount.login;
    }
    
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(changeNameAndTagline)];
    
}

-(void)changeNameAndTagline
{
    if (self.textFiled.text.length == 0) {

        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
    }else
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"nickname"] = self.textFiled.text;
        
        dic[@"tagline"] = self.textView.text;
        
        [manager PUT:@"http://club.dituhui.com/api/v2/account" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            account.tagline = self.textView.text;
            account.login = self.textFiled.text;
            [account save];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMBianJiNotification object:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
