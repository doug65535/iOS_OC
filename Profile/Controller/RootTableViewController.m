//
//  RootTableViewController.m
//  XHPathCover
#import "RootTableViewController.h"
#import "XHPathCover.h"


#import "SMNavgationController.h"
#import "SMRegisterView.h"


#import "SMSettingsTBVC.h"

#import "CustomHeaderViewController.h"

#import "ARSegmentPageController.h"
#import "SMPofileBlogTBVC.h"
#import "UIImage+ImageEffects.h"
#import "SMPofileFoverVc.h"
#import "SMProfilePinglunVc.h"
#import "SMDefaultView.h"
#import "SMFollowersTbVc.h"
#import "SMGuanZhuVc.h"


#import "UMSocial.h"

#import "BoPhotoPickerViewController.h"


#import <AVFoundation/AVFoundation.h>

#import <MobileCoreServices/MobileCoreServices.h>

#import "SMBianJiVCViewController.h"

#import "SMOfflineMapViewController.h"



#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RootTableViewController ()<ARSegmentControllerDelegate,SMDefaultViewDelegate,XHPathCoverDelegate,UIScrollViewDelegate,BoPhotoPickerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) XHPathCover *pathCover;

@property (nonatomic, strong)SMDefaultView *defaultView;


@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, strong) ARSegmentPageController *pager;

@property (nonatomic,strong)UIButton *guanzhuBtn;


@property (nonatomic,strong)SMUser *selfuserModel;


@property(nonatomic,strong)BMKOfflineMap *offline;
@property (nonatomic,strong)NSMutableArray *updateInfos;


@property(nonatomic,strong)UIImageView *bageView;
@end

@implementation RootTableViewController

-(SMDefaultView *)defaultView
{
    if (!_defaultView) {
        _defaultView = [SMDefaultView defaultView];
    }
    return _defaultView;
}

-(void)viewWillAppear:(BOOL)animated
{
    //     取出存储的模型对象
    SMAccount *account = [SMAccount accountFromSandbox];
 
    //判断是否已经授权
    if (account.token != nil) {
        //         已经授权
        
        [self.defaultView removeFromSuperview];
//        self.defaultView = nil;
//        [super viewDidLoad];
          [self loadUser];
    }else
    {
        if (self.isNeedShow) {
        [self loadUser];
            return;
        }
        
        

        self.defaultView.frame = CGRectMake(0, 0, kWidth, kHeight- 49 -64);

            [self.view addSubview:_defaultView];
            _defaultView.delegate = self;
            self.defaultView = _defaultView;
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bianjiOK) name:SMBianJiNotification object:nil];
    
}

-(void)bianjiOK
{
       [self loadUser];
}


-(void)defaultViewDidCLickLogin
{
        [self loadUser];
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


-(void)defaultViewDidClickRegister
{
    SMRegisterView *vc = [[UIStoryboard storyboardWithName:@"SMRegister" bundle:nil]instantiateInitialViewController];
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
//    [super viewDidLoad];
    
    self.title = self.userModle.login;

    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableHeaderView:view];
    

//    test bug
    
//    [self loadUser];
//    SMLog(@"%@",self.userModle.relationship);
    
    if (self.navigationController.viewControllers.count <=1) {
            self.title = @"我的";
            self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shezhi"] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
    }
    
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    
    _pathCover.userModel = self.userModle;
    
    self.pathCover.delegate = self;
//    _pathCover.bannerImageView.contentMode =UIViewContentModeCenter;
    
//    我的页面图片设置
    [_pathCover setBackgroundImage:[UIImage imageNamed:@"photo1"]];
        self.tableView.tableHeaderView = self.pathCover;
    
//    动态页设置
    self.defaultImage = [UIImage imageNamed:@"photo2"];
    self.blurImage = [[UIImage imageNamed:@"photo2"] applyDarkEffect];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMPofileBlogTBVC" bundle:nil];
    SMPofileBlogTBVC *blogVc = [sb instantiateInitialViewController];
    blogVc.userModel = self.userModle;
    
    
    UIStoryboard *sb1 = [UIStoryboard storyboardWithName:@"SMPofileFoverVc" bundle:nil];
    SMPofileFoverVc *foverVc =[sb1 instantiateInitialViewController];

    
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"SMProfilePinglunVc" bundle:nil];
    SMProfilePinglunVc *pingVc = [sb2 instantiateInitialViewController];
    pingVc.userModel = self.userModle;
    
    if (self.userModle) {
        ARSegmentPageController *pager = [[ARSegmentPageController alloc] init];
        [pager setViewControllers:@[blogVc,pingVc]];
        pager.freezenHeaderWhenReachMaxHeaderHeight = YES;
//        pager.segmentMiniTopInset = 64;
        self.pager = pager;
        
    }else{
        
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] init];
    [pager setViewControllers:@[blogVc,pingVc,foverVc]];
        pager.freezenHeaderWhenReachMaxHeaderHeight = YES;
