//
//  SMBindingTableViewController.m
    
//
//  Created by lucifer on 16/1/26.
   
//

#import "SMBindingTableViewController.h"
#import "SMBingdingCell.h"
#import "UMSocial.h"

@interface SMBindingTableViewController ()
- (IBAction)bingdingBtnClick:(UIButton *)sender;


@end

@implementation SMBindingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMBingdingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    SMAccount *acount =[SMAccount accountFromSandbox];
    
    if (indexPath.row == 0) {
        
        
        [cell.bingdingBtn setTitle:@"绑定QQ" forState:UIControlStateNormal];
        cell.bingdingBtn.backgroundColor =[UIColor orangeColor];
        cell.bingdingBtn.layer.borderWidth= 1.0;
                            cell.bingdingBtn.layer.borderColor= [[UIColor grayColor] CGColor];
        
        [cell.bingdingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.img.image = [UIImage imageNamed:@"share_qq1"];
        cell.laber.text = @"QQ";
        
        if (acount.auths.count) {
            for (SMAuths *auth  in acount.auths) {
                
                
                if ([auth.provider isEqualToString:@"qzone"]) {
                    
                    [cell.bingdingBtn setTitle:@"取消QQ绑定" forState:UIControlStateNormal];
                    cell.bingdingBtn.backgroundColor = [UIColor whiteColor];
                
                    [cell.bingdingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    cell.bingdingBtn.layer.borderWidth= 1.0;
                    cell.bingdingBtn.layer.borderColor= [[UIColor grayColor] CGColor];
                }
//                else
//                {
//                    [cell.bingdingBtn setTitle:@"绑定QQ" forState:UIControlStateNormal];
//                    cell.bingdingBtn.backgroundColor =[UIColor orangeColor];
//                    [cell.bingdingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    cell.bingdingBtn.layer.borderWidth= 1.0;
//                    cell.bingdingBtn.layer.borderColor= [[UIColor blackColor] CGColor];
//                }
               
        }
    }

    }else
    {
        
        [cell.bingdingBtn setTitle:@"绑定微博" forState:UIControlStateNormal];
        cell.bingdingBtn.backgroundColor =[UIColor orangeColor];
        
        cell.bingdingBtn.layer.borderWidth= 1.0;
                            cell.bingdingBtn.layer.borderColor= [[UIColor grayColor] CGColor];
        [cell.bingdingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.img.image = [UIImage imageNamed:@"share_weibo1"];
        cell.laber.text = @"新浪微博";
        
        for (SMAuths *auths  in acount.auths) {
            
                      
            if ([auths.provider isEqualToString:@"weibo"]) {
                [cell.bingdingBtn setTitle:@"取消微博绑定" forState:UIControlStateNormal];
                
                cell.bingdingBtn.backgroundColor = [UIColor whiteColor];
                [cell.bingdingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                cell.bingdingBtn.layer.borderWidth= 1.0;
                cell.bingdingBtn.layer.borderColor= [[UIColor grayColor] CGColor];
            }
        }

    }

    
    
    
    
    return cell;
}



- (IBAction)bingdingBtnClick:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"取消QQ绑定"]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        [manager POST:@"http://club.dituhui.com/api/v2/auth/qzone/unbind" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

                [SVProgressHUD showSuccessWithStatus:@"解绑成功"];
         
            
            
            for (SMAuths *auth in account.auths) {
                if ([auth.provider isEqualToString:@"qzone"]) {
//                    [account.auths removeObject:auth];
                    auth.provider = nil;
                    [account save];
                    [self.tableView reloadData];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"解绑失败"];
        }];
    }
    
    
    if ([sender.titleLabel.text isEqualToString:@"取消微博绑定"]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        [manager POST:@"http://club.dituhui.com/api/v2/auth/weibo/unbind" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            

                [SVProgressHUD showSuccessWithStatus:@"解绑成功"];
            
            for (SMAuths *auth in account.auths) {
                if ([auth.provider isEqualToString:@"weibo"]) {
//                    [account.auths removeObject:auth];
                    auth.provider = nil;
                    [account save];
                    [self.tableView reloadData];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"解绑失败"];
        }];
    }
    
    
    if ([sender.titleLabel.text isEqualToString:@"绑定QQ"]) {
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                
                SMLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                //            /////////////////
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                
                SMAccount *account = [SMAccount accountFromSandbox];
                
                [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic[@"nickname"] = snsAccount.userName;
                dic[@"avatar"] = snsAccount.iconURL;
                dic[@"provider"] = @"qzone";
                dic[@"uid"] = snsAccount.usid;
                dic[@"access_token"] = snsAccount.accessToken;
                
                
                [manager POST:@"http://club.dituhui.com/api/v2/auth/qzone/bind" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                    


                   
            
                    NSArray *model = [SMAuths objectArrayWithKeyValuesArray:responseObject];
                    
                    for (SMAuths *auths in model) {
                        
                        if ([auths.provider isEqualToString:@"qzone"]) {
                            SMAccount *account =[SMAccount accountFromSandbox];
                            [account.auths addObject:auths];
                            [account save];
                            [self.tableView reloadData];
                        
                        }
                        
                        
                    }

                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    SMLog(@"%@",error);
                    [SVProgressHUD showErrorWithStatus:@"绑定失败"];
                }];
                
            }});

    }
    
    if ([sender.titleLabel.text isEqualToString:@"绑定微博"]) {
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                
                SMLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);

                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                
                SMAccount *account = [SMAccount accountFromSandbox];
                
                [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic[@"nickname"] = snsAccount.userName;
                dic[@"avatar"] = snsAccount.iconURL;
                dic[@"provider"] = @"weibo";
                dic[@"uid"] = snsAccount.usid;
                dic[@"access_token"] = snsAccount.accessToken;
                
                
                [manager POST:@"http://club.dituhui.com/api/v2/auth/weibo/bind" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                   
                    
                   
                    
                    NSArray *model = [SMAuths objectArrayWithKeyValuesArray:responseObject];
                    for (SMAuths *auths in model) {
                        if ([auths.provider isEqualToString:@"weibo"]) {
                            SMAccount *account =[SMAccount accountFromSandbox];
                            [account.auths addObject:auths];
                            [account save];
                            [self.tableView reloadData];
                            
                         
                        }
                        
                        
                    }
                    
                    
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    SMLog(@"%@",error);
                    [SVProgressHUD showErrorWithStatus:@"绑定失败"];
                }];
                
            }});
        
    }

}
@end
