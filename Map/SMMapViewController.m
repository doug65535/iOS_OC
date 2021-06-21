//
//  SMMapViewController.m
    
//
//  Created by lucifer on 15/7/31.
  
//

#import "SMMapViewController.h"
#import "SMDidClickMapInfoViewController.h"
#import "SMAnno.h"
#import "SMCreatMap.h"
#import "SMAnnoListViewController.h"
#import "SMAttributes.h"
#import "SMAnnoDetailViewController.h"
#import "SMSeachTBViewController.h"
#import "SMComposeShareMapViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "SMEditAnnoVC.h"
#import "SMMakerResultViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import "SMZoneDetailViewController.h"

#import "SMLine.h"
#import "SMZone.h"

#import "SMXAnno.h"

#import "BoPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
@interface SMMapViewController ()<BMKMapViewDelegate,UMSocialUIDelegate,SMDidClickMapInfoViewControllerDelegate,BMKLocationServiceDelegate,SMEditAnnoVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
BMKLocationService* _locService;
}
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *annoDiffView;
@property (weak, nonatomic) IBOutlet UIView *heatDiffView;


@property(nonatomic,strong)NSMutableArray *annoDataArr;


@property(nonatomic,strong)NSMutableArray *annoArray;

@property(nonatomic,strong)SMAnno *anno;

@property(nonatomic,copy)NSString *PWDStr;

@property(nonatomic,strong) BMKPoiInfo *poi;


@property(nonatomic,getter=isZan)BOOL isZan;


@property(nonatomic,getter=isFover)BOOL isFover;

@property (nonatomic,copy)NSString *map_id;
@property (nonatomic,copy)NSString *maptitle;
@property (nonatomic,copy)NSString *sharetitle;


- (IBAction)locate:(UIButton *)sender;

- (IBAction)suoxiao:(UIButton *)sender;
- (IBAction)fangda:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *addAnno;
@property(nonatomic,getter=addisOn)BOOL addisOn;
- (IBAction)didClickPhotoPick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *photoPick;

@property(nonatomic,getter=mapDiffIsOn)BOOL mapDiffIsOn;

- (IBAction)addAnnoClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *centerAnno;
- (IBAction)centerAnnoClick:(UIButton *)sender;

@property (nonatomic,strong)UIImage *mapImage;
- (IBAction)mapDiffClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *mapDiffBtn;
@property (weak, nonatomic) IBOutlet UIView *mapDiffView;
- (IBAction)normalMapClcik:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *normalMapBtn;
- (IBAction)satelaiteMapLick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *satelaiteMapBtn;

@property (nonatomic,getter=isNormalMap)BOOL isNormalMap;
@property (nonatomic,getter=isSatelaiteMap)BOOL isSatelaiteMap;
@property (nonatomic,getter=isRegolonShow)BOOL isRegolonShow;

@property (weak, nonatomic) IBOutlet UIView *reglonView;
@property (weak, nonatomic) IBOutlet UISwitch *annoSwitch;
- (IBAction)annoSwitch:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *heatSwitch;
- (IBAction)heatSwitch:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *reglonSwitch;
- (IBAction)reglonSwitch:(UISwitch *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapDiffConstraint;

@property(nonatomic,strong) BMKHeatMap* heatMap;

@property(nonatomic,strong) BMKPointAnnotation* item;



@property(nonatomic,strong)NSMutableArray *linesArr;

@property(nonatomic,strong)NSMutableArray *polyLineArr;

@property(nonatomic,strong)SMLine *line;


@property(nonatomic,strong)NSMutableArray *zonesArray;

@property(nonatomic,strong)NSMutableArray *polygonArr;

@property(nonatomic,strong)SMZone *zone;

@property(nonatomic,strong) BMKPointAnnotation *lineAnno;

@property(nonatomic,strong) BMKPointAnnotation* regonAnno;


@property(nonatomic,assign) CLLocationCoordinate2D coordinate;

@property(nonatomic,assign) CLLocationCoordinate2D linecoordinate;



@property(nonatomic,strong)BMKUserLocation *photoUserLocation;
@property(nonatomic,getter=isNeedPhotoLocation) BOOL isNeedPhotoLocation;



@end

@implementation SMMapViewController

-(NSMutableArray *)linesArr
{
if (!_linesArr) {
    _linesArr = [[NSMutableArray alloc]init];
}
return _linesArr;
}
-(NSMutableArray *)annoArray
{
if (!_annoArray) {
    _annoArray = [[NSMutableArray alloc]init];
}
return _annoArray;
}

-(NSMutableArray *)polygonArr
{
if (!_polygonArr) {
    _polygonArr = [[NSMutableArray alloc]init];
}
return _polygonArr;
}

-(NSMutableArray *)zonesArray
{
if (!_zonesArray) {
    _zonesArray = [[NSMutableArray alloc]init];
}
return _zonesArray;
}

-(NSMutableArray *)annoDataArr
{
if (!_annoDataArr) {
    _annoDataArr = [[NSMutableArray alloc]init];
}
return _annoDataArr;
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
[_mapView updateLocationData:userLocation];
if (self.isNeedPhotoLocation) {
    self.photoUserLocation = userLocation;
    self.isNeedPhotoLocation = NO;
}
}

- (void)viewDidLoad {
[super viewDidLoad];



[self.mapDiffView.layer setCornerRadius:4.0f];
[self.mapDiffView.layer setShadowColor:[UIColor blackColor].CGColor];
[self.mapDiffView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
[self.mapDiffView.layer setShadowOpacity:0.6f];
self.mapDiffView.layer.shadowRadius = 2.0f;

self.normalMapBtn.contentMode = UIViewContentModeRight;

_mapView.rotateEnabled = NO;
_mapView.overlookEnabled = NO;

 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeself1)];


if (self.modle) {
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.modle.map.snapshot]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.mapImage = imageView.image;
    }];
}else
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.mapModel.snapshotURL]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.mapImage = imageView.image;
    }];
}


if (self.modle)
{
    self.map_id = self.modle.map.map_id;
    self.maptitle  =self.modle.map.title;
    self.sharetitle = self.modle.body;

    [self loadMap];
}




if (self.creatModel) {
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    self.map_id = self.creatModel.Lid;
    self.maptitle = self.creatModel.title;
    self.sharetitle = self.creatModel.title;
    
    self.mapModel = self.creatModel;
    

    
        [_locService startUserLocationService];

        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;

    


}

