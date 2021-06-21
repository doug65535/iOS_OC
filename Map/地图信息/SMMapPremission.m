//
//  SMMapPremission.m
    
//
//  Created by lucifer on 15/8/12.
  
//

#import "SMMapPremission.h"

@interface SMMapPremission ()
- (IBAction)clickEditOwner:(UISwitch *)sender;
- (IBAction)clickEditPub:(UISwitch *)sender;


- (IBAction)clickLookOwner:(id)sender;

- (IBAction)clickLookPub:(id)sender;
- (IBAction)clickLookPwd:(id)sender;

@property(nonatomic,copy)NSString *PWDStr;
@end

@implementation SMMapPremission

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.mapModel.edit_permission isEqualToString:@"public"]) {
        
        self.EditPub.on = YES;
        self.EditOwner.on = NO;
        
        self.LookPub.on = YES;
        self.LookOwner.on = NO;
        self.LookPWD.on = NO;
//
    }else
    {
        self.EditOwner.on = YES;
        self.EditPub.on = NO;
        
        if ([self.mapModel.permission isEqualToString:@"pri"]) {
            self.LookOwner.on =YES;
            self.LookPub.on = NO;
            self.LookPWD.on = NO;
        }else{
            if ([self.mapModel.permission isEqualToString:@"pas"]) {
                self.LookPub.on = NO;
                self.LookOwner.on = NO;
                self.LookPWD.on = YES;
            }else
            {
                self.LookPub.on = YES;
                self.LookOwner.on = NO;
                self.LookPWD.on = NO;
            }
        }

    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(send)];

}

-(void)send
{   NSString *EditStr = [[NSString alloc]init];
    if (self.EditOwner.on) {
        EditStr = @"owner";
    }else{
        EditStr = @"public";
    }
    
    NSString *LookStr = [[NSString alloc]init];
    if (self.LookOwner.on) {
        LookStr = @"pri";
    }else if (self.LookPub.on){
        LookStr = @"pub";
    }else {
        LookStr = @"pas";
    }

    
    if ([self.delegate respondsToSelector:@selector(didFinishPremisonEditStr:lookStr:)]) {
        [self.delegate didFinishPremisonEditStr:EditStr lookStr:LookStr];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(paswordPass:)]) {
        [self.delegate paswordPass:self.PWDStr];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)didFinishPremisonEditStr:(NSString *)EditStr lookStr:(NSString *)LookStr
//{
//    
//}

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
//   。on 是点击 完成后 的状态
- (IBAction)clickEditOwner:(UISwitch *)sender {
    if (self.EditOwner.on) {
         [self.EditPub setOn:NO animated:YES];
    }else
    {
        [self.EditPub setOn:YES animated:YES];
        
        [self.LookPub setOn:YES animated:YES];
        [self.LookPWD setOn:NO animated:YES];
        [self.LookOwner setOn:NO animated:YES];
    }
   
}

- (IBAction)clickEditPub:(UISwitch *)sender {
    

    if (self.EditPub.on) {
          [self.EditOwner setOn:NO animated:YES];
   
        [self.LookPub setOn:YES animated:YES];
        [self.LookPWD setOn:NO animated:YES];
        [self.LookOwner setOn:NO animated:YES];
        
    }else
    {
        [self.EditOwner setOn:YES animated:YES];
            }
}


- (IBAction)clickLookOwner:(id)sender {

    if (self.LookOwner.on) {
        [self.LookPub setOn:NO animated:YES];
        [self.LookPWD setOn:NO animated:YES];
    }else
    {
        [self.LookOwner setOn:YES];
    }
    
    if (self.EditPub.on) {
        [self.LookPub setOn:YES animated:YES];
        [self.LookOwner setOn:NO animated:YES];
        [self.LookPWD setOn:NO animated:YES];
    }

}

- (IBAction)clickLookPub:(id)sender {
    if (self.LookPub.on) {
        [self.LookPWD setOn:NO animated:YES];
        [self.LookOwner setOn:NO animated:YES];
    }else
    {
        [self.LookPub setOn:YES];
    }
    
    if (self.EditPub.on) {
        [self.LookPub setOn:YES animated:YES];
        [self.LookOwner setOn:NO animated:YES];
        [self.LookPWD setOn:NO animated:YES];
    }
}

- (IBAction)clickLookPwd:(id)sender {
    if (self.LookPWD.on) {
        
        if (self.isComuon) {
            [SVProgressHUD showErrorWithStatus:@"暂不支持同步到社区密码可见地图"];
        [self.LookPWD setOn:NO animated:YES];
            return;
            
        }
        [self.LookOwner setOn:NO animated:YES];
        [self.LookPub setOn:NO animated:YES];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置密码" message:@"请输入4位密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.LookPub setOn:YES animated:YES];
            [self.LookPWD setOn:NO animated:YES];
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *password = alertController.textFields.lastObject;
            
            self.PWDStr = password.text;
            
             [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        }];
       
        okAction.enabled = NO;
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];

        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入密码";
            textField.secureTextEntry = YES;
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
         
        }];
        
        [self presentViewController:alertController animated:YES completion:nil];
    
    }else{
        [self.LookPWD setOn:YES];
        
    }
    
    if (self.EditPub.on) {
        [self.LookPub setOn:YES animated:YES];
        [self.LookOwner setOn:NO animated:YES];
        [self.LookPWD setOn:NO animated:YES];
    }
    
    
    
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.lastObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length == 4;
    }
}
@end
