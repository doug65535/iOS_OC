//
//  SMDetailViewController.m
    
//
//  Created by lucifer on 15/7/20.
  
//

#import "SMDetailViewController.h"
#import "UIButton+WebCache.h"
#import "SMRepies.h"
#import "SMRepiesStatus.h"
#import "SMInputTextView.h"
#import "SMPingLunViewController.h"

#import "SMMapViewController.h"


#import "SMComunityViewController.h"

#import "RootTableViewController.h"
#import "HZPhotoBrowser.h"

#import "SMDetailPinglunCell.h"

#import "UMSocial.h"

#import "SMWebVc.h"
#import "SMHuaTiVc.h"

#import "SMLikeFridensTableViewController.h"

#import "SMPhotoCollectViewCell.h"
#import "SMDetailZanShouCangTableViewCell.h"
#import <TencentOpenAPI/QQApiInterface.h>


#import "CoreEmotionView.h"
#import "NSArray+SubArray.h"
#import "EmotionModel.h"
#import "NSString+EmotionExtend.h"

@interface SMDetailViewController ()<UITableViewDataSource,UITableViewDelegate,SMPingLunViewControllerDelegate,HZPhotoBrowserDelegate,SMDetailPinglunCellDeleagate,UMSocialUIDelegate,MLEmojiLabelDelegate,SMLikeFridensTableViewControllerDelegate,UIWebViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)SMPictures *pic;


@property (strong, nonatomic) IBOutlet UILabel *user_name;

@property (strong, nonatomic) IBOutlet UIButton *user_image;


@property (strong, nonatomic) IBOutlet UIButton *fireTime;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@property (strong, nonatomic) IBOutlet MLEmojiLabel *textLaber;
@property (strong, nonatomic) IBOutlet UIButton *markLaber;
@property (weak, nonatomic) IBOutlet UIButton *locationLaber;

- (IBAction)user_img:(UIButton *)sender;
/**
 *  滚动范围高度
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;
/**
 *  详情数据页面高度
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;


/**
 *  详情文字高度
 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeight;



@property (nonatomic, getter=isZanSelected) BOOL isZanSelected;

@property(nonatomic,strong)UIButton *zanBtn;

@property (nonatomic,strong)UIButton *pinglunBtn;


@property (nonatomic,strong)NSMutableArray *repliesArr;

@property (nonatomic,strong)NSMutableArray *favorsArr;

@property (nonatomic,strong)NSMutableArray *likersArr;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property(nonatomic,getter=isZan)BOOL isZan;


@property(nonatomic,getter=isFover)BOOL isFover;

/**
 *  保存生成的图片
 */
@property(nonatomic,strong)UIImage *collectimage;


@property(nonatomic,strong)UITextField *inputTextView;


@property(nonatomic,strong)UIView *pinglunBarView;


@property(nonatomic,strong)UIButton *btn2;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectLayout;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;

- (IBAction)markLaber:(UIButton *)sender;


@property(nonatomic,strong)SMPhotoCollectViewCell *collectCell;


@property(nonatomic,strong)HZPhotoBrowser *phtotBrowser;



@property (nonatomic,strong) CoreEmotionView *emotionView;
@property (nonatomic,assign) NSUInteger curve;
@property (nonatomic,assign) CGFloat time;

@property(nonatomic,strong)UIButton *emojiBtn;

@end
@implementation SMDetailViewController
{
    float mScrollViewOffsetY;
}
-(NSMutableArray *)likersArr
{
    if (!_likersArr) {
        _likersArr = [[NSMutableArray alloc] init];
    }
    return _likersArr;
}
-(NSMutableArray *)favorsArr
{
    if (!_favorsArr) {
        _favorsArr = [[NSMutableArray alloc]init];
    }
    return _favorsArr;
}

-(NSMutableArray *)repliesArr
{
    if (!_repliesArr) {
        _repliesArr = [[NSMutableArray alloc]init];
    }
    return _repliesArr;
}

@synthesize mScrollView;
@synthesize mDockMenuView;
@synthesize mScrollDockMenuView;
@synthesize view1;
@synthesize view2;
@synthesize view3;
#define DEVICE_3_5_INCH ([[UIScreen mainScreen] bounds].size.height == 480)
#define DEVICE_4_0_INCH ([[UIScreen mainScreen] bounds].size.height == 568)



//当用户点击菜单的时候，设置scrollView从指定的偏移位置开始显示
-(void) onDockMenuItemClick:(id)sender
{
    int tag = (int)((UIButton*) sender).tag;

    [self ChangeDockMenuSubViews:tag-K_MENUITEM_DEFAULT];
    
    if (mScrollViewOffsetY < mScrollDockMenuView.frame.origin.y) {
        [mDockMenuView changeMenuItemState:tag];
               [mScrollDockMenuView changeMenuItemState:tag];
    }
    else
    {
        [mScrollDockMenuView changeMenuItemState:tag];
           [mDockMenuView changeMenuItemState:tag];
//        [mScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
}

- (void)viewDidLoad
{
//    view1.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self getMoreLikers];
//    }];
//    UIImageView *imgView = [[UIImageView alloc]init];
//    
//    if (self.modle.pictures.count != 0) {
//        for (SMPictures *pic in self.modle.pictures) {
//            [imgView sd_setImageWithURL:[NSURL URLWithString:pic.url]];
//        }
//        
//    }else {
//        [imgView sd_setImageWithURL:[NSURL URLWithString:self.modle.map.snapshot]];
//    }
//    
//    self.collectimage = imgView.image;
    
    [super viewDidLoad];
    
    self.title = @"详情";

     [self setToolBtn];
    
    [self setDetailData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStylePlain target:self action:@selector(someShare)];
    
    //     远程推送的情况
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(guanbi)];
    }
//    if (DEVICE_3_5_INCH) {
//        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
//    }
//    else
//    {
//        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
//    }
    
    if (![self.modle.type isEqualToString:@"long"]) {
        
       
        [self getFavorsData];
        [self getLikers];
        [self getrepliesData];
        
        [self addBackgroundScrollView];
        [self addBackgroundScrollViewSubViews];
        [self addMenuViews];
        
        [self ChangeDockMenuSubViews:1];
        [mScrollDockMenuView changeMenuItemState:101];
        [mDockMenuView changeMenuItemState:101];
        
     
    }else
    {
        return;
    }
    
 
}

-(void)guanbi
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)coverClick
{
    _window.hidden  =  YES;
}
-(void)clickZan
{
      _window.hidden  =  YES;
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    if (!account) {
        
        _window.hidden  =  YES;
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:logVc];
            [self presentViewController:nav animated:YES completion:nil];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/like",self.modle.Lid];
    
    [manager POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.isZan = YES;
        if ([responseObject[@"status"]  isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"您已赞"];
        }
        SMLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}

-(void)clickShoucang
{
    _window.hidden  =  YES;
    SMAccount *account = [SMAccount accountFromSandbox];
    
    if (!account) {
        _window.hidden  =  YES;
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:logVc];
            [self presentViewController:nav animated:YES completion:nil];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        

        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/favor",self.modle.Lid];
    
    [manager POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.isFover = YES;
        if ([responseObject[@"status"]  isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"您已收藏"];
        }
        SMLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];

}
//点击复制
-(void)clickCopy
{
     _window.hidden  =  YES;
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString *string =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.modle.Lid];
    
    [pab setString:string];
    
    if (pab == nil) {
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
        
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"已复制地图链接"];
    }
    
   
}