if (self.mapModel) {
    
    SMAccount *acount = [SMAccount accountFromSandbox];
    
    if ([self.mapModel.user_id isEqualToString:acount.user_id] || [self.mapModel.edit_permission isEqualToString:@"public"] ||

        [self isOperator]
        ) {
       self.addAnno.hidden = NO;
        self.photoPick.hidden = NO;
    }else
    {
        self.addAnno.hidden = YES;
        self.photoPick.hidden = YES;
    }
    
//        if ([self.mapModel.user_id isEqualToString:acount.user_id]) {
        self.mapDiffBtn.hidden = NO;


    if (![self.mapModel.user_id isEqualToString:acount.user_id] && [self.mapModel.permission isEqualToString:@"pas"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入密码进入" message:@"请输入4位密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD dismiss];
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *password = alertController.textFields.lastObject;

            self.PWDStr = password.text;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            

            [SVProgressHUD showWithStatus:@"正在载入标注点"];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            SMAccount *account = [SMAccount accountFromSandbox];
            
            [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
            
            NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/markers",self.map_id];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            dic[@"need_creator"] = @"true";
            
            if (self.PWDStr) {
                dic[@"password"] = self.PWDStr;
            }
            
            [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                
                if (![responseObject[@"status"] isEqual:@200]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [SVProgressHUD showErrorWithStatus:@"密码错误"];
                    }];
                }else{
                
                NSArray *model = [SMAnno objectArrayWithKeyValuesArray:responseObject[@"markers"]];
                [self.annoDataArr addObjectsFromArray:model];
                
                if (self.annoArray.count == 0) {
                    

                }
                
                for (SMAnno *annoData in model) {
                    
                    self.anno = annoData;
                    
                    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
                    
                    
                    CLLocationCoordinate2D coor;
                    coor.latitude = annoData.y;
                    coor.longitude = annoData.x;
                    annotation.coordinate = coor;
                    annotation.title = annoData.title;
                    
                    [_mapView addAnnotation:annotation];
                    
                    
                    [self.annoArray addObject:annotation];
                    
                    if (self.annoArray.count  == model.count) {
                        [SVProgressHUD dismiss];
                    }
                }
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                SMLog(@"%@",error);
            }];

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

    }

    
    self.map_id = self.mapModel.Lid;
    self.maptitle = self.mapModel.title;
    self.sharetitle = self.mapModel.title;

    CLLocationCoordinate2D coor;


    NSString *string = self.mapModel.center;
    NSRange start = [string rangeOfString:@"("];
    NSRange end = [string rangeOfString:@","];
    NSString *sub1 = [string substringWithRange:NSMakeRange(start.location+1, end.location-start.location -1)];
    coor.longitude = [sub1 floatValue];

    NSRange start2 = [string rangeOfString:@","];
    NSRange end2 = [string rangeOfString:@")"];
    NSString *sub2 = [string substringWithRange:NSMakeRange(start2.location+1, end2.location-start2.location -1)];
    coor.latitude = [sub2 floatValue];
    
    BMKMapStatus *status = [[BMKMapStatus alloc]init];
    status.fLevel = [self.mapModel.level intValue];
    
    status.targetGeoPt = CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
    [self.mapView setMapStatus:status];
}

if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"] ) {
    [self loadZones:self.mapModel.Lid];
}

if ([self.creatModel.app_name isEqualToString:@"MARKER_ZONE"] ) {
    [self loadZones:self.creatModel.Lid];
}

if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"] || [self.creatModel.app_name isEqualToString:@"MARKER_ZONE"] ) {
    self.reglonView.hidden = NO;
    self.mapDiffConstraint.constant = 235;
    [self.reglonSwitch setOn:YES];
}else
{
    self.reglonView.hidden = YES;
    self.mapDiffConstraint.constant = 190;
}



if ([self.mapModel.app_name isEqualToString:@"LINE"] ) {
    [self loadLine:self.mapModel.Lid];
    self.addAnno.hidden = YES;
    self.photoPick.hidden = YES;
    self.reglonView.hidden = YES;
    self.annoDiffView.hidden = YES;
    self.heatDiffView.hidden = YES;
    
    self.mapDiffConstraint.constant = 100 ;
}

if ([self.creatModel.app_name isEqualToString:@"LINE"] ) {
    [self loadLine:self.creatModel.Lid];
}


[self loadAnno];


[self setUpMapInfoBtn];

[self setUpAnnoInfoBtn];

//    [self setUpSeachBtn];

[self loadIsZan];
[self loadIsFover];

self.navigationItem.title = self.maptitle;

[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectZone:) name:SMSectetZoneNotification object:nil];

[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectLine:) name:SMSectetLineNotification object:nil];


[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectAnno:) name:SMSectetAnnoNotification object:nil];

[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectPOISeacher:) name:SMSectetPOIseachNotification object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailEditChangeMap:) name:SMDetailEditAnnoNotification object:nil];


[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailDeleteChangeMap:) name:SMDetailDeleteAnnoNotification object:nil];

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_share" higImage:@"nav_share_press" target:self action:@selector(share)];
UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_map_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
//    UIBarButtonItem *shareButtonItem = [UIBarButtonItem itemWithImage:@"nav_share" higImage:@"nav_share_press" target:self action:@selector(share)];
 UIBarButtonItem *seachButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_map_seach"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickSeachBtn)];
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//     UIBarButtonItem *seachButtonItem = [UIBarButtonItem itemWithImage:@"map_search" higImage:@"map_search" target:self action:@selector(didClickSeachBtn)];
//   negativeSpacer.width = -15;
[seachButtonItem setImageInsets:UIEdgeInsetsMake(0,  5, 0, -5)];
 [shareButtonItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
self.navigationItem.rightBarButtonItems = @[shareButtonItem,seachButtonItem];


_mapView.showMapScaleBar = YES;

//    _mapView.mapScaleBarPosition = CGPointMake(1.0 / 2.0 *kWidth-20,
//                                               kHeight - 30);
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
if (alertController) {
    UITextField *login = alertController.textFields.lastObject;
    UIAlertAction *okAction = alertController.actions.lastObject;
    okAction.enabled = login.text.length == 4;
}
}


-(void)dealloc
{
[[NSNotificationCenter defaultCenter] removeObserver:self];

if (_mapView) {
    _mapView = nil;
}
if (_locService) {
    _locService.delegate = nil;
}

}

-(void)didSelectPOISeacher:(NSNotification *)notification

{
BMKPoiInfo *poi = [[notification userInfo] valueForKey:@"poiModel"];

        self.poi = poi;
        BMKMapStatus *status = [[BMKMapStatus alloc]init];
        
        status.targetGeoPt = poi.pt;
        
        [self.mapView setMapStatus:status withAnimation:YES];

        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = poi.pt;

        item.title = poi.name;
        item.subtitle = @"请点按添加至地图";

        [_mapView addAnnotation:item];
        self.item = item;
        [self.mapView selectAnnotation:item animated:YES];

}
static UIWindow *_window;

-(void)share
{

_window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
_window.hidden = NO;
_window.windowLevel = UIWindowLevelAlert;


UIButton *cover = [[UIButton alloc] init];
cover.frame = [UIScreen mainScreen].bounds;
cover.backgroundColor = [UIColor blackColor];
cover.alpha = 0.5;

[cover addTarget:self action:@selector(coverClick1) forControlEvents:UIControlEventTouchUpInside];



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


[cancel addTarget:self action:@selector(coverClick1) forControlEvents:UIControlEventTouchUpInside];
[coverView addSubview:cancel];

/* ************************************** */
UIScrollView *scr1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 257 - 64- 96, kWidth,96)];
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

UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 97 ,kWidth, 1)];
view.backgroundColor = [UIColor blackColor];

[scr2 addSubview:view];

[coverView addSubview:scr1];
[coverView addSubview:scr2];

//    [_window addSubview:scr2];
//    [self.mapView addSubview:scr2];

////////////////////////////////////////


UIButton *Btn1 = [[UIButton alloc]initWithFrame:CGRectMake(btnMagin , btnYMagin , btnWidth, btnHeight)];
UILabel *Laber1 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin, btnYMagin + btnWidth, btnWidth, 20)];
Laber1.text = @"社区";
Laber1.textAlignment = NSTextAlignmentCenter;
Laber1.font = [UIFont systemFontOfSize:14];

[Btn1 setImage:[UIImage imageNamed:@"share_community"] forState:UIControlStateNormal];
[scr2 addSubview:Btn1];
[scr2 addSubview:Laber1];

[Btn1 addTarget:self action:@selector(shareToCommiunity) forControlEvents:UIControlEventTouchUpInside];


UIButton *Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *2+btnWidth , btnYMagin , btnWidth, btnHeight)];
UILabel *Laber2 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin*2 +btnWidth, btnYMagin + btnWidth, btnWidth, 20)];
Laber2.text = @"微信";
Laber2.textAlignment = NSTextAlignmentCenter;
Laber2.font = [UIFont systemFontOfSize:14];

[Btn2 setImage:[UIImage imageNamed:@"share_weichat"] forState:UIControlStateNormal];
[scr2 addSubview:Btn2];
[scr2 addSubview:Laber2];

[Btn2 addTarget:self action:@selector(shareToWechat) forControlEvents:UIControlEventTouchUpInside];



UIButton *Btn3 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin*3 +btnWidth *2 , btnYMagin ,btnWidth, btnHeight)];

UILabel *Laber3 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin*3 +btnWidth *2 , btnYMagin + btnWidth, btnWidth, 20)];

