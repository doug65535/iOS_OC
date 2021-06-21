//
//  SMGuanzhuFensiCell.m
    
//
//  Created by lucifer on 15/9/30.
 
//

#import "SMGuanzhuFensiCell.h"

@implementation SMGuanzhuFensiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(SMUser *)user
{
    _user = user;
    
    [self.loginView sd_setImageWithURL:[NSURL URLWithString:user.avatar]placeholderImage:[UIImage imageNamed:@"tab_me"]];
    
    self.loginView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title.text = user.login;
    
    if (user.tagline) {
         self.detaititle.text = user.tagline;
    }else
    {
        self.detaititle.text =@"这个人很懒，什么也没留下";
    }
   
    
    
    
    if (self.user.relationship) {
        if ([self.user.relationship isEqualToString:@"关注"]) {
            [self.guanzhu setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
        }else if([self.user.relationship isEqualToString:@"已关注"])
        {
            [self.guanzhu setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
        }else
        {
            [self.guanzhu setImage:[UIImage imageNamed:@"xianghuguanzhu"] forState:UIControlStateNormal];
        }
    }else
    {
        [self.guanzhu.imageView setImage:nil];
    }
    
}

- (IBAction)guanzhu:(id)sender {
    [SVProgressHUD showWithStatus:@"正在请求"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    SMLog(@"%@",account.token);
    NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/follow", self.user.user_id];
    
    [manager POST:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SMUser *userMode = [SMUser objectWithKeyValues:responseObject[@"user"]];
        if (userMode.relationship) {
            if ([userMode.relationship isEqualToString:@"关注"]) {
                [self.guanzhu setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
            }else if([userMode.relationship isEqualToString:@"已关注"])
            {
                [self.guanzhu setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
            }else
            {
                [self.guanzhu setImage:[UIImage imageNamed:@"xianghuguanzhu"] forState:UIControlStateNormal];
            }
        }else
        {
            [self.guanzhu setImage:nil forState:UIControlStateNormal];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
}
@end
