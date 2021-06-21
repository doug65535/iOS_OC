//
//  SMDetailPinglunCell.m
    
//
//  Created by lucifer on 15/9/8.
  
//

#import "SMDetailPinglunCell.h"

#import "RootTableViewController.h"

#import "SMHuaTiVc.h"

#import "SMWebVc.h"
#import "SMMapViewController.h"
@interface SMDetailPinglunCell ()<MLEmojiLabelDelegate>

@property (weak, nonatomic) IBOutlet UIButton *userImage;
- (IBAction)userPick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *userLogin;
@property (weak, nonatomic) IBOutlet UILabel *flor;
@property (weak, nonatomic) IBOutlet UILabel *fireTime;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *replayBody;

@end

@implementation SMDetailPinglunCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)userPick:(UIButton *)sender {
    if ([self.deleagete respondsToSelector:@selector(didClickCellImage:)]) {
        [self.deleagete didClickCellImage:sender.tag];
    }
}

-(CGFloat)cellHeightWithRelayModel:(SMRepies *)replay
{
    self.replayBody.text = replay.body;
    
    [self.replayBody setPreferredMaxLayoutWidth:kWidth - 64];

      CGSize meagesize = [self.replayBody sizeThatFits:CGSizeMake(kWidth -64, MAXFLOAT)];

    return meagesize.height+44;
}

-(void)setReplayModel:(SMRepies *)replayModel
{
    [self.userImage sd_setBackgroundImageWithURL:[NSURL URLWithString:replayModel.user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageLowPriority |SDWebImageRetryFailed];
    
    self.userImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    用于找到点击头像是点得哪个
    self.userImage.tag = [replayModel.floor integerValue];
    
    self.replayBody.text = replayModel.body;
    

    self.userLogin.text = replayModel.user.login;
    self.flor.text =[NSString stringWithFormat:@"%@楼",replayModel.floor];
    self.fireTime.text = replayModel.created_at;
    [self.replayBody setPreferredMaxLayoutWidth:kWidth-64];
    
    self.replayBody.delegate = self;
    self.replayBody.isNeedAtAndPoundSign = YES;
    self.replayBody.disableEmoji = NO;
}

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


-(void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
            
        case MLEmojiLabelLinkTypeURL:
        {
            NSString *url = link ;
            
            
            NSString *str = @"dituhui.com";
            
            if ([url rangeOfString:str].location != NSNotFound && [url rangeOfString:@"maps"].location != NSNotFound) {
                
          
                
                NSArray *strArr = [url componentsSeparatedByString:@"/maps/"];
                
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                
                SMAccount *account = [SMAccount accountFromSandbox];
                
                [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
                [manager GET:[NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@.json",strArr[1]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    SMLog(@"%@",strArr[1]);
                    SMCreatMap *mapmodel = [SMCreatMap objectWithKeyValues:responseObject[@"info"]];
                    
                    
                    if ([mapmodel.app_name rangeOfString:@"MARKER"].location == NSNotFound) {
                        SMWebVc *webVc = [[UIStoryboard storyboardWithName:@"SMWebVc" bundle:nil]instantiateInitialViewController];
                        webVc.url = link;
                        
                        SMNavgationController *nav = [[SMNavgationController alloc]init];
                        [nav addChildViewController:webVc];
                        [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
                        
                    }else{
                        SMMapViewController *mapViewVC = [[UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil]instantiateInitialViewController];
                        mapViewVC.mapModel = mapmodel;
                        
                        SMNavgationController *nav = [[SMNavgationController alloc]init];
                        [nav addChildViewController:mapViewVC];
                        
                        [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络异常"];
                }];

        }else
        {
            SMWebVc *webVc = [[UIStoryboard storyboardWithName:@"SMWebVc" bundle:nil]instantiateInitialViewController];
            webVc.url = link;
            
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:webVc];
            [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
        }
        }
            break;
        
        case MLEmojiLabelLinkTypePhoneNumber:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@" ,link]]];
        }
            break;
        case MLEmojiLabelLinkTypeEmail:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",link]]];
        }
            break;
        case MLEmojiLabelLinkTypeAt:
        {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            SMAccount *account = [SMAccount accountFromSandbox];
            
            [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
            NSString *str = [link substringFromIndex:1];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            dic[@"login"] = str;
            
            [manager POST:@"http://club.dituhui.com/api/v2/users/user_info" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                SMUser *userModel =[SMUser objectWithKeyValues:responseObject];
                RootTableViewController *vc = [[UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil]instantiateInitialViewController];
                vc.userModle = userModel;
               
                if ([self.deleagete respondsToSelector:@selector(didclickrenWu:)]) {
                    [self.deleagete didclickrenWu:vc];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];
        }
            break;
        case MLEmojiLabelLinkTypePoundSign:
        {
            NSString *str = [link substringFromIndex:1];
            NSString *str1 = [str substringToIndex:str.length -1];
            
            SMHuaTiVc *vc =[[UIStoryboard storyboardWithName:@"SMHuaTiVc" bundle:nil]instantiateInitialViewController];
            vc.huati = str1;
            
            if ([self.deleagete respondsToSelector:@selector(didClickHuati:)]) {
                [self.deleagete didClickHuati:vc];
            }
            
        }
            break;
        default:
            SMLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

@end