Laber3.text = @"朋友圈";
Laber3.textAlignment = NSTextAlignmentCenter;
Laber3.font = [UIFont systemFontOfSize:14];


[Btn3 setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
[scr2 addSubview:Btn3];
[scr2 addSubview:Laber3];



[Btn3 addTarget:self action:@selector(shareToWechatZone) forControlEvents:UIControlEventTouchUpInside];

UIButton *Btn4 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *4 +btnWidth *3, btnYMagin, btnWidth,btnHeight)];

UILabel *Laber4 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *4 +btnWidth *3, btnYMagin + btnWidth, btnWidth, 20)];
Laber4.text = @"微博";
Laber4.textAlignment = NSTextAlignmentCenter;
Laber4.font = [UIFont systemFontOfSize:14];

[Btn4 setImage:[UIImage imageNamed:@"share_weibo"] forState:UIControlStateNormal];
[scr2 addSubview:Btn4];
[scr2 addSubview:Laber4];

[Btn4 addTarget:self action:@selector(shareToSinaBlog) forControlEvents:UIControlEventTouchUpInside];

if ([QQApiInterface isQQInstalled]) {
    UIButton *Btn5 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin, btnWidth,btnHeight)];
    UILabel *Laber5 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *5+ btnWidth *4, btnYMagin + btnWidth, btnWidth, 20)];
    Laber5.text = @"QQ空间";
    Laber5.textAlignment = NSTextAlignmentCenter;
    Laber5.font = [UIFont systemFontOfSize:14];
    
    [Btn5 setImage:[UIImage imageNamed:@"share_qqzone"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn5];
    [scr2 addSubview:Laber5];
    
    [Btn5 addTarget:self action:@selector(shareToQQZone1) forControlEvents:UIControlEventTouchUpInside];
}
if ([QQApiInterface isQQInstalled]) {
    UIButton *Btn6 = [[UIButton alloc] initWithFrame:CGRectMake(btnMagin *6+ btnWidth *5, btnYMagin, btnWidth,btnHeight)];
    UILabel *Laber6 = [[UILabel alloc]initWithFrame:CGRectMake(btnMagin *6+ btnWidth *5, btnYMagin + btnWidth, btnWidth, 20)];
    Laber6.text = @"QQ";
    Laber6.textAlignment = NSTextAlignmentCenter;
    Laber6.font = [UIFont systemFontOfSize:14];
    
    [Btn6 setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
    [scr2 addSubview:Btn6];
    [scr2 addSubview:Laber6];
    
    [Btn6 addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
}


scr2.userInteractionEnabled = YES;
scr2.contentSize = CGSizeMake(kWidth +100 +btnWidth, 96);



_window.hidden = NO;


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

NSString *urlStr = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/zan",self.map_id];

[manager POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    self.isZan = YES;
    if ([responseObject[@"status"]  isEqualToNumber:@200]) {
        [SVProgressHUD showSuccessWithStatus:@"地图点赞成功"];
    }else{
    
    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
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

NSString *urlStr = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/fav",self.map_id];

[manager POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    self.isFover = YES;
    if ([responseObject[@"status"]  isEqualToNumber:@200]) {
        [SVProgressHUD showSuccessWithStatus:@"地图收藏成功"];
    }else{
        
        [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
    }
    SMLog(@"%@",responseObject);
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
}];

}


-(void)clickCopy
{

     _window.hidden  =  YES;
UIPasteboard *pab = [UIPasteboard generalPasteboard];

NSString *string =[NSString stringWithFormat:@"http://c.dituhui.com/maps/%@",self.map_id];

[pab setString:string];

if (pab == nil) {
    [SVProgressHUD showErrorWithStatus:@"复制失败"];
    
}else
{
    [SVProgressHUD showSuccessWithStatus:@"已复制地图链接"];
}


}


-(void)shareToCommiunity
{
      _window.hidden  =  YES;
if ([self.mapModel.permission isEqualToString:@"pas"]) {
    [SVProgressHUD showErrorWithStatus:@"暂不支持分享密码可见地图到社区"];
    return;
}

UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMComposeShareMap" bundle:nil];
SMComposeShareMapViewController *vc = [sb instantiateInitialViewController];

if (self.mapModel) {
    vc.creatModel = self.mapModel;
}else
{
    vc.model = self.modle;
}

SMNavgationController * nav = [[SMNavgationController alloc]init];

[nav addChildViewController:vc];



[self presentViewController:nav animated:YES completion:nil];



}

-(void)shareToWechat
{


    [UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.mapModel.Lid];

  _window.hidden  =  YES;

[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.sharetitle image:self.mapImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    if (response.responseCode == UMSResponseCodeSuccess) {
        SMLog(@"分享成功！");
    }
}];

}


-(void)shareToWechatZone
{


[UMSocialData defaultData].extConfig.wechatTimelineData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.mapModel.Lid];

      _window.hidden  =  YES;
[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.sharetitle image:self.mapImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    if (response.responseCode == UMSResponseCodeSuccess) {
        SMLog(@"分享成功！");
    }
}];

}

-(void)shareToQQ
{

    [UMSocialData defaultData].extConfig.qqData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.mapModel.Lid];

_window.hidden  =  YES;
[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.sharetitle image:self.mapImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    if (response.responseCode == UMSResponseCodeSuccess) {
        SMLog(@"分享成功！");
    }
}];
}

-(void)shareToSinaBlog
{

[UMSocialData defaultData].extConfig.qzoneData.url =[NSString stringWithFormat:@"http://www.dituhui.com/maps/%@",self.mapModel.Lid];

      _window.hidden  =  YES;
[[UMSocialControllerService defaultControllerService] setShareText:self.sharetitle shareImage:self.mapImage socialUIDelegate:self];

[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

}



-(void)shareToQQZone1
{
      _window.hidden  =  YES;
[[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.sharetitle image:self.mapImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
if (response.responseCode == UMSResponseCodeSuccess) {
    NSLog(@"分享成功！");

}
}];
}

-(void)coverClick1
{

//    _window.hidden  =  YES;
_window.hidden = YES;
}

-(void)setUpSeachBtn
{
//    UIButton *annoInfo = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 44 - 5,1.0 /6.0 * kHeight -10, 44 , 44)];
//    
//    [annoInfo setImage:[UIImage imageNamed:@"map_search"] forState:UIControlStateNormal];
//   
//    [self.view addSubview:annoInfo];
//
//    [annoInfo addTarget:self action:@selector(didClickSeachBtn) forControlEvents:UIControlEventTouchUpInside];



}



-(void)didClickSeachBtn
{


//        [_locService stopUserLocationService];
UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMSeachBarVC" bundle:nil];
SMSeachTBViewController *seachVc = [sb instantiateInitialViewController];

seachVc.mapModel = self.mapModel;



[seachVc.annoDataArr addObjectsFromArray:self.annoDataArr];


if (self.zonesArray) {
    seachVc.zonesArr = self.zonesArray;
}

if (self.linesArr) {
    seachVc.linesArr = self.linesArr;
}

[self.navigationController pushViewController:seachVc animated:YES];
}


-(void)setUpAnnoInfoBtn
{

UIButton *annoInfo = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-44 - 5,
                                                             5.0 /6.0 * kHeight - 40, 44 , 44)];

[annoInfo setImage:[UIImage imageNamed:@"map_dingwei@2x-7"] forState:UIControlStateNormal];



[self.view addSubview:annoInfo];


[annoInfo addTarget:self action:@selector(didClickAnnoInfo) forControlEvents:UIControlEventTouchUpInside];

}


-(void)didClickAnnoInfo
{


UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAnnoList" bundle:nil];

SMAnnoListViewController *annoInfoVc = [sb instantiateInitialViewController];

[self addChildViewController:annoInfoVc];


[annoInfoVc.annoDataArr addObjectsFromArray:self.annoDataArr];
[annoInfoVc.linesArr addObjectsFromArray:self.linesArr];
if (self.mapModel) {
    annoInfoVc.mapModel = self.mapModel;
}

if (self.zonesArray) {
    annoInfoVc.zonesArr = self.zonesArray;
}



[self.navigationController pushViewController:annoInfoVc animated:YES];

}