// 分享到微信
-(void)shareToWechat
{
    
    if (self.modle.map.map_id) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.modle.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.modle.Lid];
    }
        _window.hidden  =  YES;
  
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.modle.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
           
            SMLog(@"分享成功！");
        }
    }];

}

// 分享到朋友圈
-(void)shareToWechatZone
{
    
    
    if (self.modle.map.map_id) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.modle.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.modle.Lid];
    }
        _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.modle.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
        }
    }];

}
//   分享到新浪微博
-(void)shareToSinaBlog
{
     _window.hidden  =  YES;
    [[UMSocialControllerService defaultControllerService] setShareText:self.modle.body shareImage:self.collectCell.photoView.image socialUIDelegate:self];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
   
}


// 分享到QQ空间
-(void)shareToQQZone
{
    if (self.modle.map.map_id) {
        [UMSocialData defaultData].extConfig.qzoneData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.modle.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.qzoneData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.modle.Lid];
    }

  
         _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.modle.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
        }
    }];
}

-(void)shareToQQ
{
    if (self.modle.map.map_id) {
        [UMSocialData defaultData].extConfig.qqData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.modle.map.map_id];
    }else
    {
        [UMSocialData defaultData].extConfig.qqData.url =[NSString stringWithFormat:@"http://club.dituhui.com/t/%@",self.modle.Lid];
    }
    _window.hidden  =  YES;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.modle.body image:self.collectCell.photoView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            SMLog(@"分享成功！");
            
        }
    }];
}


static UIWindow *_window;
-(void)someShare
{
    // 1.创建window
    _window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.hidden = NO;
    _window.windowLevel = UIWindowLevelAlert;
    
    // 2.创建蒙版
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //将蒙版添加到window上
    [_window addSubview:cover];
    
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 257, kWidth, 257)];
    coverView.backgroundColor = [UIColor clearColor];
    //    [cover addSubview:coverView];
    [_window addSubview:coverView];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 257 - 44 -8, kWidth, 44 +8)];
    cancel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
//    cancel.titleLabel.textColor = [UIColor redColor];
    
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    [cancel addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:cancel];
    
    /* ************************************** */
    UIScrollView *scr1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 257 - 64- 96,kWidth,96)];
    scr1.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    //  ////////////////////////////////////////////////
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 60;
    CGFloat btnMagin = 20;
    CGFloat btnYMagin = 8;

    //////////点赞
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin, btnYMagin, btnWidth, btnHeight)];
    
    UILabel *laber1 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin, btnYMagin +btnHeight, btnWidth, 20)];
    laber1.text = @"点赞";
    laber1.font = [UIFont systemFontOfSize:14];
    laber1.textAlignment = NSTextAlignmentCenter;
    
    [btn1 addTarget:self action:@selector(clickZan) forControlEvents:UIControlEventTouchUpInside];
    if (self.isZan) {
        [btn1 setImage:[UIImage imageNamed:@"share_like"] forState:UIControlStateNormal];
    }else
    {
        [btn1 setImage:[UIImage imageNamed:@"don'tlike"] forState:UIControlStateNormal];
    }
    [scr1 addSubview: btn1];
    [scr1 addSubview:laber1];
    ///////////////////////////////////////////////////
    /////收藏
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin*2 + btn1.width , btnYMagin, btnWidth, btnHeight)];
    UILabel *laber2 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *2 +btn1.width, btnYMagin + btnHeight, btnWidth, 20)];
    laber2.text = @"收藏";
    laber2.textAlignment = NSTextAlignmentCenter;
    laber2.font = [UIFont systemFontOfSize:14.0f];
    
    if (self.isFover) {
        [btn2 setImage:[UIImage imageNamed:@"share_collect_press"] forState:UIControlStateNormal];
    }else
    {
        [btn2 setImage:[UIImage imageNamed:@"nocollect"] forState:UIControlStateNormal];
    }
    
    [btn2 addTarget:self action:@selector(clickShoucang) forControlEvents:UIControlEventTouchUpInside];
    [scr1 addSubview:btn2];
    [scr1 addSubview:laber2];
    
    ////复制链接
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin*3 +btn1.width *2, btnYMagin,btnWidth, btnHeight)];
    UILabel *laber3 = [[UILabel alloc] initWithFrame:CGRectMake(btnMagin*3 +btn1.width *2, btnYMagin + btnHeight, btnWidth, 20)];
    laber3.text = @"复制链接";
    laber3.textAlignment = NSTextAlignmentCenter;
    laber3.font = [UIFont systemFontOfSize:14];
    
    [btn3 setImage:[UIImage imageNamed:@"share_copy"] forState:UIControlStateNormal];
    