//        pager.segmentMiniTopInset = 64;
        self.pager = pager;
        
    }
       [self.pager addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:NULL];
    
    


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BMKOfflineMap *offline = [[BMKOfflineMap alloc]init];
        _offline =  offline;
        NSArray *localInfos = [offline getAllUpdateInfo];
        
        
        NSMutableArray *localFinish = [NSMutableArray array];
        NSMutableArray *updateInfos = [NSMutableArray array];
        for (BMKOLUpdateElement* item in localInfos) {
            if (item.status == 4) {
                [localFinish addObject:item];
            }
        }
        
        for (BMKOLUpdateElement *item in localFinish) {
            if (item.update == YES) {
                [updateInfos addObject:item];
            }
        }
        
        self.updateInfos = updateInfos;

    });
    
    
}



-(void)didClickFensi
{
    SMFollowersTbVc *followerVc = [[UIStoryboard storyboardWithName:@"SMFollowersTbVc" bundle:nil]instantiateInitialViewController];
    
    followerVc.userModel = self.userModle;
    followerVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:followerVc animated:YES];
}

-(void)didClickGuanzhu
{
    SMGuanZhuVc *guanzhuVc = [[UIStoryboard storyboardWithName:@"SMGuanZhuVc" bundle:nil]instantiateInitialViewController];
    guanzhuVc.userModel = self.userModle;

    guanzhuVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guanzhuVc animated:YES];
}

-(void)didclickAvater
{
    BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)putImage:(UIImage *)image
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

    [manager POST:@"http://club.dituhui.com/api/v2/account/avatar" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);
        
        [formData appendPartWithFileData:iamgeData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
          [_pathCover setAvatarImage:image];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          SMLog(@"失败%@",error );
    }];


}


- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    
    for (int i =0 ; i< assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [_pathCover setAvatarImage:tempImg];
        
        [self putImage:tempImg];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//超过最大选择项时
- (void)photoPickerDidMaximum:(BoPhotoPickerViewController *)picker {
    //    NSLog(@"%s",__func__);
    [SVProgressHUD showErrorWithStatus:@"选择一张照片即可"];
}
- (BOOL)checkCameraAvailability {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                __block status = YES;
            }else{
                __block status = NO;
            }
        }];
        
    }
    return status;
}

- (void)photoPickerTapAction:(BoPhotoPickerViewController *)picker {
    if(![self checkCameraAvailability]){
        [SVProgressHUD showErrorWithStatus:@"您没有打开相机的权限 请到‘设置‘中打开"];
        return;
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImagePickerController *cameraUI = [UIImagePickerController new];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
    
    [self presentViewController:cameraUI animated: YES completion:nil];
}
#pragma mark - UIImagePickerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
// 选中图片时调用

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [_pathCover setAvatarImage:image];
    
     [self putImage:image];
    // 关闭图片选择器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}





-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.pager.title =@"动态";
}

-(NSString *)segmentTitle
{
    return @"common";
}