-(void)didSelectAnno:(NSNotification *)notification
{
SMAnno *anno = [[notification userInfo] valueForKey:@"model"];
if ([self.mapModel.app_name isEqualToString:@"LINE"]) {
    NSArray *bdxyArr =[anno.bdxy componentsSeparatedByString:@","];
    anno.y = [bdxyArr[1] doubleValue];
    anno.x = [bdxyArr[0] doubleValue];
}

for (BMKPointAnnotation *annotation in self.annoArray) {
    if (annotation.coordinate.latitude == anno.y && annotation.coordinate.longitude == anno.x) {
        
        BMKMapStatus *status = [[BMKMapStatus alloc]init];
        
        status.targetGeoPt = CLLocationCoordinate2DMake(anno.y, anno.x);
        
        [self.mapView setMapStatus:status withAnimation:YES];
        [self.mapView selectAnnotation:annotation animated:YES];
      
    }
}
}

-(void)didSelectZone:(NSNotification *)notification
{
SMZone *zone  = [[notification userInfo] valueForKey:@"model"];

        BMKMapStatus *status = [[BMKMapStatus alloc]init];
        
        status.targetGeoPt = CLLocationCoordinate2DMake(zone.geometry.center.y.doubleValue, zone.geometry.center.x.doubleValue);
        
        [self.mapView setMapStatus:status withAnimation:YES];




BMKPointAnnotation* regonAnno = [[BMKPointAnnotation alloc]init];
regonAnno.coordinate = CLLocationCoordinate2DMake(zone.geometry.center.y.doubleValue, zone.geometry.center.x.doubleValue);

regonAnno.title = zone.title;

self.regonAnno = regonAnno;

self.zone = zone;
self.coordinate = CLLocationCoordinate2DMake(zone.geometry.center.y.doubleValue, zone.geometry.center.x.doubleValue);


self.mapView.delegate = self;
[self.mapView addAnnotation:regonAnno];


[self.mapView selectAnnotation:regonAnno animated:YES];


}

-(void)didSelectLine:(NSNotification *)notification
{
SMLine *line  = [[notification userInfo] valueForKey:@"model"];

BMKMapStatus *status = [[BMKMapStatus alloc]init];

NSInteger count = line.nodes.count/2;

SMLinePoint *point = line.nodes[count];

NSArray *array = [point.p componentsSeparatedByString:@","];

status.targetGeoPt = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);

[self.mapView setMapStatus:status withAnimation:YES];

if (!self.lineAnno) {
     _lineAnno = [[BMKPointAnnotation alloc]init];
}


_lineAnno.coordinate = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);

_lineAnno.title = line.title;



self.line = line;
self.coordinate = CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);


self.mapView.delegate = self;
[self.mapView addAnnotation:_lineAnno];


[self.mapView selectAnnotation:_lineAnno animated:YES];


}





-(void)setUpMapInfoBtn
{

UIButton *btnMap = [[UIButton alloc]initWithFrame:CGRectMake(kWidth -44 -5,
                                                             kHeight - 82, 44 , 44)];

[btnMap setImage:[UIImage imageNamed:@"map_xinxi"] forState:UIControlStateNormal];



[self.view addSubview:btnMap];


[btnMap addTarget:self action:@selector(didClickMapInfo) forControlEvents:UIControlEventTouchUpInside];

}


-(void)didClickMapInfo
{
UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapInfo" bundle:nil];

SMDidClickMapInfoViewController *mapInfoVc = [sb instantiateInitialViewController];

mapInfoVc.delegate = self;
[self addChildViewController:mapInfoVc];


if (self.mapModel) {
    mapInfoVc.mapmodel = self.mapModel;
}else{
    mapInfoVc.model = self.modle;
}


[self.navigationController pushViewController:mapInfoVc animated:YES];

}

-(void)willUpdateMap:(SMCreatMap *)newModel
{
self.mapModel = newModel;
self.title = newModel.title;
}

-(void)closeself1
{


[SVProgressHUD dismiss];
SMAccount *account = [SMAccount accountFromSandbox];

if (self.mapModel && self.annoArray.count != 0 &&([self.mapModel.user_id isEqualToString:account.user_id] || [self.mapModel.edit_permission isEqualToString:@"public"] ||
                                                  [self isOperator])) {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/save",self.mapModel.Lid];
    
    NSMutableDictionary *pramers = [[NSMutableDictionary alloc]init];
    
    pramers[@"level"]= [NSString stringWithFormat:@"%f",self.mapView.zoomLevel];
    pramers[@"center"] = [NSString stringWithFormat:@"(%f,%f)",self.mapView.centerCoordinate.longitude,self.mapView.centerCoordinate.latitude];
    
    
    [manager POST:strUrl parameters:pramers success:^(NSURLSessionDataTask *task, id responseObject) {

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}


if ([self.delegate respondsToSelector:@selector(willRoladData:)]) {
    [self.delegate willRoladData:self.mapModel];
}



if (self.annoArray.count == 0 && self.zonesArray.count == 0 && self.linesArr.count == 0  && ([self.mapModel.user_id isEqualToString:account.user_id] || [self.mapModel.edit_permission isEqualToString:@"public"] ||
                                  [self isOperator]) && (self.creatModel)) {
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出" message:@"没有标注点，此地图将不会被保存，是否确认退出" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.delegate respondsToSelector:@selector(closeMapAndMapCompose)]) {
            [self.delegate closeMapAndMapCompose];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}else
{
    if ([self.delegate respondsToSelector:@selector(closeMapAndMapCompose)]) {
        [self.delegate closeMapAndMapCompose];
    }
   [self dismissViewControllerAnimated:YES completion:nil];
}
}


- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];

}


-(void)viewWillAppear:(BOOL)animated
{
[super viewWillAppear:YES];


_mapView.delegate = self;

if (self.heatSwitch.on) {
    [_mapView addHeatMap:_heatMap];
}
//

}


-(void)viewWillDisappear:(BOOL)animated
{
[super viewWillDisappear:YES];


_mapView.delegate = nil;
_locService.delegate = nil;


}


-(void)loadMap
{
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@.json",self.map_id];

[manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

    SMCreatMap *model = [SMCreatMap objectWithKeyValues:responseObject[@"info"]];
    

    self.mapModel = model;
    
    CLLocationCoordinate2D coor;
    

    NSString *string = model.center;
    NSRange start = [string rangeOfString:@"("];
    NSRange end = [string rangeOfString:@","];
    NSString *sub1 = [string substringWithRange:NSMakeRange(start.location+1, end.location-start.location -1)];
    coor.longitude = [sub1 floatValue];
    
    NSRange start2 = [string rangeOfString:@","];
    NSRange end2 = [string rangeOfString:@")"];
    NSString *sub2 = [string substringWithRange:NSMakeRange(start2.location+1, end2.location-start2.location -1)];
    coor.latitude = [sub2 floatValue];
    

    BMKMapStatus *status = [[BMKMapStatus alloc]init];
    status.fLevel = [model.level intValue];
    
    status.targetGeoPt = CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
    
    
    [self.mapView setMapStatus:status];

    SMAccount *acount = [SMAccount accountFromSandbox];
    if (![self.mapModel.app_name isEqualToString:@"LINE"]&&([self.mapModel.user_id isEqualToString:acount.user_id]||[self.mapModel.edit_permission isEqualToString:@"public"]||
//            [acount.groups containsObject:self.mapModel.group_id]
        [self isOperator]
        )
        ) {
        self.addAnno.hidden = NO;
        self.photoPick.hidden = NO;
    }else{
        self.addAnno.hidden = YES;
        self.photoPick.hidden = YES;
    }
//        if ([self.mapModel.user_id isEqualToString:acount.user_id]) {
        self.mapDiffBtn.hidden = NO;
//        }else
//        {
//            self.mapDiffBtn.hidden = YES;
//        }

    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"] ) {
        [self loadZones:self.mapModel.Lid];
    }
    
//        if ([self.modle.map.app isEqualToString:@"line"]) {
//            [self loadLine:self.modle.map.Lid];
//        }
//        
    if ([self.mapModel.app_name isEqualToString:@"LINE"] ) {
        [self loadLine:self.mapModel.Lid];
        self.addAnno.hidden = YES;
        self.photoPick.hidden =YES;
        self.reglonView.hidden = YES;
        self.annoDiffView.hidden = YES;
        self.heatDiffView.hidden = YES;
        
        self.mapDiffConstraint.constant = 100 ;
    }
    
    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"] || [self.creatModel.app_name isEqualToString:@"MARKER_ZONE"] ) {
        self.reglonView.hidden = NO;
        self.mapDiffConstraint.constant = 235;
        [self.reglonSwitch setOn:YES];
    }else
    {
        self.reglonView.hidden = YES;
        self.mapDiffConstraint.constant = 190;
    }

} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
}];
}