//    [btn3 setImage:[UIImage imageNamed:@"share_copy_press"] forState:UIControlStateHighlighted];
    [btn3 addTarget:self action:@selector(clickCopy) forControlEvents:UIControlEventTouchUpInside];
    [scr1 addSubview:btn2];
    [scr1 addSubview:btn3];
    [scr1 addSubview:laber3];
    
    scr1.userInteractionEnabled = YES;
    scr1.contentSize = CGSizeMake(kWidth , 96);
    
    
    /* ************************************** */
    
    UIScrollView *scr2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , kWidth, 96)];
    
    scr2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    加条线
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 97 ,kWidth, 1)];
    view.backgroundColor = [UIColor blackColor];
    
    [scr2 addSubview:view];
    
    [coverView addSubview:scr1];
    [coverView addSubview:scr2];
    
    //    [_window addSubview:scr2];
    //    [self.mapView addSubview:scr2];

    //////////分享到微信
    UIButton *Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin , btnYMagin , btnWidth, btnHeight)];
    UILabel *Laber2 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin, btnYMagin + btnWidth, btnWidth, 20)];
    Laber2.text = @"微信";
    Laber2.textAlignment = NSTextAlignmentCenter;
    Laber2.font = [UIFont systemFontOfSize:14];
    
    [Btn2 setImage:[UIImage imageNamed:@"share_weichat"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn2];
    [scr2 addSubview:Laber2];
    
    [Btn2 addTarget:self action:@selector(shareToWechat) forControlEvents:UIControlEventTouchUpInside];
    
    //////////分享到朋友圈
    
    UIButton *Btn3 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin*2 +btnWidth , btnYMagin ,btnWidth, btnHeight)];
    
    UILabel *Laber3 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin*2 +btnWidth , btnYMagin + btnWidth, btnWidth, 20)];
    
    Laber3.text = @"朋友圈";
    Laber3.textAlignment = NSTextAlignmentCenter;
    Laber3.font = [UIFont systemFontOfSize:14];
    
    
    [Btn3 setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn3];
    [scr2 addSubview:Laber3];
    
    
    
    [Btn3 addTarget:self action:@selector(shareToWechatZone) forControlEvents:UIControlEventTouchUpInside];
    //////////////////分享到微博
    UIButton *Btn4 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *3 +btnWidth *2, btnYMagin, btnWidth,btnHeight)];
    
    UILabel *Laber4 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *3 +btnWidth *2, btnYMagin + btnWidth, btnWidth, 20)];
    Laber4.text = @"微博";
    Laber4.textAlignment = NSTextAlignmentCenter;
    Laber4.font = [UIFont systemFontOfSize:14];
    
    [Btn4 setImage:[UIImage imageNamed:@"share_weibo"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn4];
    [scr2 addSubview:Laber4];
    
    [Btn4 addTarget:self action:@selector(shareToSinaBlog) forControlEvents:UIControlEventTouchUpInside];
    ///////////////分享到qq空间
    if ([QQApiInterface  isQQInstalled]) {
        UIButton *Btn5 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *4+ btnWidth *3, btnYMagin, btnWidth,btnHeight)];
        UILabel *Laber5 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *4+ btnWidth *3, btnYMagin + btnWidth, btnWidth, 20)];
        Laber5.text = @"QQ空间";
        Laber5.textAlignment = NSTextAlignmentCenter;
        Laber5.font = [UIFont systemFontOfSize:14];
        
        [Btn5 setImage:[UIImage imageNamed:@"share_qqzone"] forState:UIControlStateNormal];
        [scr2 addSubview:Btn5];
        [scr2 addSubview:Laber5];
        
        [Btn5 addTarget:self action:@selector(shareToQQZone) forControlEvents:UIControlEventTouchUpInside];
        
     
    }
    if ([QQApiInterface  isQQInstalled]) {
        UIButton *Btn6 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin, btnWidth,btnHeight)];
        UILabel *Laber6 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin + btnWidth, btnWidth, 20)];
        Laber6.text = @"QQ";
        Laber6.textAlignment = NSTextAlignmentCenter;
        Laber6.font = [UIFont systemFontOfSize:14];
        
        [Btn6 setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
        [scr2 addSubview:Btn6];
        [scr2 addSubview:Laber6];
        
        [Btn6 addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    scr2.userInteractionEnabled = YES;
    scr2.contentSize = CGSizeMake(kWidth +20 +btnWidth, 96);
    /* ************************************** */
    // 6.显示菜单
    _window.hidden = NO;
    

}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    
    if (self.isneedset) {
        
        [self ChangeDockMenuSubViews:1];
        [mScrollDockMenuView changeMenuItemState:101];
        [mDockMenuView changeMenuItemState:101];
        
        if (self.detailViewHeight.constant +64 +40 >= kHeight) {
            [mScrollView setContentOffset:CGPointMake(0, mScrollDockMenuView.frame.origin.y - 64) animated:YES];
        }
        
     
    }
    
    if (self.isneedZan) {
        [self ChangeDockMenuSubViews:0];
        [mScrollDockMenuView changeMenuItemState:100];
        [mDockMenuView changeMenuItemState:100];
        
        [mScrollView setContentOffset:CGPointMake(0, mScrollDockMenuView.frame.origin.y - 64) animated:YES];
        
    }
    
}

//设置下部工具条

-(void)setToolBtn
{
    //    UIButton *zanBtn = [[UIButton alloc] init];
    ////    zanBtn.backgroundColor = [UIColor greenColor];
    //    zanBtn.frame = CGRectMake(0, self.view.height - 44, self.view.width/2, 44);
    //    [self.view addSubview:zanBtn];
    //    self.zanBtn = zanBtn;
    //    [zanBtn setImage:[UIImage imageNamed:@"cell_zan"] forState:UIControlStateNormal];
    //    [zanBtn setBackgroundImage:[UIImage imageNamed:@"bg-1"] forState:UIControlStateNormal];
    //    zanBtn.backgroundColor = [UIColor whiteColor];
    //    [zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    //##########################################################
    //    UIButton *pingBtn = [[UIButton alloc] init];
    //    pingBtn.backgroundColor = [UIColor whiteColor];
    //    pingBtn.frame = CGRectMake(self.view.width/2, self.view.height - 44, self.view.width/2, 44);
    //    [self.view addSubview:pingBtn];
    //    self.pinglunBtn = pingBtn;
    //
    //    [pingBtn setImage:[UIImage imageNamed:@"cell_pinglun"] forState:UIControlStateNormal];
    //    [pingBtn setBackgroundImage:[UIImage imageNamed:@"bg-1"] forState:UIControlStateNormal];
    //
    //    [pingBtn addTarget:self action:@selector(pinglun:) forControlEvents:UIControlEventTouchUpInside];
    //       //##########################################################
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,kHeight-45, self.view.width, 45)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self.view addSubview:view];
    
    
    
    UIButton *emoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, 44, 44)];
    
    [emoBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    [emoBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    
    [emoBtn addTarget:self action:@selector(didclickEmoBtn) forControlEvents:UIControlEventTouchUpInside];
    emoBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:emoBtn];
     self.emojiBtn = emoBtn;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(44, 1, 44, 44)];
    
    [btn setImage:[UIImage imageNamed:@"compose_mentionbutton_background"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(didclickmentionbutton) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:btn];
    
   
    
    
    
    
    
    ///////////
    UITextField *inputView = [[UITextField alloc]initWithFrame:CGRectMake(88, 1, self.view.width -60 -44 -44, 44)];
    //    inputView.delegate = self;
    
    inputView.placeholder = @"快速评论";
    inputView.backgroundColor = [UIColor whiteColor];
    self.inputTextView = inputView;
    
    [view addSubview:inputView];
    
    
    ///////////
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - 60, 1,60, 44)];
    
    [btn2 setTitle:@"评论" forState:UIControlStateNormal];
    
    btn2.backgroundColor = [UIColor orangeColor];
    
    
    [btn2 addTarget:self action:@selector(didClickPinglun) forControlEvents:UIControlEventTouchDown];
    btn2.enabled = NO;
    self.btn2 = btn2;
    [view addSubview:btn2];
    
    self.pinglunBarView = view;
    // 监听键盘的弹出和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldShouldBeginEditing) name:UITextFieldTextDidChangeNotification object:nil];
    
    
 
    
}

-(CoreEmotionView *)emotionView{
    
    if(_emotionView==nil){
        _emotionView = [CoreEmotionView emotionView];
    }
    
    return _emotionView;
}
/*
 *  视图准备
 */
-(void)viewPrepare{
    
    self.emotionView.textField=self.inputTextView;
    
    //设置代理
    self.inputTextView.delegate=self;
//    //监听通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNoti:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}



/*
 *  事件
 */
-(void)event{
    
    //删除按钮点击事件
    __weak typeof(self) weakSelf=self;
    self.emotionView.deleteBtnClickBlock=^(){
        
        [weakSelf.inputTextView deleteBackward];
    };
}

/**
 *  点击了表情按钮
 */
-(void)didclickEmoBtn
{
    
    //视图准备
    [self viewPrepare];
    
    //事件
    [self event];
    
    [self.inputTextView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.inputTextView.inputView=self.inputTextView.inputView?nil:self.emotionView;
        
    
        
        [self.inputTextView becomeFirstResponder];
    });
    if (!self.inputTextView.inputView) {
        [self.emojiBtn setImage:[UIImage imageNamed:@"face_jianpan"] forState:UIControlStateNormal];
    }else
    {
        [self.emojiBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    }
    
}
-(void)textFieldShouldBeginEditing
{  
    self.btn2.enabled = (self.inputTextView.text.length > 0);
}




-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)keyboardDidShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘高度
    CGFloat keyboardHeigth = keyboardFrame.size.height;
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.pinglunBarView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeigth);
    } completion:nil];
}