-(void)settings
{
    SMSettingsTBVC *tb = [[SMSettingsTBVC alloc]init];

    tb.hidesBottomBarWhenPushed =YES;
//    SMAccount *acount = [SMAccount accountFromSandbox];
 
    tb.userModel = _selfuserModel;

    [self.navigationController pushViewController:tb animated:YES];
}
-(void)loadUser
{
    if (self.userModle) {

            [_pathCover setAvatarUrlString:self.userModle.avatar];
        
            [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.userModle.login, XHUserNameKey, [NSString stringWithFormat:@"粉丝%tu",self.userModle.followers_count],
                                 XHBirthdayKey,[NSString stringWithFormat:@"关注%tu",self.userModle.followings_count],SMFollowings, _userModle.tagline,tagline,nil]];
        
            
            _pathCover.isZoomingEffect = YES;
     
//        关注按钮
        UIButton *guanzhuBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth -20 -63, 20, 63, 20)];
        
        [guanzhuBtn addTarget:self action:@selector(didClickguanzhuBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:guanzhuBtn];
        
        self.guanzhuBtn = guanzhuBtn;
        
        if (self.userModle.relationship) {
            if ([self.userModle.relationship isEqualToString:@"关注"]) {
                [guanzhuBtn setImage:[UIImage imageNamed:@"profile_guanzhu"] forState:UIControlStateNormal];
            }else if([self.userModle.relationship isEqualToString:@"已关注"])
            {
                [guanzhuBtn setImage:[UIImage imageNamed:@"profile_yiguanzhu"] forState:UIControlStateNormal];
            }else
            {
                [guanzhuBtn setImage:[UIImage imageNamed:@"profile_xianghuguanzhu"] forState:UIControlStateNormal];
            }
        }else
        {
            [guanzhuBtn.imageView setImage:nil];
        }
        

    
    }else{
        
            SMAccount *account = [SMAccount accountFromSandbox];
//           SMLog(@"tokenshi%@",account.token);
//        if (account) {
//            [_pathCover setAvatarUrlString:account.avatar];
//            
//            [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:account.login, XHUserNameKey, [NSString stringWithFormat:@"粉丝%@",account.followers_count], XHBirthdayKey,[NSString stringWithFormat:@"关注%@",account.followings_count],SMFollowings,account.tagline,tagline, nil]];
            SMLog(@"TOKEN是%@",account.token);
//
//        }else{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    

    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
         
    NSString *urlStr = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@",account.user_id];

    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SMUser *userModel = [SMUser objectWithKeyValues:responseObject];
//        self.userModle = userModel;
        self.selfuserModel = userModel;
        [_pathCover setAvatarUrlString:userModel.avatar];
        
        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:userModel.login, XHUserNameKey, [NSString stringWithFormat:@"粉丝%tu",userModel.followers_count], XHBirthdayKey,[NSString stringWithFormat:@"关注%tu",userModel.followings_count],SMFollowings,userModel.tagline,tagline, nil]];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
            
//        }
    }
}

-(void)didClickguanzhuBtn
{
    [SVProgressHUD showWithStatus:@"正在请求"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    SMLog(@"%@",account.token);
    NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/follow", self.userModle.user_id];
    
    [manager POST:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SMUser *userMode = [SMUser objectWithKeyValues:responseObject[@"user"]];
        if (userMode.relationship) {
            if ([userMode.relationship isEqualToString:@"关注"]) {
                [self.guanzhuBtn setImage:[UIImage imageNamed:@"profile_guanzhu"] forState:UIControlStateNormal];
            }else if([userMode.relationship isEqualToString:@"已关注"])
            {
                [self.guanzhuBtn setImage:[UIImage imageNamed:@"profile_yiguanzhu"] forState:UIControlStateNormal];
            }else
            {
                [self.guanzhuBtn setImage:[UIImage imageNamed:@"profile_xianghuguanzhu"] forState:UIControlStateNormal];
            }
        }else
        {
            [self.guanzhuBtn setImage:nil forState:UIControlStateNormal];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3
    ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    右边小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell 下划线
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {

        cell.textLabel.text = @"动态";
        cell.imageView.image = [UIImage imageNamed:@"me_notice"];
        return cell;
    }else if(indexPath.row ==1){
//        if (indexPath.row == 1) {
        cell.textLabel.text = @"地图";
        cell.imageView.image = [UIImage imageNamed:@"me_map"];
        return cell;
    }else
    {
        cell.textLabel.text = @"离线";
          cell.imageView.image = [UIImage imageNamed:@"my_offline"];
        
        if (self.updateInfos.count) {
        CGFloat witch = 3;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(witch,19 , 6, 6)];
            [imageView setImage:[UIImage imageNamed:@"message_count1"]];
            
            [cell addSubview:imageView];
             self.bageView = imageView;
        }
        
    
               return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        CustomHeaderViewController *ditu = [CustomHeaderViewController alloc];
        ditu.userModel = self.userModle;
        ditu = [ditu init];
        ditu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ditu animated:YES];
    }
    
    if (indexPath.row == 0) {
        self.pager.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.pager animated:YES];
    }
    
    if (indexPath.row == 2) {
        
        
        SMOfflineMapViewController *offline = [[UIStoryboard storyboardWithName:@"SMOfflineMap" bundle:nil] instantiateInitialViewController];
        offline.hidesBottomBarWhenPushed = YES;
    
//        [self.navigationController addChildViewController:offline];
        offline.offlineMap = self.offline;
        
        if (self.bageView) {
             [self.bageView removeFromSuperview];
        }
       
        
        [self.navigationController pushViewController:offline animated:YES];
 }
}
-(void)dealloc
{
    [self.pager removeObserver:self forKeyPath:@"segmentToInset"];
}

@end