-(void)loadLine:(NSString *)mapID
{
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
NSString *url = [NSString stringWithFormat:@"http://c.dituhui.com/maps/%@/get_lines",mapID];

[manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *model =[SMLine objectArrayWithKeyValuesArray:responseObject];
    [self.linesArr addObjectsFromArray:model];
    
    for (SMLine *line in model) {
        
        CLLocationCoordinate2D coords[(line.nodes.count)];
        
        for (int i=0; i<line.nodes.count; i++) {
            SMLinePoint *point = line.nodes[i];
            
            NSArray *array = [point.p componentsSeparatedByString:@","];
            
            coords[i].longitude = [array[0] floatValue];
            coords[i].latitude= [array[1] floatValue];
            
        }
        BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coords count:line.nodes.count];
        [self.polyLineArr addObject:polyLine];
        

        polyLine.subtitle = line.Lid;
        
        [_mapView addOverlay:polyLine];
        
        if (line.markers.count) {
            for (SMAnno *annoData in line.markers) {
                
                self.anno = annoData;
                
                SMXAnno* annotation = [[SMXAnno alloc]init];
				annotation.annoModel = annoData;
				annotation.url = annoData.icon.url;
				 [annotation.attributes addObjectsFromArray:annoData.attributes];

                CLLocationCoordinate2D coor;
                
                NSArray *bdxyArr =[self.anno.bdxy componentsSeparatedByString:@","];
                
                coor.latitude = [bdxyArr[1] doubleValue];
                coor.longitude = [bdxyArr[0] doubleValue];
                
                
                annotation.coordinate = coor;
                annotation.title = annoData.title;
                
                [_mapView addAnnotation:annotation];
                
                
                [self.annoArray addObject:annotation];
                [self.annoDataArr addObject:annoData];
                
            }
        }
    }
    
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
}];
}




-(void)loadIsZan
{

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
NSString *urlStr = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/zan",self.map_id];
[manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
    if ([responseObject[@"message"] isEqualToString:@"true"]) {
        self.isZan = YES;
    }else
    {
        self.isZan = NO;
    }
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
}];
}

-(void)loadIsFover
{

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
NSString *urlStr = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/fav",self.map_id];
[manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
    if ([responseObject[@"message"] isEqualToString:@"true"]) {
        self.isFover = YES;
    }else
    {
        self.isFover = NO;
    }
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
}];
}



-(void)loadZones:(NSString *)mapId
{
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

[manager GET:[NSString stringWithFormat:@"http://c.dituhui.com/maps/%@/get_zones",mapId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *model = [SMZone objectArrayWithKeyValuesArray:responseObject];
    [self.zonesArray removeAllObjects];
    [self.zonesArray addObjectsFromArray:model];
    
    for (SMZone *zone in model) {
        
        NSArray *pointsArr =[SMPoints objectArrayWithKeyValuesArray: zone.geometry.points[0]];
        
//            if ([zone.geometry_type isEqualToString:@"polygon"]) {
        
            CLLocationCoordinate2D coords[(pointsArr.count)];

            for (int i=0; i<pointsArr.count; i++) {
                SMPoints *point = pointsArr[i];
                coords[i].latitude = point.y.doubleValue;
                coords[i].longitude = point.x.doubleValue;
            }
                BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:pointsArr.count];
        polygon.title = zone.smid;
        
        [self.polygonArr addObject:polygon];
//             [_mapView addOverlay:polygon];
    }
   
    [_mapView addOverlays:self.polygonArr];
    
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
    [SVProgressHUD showErrorWithStatus:@"未能加载区域信息"];
}];
}

-(UIColor *)getColor:(NSString *)hexColor alpha:(NSString *)alpha{
unsigned int red,green,blue;
NSRange range;
range.length = 2;

range.location = 1;
[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];

range.location = 3;
[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];

range.location = 5;
[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];

return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha.floatValue];
}



- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{

if ([overlay isKindOfClass:[BMKPolygon class]]){
    
    BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];

    SMLog(@"%@",polygonView.polygon.title);

    for (SMZone *zone in _zonesArray) {

        if (polygonView.polygon.title == zone.smid) {
            polygonView.strokeColor = [self getColor:zone.style.line_color alpha:zone.style.line_alpha];
            polygonView.fillColor = [self getColor:zone.style.fill_color alpha:zone.style.fill_opacity];
            polygonView.lineWidth =zone.style.line_weight.floatValue;

        }
    
}
      return polygonView;
}

if ([overlay isKindOfClass:[BMKPolyline class]]){
     BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
    for (SMLine *line in self.linesArr) {
        
//                    if (line.nodes.count == polylineView.polyline.pointCount) {
        if (line.Lid == polylineView.polyline.subtitle) {
            
        polylineView.strokeColor = [self getColor:line.style.line_color alpha:line.style.line_alpha];
        polylineView.fillColor = [self getColor:line.style.line_color alpha:line.style.line_alpha];
        polylineView.lineWidth = line.style.line_weight.floatValue;
    }
    }
    
    return polylineView;
}

return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView
{
//    if (self.lineAnno) {
//        [mapView removeAnnotation:_lineAnno];
//    }


for (SMLine *line in self.linesArr) {
    
   
    BMKMapStatus *status = [[BMKMapStatus alloc]init];
    
    
    CLLocationCoordinate2D coords[(line.nodes.count)];
    
    for (int i=0; i<line.nodes.count; i++) {
        SMLinePoint *point = line.nodes[i];
        
        NSArray *array = [point.p componentsSeparatedByString:@","];
        
        coords[i].longitude = [array[0] floatValue];
        
        coords[i].latitude= [array[1] floatValue];
    
    }
    
//        if ([overlayView.overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coords count:line.nodes.count];
        if (polyLine.coordinate.latitude== overlayView.overlay.coordinate.latitude && polyLine.coordinate.longitude == overlayView.overlay.coordinate.longitude) {
            status.targetGeoPt = coords[line.nodes.count/2];
            
            [self.mapView setMapStatus:status withAnimation:YES];
            
            if (!self.lineAnno) {
                
                _lineAnno = [[BMKPointAnnotation alloc]init];
            }
            _lineAnno.coordinate =coords[line.nodes.count/2];
            
            _lineAnno.title = line.title;

            

            self.line = line;
            self.linecoordinate = coords[line.nodes.count/2];;
            [_mapView addAnnotation:_lineAnno];
            [self.mapView selectAnnotation:_lineAnno animated:YES];
//            }
    }
 
}

}




- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
if (self.regonAnno) {
    [mapView removeAnnotation:_regonAnno];
}
//    if (self.lineAnno) {
//        [mapView removeAnnotation:_lineAnno];
//    }