- (void)keyboardDidHide:(NSNotification *)note
{
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.pinglunBarView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 关闭键盘
    [self.view endEditing:YES];
}

-(void)didClickPinglun
{
    SMAccount *account = [SMAccount accountFromSandbox];
    
    if (account == nil) {
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
//            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:logVc];
            [self presentViewController:nav animated:YES completion:nil];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;

    }else{
    
    [SVProgressHUD showWithStatus:@"正在发布评论"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"body"] = self.inputTextView.text;
    parameters[@"message_id"] = self.modle.Lid;
    
    // 2.发送请求
    
    NSString *url = @"http://club.dituhui.com/api/v2/replies";
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 0.关闭键盘
        [self.view endEditing:YES];
        
        //        1.清空评论文字
        self.inputTextView.text = nil;
        self.btn2.enabled = NO;
        
        // 2.弹出提示用户
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
        [self didFinishPinglun];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论失败"];
        
    }];
        
    }
}
//点击了 @关联按钮
-(void)didclickmentionbutton
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMLikeFirends" bundle:nil];
    SMLikeFridensTableViewController *mentionVc = [sb instantiateInitialViewController];
    
    mentionVc.delegate = self;
    
    //
    SMNavgationController *nav = [[SMNavgationController alloc] init];
    
    [nav addChildViewController:mentionVc];
    
    
    // 3.弹出授权控制器
    [self presentViewController:nav animated:YES completion:nil];
}

//点击@好友 的回调
-(void)didClickdidSelectWithLikerName:(NSString *)name
{
    self.inputTextView.placeholder = nil;
    self.inputTextView.text = [NSString stringWithFormat:@"%@ @%@", self.inputTextView.text, name];
}



//-(void)pinglun:(UIButton *)btn
//{
//
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Pinglun" bundle:nil];
//    SMPingLunViewController *pinglunVc = [sb instantiateInitialViewController];
//
//    pinglunVc.delegate = self;
//    pinglunVc.modle = self.modle;
//    //
//    SMNavgationController *nav = [[SMNavgationController alloc] init];
//
//    [nav addChildViewController:pinglunVc];
//
//
//    // 3.弹出授权控制器
//    [self presentViewController:nav animated:YES completion:nil];
//
//
//}


////点赞后处理方法
//-(void)zanBtn:(UIButton *)btn
//{
//    if (self.modle.has_liked) {
//        [SVProgressHUD showErrorWithStatus:@"您已赞过"];
//        return;
//    }
//    SMAccount *acount = [SMAccount accountFromSandbox];
//    if (!acount) {
//
//        _window.hidden  =  YES;
//        [SVProgressHUD showErrorWithStatus:@"您尚未登陆"];
//
//        return ;
//    }
//
//    [self.zanBtn setImage:[UIImage imageNamed:@"cell_zan_press"] forState:UIControlStateNormal];
//
//    // 收藏post请求
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    SMAccount *account = [SMAccount accountFromSandbox];
//
//    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
//
//
//    NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/like",self.modle.Lid];
//
//
//
//    [manager POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        self.modle.likes_count = [NSString stringWithFormat:@"%i",(self.modle.likes_count.intValue +1)];
//        self.modle.has_liked = YES;
//
////        [self.zanBtn setTitle:self.modle.likes_count forState:UIControlStateNormal];
//
//        [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        SMLog(@"%@",error);
//    }];
//
//}
//



//-(void)close
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//添加ScrollView用来显示所有的内容
-(void) addBackgroundScrollView
{
    [mScrollView setDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    mScrollView.delegate = nil;
}
// 否则出现三条在上面常驻
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    mScrollView.delegate = self;
}

//给scrollView添加内容
-(void) addBackgroundScrollViewSubViews
{
    
    
    //    mScrollDockMenuView  = [[DockMenuView alloc]initWithFrame:mScrollDockMenuView.frame];
    //
    
    mScrollDockMenuView.mDockMenuItemDelegate = self;
    
    NSMutableArray *array =  [self setStringItemTitle];
    
    [mScrollDockMenuView setMenuItemData:array];
    
    [mScrollDockMenuView changeMenuItemState:K_MENUITEM_DEFAULT];
    //    [self.mScrollView addSubview:mScrollDockMenuView];
    
    
    [self addDockMenuSubViews_ProductDisplay];
    [self addDockMenuSubViews_BrandPrice];
    [self addDockMenuSubViews_InvestDetails];
    
}

// 设置三个上面的数字
-(NSMutableArray *)setStringItemTitle
{
    NSString *str = self.modle.likes_count;
    if ([str isEqualToString:@"0"]) {
        str = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    NSString *strZan = [NSString stringWithFormat:@"赞 %@",str];
    
    
    NSString *str2 = self.modle.replies_count;
    
    if ([str2 isEqualToString:@"0"]) {
        str2 = [str2 stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    NSString *pingBtn = [NSString stringWithFormat:@"评论 %@",str2];
    
    
    
    NSString *str3 = self.modle.favors_count;
    
    if ([str3 isEqualToString:@"0"]) {
        str3 = [str3 stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    NSString *favorsBtn = [NSString stringWithFormat:@"收藏 %@",str3];
    
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:strZan,pingBtn,favorsBtn, nil];
    
    return array;
}

//给窗口添加和scrollView中的菜单一样的试图，用于覆盖scrollView中的菜单，来达到菜单停靠的效果
-(void) addMenuViews
{
    mDockMenuView  = [[DockMenuView alloc]initWithFrame:CGRectMake(0, 64, mScrollDockMenuView.frame.size.width, mScrollDockMenuView.frame.size.height)];
    [mDockMenuView setHidden:YES];
    
    mDockMenuView.mDockMenuItemDelegate = self;
    
    NSMutableArray *array = [self setStringItemTitle];
    
    [mDockMenuView setMenuItemData:array];
    
    [mDockMenuView changeMenuItemState:K_MENUITEM_DEFAULT];
    
    
    [self.view addSubview:mDockMenuView];
}

//根据scrollView滚动de偏移量来控制窗口菜单的显示与否
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    mScrollViewOffsetY = scrollView.contentOffset.y;
    
    if (mScrollViewOffsetY < mScrollDockMenuView.frame.origin.y - 64) {
        
        [mDockMenuView setHidden:YES];
        
    }
    else
    {
        [mDockMenuView setHidden:NO];
    }
    
}



//添加点赞视图
-(void) addDockMenuSubViews_ProductDisplay
{
    
    //    view1 = [[DockMenuSubView alloc]initWithFrame:CGRectMake(0, mScrollDockMenuView.y+ mScrollDockMenuView.height +10, kWidth, 400)];
    
    view1 =[[DockMenuSubView alloc]initWithFrame:CGRectMake(0, self.detailViewHeight.constant + 50 , kWidth, 400)];
    
    
    
    [mScrollView addSubview:view1];
    
    //    CGRect rect= view1.frame;
    //
    //    //设置view1 的frame
    //    rect.size.height = view1.frame.origin.y+view1.frame.size.height+10;
    //
    //    [view1 setFrame:rect];
    
    
    
    view1.delegate = self;
    view1.dataSource = self;
    
    //    view1.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self getMoreLickers];
    //
    //    }];
    
}


//添加评论
-(void) addDockMenuSubViews_BrandPrice
{
    
    view2 = [[DockMenuSubView alloc]initWithFrame:CGRectMake(0, self.detailViewHeight.constant + 50, kWidth, 400)];
    [mScrollView addSubview:view2];
    
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWidth, 300)];
    //    [label setBackgroundColor:[UIColor blueColor]];
    //    [label setTextAlignment:NSTextAlignmentCenter];
    //    [label setText:@"menu2"];
    
    
    ////    重新设置frame 可以不用tableview单独交互
    //    CGRect rect= view2.frame;
    //    rect.size.height = view2.frame.origin.y+view2.frame.size.height+10;
    //    [view2 setFrame:rect];
    //    [view2 addSubview:label];
    
    
    
    
    [view2 setHidden:YES];
    
    
    //    UIView *view =[ [UIView alloc]init];
    //
    //    view.backgroundColor = [UIColor clearColor];
    //
    //    [view2 setTableFooterView:view];
    //
    
    view2.dataSource = self;
    view2.delegate = self;
}

//添加收藏
-(void) addDockMenuSubViews_InvestDetails
{
    view3 = [[DockMenuSubView alloc]initWithFrame:CGRectMake(0, self.detailViewHeight.constant + 50, kWidth, 400)];
    [mScrollView addSubview:view3];
    
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kWidth, 40)];
    //    [label setBackgroundColor:[UIColor orangeColor]];
    //    [label setTextAlignment:NSTextAlignmentCenter];
    //    [label setText:@"menu3"];
    //
    //    CGRect rect= view3.frame;
    //    rect.size.height = view3.frame.origin.y+view3.frame.size.height+10;
    //    [view3 setFrame:rect];
    //
    //    [view3 setHidden:YES];
    
    view3.dataSource = self;
    view3.delegate = self;
}

