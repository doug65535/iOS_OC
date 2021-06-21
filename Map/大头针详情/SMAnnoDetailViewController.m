//
//  SMAnnoDetailViewController.m
    
//
//  Created by lucifer on 15/8/5.
  
//

#import "SMAnnoDetailViewController.h"
#import "SMAttributes.h"
#import "SMImg.h"

#import "SMPhotoCollectionViewCell.h"

#import "SMMapViewController.h"

#import "RootTableViewController.h"
#import "SMEditAnnoVC.h"
#import "HZPhotoBrowser.h"
#import "SMAttributes.h"
@interface SMAnnoDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SMEditAnnoVCDelegate,HZPhotoBrowserDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *annoDetailTitle;


//@property (weak, nonatomic) IBOutlet UILabel *picLaber;


//@property (strong, nonatomic) IBOutlet UILabel *detailText;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
//@property (strong, nonatomic) IBOutlet UILabel *attrKey;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *laout;
@property (strong, nonatomic) IBOutlet UICollectionView *imgCollec;

@property(strong,nonatomic)HZPhotoBrowser *photoBrowser;
//@property (weak, nonatomic) IBOutlet UILabel *creatorInfo;
@property (weak, nonatomic) IBOutlet UIButton *creator;
- (IBAction)enterCreator:(id)sender;

@property(strong,nonatomic)UIImage *image;
@property(strong ,nonatomic)NSMutableArray *imageArr;
@property(strong,nonatomic)UIImage *cellImage;

//@property (weak, nonatomic) IBOutlet UIButton *daohang;
- (IBAction)daohang:(UIButton *)sender;

- (IBAction)locationToMap:(UIButton *)sender;
@property(nonatomic,strong) BMKLocationService *locService;

@property (weak, nonatomic) IBOutlet UILabel *creatTime;


@property (weak, nonatomic) IBOutlet UITableView *detailKeyValue;

@property (weak, nonatomic) IBOutlet UIView *picView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTBTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picConstraint;
@property (weak, nonatomic) IBOutlet UILabel *creator1;

@end

@implementation SMAnnoDetailViewController


-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.annoModel.subTitle) {
        self.annoModel.title = self.annoModel.subTitle;
    }
    
    self.imgCollec.delegate = self;
    self.imgCollec.dataSource =self;
  
    self.laout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    
    self.detailKeyValue.dataSource = self;
    self.detailKeyValue.delegate = self;
    
    self.annoDetailTitle.text = self.annoModel.title;
    
    if (self.annoModel.img.count == 0) {
        self.picView.hidden = YES;
        self.detailTBTopMargin.constant = 15;
    }
    
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.detailKeyValue setTableFooterView:view];
    
    [self.detailKeyValue setTableHeaderView:view];
    
    
//    for (SMAttributes *attr in self.annoModel.attributes) {
//        self.attrKey.text = attr.key;
//        self.detailText.text = attr.value;
//        SMLog(@"%@",attr.value);
//        if ([attr.value isEqualToString:@""]) {
////            [self.attrKey removeFromSuperview];
////            [self.detailText removeFromSuperview];
//            
//            self.attrKey.hidden = YES;
//            self.detailText.hidden = YES;
//        }
//    }
    
        [self.creator setTitle:self.annoModel.creator forState:UIControlStateNormal];
        
        self.creatTime.text = self.annoModel.created_at;
    
    SMAccount *acount = [SMAccount accountFromSandbox];
//    路线地图不支持编辑
    if ((![self.mapModel.app_name isEqualToString:@"LINE"])&&([self.mapModel.user_id isEqualToString:acount.user_id] || [self.mapModel.edit_permission isEqualToString:@"public"] ||
        [self isOperator]
        )) {
        self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_create"]  style:UIBarButtonItemStylePlain target:self action:@selector(willENterEditAnnoVc)];
    }
    
    if ([self.mapModel.user_id isEqualToString:acount.user_id])
    {
        [self.creator1 removeFromSuperview];
        [self.creator removeFromSuperview];
        [self.creatTime removeFromSuperview];
        self.picConstraint.constant = 0;
    }    
}

-(void)willENterEditAnnoVc
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"EditAnno" bundle:nil];
    SMEditAnnoVC *editVc = [sb instantiateInitialViewController];
    
    editVc.level = [self.mapModel.level floatValue];
    
    CLLocationCoordinate2D coor;
    coor.longitude = self.annoModel.x;
    coor.latitude = self.annoModel.y;
    
    editVc.coordinate = coor;
    editVc.mapModel = self.mapModel;
    editVc.finalStr = self.finalUrl;
    
    editVc.annoModel = self.annoModel;
    editVc.delegate = self;
//    编辑后在进入
    if (self.imageArr.count != 0) {
        [editVc.images addObjectsFromArray:self.imageArr];
    }
//    初始进入
    else
    {
        [editVc.imgArr addObjectsFromArray:self.annoModel.img];
    }
    
    [self addChildViewController:editVc];
    
    [self.navigationController pushViewController:editVc animated:YES];
}