for (SMZone *zone in self.zonesArray) {
    
    //            self.zone = zone;
    NSArray *pointsArr =[SMPoints objectArrayWithKeyValuesArray: zone.geometry.points[0]];
    
    //            if ([zone.geometry_type isEqualToString:@"polygon"]) {
    
    CLLocationCoordinate2D coords[(pointsArr.count)];
    
    for (int i=0; i<pointsArr.count; i++) {
        SMPoints *point = pointsArr[i];
        coords[i].latitude = point.y.doubleValue;
        coords[i].longitude = point.x.doubleValue;
    }
    
    if (BMKPolygonContainsCoordinate(coordinate, coords, pointsArr.count)) {
        
        BMKMapStatus *status = [[BMKMapStatus alloc]init];
        
        status.targetGeoPt = coordinate;
        
        [self.mapView setMapStatus:status withAnimation:YES];
        
        BMKPointAnnotation* regonAnno = [[BMKPointAnnotation alloc]init];
        regonAnno.coordinate = coordinate;
        
        regonAnno.title = zone.title;

        
        self.zone = zone;
        self.linecoordinate = coordinate;
        self.regonAnno = regonAnno;
        
        [_mapView addAnnotation:regonAnno];
        
        
        [self.mapView selectAnnotation:regonAnno animated:YES];
    }
    
    
}
}




- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
if (self.regonAnno) {
    [mapView removeAnnotation:_regonAnno];
}
//    if (self.lineAnno) {
//        [mapView removeAnnotation:_lineAnno];
//    }
for (SMZone *zone in self.zonesArray) {
    
    //            self.zone = zone;
    NSArray *pointsArr =[SMPoints objectArrayWithKeyValuesArray: zone.geometry.points[0]];
    
    //            if ([zone.geometry_type isEqualToString:@"polygon"]) {
    
    CLLocationCoordinate2D coords[(pointsArr.count)];
    
    for (int i=0; i<pointsArr.count; i++) {
        SMPoints *point = pointsArr[i];
        coords[i].latitude = point.y.doubleValue;
        coords[i].longitude = point.x.doubleValue;
    }
    
    if (BMKPolygonContainsCoordinate(mapPoi.pt, coords, pointsArr.count)) {
        
        BMKMapStatus *status = [[BMKMapStatus alloc]init];
        
        status.targetGeoPt = mapPoi.pt;
        
        [self.mapView setMapStatus:status withAnimation:YES];
        
        BMKPointAnnotation* regonAnno = [[BMKPointAnnotation alloc]init];
        regonAnno.coordinate = mapPoi.pt;
        
        regonAnno.title = zone.title;

        self.zone = zone;
        self.coordinate = mapPoi.pt;
        self.regonAnno = regonAnno;
        
        [_mapView addAnnotation:regonAnno];
        
        [self.mapView selectAnnotation:regonAnno animated:YES];
    }
}
}


-(void)loadAnno
{

[SVProgressHUD showWithStatus:@"正在加载标注点..."];

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/maps/%@/markers",self.map_id];

NSMutableDictionary *dic = [NSMutableDictionary dictionary];

dic[@"need_creator"] = @"true";

if (self.PWDStr) {
    dic[@"password"] = self.PWDStr;
}

[manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
    NSArray *model = [SMAnno objectArrayWithKeyValuesArray:responseObject[@"markers"]];
    
    if (self.mapModel.title_key) {
        for (SMAnno *annomodel in model) {
        for (SMAttributes *attr in annomodel.attributes) {
                if ([attr.key isEqual: self.mapModel.title_key]) {
                    annomodel.subTitle = annomodel.title;
                    annomodel.title = attr.value;
                }
            }
            
            
        }
    }
    
    [self.annoDataArr addObjectsFromArray:model];
    
    if (model.count == 0) {
        [SVProgressHUD dismiss];
    }
    
    for (SMAnno *annoData in model) {
        
        self.anno = annoData;
    
        SMXAnno* annotation = [[SMXAnno alloc]init];
        
        CLLocationCoordinate2D coor;
        coor.latitude = annoData.y;
        coor.longitude = annoData.x;
        annotation.coordinate = coor;
        annotation.title = annoData.title;
        annotation.url = annoData.icon.url;
        [annotation.attributes addObjectsFromArray:annoData.attributes];
        
        
          annotation.annoModel = annoData;
        
        [self.annoArray addObject:annotation];
        
      
        
        
        if (self.annoArray.count  == model.count) {
            [SVProgressHUD dismiss];
            
            if ([self.delegate respondsToSelector:@selector(didFinishLoadAnno)]) {
                [self.delegate didFinishLoadAnno];
            }
        }
    }
    
    [_mapView addAnnotations:self.annoArray];
    
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);

    [SVProgressHUD dismiss];

}];
}




-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{

BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnimatedAnnotation"];


if (annotationView == nil) {

    annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnimatedAnnotation"];
}

if (annotation == self.regonAnno) {
    annotationView.image = nil;
    return annotationView;
}

if (annotation == self.lineAnno) {
    annotationView.image = nil;
    return annotationView;
}



SMXAnno *tt = (SMXAnno *)annotation;
if ([tt isKindOfClass:[SMXAnno class]]) {

    self.anno.icon.url = tt.url;
    [self.anno.attributes arrayByAddingObjectsFromArray:tt.attributes];
    self.anno.title = tt.title;
}else{

	return annotationView;
}

	[SVProgressHUD dismiss];

UIImageView *imageView = [[UIImageView alloc]init];

if (tt.annoModel.icon.url == nil) {
    tt.annoModel.icon.url = @"http://a.dituhui.com/images/marker/icon/default/f187a438f894863854cc53b6927702b3.png";
}

[imageView sd_setImageWithURL:[NSURL URLWithString:tt.annoModel.icon.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    CGSize size = CGSizeMake(image.size.width *1.5, image.size.height *1.5);
    UIGraphicsBeginImageContext(size);
    [imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
  
        [annotationView setImage:scaledImage];
    
    CGPoint p = CGPointMake(0,-image.size.height/5);
    
    [annotationView setCenterOffset:p];
    

    if ( [self.mapModel.labelSettings.is_show_label isEqual:@"1"]) {
      
        
        for (SMAttributes *attr in tt.annoModel.attributes) {
            
            if ([attr.key isEqual:self.mapModel.labelSettings.label]) {
                
                CGFloat contentHeight = 12;
                
                CGSize size = [attr.value boundingRectWithSize:CGSizeMake(MAXFLOAT, contentHeight) options:
                               NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                
                UILabel *laber = [[UILabel alloc]initWithFrame:CGRectMake(annotationView.width, annotationView.height/4, size.width , 12)];
                laber.backgroundColor = [UIColor whiteColor];
                laber.font = [UIFont systemFontOfSize:12.0f];
                laber.text = attr.value;
                [annotationView addSubview:laber];
                
            }else
            {

            }
        }
    }

}];

imageView = nil;



return annotationView;


}
//}



- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{


if (view.annotation.coordinate.longitude == self.coordinate.longitude && view.annotation.coordinate.latitude == self.coordinate.latitude) {
  
    SMZoneDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"SMZoneDetail" bundle:nil] instantiateInitialViewController];
    
    
    detailVC.zone = _zone;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [self.mapView removeAnnotation:self.regonAnno];
    
    return;
    
}


if (view.annotation.coordinate.longitude == self.linecoordinate.longitude && view.annotation.coordinate.latitude == self.linecoordinate.latitude) {
    
    SMZoneDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"SMZoneDetail" bundle:nil] instantiateInitialViewController];
    
    
    detailVC.line = _line;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    
    [self.mapView removeAnnotation:self.regonAnno];
    [self.mapView removeAnnotation:self.lineAnno];
    return;
    
}