//点击dockMenuItem后切换视图
-(void) ChangeDockMenuSubViews:(int) currentIndex
{
    switch (currentIndex) {
        case 0:
        {
            if (view2 != nil && ![view2 isHidden]) {
                [view2 setHidden:YES withDirection:NO];
            }
            if (view3 != nil && ![view3 isHidden]) {
                [view3 setHidden:YES withDirection:NO];
            }
            if (view1 != nil && [view1 isHidden]) {
                [view1 setHidden:NO withDirection:NO];
                //            [mScrollView setContentSize:CGSizeMake(kWidth, self.detailViewHeight.constant + view1.contentSize.height +74)];
                CGRect frame = view1.frame;
                frame.size.height = view1.contentSize.height;
                [view1 setFrame:frame];
                
                self.contentSizeHeight.constant = view1.y +view1.height +64;
            }
        }
            break;
        case 1:
        {
            if (view1 != nil && ![view1 isHidden]) {
                [view1 setHidden:YES withDirection:YES];
                
                if (view2 != nil) {
                    [view2 setHidden:NO withDirection:YES];
                    CGRect frame = view2.frame;
                    frame.size.height = view2.contentSize.height;
                    [view2 setFrame:frame];
                    
                    self.contentSizeHeight.constant = view2.y +view2.height +64;
                }
            }
            if (view3 != nil && ![view3 isHidden]) {
                [view3 setHidden:YES withDirection:NO];
                
                if (view2 != nil) {
                    [view2 setHidden:NO withDirection:NO];
                    //                   [mScrollView setContentSize:CGSizeMake(kWidth, self.detailViewHeight.constant + view2.contentSize.height +74)];
                    CGRect frame = view2.frame;
                    frame.size.height = view2.contentSize.height;
                    [view2 setFrame:frame];
                    
                    self.contentSizeHeight.constant = view2.y +view2.height +64;
                }
            }
        }
            break;
        case 2:
        {
            if (view1 != nil && ![view1 isHidden]) {
                [view1 setHidden:YES withDirection:YES];
            }
            if (view2 != nil && ![view2 isHidden]) {
                [view2 setHidden:YES withDirection:YES];
            }
            if (view3 != nil && [view3 isHidden]) {
                [view3 setHidden:NO withDirection:YES];
                //            [mScrollView setContentSize:CGSizeMake(kWidth, self.detailViewHeight.constant + view3.contentSize.height +74)];
                CGRect frame = view3.frame;
                frame.size.height = view3.contentSize.height;
                [view3 setFrame:frame];
                
                self.contentSizeHeight.constant = view3.y +view3.height +64;
            }
        }
            break;
        default:
            break;
    }
}

-(void)didClickUrl:(SMNavgationController *)nav
{
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)didclickrenWu:(UIViewController *)rootVc
{
    [self.navigationController pushViewController:rootVc animated:YES];
}
-(void)didClickHuati:(UITableViewController *)huatiVc
{
    [self.navigationController pushViewController:huatiVc animated:YES];
}

#pragma mark -- 正则代理方法
-(void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
            
        case MLEmojiLabelLinkTypeURL:
        {
            
            NSString *url = link ;

            
            NSString *str = @"dituhui.com";
            
            if ([url rangeOfString:str].location != NSNotFound) {
                
                NSArray *strArr = [url componentsSeparatedByString:@"/maps/"];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                
                SMAccount *account = [SMAccount accountFromSandbox];
                
                [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
                [manager GET:[NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@.json",strArr[1]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    SMLog(@"%@",strArr[1]);
                    SMCreatMap *mapmodel = [SMCreatMap objectWithKeyValues:responseObject[@"info"]];
                    
                    if ([mapmodel.app_name rangeOfString:@"MARKER"].location == NSNotFound && [mapmodel.app_name rangeOfString:@"LINE"].location == NSNotFound) {
                        SMWebVc *webVc = [[UIStoryboard storyboardWithName:@"SMWebVc" bundle:nil]instantiateInitialViewController];
                        webVc.url = link;
                        
                        SMNavgationController *nav = [[SMNavgationController alloc]init];
                        [nav addChildViewController:webVc];
                        [self presentViewController:nav animated:YES completion:nil];
                    }else{
                    SMMapViewController *mapViewVC = [[UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil]instantiateInitialViewController];
                    mapViewVC.mapModel = mapmodel;
                    
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:mapViewVC];
                    
                    [self presentViewController:nav animated:YES completion:nil];
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络异常"];
                }];
            }else{
                
            SMWebVc *webVc = [[UIStoryboard storyboardWithName:@"SMWebVc" bundle:nil]instantiateInitialViewController];
            webVc.url = link;
                
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:webVc];
            [self presentViewController:nav animated:YES completion:nil];
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
                vc.isNeedShow = YES;
                [self.navigationController pushViewController:vc animated:YES];
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
            SMLog(@"-----string----%@",str1);
//            [self.navigationController pushViewController:vc animated:YES];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
            break;
        default:
            SMLog(@"点击了不知道啥%@",link);
            break;
    }
}

//加载完成后布局
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//       [self setToolBtn];
    
        float height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
//       SMLog(@"%f",height);
    
            self.webViewHeight.constant = height;
    
            self.detailViewHeight.constant = self.detailViewHeight.constant - 350 +self.webViewHeight.constant;
//    self.detailViewHeight.constant = 1000;
    [self getFavorsData];
    [self getLikers];
    [self getrepliesData];
    
    [self addBackgroundScrollView];
    [self addBackgroundScrollViewSubViews];
    [self addMenuViews];
    
    [self ChangeDockMenuSubViews:1];
    [mScrollDockMenuView changeMenuItemState:101];
    [mDockMenuView changeMenuItemState:101];
}