-(void)willgiveToDetail:(NSMutableArray *)images title:(NSString *)title detailTitle:(NSString *)detailTitle makerId:(NSString *)makerId
{
    if (images.count != 0) {

        self.detailTBTopMargin.constant = 130;
        self.picView.hidden = NO;
    }
    
    if ( images.count == 0 ) {
        self.picView.hidden = YES;
        self.detailTBTopMargin.constant = 15;
    }
    
    [self.imageArr removeAllObjects];
    [self.imageArr addObjectsFromArray:images];
    
//   没用把？!
    
    for (UIImage *image in images) {
        
        self.image = image;
        
    }
    [self.imgCollec reloadData];

    

//        for (SMAttributes *attr in self.annoModel.attributes) {
//            attr.value = detailTitle;
//        }
        [self.detailKeyValue reloadData];

    
    if (title) {
         self.annoDetailTitle.text = title;
    }
}

-(void)didclickGPS
{

//    发布通知
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.annoModel forKey:@"model"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.image) {
        return self.imageArr.count;
    }else{
    return self.annoModel.img.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.获取cell
    SMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
//    self.imageCell = cell;
    
    if (self.image) {
        cell.image = self.imageArr[indexPath.row];
    }else
    {
        SMImg *img = self.annoModel.img[indexPath.row];
        cell.img = img;
    }
    
    cell.imageview.contentMode =  UIViewContentModeScaleAspectFill;


    // 3.返回cell
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//     SMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    SMPhotoCollectionViewCell *cell = (SMPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    _photoBrowser = browserVc;
    
    browserVc.sourceView = cell;
//    browserVc.sourceImagesContainerView = cell.superview;

    if (self.annoModel.img.count) {
        browserVc.imageCount = self.annoModel.img.count;
        browserVc.currentImageIndex = (int)indexPath.item;
        
    }
    else
    {
        browserVc.imageCount = 1;
        browserVc.currentImageIndex = 0;
    }

    
    self.cellImage = cell.imageview.image;
    // 代理
    browserVc.delegate = self;
    // 展示图片浏览器
    
    [self presentViewController:browserVc animated:NO completion:nil];
//     [browserVc show];
}

-(void)cellChangeL:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SMPhotoCollectionViewCell *cell = (SMPhotoCollectionViewCell *)[_imgCollec cellForItemAtIndexPath:indexPath];
    _photoBrowser.sourceImagesContainerView = cell;
}

-(UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.cellImage;
}

-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
        SMImg *pic = self.annoModel.img[index];
        return [NSURL URLWithString:pic.url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)todoSomething:(id)sender
{
    if (self.annoModel.creator) {
   
        
        NSInteger uid = self.annoModel.creator_id.integerValue *12345 +54321;
        NSString *strUid = [NSString stringWithFormat:@"%tu",uid];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@",strUid];
        
        [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            SMUser *userModel = [SMUser objectWithKeyValues:responseObject];
            RootTableViewController *rootVc =[[UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil]instantiateInitialViewController];
            rootVc.userModle = userModel;
            [self.navigationController pushViewController:rootVc animated:YES];
            [SVProgressHUD dismiss];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@",error);
            [SVProgressHUD dismiss];
        }];
        
    }else{
        [SVProgressHUD dismiss];
        return;
    }

}

//-(void)dealloc
//{
//    [SVProgressHUD dismiss];
//}

- (IBAction)enterCreator:(id)sender {
         [SVProgressHUD showWithStatus:@"正在加载"];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:1.0f];
    
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
        _locService.delegate = nil;
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"定位失败"];
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //初始化调启导航时的参数管理类
//    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    
    BMKOpenDrivingRouteOption *option = [[BMKOpenDrivingRouteOption alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
//    CLLocationCoordinate2D coor1;
//    coor1.latitude = ;
//    coor1.longitude = ;
    start.pt = userLocation.location.coordinate;
    //指定起点名称
    start.name = userLocation.title;
    //指定起点
//    para.startPoint = start;
    option.startPoint = start;
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    CLLocationCoordinate2D coor2;
    coor2.latitude = self.annoModel.y;
    coor2.longitude = self.annoModel.x;
    end.pt = coor2;
    //指定终点名称
    end.name = self.annoModel.title;
    //指定终点
//    para.endPoint = end;
    option.endPoint = end;
    
//    //指定返回自定义scheme
//    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
//    para.appScheme = @"com.supermap.dituhui.iosdituhui";
    
    //调启百度地图客户端导航
//    [BMKNavigation openBaiduMapNavigation:para];
//    [_locService stopUserLocationService];
    
    [BMKOpenRoute openBaiduMapDrivingRoute:option];
    _locService.delegate = nil;
}

- (IBAction)daohang:(UIButton *)sender {
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];

}

- (IBAction)locationToMap:(UIButton *)sender {
    [self didclickGPS];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.annoModel.attributes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    SMAttributes *attr = self.annoModel.attributes[indexPath.row];
    
    cell.textLabel.text = attr.key;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = attr.value;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // 列寬
    CGFloat contentWidth = kWidth -40;
    // 用何種字體進行顯示
    // 該行要顯示的內容
    SMAttributes *attr = self.annoModel.attributes[indexPath.row];
    NSString *content = attr.value;
    // 計算出顯示完內容需要的最小尺寸
//    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:
            NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    SMLog(@"%f",size.height);
    // 這裏返回需要的高度
    return size.height+20;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