if (view.annotation.coordinate.longitude == self.poi.pt.longitude && view.annotation.coordinate.latitude == self.poi.pt.latitude) {
    
    UIStoryboard *sb= [UIStoryboard storyboardWithName:@"EditAnno" bundle:nil];
    SMEditAnnoVC *editvc = [sb instantiateInitialViewController];
    
    editvc.level = self.mapView.zoomLevel;
    editvc.coordinate = self.poi.pt;
    editvc.mapModel = self.mapModel;
    editvc.delegate = self;
    
    editvc.poiModel = self.poi;
    
    
    
    [self.navigationController pushViewController:editvc animated:YES];
    
    [self.mapView removeAnnotation:self.item];
    
    
    
}else{

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAnnoDetail" bundle:nil];
    SMAnnoDetailViewController *detailVC = [sb instantiateInitialViewController];
    
    [self addChildViewController:detailVC];
    
    for (SMAnno *anno in self.annoDataArr) {
        if ([self.mapModel.app_name isEqual:@"LINE"]) {
            NSArray *arr = [anno.bdxy componentsSeparatedByString:@","];
            anno.x = [arr[0] doubleValue];
            anno.y = [arr[1] doubleValue];
        }
        if (view.annotation.coordinate.longitude == anno.x && view.annotation.coordinate.latitude == anno.y ) {

            if (anno) {
                detailVC.annoModel = anno;
                detailVC.mapModel = self.mapModel;
                detailVC.finalUrl = anno.icon.url;
                [self.navigationController pushViewController:detailVC animated:YES];
                return;
            }
        }
    }
}
}


- (IBAction)locate:(UIButton *)sender {


BOOL enable=[CLLocationManager locationServicesEnabled];

int status=[CLLocationManager authorizationStatus];
if(enable && status>=3)  {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
        //    static dispatch_once_t onceToken;
        //    dispatch_once(&onceToken, ^{
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;        _mapView.showsUserLocation = YES;
}else
{
    
    
    if (_locService ==nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
    }else{
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        

    }
    
    
    
}


}

- (IBAction)suoxiao:(UIButton *)sender {
float level =  self.mapView.zoomLevel;
if (3.0 < level <19.0) {
    self.mapView.zoomLevel = self.mapView.zoomLevel + 1.0;
}
}

- (IBAction)fangda:(UIButton *)sender {
float level =  self.mapView.zoomLevel;
if (3.0 < level <19.0) {
    self.mapView.zoomLevel = self.mapView.zoomLevel - 1.0;
}
}
- (IBAction)addAnnoClick:(UIButton *)sender {

if (self.addisOn == NO) {
    [self.addAnno setImage:[UIImage imageNamed:@"map_guanbi"] forState:UIControlStateNormal];
    
    [self.addAnno setImage:[UIImage imageNamed:@"map_guanbi_press"] forState:UIControlStateHighlighted];
    
    self.centerAnno.hidden = NO;
    
}else
{
    self.centerAnno.hidden = YES;
    [self.addAnno setImage:[UIImage imageNamed:@"map_dingwei@2x-13"] forState:UIControlStateNormal];
}
  self.addisOn = !self.addisOn;
}



-(BOOL)isOperator
{
SMAccount *acount = [SMAccount accountFromSandbox];

for (NSNumber *num in acount.groups) {
    NSString *str = [NSString stringWithFormat:@"%@",num];
    if ([str isEqualToString:self.mapModel.group_id]) {
        return YES;
        break;
    }
}
return NO;
}


- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
SMAccount *acount = [SMAccount accountFromSandbox];
//    BOOL identicalStringFound = [acount.groups indexOfObjectIdenticalTo:self.mapModel.group_id] != NSNotFound;
//    SMLog(@"%d",identicalStringFound);
if ((self.mapModel && ![self.mapModel.app_name isEqualToString:@"LINE"]&&[self.mapModel.user_id isEqualToString:acount.user_id] )||[self.mapModel.edit_permission isEqualToString:@"public"]||
//        [acount.groups containsObject:self.mapModel.group_id]
    [self isOperator]
//     identicalStringFound
    ) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EditAnno" bundle:nil];
    SMEditAnnoVC *editvc = [sb instantiateInitialViewController];
    
    editvc.level = self.mapView.zoomLevel;
    editvc.coordinate = coordinate;
    editvc.mapModel = self.mapModel;
    editvc.delegate = self;
    
    [self addChildViewController:editvc];
    [self.navigationController pushViewController:editvc animated:YES];
    
}else{
    return;
}
}
- (IBAction)centerAnnoClick:(UIButton *)sender {

UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EditAnno" bundle:nil];
SMEditAnnoVC *editvc = [sb instantiateInitialViewController];

if (self.annoArray.count) {
    SMAnno *model = self.annoDataArr[0];
     editvc.attr = model.attributes;
}else
{
    NSMutableArray *attr = [[NSMutableArray alloc]init];
    editvc.attr = attr;
}




editvc.level = self.mapView.zoomLevel;
editvc.coordinate = self.mapView.centerCoordinate;
editvc.mapModel = self.mapModel;
editvc.delegate =self;
editvc.isAddAnno = YES;


[self addChildViewController:editvc];
[self.navigationController pushViewController:editvc animated:YES];
[self addAnnoClick:self.addAnno];
}

-(void)willgiveToDetail:(NSMutableArray *)images title:(NSString *)title detailTitle:(NSString *)detailTitle makerId:(NSString *)makerId
{

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/markers/%@",makerId];

[manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
    SMAnno *annoNewModel = [SMAnno objectWithKeyValues:responseObject[@"marker_info"]];

    [self.annoDataArr addObject:annoNewModel];
    self.anno = annoNewModel;

    SMXAnno* annotation = [[SMXAnno alloc]init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = annoNewModel.y;
    coor.longitude = annoNewModel.x;
    annotation.coordinate = coor;
    annotation.title = annoNewModel.title;
    
    annotation.annoModel = annoNewModel;
    
    [_mapView addAnnotation:annotation];
    
    [self.annoArray addObject:annotation];
    
    

    BMKMapStatus *status = [[BMKMapStatus alloc]init];
    
    status.targetGeoPt = CLLocationCoordinate2DMake(annoNewModel.y, annoNewModel.x);
    
    [self.mapView setMapStatus:status withAnimation:YES];
    [self.mapView selectAnnotation:annotation animated:YES];

} failure:^(NSURLSessionDataTask *task, NSError *error) {
//        SMLog(@"%@",error);
}];

}