/**
 *  设置详情页帖子数据
 */
-(void)setDetailData
{
//    长文图文混排情况
    if ([self.modle.type  isEqualToString: @"long"]) {
//        杂项
        self.user_name.text = self.modle.user.login;
        
        //    SMLog(@"%@",self.modle.created_at);
        //用户头像
        [self.user_image sd_setImageWithURL:[NSURL URLWithString:self.modle.user.avatar] forState:UIControlStateNormal];
        
        
        //发布时间
        [self.fireTime setTitle:self.modle.created_at forState:UIControlStateNormal];
        
        //    [self.fireTime setImage:[UIImage imageNamed:@"information_time"] forState:UIControlStateNormal];
        
        self.collectView.backgroundColor = [UIColor whiteColor];
        
//         正格的
        [self.textLaber removeFromSuperview];
        [self.collectView removeFromSuperview];
        
        self.webView.hidden = NO;

        
//      添加标题
          NSString *body = [NSString stringWithFormat:@"<div style=\"font:黑体:color:#000000:font-size:80px\">%@</div>%@",self.modle.title,self.modle.body];
        
        NSString *urlStr = [NSString stringWithFormat:@"<html><head><style type='text/css'>img{max-width: 100%%;}.breakword {\nwhite-space: pre-line;\nword-wrap: break-word;\nword-break: break-word;}</style></head><body><div style='width:100%%;'>%@</div></body></html>",body];
           self.webView.delegate = self;
        [self.webView loadHTMLString:urlStr baseURL:nil];
     
//          CGFloat documentHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];

//        CGRect frame = _webView.frame;
//        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
//        frame.size = fittingSize;
//        _webView.frame = frame;
        
//                float height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
//        
//        SMLog(@"------%f",height);
//        self.webViewHeight.constant = 1109;
//////
////        [self.webView setHeight:1109 ];
//        self.detailViewHeight.constant = self.detailViewHeight.constant - 350 +1109;

        
    }else{
    //描述文字
    self.textLaber.text = self.modle.body;
    self.textLaber.delegate = self;
    self.textLaber.isNeedAtAndPoundSign = YES;
        self.textLaber.font = [UIFont systemFontOfSize:14];
    CGSize messageSize = [self.textLaber sizeThatFits:CGSizeMake(kWidth -20, MAXFLOAT)];
    [self.textLaber setPreferredMaxLayoutWidth:kWidth-20];
    
    self.textHeight.constant = messageSize.height +10;
    
    
    //用户名
    self.user_name.text = self.modle.user.login;
    
    //    SMLog(@"%@",self.modle.created_at);
    
    //用户头像
    [self.user_image sd_setImageWithURL:[NSURL URLWithString:self.modle.user.avatar] forState:UIControlStateNormal];
    
    
    //发布时间
    [self.fireTime setTitle:self.modle.created_at forState:UIControlStateNormal];
    
    //    [self.fireTime setImage:[UIImage imageNamed:@"information_time"] forState:UIControlStateNormal];
    
    self.collectView.backgroundColor = [UIColor whiteColor];
    
    
    
//    有无图片 图片类型各种情况的布局
    if (self.modle.map.snapshot != nil) {
        self.detailViewHeight.constant = 500 + self.textHeight.constant + self.collectHeight.constant -300 -40;
    }
    
    if(self.modle.pictures.count != 0){
        
        
        if (self.modle.pictures.count ==1) {
            
            self.detailViewHeight.constant = 500 + self.textHeight.constant +self.collectHeight.constant -300 -40;
        }else{
            
            NSUInteger count = self.modle.pictures.count;
            // 有配图, 几张? 几行?
            // 1.计算行数
            NSUInteger row = 0;
            if(count % 3 == 0 )
            {
                row = count /  3;
            }else
            {
                row = count / 3 + 1;
            }
            
            CGFloat photoMargin = 3.0;
            
            CGFloat photoHeight = 0.0;
            if (count ==4) {
                photoHeight = ((kWidth -10) - photoMargin) / 2;
            }else if(count == 2)
            {
                photoHeight = ((kWidth -10) - photoMargin) / 2;
            }
            else
            {
                photoHeight = ((kWidth -10)- 2*photoMargin) / 3;
            }
            
            CGFloat photosHeight = row * photoHeight + (row - 1) * photoMargin;
            self.collectHeight.constant = photosHeight;
            
            
            self.detailViewHeight.constant = 500 +self.collectHeight.constant -300 +self.textHeight.constant - 40;
        }
    }
    if (self.modle.pictures.count == 0 && self.modle.map.snapshot == nil)
    {
        //        self.detailViewHeight.constant -=self.collectHeight.constant;
        
        self.collectHeight.constant = 0;
        self.detailViewHeight.constant = 500 - 300 +self.textHeight.constant - 40  ;
    }
        
    }
//    有标签情况
    if (self.modle.tags.count != 0) {
        [self.markLaber setImage:[UIImage imageNamed:@"create_tag"] forState:UIControlStateNormal];
        
        NSMutableString *strArr = [[NSMutableString alloc]init];
        for (NSString *str in self.modle.tags) {
            [strArr appendString:@" "];
            [strArr appendString:str];
            [strArr appendString:@" "];
        }
        [self.markLaber setTitle:strArr forState:UIControlStateNormal];
    }else
    {
        self.detailViewHeight.constant = self.detailViewHeight.constant - self.markLaber.height;
        [self.markLaber removeFromSuperview];
    }
//    有地址情况
    if (self.modle.address) {
        [self.locationLaber setImage:[UIImage imageNamed:@"create_location"] forState:UIControlStateNormal];
        [self.locationLaber setTitle:self.modle.address forState:UIControlStateNormal];
        
    }else
    {
        self.detailViewHeight.constant = self.detailViewHeight.constant - self.locationLaber.height;
        [self.locationLaber removeFromSuperview];
    }
}
    

/**
 *  判断为图片贴进入大图
 *
 */
#pragma mark - 九宫格数据和代理方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.modle.map.snapshot) {
        return 1;
    }else if(self.modle.pictures.count != 0){
        return self.modle.pictures.count;
    }else
    {
        return 0;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    SMLog(@"%@",self.status.pictures);
    
    SMPhotoCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    self.collectCell = cell;
    
    //      SMLog(@"%@",self.status);
    
    if (self.modle.map.snapshot != nil) {
        
//        cell.photo = self.modle.map.snapshot;
        
        NSString *strUrl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",self.modle.map.snapshot];
        
        cell.photo = strUrl;
        
        //        self.collectHeight.constant = 200;
        
        cell.width = self.collectView.width;
        cell.height = 300;
        cell.photoView.contentMode =  UIViewContentModeScaleAspectFill;
        
        cell.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        cell.photoView.clipsToBounds  = YES;
        

        //    self.detailViewHeight.constant = 500 + self.textHeight.constant + self.collectHeight.constant -300 -40;
        
        if ([self.modle.map.app isEqual:@"marker"]||[self.modle.map.app isEqualToString:@"marker_zone"] || [self.modle.map.app isEqualToString:@"line"]) {
            
            UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"events map"]];
            CGFloat w = 55;
            CGFloat h = 24;
            //            self.picture 没生成出来会造成标签图片位移
            imageview.frame = CGRectMake(cell.width -w , 0, w, h);
            [cell addSubview:imageview];
            
        }
    }
    
    if(self.modle.pictures.count != 0){
        
        SMPictures *pic = self.modle.pictures[indexPath.item];
        
//        cell.photo = pic.url;
        
        cell.photo = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
        
        if (self.modle.pictures.count ==1) {
            
            cell.width = self.collectView.width;
            cell.height = 300;
            //            self.collectHeight.constant = 200;
            //        self.detailViewHeight.constant = 500 + self.textHeight.constant +self.collectHeight.constant -300 -40;
            cell.photoView.contentMode =  UIViewContentModeScaleAspectFill;
            
            cell.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            
            cell.photoView.clipsToBounds  = YES;
            

        }else{
            
            NSUInteger count = self.modle.pictures.count;
            // 有配图, 几张? 几行?
            // 1.计算行数
            NSUInteger row = 0;
            if(count % 3 == 0 )
            {
                row = count /  3;
            }else
            {
                row = count / 3 + 1;
            }
            
            CGFloat photoMargin = 3.0;
            
            CGFloat photoHeight = 0.0;
            if (count ==4) {
                photoHeight = ((kWidth -10) - photoMargin) / 2;
            }else if(count == 2)
            {
                photoHeight = ((kWidth -10) - photoMargin) / 2;
            }
            else
            {
                photoHeight = ((kWidth -10)- 2*photoMargin) / 3;
            }
            
            cell.width = photoHeight;
            cell.height = photoHeight;
            cell.photoView.contentMode =  UIViewContentModeScaleAspectFill;
            
            cell.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            
            cell.photoView.clipsToBounds  = YES;
            

            self.collectLayout.itemSize = cell.size;
            self.collectLayout.minimumLineSpacing = photoMargin;
            self.collectLayout.minimumInteritemSpacing = photoMargin;
            
            //            CGFloat photosHeight = row * photoHeight + (row - 1) * photoMargin;
            //            self.collectHeight.constant = photosHeight;
            
            
            //            self.detailViewHeight.constant = 500 +self.collectHeight.constant -300 +self.textHeight.constant - 40;
            // 2.计算高度
            // 行数 * 配图的高度 + (行数 – 1) * 间隙
            
            //
            //            // 3.设置配图管理者的高度
            //            self.collectHeight.constant = photosHeight;
            //            self.detailViewHeight.constant = 100+photosHeight;
            
        }
        //             让UICollectionView重新加载数据
        //            [self.photoCollectView reloadData];
        
        // 4.修改原创微博的高度等于配图的高度 = 原来的高度(正文最大的Y) + 配图的高度
        //            self.originalVIewHeight.constant += self.photosViewHeight.constant + 10;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.isneedset = NO;
    self.isneedZan = NO;
    if ([self.modle.map.app isEqualToString:@"marker"] || [self.modle.map.app isEqualToString:@"marker_zone"] ||[self.modle.map.app isEqualToString:@"line"]) {
        [self enterMapview];
    }else
    {
        SMPhotoCollectViewCell *cell = (SMPhotoCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
        _phtotBrowser = browserVc;
        browserVc.sourceView =cell;
//        browserVc.sourceImagesContainerView = cell.superview;
        
        if (self.modle.pictures.count) {
            browserVc.imageCount = self.modle.pictures.count;
            browserVc.currentImageIndex = (int)indexPath.item;
            
        }
        else
        {
            browserVc.imageCount = 1;
            browserVc.currentImageIndex = 0;
        }
        //     SMLog(@"%d",browserVc.currentImageIndex);
        self.collectimage = cell.photoView.image;
        // 代理
        browserVc.delegate = self;
        
        //    SMLog(@"%@",cell);
        // 展示图片浏览器
        [self presentViewController:browserVc animated:NO completion:nil];
//        [browserVc show];
    }
}

-(void)cellChangeL:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SMPhotoCollectViewCell *cell = (SMPhotoCollectViewCell *)[_collectView cellForItemAtIndexPath:indexPath];
    _phtotBrowser.sourceImagesContainerView = cell;
    
}
#pragma mark - photobrowser代理方法
-(UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.collectimage;
}

-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.modle.pictures.count) {
        SMPictures *pic = self.modle.pictures[index];
        return [NSURL URLWithString:pic.url];
    }else
    {
        return [NSURL URLWithString:self.modle.map.snapshot];
    }
    
}




//-(void)enterDetailPic:(UIButton *)mapBtn
//{
//    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
//    browserVc.sourceImagesContainerView = mapBtn;
//    browserVc.imageCount = 1;
//    browserVc.currentImageIndex = 0;
//
//    self.collectimage = mapBtn.imageView.image;
//    // 代理
//    browserVc.delegate = self;
//    // 展示图片浏览器
//    [browserVc show];
//}


/**
 *  当判断为地图贴 进入地图
 */