-(void)detailEditChangeMap:(NSNotification *)notification
{
SMAnno *anno = [[notification userInfo] valueForKey:@"editmodel"];

    for (BMKPointAnnotation* annotation in self.annoArray) {
            if (annotation.coordinate.latitude == anno.y && annotation.coordinate.longitude == anno.x) {
                [self.mapView removeAnnotation:annotation];
                [self.annoDataArr removeObject:anno];
            }

        }

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.requestSerializer = [AFJSONRequestSerializer serializer];

SMAccount *account = [SMAccount accountFromSandbox];

[manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/markers/%@",anno.Lid];

[manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    SMAnno *annoNewModel = [SMAnno objectWithKeyValues:responseObject[@"marker_info"]];

    [self.annoDataArr addObject:annoNewModel];
    
    
    


	SMXAnno *annotation = [[SMXAnno alloc]init];



    CLLocationCoordinate2D coor;
    coor.latitude = annoNewModel.y;
    coor.longitude = annoNewModel.x;
    annotation.coordinate = coor;
    annotation.title = annoNewModel.title;
    
	annotation.annoModel = annoNewModel;
    

    self.anno =annoNewModel;
    [_mapView addAnnotation:annotation];
    

    
    [self.annoArray addObject:annotation];
    

    BMKMapStatus *status = [[BMKMapStatus alloc]init];
    
    status.targetGeoPt = CLLocationCoordinate2DMake(annoNewModel.y, annoNewModel.x);
    
    [self.mapView setMapStatus:status withAnimation:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
    
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    SMLog(@"%@",error);
}];
}


-(void)detailDeleteChangeMap:(NSNotification *)noti
{
SMAnno *anno = [[noti userInfo] valueForKey:@"deletemodel"];

for (BMKPointAnnotation* annotation in self.annoArray) {
    if (annotation.coordinate.latitude == anno.y && annotation.coordinate.longitude == anno.x) {
        [self.mapView removeAnnotation:annotation];
        [self.annoDataArr removeObject:anno];
    }

}
}
- (IBAction)mapDiffClick:(UIButton *)sender {
self.mapDiffIsOn = !_mapDiffIsOn;
self.mapDiffView.hidden = !_mapDiffIsOn;

if (self.mapDiffIsOn) {
    
    [self.mapDiffBtn setImage:[UIImage imageNamed:@"map_guanbi"] forState:UIControlStateNormal];
    

    if (self.isSatelaiteMap) {
        [self.satelaiteMapBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];
        [self.normalMapBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];
    }
    
    
    

    if (self.heatSwitch.on) {
        [self.heatSwitch setOn:YES];
    }else
    {
        [self.heatSwitch setOn:NO];
    }
    
    if (self.annoSwitch.on) {
        [self.annoSwitch setOn:YES];
    }else
    {
        [self.annoSwitch setOn:NO];
    }
  
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
         self.mapDiffView.alpha = 1.f;
         self.mapDiffView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
             self.mapDiffView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];

    
}else
{

    
    [self.mapDiffBtn setImage:[UIImage imageNamed:@"map_diff"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3f animations:^{
        
         self.mapDiffView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.mapDiffView.alpha = 0.1f;
    } completion:^(BOOL finished) {
        self.mapDiffView.hidden = YES;
    }];
}
}
- (IBAction)normalMapClcik:(UIButton *)sender {



[self.satelaiteMapBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];
[self.normalMapBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];

self.isSatelaiteMap = NO;
_mapView.mapType = BMKMapTypeStandard;

}
- (IBAction)satelaiteMapLick:(UIButton *)sender {
self.isSatelaiteMap = YES;

[self.satelaiteMapBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"] forState:UIControlStateNormal];
[self.normalMapBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"] forState:UIControlStateNormal];

_mapView.mapType = BMKMapTypeSatellite;
//     NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config(清新蓝)" ofType:@""];
//    [BMKMapView customMapStyle:path];
}



- (IBAction)annoSwitch:(UISwitch *)sender {
if (self.heatSwitch.on && !self.annoSwitch.on) {

    [self.annoSwitch setOn:NO];
    [_mapView removeAnnotations:_mapView.annotations];
}else
{
    [self.annoSwitch setOn:YES];

    [_mapView addAnnotations:self.annoArray];
}
}

-(void)creatHeatMap
{

BMKHeatMap* heatMap = [[BMKHeatMap alloc]init];

NSMutableArray* data = [NSMutableArray array];


for (BMKPointAnnotation *anno  in self.mapView.annotations) {

    BMKHeatMapNode *heapmapnode_test = [[BMKHeatMapNode alloc]init];
    
    heapmapnode_test.pt = anno.coordinate;
    heapmapnode_test.intensity = 1.0f;

    [data addObject:heapmapnode_test];
}


UIColor* color1 = [UIColor blueColor];
UIColor* color2 = [UIColor greenColor];
UIColor* color3 = [UIColor yellowColor];
UIColor* color4 = [UIColor redColor];

NSArray*colorInitialArray = [[NSArray alloc]initWithObjects:color1,color2,color3,color4,nil];
//    heatMap.mGradient.mColors = colorInitialArray;
//    heatMap.mGradient.mStartPoints = @[@"0.08f", @"0.4f", @"1f"];

BMKGradient* gradient =[[BMKGradient alloc]initWithColors:colorInitialArray startPoints:@[@"0.08",@"0.5",@"0.9",@"1"]];
heatMap.mGradient = gradient;


heatMap.mData = data;
heatMap.mRadius = 25;
//    heatMap.mOpacity = 0.4;


self.heatMap = heatMap;
[_mapView addHeatMap:heatMap];

}
- (IBAction)heatSwitch:(UISwitch *)sender {
if (!self.heatSwitch.on && self.annoSwitch.on) {
    [self.heatSwitch setOn:NO];
     [_mapView removeHeatMap];
}else
{
    [self.heatSwitch setOn:YES];
    [self creatHeatMap];
}
}
- (IBAction)reglonSwitch:(UISwitch *)sender {

if (!self.reglonSwitch.on) {
    [self.reglonSwitch setOn:NO];
     [self.mapView removeOverlays:self.polygonArr];
  
}else
{
    [self.reglonSwitch setOn:YES];
     [self.mapView addOverlays:self.polygonArr];
}

}
- (IBAction)didClickPhotoPick:(UIButton *)sender {

BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
picker.maximumNumberOfSelection = 1;
picker.multipleSelection = NO;
picker.assetsFilter = [ALAssetsFilter allPhotos];
picker.showEmptyGroups = YES;
picker.delegate=self;
picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return YES;
}];

[self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAsset:(ALAsset*)asset
{
    UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];


NSDictionary *imageData = [[NSMutableDictionary alloc]initWithDictionary:asset.defaultRepresentation.metadata];

NSDictionary *gpsData = [imageData objectForKey:(NSString *)kCGImagePropertyGPSDictionary];

NSString *latitude = [gpsData objectForKey:@"Latitude"];
NSString *longitude = [gpsData objectForKey:@"Longitude"];


NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];


 [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; ;


formatter.dateFormat = @"yyyy:MM:dd HH:mm:ss";
NSString *dateStr = [NSString stringWithFormat:@"%@ %@",gpsData[@"DateStamp"],gpsData[@"TimeStamp"]];
NSDate *createdDate = [formatter dateFromString:dateStr];

 formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:28800]];

CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);

NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);

testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);


CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转

if (latitude) {
    SMEditAnnoVC *editAnno = [[UIStoryboard storyboardWithName:@"EditAnno" bundle:nil] instantiateInitialViewController];
    editAnno.temImage = tempImg;
    

    editAnno.altitude = [NSString stringWithFormat:@"%f",baiduCoor.latitude];
    editAnno.longtitude = [NSString stringWithFormat:@"%f",baiduCoor.longitude];
    editAnno.level = self.mapView.zoomLevel ;
    editAnno.mapModel = self.mapModel;
    editAnno.delegate = self;
    editAnno.temImageTitle =[formatter stringFromDate:createdDate];;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController pushViewController:editAnno animated:YES];
}else
{
    [SVProgressHUD showErrorWithStatus:@"您选择的照片没有定位信息，请重新选择"];
}
}

-(void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets
{
if (assets.count == 0) {
    [SVProgressHUD showErrorWithStatus:@"请选择一张照片"];
}else{
[SVProgressHUD showErrorWithStatus:@"图片无位置信息,请选择自己拍摄的照片并给与相机定位权限"];
}
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



BOOL enable=[CLLocationManager locationServicesEnabled];

int status=[CLLocationManager authorizationStatus];
if(enable && status>=3)  {
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    self.isNeedPhotoLocation = YES;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImagePickerController *cameraUI = [UIImagePickerController new];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
    
    [self presentViewController:cameraUI animated: YES completion:nil];
}else
{
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】"preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
  
        [picker presentViewController:alertVC animated:YES completion:nil];

   

}


}
#pragma mark - UIImagePickerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
[picker dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

UIImage *image = info[UIImagePickerControllerOriginalImage];

if (self.photoUserLocation) {
    SMEditAnnoVC *editAnno = [[UIStoryboard storyboardWithName:@"EditAnno" bundle:nil] instantiateInitialViewController];
    editAnno.temImage = image;
    
    
    editAnno.altitude = [NSString stringWithFormat:@"%f",
                         _photoUserLocation.location.coordinate.latitude];
    editAnno.longtitude = [NSString stringWithFormat:@"%f",_photoUserLocation.location.coordinate.longitude];
    editAnno.level = self.mapView.zoomLevel ;
    editAnno.mapModel = self.mapModel;
    editAnno.delegate = self;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
      dateFormatter.dateFormat = @"yyyy:MM:dd HH:mm:ss";
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    editAnno.temImageTitle = dateString;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController pushViewController:editAnno animated:YES];
}else
{
    [SVProgressHUD showErrorWithStatus:@"未采集到您的位置信息"];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



}


@end