-(void)enterMapview
{
    
    //    SMNavgationController *nav = [[SMNavgationController alloc]init];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil];
    SMMapViewController *mapVC = [sb instantiateInitialViewController];
    mapVC.modle = self.modle;
//    mapVC.mapImage = self.collectimage;
    
    
    SMNavgationController *nav = [[SMNavgationController alloc] init];
    
    [nav addChildViewController:mapVC];
    
    
    // 3.弹出授权控制器
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma 加载列表信息
/**
 *  获取点赞数据
 */
-(void)getLikers
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/likers",self.modle.Lid];

    [manager GET:strUrl parameters:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        [self.likersArr removeAllObjects];
        
        NSArray *modle = [SMUser objectArrayWithKeyValuesArray:responseObject];
        [self.likersArr addObjectsFromArray:modle];
        
        [view1 reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}
//-(void)getMoreLikers
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    SMAccount *account = [SMAccount accountFromSandbox];
//    
//    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
//    
//    
//    NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/likers",self.modle.Lid];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    dic[@"last_id"] = [[self.likersArr lastObject] Lid];
//    
//    [manager GET:strUrl parameters:dic  success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSArray *modle = [SMUser objectArrayWithKeyValuesArray:responseObject];
//        [self.likersArr addObjectsFromArray:modle];
//        
//        [view1 reloadData];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        SMLog(@"%@",error);
//    }];
//}
//


/**
 *  获取评论数据
 */

-(void)getrepliesData

{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"items_count"] = @1000;
    
    NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/replies",self.modle.Lid];
    
    [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        SMRepiesStatus *modle = [SMRepiesStatus objectWithKeyValues:responseObject];
        
        NSArray *modelArr = modle.replies;
        
        [self.repliesArr addObjectsFromArray:modelArr];
        
        [view2 reloadData];
        //
        //      设置contentsize
        if (self.repliesArr.count == modelArr.count) {
            
            CGRect frame = view2.frame;
            frame.size.height = view2.contentSize.height;
            [view2 setFrame:frame];
            
            self.contentSizeHeight.constant = view2.y +view2.height +64;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
    
    
}

/**
 *  获取收藏数据
 */
-(void)getFavorsData
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/favors",self.modle.Lid];
    
    [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modle = [SMUser objectArrayWithKeyValuesArray:responseObject];
        [self.favorsArr addObjectsFromArray:modle];
        
        [view3 reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
    
}



#pragma  数据源方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == view1) {
        
        return self.likersArr.count ;

    }else if(tableView == view2){

        
//        if (self.repliesArr.count == 0) {
//            return 1;
//        }else{
        return self.repliesArr.count ;
//        }

    }else
    {

        return self.favorsArr.count ;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == view2) {
        SMDetailPinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" ];
        if (cell == nil) {
            [tableView  registerNib:[UINib nibWithNibName:@"SMDetailPinglunCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        }
        
        return [cell cellHeightWithRelayModel:self.repliesArr[indexPath.row]];
        
    }else
    {
        return  60;
    }
}


-(void)didClickCellImage:(NSInteger)tag
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil];
    
    RootTableViewController *rootVc = [sb instantiateInitialViewController];
    
    SMRepies *replay = self.repliesArr[tag-1];
    
    
    rootVc.userModle = replay.user;
    
    rootVc.isNeedShow = YES;
    
    [self.navigationController pushViewController:rootVc animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == view2) {

        SMDetailPinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" ];
        if (cell == nil) {
            [tableView  registerNib:[UINib nibWithNibName:@"SMDetailPinglunCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        }
        
     
        SMRepies *repies = self.repliesArr[indexPath.row];
        
        cell.replayModel = repies;
        
        cell.deleagete = self;
        
    
        return cell;
        
    }else
    {
//        static NSString *ID = @"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        }
//
        SMDetailZanShouCangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
        if (cell == nil) {
//            [tableView  registerNib:[UINib nibWithNibName:@"SMDetailZanShouCangTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//            
//            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SMDetailZanShouCangTableViewCell" owner:self options:nil]lastObject];
        }
        
        if (tableView == view1) {
            
            SMUser *user = self.likersArr[indexPath.row];
            [ cell.avterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
     
            
            cell.title.text = user.login;
            cell.title.font = [UIFont systemFontOfSize:13];
            
        }else if(tableView ==view3){
            SMUser *user = self.favorsArr[indexPath.row];
            [ cell.avterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            
            cell.title.text = user.login;
            cell.title.font = [UIFont systemFontOfSize:13];
            
        }
        return cell;
        
    }
    
}


//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (self.repliesArr.count == 0 &&tableView ==view2) {
//     
//        return @"还没有人评论~";
//    }else if(self.likersArr.count == 0 &&tableView == view1)
//    {
//         return @"还没有人点赞~";
//    }else if(self.favorsArr.count == 0 &&tableView ==view3){
//        return @"还没有人收藏~";
//    }else
//    {
//        return nil;
//    }
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *header = @"customHeader1";
    UITableViewHeaderFooterView *vHeader;

    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    
    vHeader.textLabel.textColor = [UIColor lightGrayColor];
    vHeader.textLabel.font = [UIFont boldSystemFontOfSize:12];


    if (self.repliesArr.count  == 0 &&tableView ==view2) {
        
         vHeader.textLabel.text =  @"还没有人评论~";
    
    }else if(self.likersArr.count == 0 &&tableView == view1)
    {
        vHeader.textLabel.text = @"还没有人点赞~";
    }else if(self.favorsArr.count == 0 &&tableView ==view3){
       vHeader.textLabel.text  = @"还没有人收藏~";
    }else
    {
        vHeader = nil;
    }
    return vHeader;
}
//否则上面不调用
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.repliesArr.count  == 0 &&tableView ==view2) {
        
        return 30;
    }else if(self.likersArr.count == 0 &&tableView == view1)
    {
        return 30;
        
    }else if(self.favorsArr.count == 0 &&tableView ==view3){
        return 30;
    }else
    {
        return 0;
    }
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    

    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor whiteColor];
//    单独给评论做大小
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == view2) {
        
        SMAccount *acout = [SMAccount accountFromSandbox];
        if (!acout) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                //            [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                SMNavgationController *nav = [[SMNavgationController alloc]init];
                [nav addChildViewController:logVc];
                [self presentViewController:nav animated:YES completion:nil];
            }]];
            
            
            [self presentViewController:alertVC animated:YES completion:nil];
            
            return;

        }
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Pinglun" bundle:nil];
        SMPingLunViewController *pinglunVc = [sb instantiateInitialViewController];
        
        pinglunVc.delegate = self;
        
        pinglunVc.reply = self.repliesArr[indexPath.row];
        
        pinglunVc.modle = self.modle;
        
        
        
        SMNavgationController *nav = [[SMNavgationController alloc] init];
        
        [nav addChildViewController:pinglunVc];
        
        
        // 3.弹出授权控制器
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
    
    
    if (tableView == view1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil];
        
        RootTableViewController *rootVc = [sb instantiateInitialViewController];
        SMUser *user = self.likersArr[indexPath.row];
        
        rootVc.userModle = user;
        rootVc.isNeedShow = YES;
        [self.navigationController pushViewController:rootVc animated:YES];
        self.isneedset = NO;
    }
    
    if(tableView ==view3){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil];
        
        RootTableViewController *rootVc = [sb instantiateInitialViewController];
        SMUser *user = self.favorsArr[indexPath.row];
        
        rootVc.userModle = user;
        rootVc.isNeedShow = YES;
        [self.navigationController pushViewController:rootVc animated:YES];
        self.isneedset = NO;
    }
}
/**
 *  评论控制器关闭后的代理回调
 */
-(void)didFinishPinglun
{
    //    
    self.modle.replies_count  =[NSString stringWithFormat:@"%d",(self.modle.replies_count.intValue +1)];
    
    [self setStringItemTitle];
    [self.repliesArr removeAllObjects];
    
    [self getrepliesData];
}


-(void)setModle:(SMStatus *)modle
{
    _modle = modle;
}


- (IBAction)user_img:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil];
    
    RootTableViewController *rootVc = [sb instantiateInitialViewController];
    
    SMUser *user = self.modle.user;
    
    rootVc.userModle = user;
    rootVc.isNeedShow = YES;
    [self.navigationController pushViewController:rootVc animated:YES];
}
- (IBAction)markLaber:(UIButton *)sender {

    
    SMHuaTiVc *vc =[[UIStoryboard storyboardWithName:@"SMHuaTiVc" bundle:nil]instantiateInitialViewController];
//    vc.huati = sender.titleLabel.text;
//    vc.huati = [NSString stringWithFormat:@"%@",sender.currentTitle];
//    vc.huati = sender.currentTitle;
    
     vc.huati = [sender.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
