//
//  SMOfflineMapViewController.m
    
//
//  Created by lucifer on 16/4/18.
   
//

#import "SMOfflineMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


#import "ShopTypeCell.h"
#import "MJShopListController.h"


#define kDuration 0.2
#define kAlpha 0
@interface SMOfflineMapViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,BMKOfflineMapDelegate,BMKGeoCodeSearchDelegate>

{
    
    BMKLocationService* _locService;
    
    BMKGeoCodeSearch* _geocodesearch;

    NSString *_citiName;
    
    NSString *_province;
    

    
    /**
     *  热门城市
     */
    NSArray* _arrayHotCityData;
    /**
     *  全国支持离线地图的城市
     */
    NSArray* _arrayOfflineCityData;
    
//    /**
//     *  支持离线地图的省份下城市
//     */
//    NSMutableArray* _arrayOffineProinceCityArr;
    /**
     *  本地下载的离线地图
     */
    NSArray* _arraylocalDownLoadMapInfo;
    /**
     *  下载的离线地图已完成的
     */
    NSMutableArray* _localFinishMapInfo;
    
    /**
     *  下载的离线地图未完成的
     */
    NSMutableArray* _localUnFinishMapInfo;
    
    /**
     *  下载完成的需要更新的
     */
    NSMutableArray *_localUpdateInfo;
    
    /**
     *  全局设置
     */
    UIView *_btnsView;
}



@property (nonatomic, strong) NSMutableArray *animRows;
@property (nonatomic, strong) MJShopListController *shopsController;

- (IBAction)segementChange:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControl;

@property (weak, nonatomic) IBOutlet UIView *noShowView;

@end

@implementation SMOfflineMapViewController



- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BMKAddressComponent* poi = result.addressDetail;
        _citiName = poi.city;
        _province = poi.province;

    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        SMLog(@"起始点有歧义");
    } else if(error == BMK_SEARCH_RESULT_NOT_FOUND){
        [SVProgressHUD showErrorWithStatus:@"没有检索到结果"];
    }

}

- (void)dealloc {
    
    if (_offlineMap.delegate!= nil) {
        _offlineMap.delegate = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = _locService.userLocation.location.coordinate;
    [_geocodesearch reverseGeoCode:option];
}





- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {

        
        if (self.segementControl.selectedSegmentIndex == 0) {
            

            BMKOLUpdateElement* updateInfo = [_offlineMap getUpdateInfo:state];
            SMLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
            [self reLoadLocalArr];
            [self.mainTB reloadData];
            
        }

        
    }
    
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        SMLog(@"是否有更新%d",updateInfo.update);
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
     self.shopsController = [[MJShopListController alloc] init];
   
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    // Do any additional setup after loading the view.
    self.title = @"离线地图包";
    
    
    //初始化离线地图服务
    
    if (_offlineMap == nil) {
        _offlineMap = [[BMKOfflineMap alloc]init];
    }
    
    _offlineMap.delegate =self;
    
    
     self.shopsController.offlineMap = _offlineMap;
    
    //获取热门城市
    _arrayHotCityData = [_offlineMap getHotCityList];
    //获取支持离线下载城市列表
    _arrayOfflineCityData = [_offlineMap getOfflineCityList];
    
    _arraylocalDownLoadMapInfo = [_offlineMap getAllUpdateInfo];
    
    _localFinishMapInfo = [NSMutableArray array];
    _localUnFinishMapInfo = [NSMutableArray array];
    _localUpdateInfo  =[NSMutableArray array];
    
    for (BMKOLUpdateElement* item in _arraylocalDownLoadMapInfo) {
        if (item.status == 4) {
            [_localFinishMapInfo addObject:item];
        }else
        {
            [_localUnFinishMapInfo addObject:item];
        }
    }
    
    for (BMKOLUpdateElement *item in _localFinishMapInfo) {
        if (item.update == YES) {
            [_localUpdateInfo addObject:item];
        }
    }
    
    
    
  
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"SMClickProviceCity" object:nil];
    
    
    UIView *btnsView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight -40, kWidth, 40)];
    [self.view addSubview:btnsView];
 
    
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/3, 40)];
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/3, 0,kWidth/3 , 40)];
        UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/3*2, 0, kWidth/3, 40)];
    
        [btn1 setBackgroundColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1] ];
    
        [btn2 setBackgroundColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1]];
        [btn3 setBackgroundColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1]];
        
        [btn1.layer setBorderWidth:1.0];
        [btn2.layer setBorderWidth:1.0];
        [btn3.layer setBorderWidth:1.0];
        
        [btn1.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btn2.layer setBorderColor:[UIColor whiteColor].CGColor];
        [btn3.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [btnsView addSubview:btn1];
        [btnsView addSubview:btn2];
        [btnsView addSubview:btn3];
        
        [btn1 setTitle:@"全部更新" forState:UIControlStateNormal];
        [btn2 setTitle:@"全部下载" forState:UIControlStateNormal];
        [btn3 setTitle:@"全部暂停" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    btn3.titleLabel.font = [UIFont systemFontOfSize:12];

        [btn1 setImage:[UIImage imageNamed:@"reload_white"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"download_white"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"pause_white"] forState:UIControlStateNormal];
        
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self  action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (!_localUpdateInfo) {
//            [btn1 setImage:[UIImage imageNamed:@"reload_gray"] forState:UIControlStateNormal];
//            [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        }else
//        {
//            [btn1 setImage:[UIImage imageNamed:@"reload_white"] forState:UIControlStateNormal];
//            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//    
//        for (BMKOLUpdateElement *item in _localUnFinishMapInfo) {
//            //                        没有正在下载 且没有等待下载的
//            if (!(item.status == 1) && !(item.status == 2)) {
//                [btn3 setImage:[UIImage imageNamed:@"pause_gray"] forState:UIControlStateNormal];
//                [btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            }
//        }
//        
//        if (!_localUnFinishMapInfo.count) {
//            [btn2 setImage:[UIImage imageNamed:@"download_gray"] forState:UIControlStateNormal];
//            [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        }
//
       _btnsView = btnsView;
    
    self.mainTB.delegate = self;
    self.mainTB.dataSource = self;
    if (_arraylocalDownLoadMapInfo.count) {
        self.noShowView.hidden = YES;
        _btnsView.hidden = NO;
    }else
    {
        self.noShowView.hidden = NO;
        _btnsView.hidden = YES;
    }
}

-(void)btn1Click:(id)sender
{

    [UIView animateWithDuration:0.2 animations:^{
        [sender setBackgroundColor:[UIColor blueColor]];
    } completion:^(BOOL finished) {
        [sender setBackgroundColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1]];
    }];
        if (_localUpdateInfo.count) {
        
        for (BMKOLUpdateElement *item in _localUpdateInfo) {
            [_offlineMap update:item.cityID];
        }
        [self reLoadLocalArr];
       
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"没有可更新的地图"];
        
    }

}
-(void)btn2Click:(id)sender
{
    
    [UIView animateWithDuration:0.2 animations:^{
        [sender setBackgroundColor:[UIColor blueColor]];
    } completion:^(BOOL finished) {
        [sender setBackgroundColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1]];
    }];
    if (_localUnFinishMapInfo.count) {
        for (BMKOLUpdateElement *item in _localUnFinishMapInfo) {
            [_offlineMap start:item.cityID];
        }
        [self reLoadLocalArr];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"未添加下载地图任务"];
    }

}
-(void)btn3Click:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        [sender setBackgroundColor:[UIColor blueColor]];
    } completion:^(BOOL finished) {
        [sender setBackgroundColor:[UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1]];
    }];
    BOOL needPause = NO;
    for (BMKOLUpdateElement *item in _localUnFinishMapInfo) {
        
        if (item.status == 1 || item.status == 2) {
            needPause = YES;
        }
        
        [_offlineMap pause:item.cityID];
    }
    if (needPause == NO) {
        [SVProgressHUD showErrorWithStatus:@"没有可暂停的任务"];
    }
    
    [self reLoadLocalArr];
}

-(void)notice:(NSNotification *)notification{
    BMKOLSearchRecord *item = [[notification userInfo] valueForKey:@"SMClickProviceCity"];
        [_offlineMap start:item.cityID];
    SMLog(@"%tu",item.cityID);
    
    
    [self reLoadLocalArr];
    
}


-(void)reLoadLocalArr
{
    _arraylocalDownLoadMapInfo = [_offlineMap getAllUpdateInfo];
    [_localFinishMapInfo  removeAllObjects];
    [_localUnFinishMapInfo removeAllObjects];
    
    for (BMKOLUpdateElement* item in _arraylocalDownLoadMapInfo) {
        if (item.status == 4) {
            [_localFinishMapInfo addObject:item];
        }else
        {
            [_localUnFinishMapInfo addObject:item];
        }
    }
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
//    view.tintColor = [UIColor clearColor];
    UITableViewHeaderFooterView *vHeader = (UITableViewHeaderFooterView *)view;
    vHeader.textLabel.font = [UIFont systemFontOfSize:12];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segementControl.selectedSegmentIndex == 0) {
        
        if (_localUnFinishMapInfo.count != 0) {
            return 2;
        }else{
            return 1;
        }
    }else  //城市列表
    {
        return 3;
    }

    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.segementControl.selectedSegmentIndex == 0) {
        
        if (_localUnFinishMapInfo.count != 0) {
            switch (section) {
                case 0:
                    return @"正在下载";
                    break;
                case 1:
                    return @"下载完成";
                    break;
                case 2:
                    return nil;
                default: return nil;
                    break;
            }
        }else{
            if (section == 0) {
                return @"下载完成";
            }else
            {
                return nil;
            }
        }
    }else  //城市列表
    {
        if (section == 0) {
            return @"当前城市";
        }else if(section == 1)
        {
            return @"热门城市";
        }else
        {
            return @"按省份查找";
        }
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segementControl.selectedSegmentIndex == 0) {
        if (_localUnFinishMapInfo.count != 0) {
            switch (section) {
                case 0:
                    return _localUnFinishMapInfo.count;
                    break;
                case 1:
                    return _localFinishMapInfo.count;
                    break;
                case 2:
                    return 0;
                    
                default:return 0;
                    break;
            }
        }else
        {
            switch (section) {
                case 0:
                    return _localFinishMapInfo.count;
                    break;
                case 1:
                    return 0;
                    break;
                    
                default: return 0;
                    break;
            }
        }
    }else  //城市列表
    {
        if (section == 0) {
            return 2;
        }else if(section == 1)
        {
            return _arrayHotCityData.count;
        }else
        {
            return _arrayOfflineCityData.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    tableView.separatorStyle = NO;
    static NSString *identifier = @"UITableViewCell";
    ShopTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ShopTypeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    
    if (self.segementControl.selectedSegmentIndex == 0) {//下载管理
        
//        点过来要关闭抽屉恢复cell样式
        
        [self.shopsController.view removeFromSuperview];
        self. animRows = nil;
        // 可以滚动
        self.mainTB. scrollEnabled= YES;
        
        if (_localUnFinishMapInfo.count != 0) {//有正在下载的 显示三组
            switch (indexPath.section) {
                case 0:
                {
                    BMKOLUpdateElement *item = _localUnFinishMapInfo[indexPath.row];
                    cell.textLabel.text= item.cityName;
                    
                    UILabel *laber =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
//                    laber.autoresizingMask =UIViewAutoresizingFlexibleRightMargin;
                    laber.backgroundColor = [UIColor clearColor];
                    laber.font = [UIFont systemFontOfSize:12];
                    laber.textColor = [UIColor lightGrayColor];
                    
                    switch (item.status) {
                
                            case 1:
                            laber.text = [NSString stringWithFormat:@"正在下载%tu%%",item.ratio];
                            break;
                        case 2:
                            laber.text = [NSString stringWithFormat:@"等待下载%tu%%",item.ratio];
                            break;
                            case 3:
                            laber.text = [NSString stringWithFormat:@"已暂停%tu%%",item.ratio];
                            laber.textColor = [UIColor redColor];
                            break;
                        default:
                            laber.text = @"异常";
                             laber.textColor = [UIColor redColor];
                            break;
                    }
                    
                    
                    cell.accessoryView = laber;
                }
                    break;
                case 1:
                {
                    BMKOLUpdateElement *item = _localFinishMapInfo[indexPath.row];
                    cell.textLabel.text= item.cityName;

                    UILabel *laber =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
                    laber.backgroundColor = [UIColor clearColor];
                    laber.font = [UIFont systemFontOfSize:12];
                    
                    if (item.update == YES) {
                        
                        NSString *str = [NSString stringWithFormat:@"有更新%@",[self getDataSizeString:item.size]];
                        laber.width = 60;
                        laber.text = str;
                        laber.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                    }else{
                        laber.textColor = [UIColor lightGrayColor];
                        laber.text = @"完成";
                    }
                    
                    cell.accessoryView = laber;
                }
                    break;
                case 2:
                {
                    
                }
                    
                default:
                    break;
            }
        }else  //没有正在下载的 显示两组
        {
            if (indexPath.section == 0) {
                BMKOLUpdateElement *item = _arraylocalDownLoadMapInfo[indexPath.row];
                cell.textLabel.text= item.cityName;
                UILabel *laber =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
                
                laber.font = [UIFont systemFontOfSize:12];
                laber.backgroundColor = [UIColor clearColor];
                if (item.update == YES) {
                    
                    NSString *str = [NSString stringWithFormat:@"有更新%@",[self getDataSizeString:item.size]];
                    laber.width = 60;
                    laber.text = str;
                    laber.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                }else{
                    laber.textColor = [UIColor lightGrayColor];
                    laber.text = @"完成";
                }
                
                cell.accessoryView = laber;
            }else
            {
//                uiswitch
            }
        }

   
}else           //城市列表
    {
        if (indexPath.section == 0) {  //当前城市
            if (indexPath.row == 0) {
                if (_citiName == nil) {
                    cell.textLabel.text = @"还未定位到当前城市";
                    
                    cell.accessoryView = nil;
                }else
                {
                    cell.textLabel.text = _citiName;
                    
                    for (BMKOLSearchRecord *item in _arrayOfflineCityData ) {
                        
                        if ([item.cityName isEqualToString: _citiName]) {
                            
                            
                            NSString*packSize = [self getDataSizeString:item.size];
                            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 70, 40)];
                            UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
                            UIImageView *imageView = [[UIImageView alloc]init];
                            imageView.frame = CGRectMake(50, 0, 20, 40);
                            [imageView setImage:[UIImage imageNamed:@"lodingBlue"]];
                            imageView.contentMode = UIViewContentModeCenter;
                            [view addSubview:sizelabel];
                            [view addSubview:imageView];
                            sizelabel.text = packSize;
                            sizelabel.font = [UIFont systemFontOfSize:12];
                            sizelabel.backgroundColor = [UIColor clearColor];
                            
                            cell.accessoryView = view;
                            BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:item.cityID];
                            
                            switch (element.status) {
                                case 1:
                                    sizelabel.text = @"正在下载";
                                    sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                                    break;
                                case 2:
                                    sizelabel.text = @"等待下载";
                                    sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                                    break;
                                case 3:
                                    sizelabel.text = @"已暂停";
                                    sizelabel.textColor = [UIColor redColor];
                                    break;
                                case 4:
                                    sizelabel.text = @"已下载";
                                    sizelabel.textColor  =[UIColor lightGrayColor];
                                    [imageView setImage:[UIImage imageNamed:@"lodingGray"]];
                                    break;
                                    
                                default:sizelabel.text = packSize;
                                    break;
                            }
                            
                            
                        }
                        if([item.cityName isEqualToString: _province])
                        {
                            for (BMKOLSearchRecord *provinceItem in item.childCities) {
                                NSString*packSize = [self getDataSizeString:provinceItem.size];
                                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 70, 40)];
                                UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
                                UIImageView *imageView = [[UIImageView alloc]init];
                                imageView.frame = CGRectMake(50, 0, 20, 40);
                                [imageView setImage:[UIImage imageNamed:@"lodingBlue"]];
                                imageView.contentMode = UIViewContentModeCenter;
                                [view addSubview:sizelabel];
                                [view addSubview:imageView];
                                sizelabel.text = packSize;
                                sizelabel.font = [UIFont systemFontOfSize:12];
                                sizelabel.backgroundColor = [UIColor clearColor];
                                
                                cell.accessoryView = view;
                                BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:item.cityID];
                                
                                switch (element.status) {
                                    case 1:
                                        sizelabel.text = @"正在下载";
                                        sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                                        break;
                                    case 2:
                                        sizelabel.text = @"等待下载";
                                        sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                                        break;
                                    case 3:
                                        sizelabel.text = @"已暂停";
                                        sizelabel.textColor = [UIColor redColor];
                                        break;
                                    case 4:
                                        sizelabel.text = @"已下载";
                                        sizelabel.textColor  =[UIColor lightGrayColor];
                                        [imageView setImage:[UIImage imageNamed:@"lodingGray"]];
                                        break;
                                        
                                    default:sizelabel.text = packSize;
                                        break;
                                }
                                
                            }
                        }
                    }

                }
                
            }else   //固定的全国包
            {
                cell.textLabel.text = @"全国基础包";
                
                BMKOLSearchRecord *baseItem = _arrayOfflineCityData[0];
                NSString*packSize = [self getDataSizeString:baseItem.size];
                
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 70, 40)];
                UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(50, 0, 20, 40);
                [imageView setImage:[UIImage imageNamed:@"lodingBlue"]];
                imageView.contentMode = UIViewContentModeCenter;
                [view addSubview:sizelabel];
                [view addSubview:imageView];
                sizelabel.text = packSize;
                sizelabel.font = [UIFont systemFontOfSize:12];
                sizelabel.backgroundColor = [UIColor clearColor];
                
                cell.accessoryView = view;
                BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:baseItem.cityID];
                
                switch (element.status) {
                    case 1:
                        sizelabel.text = @"正在下载";
                        sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                        break;
                    case 2:
                        sizelabel.text = @"等待下载";
                        sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                        break;
                    case 3:
                        sizelabel.text = @"已暂停";
                        sizelabel.textColor = [UIColor redColor];
                        break;
                    case 4:
                        sizelabel.text = @"已下载";
                        sizelabel.textColor  =[UIColor lightGrayColor];
                        [imageView setImage:[UIImage imageNamed:@"lodingGray"]];
                        break;
                        
                    default:sizelabel.text = packSize;
                        break;
                }
                
            }
        }else if (indexPath.section == 1){ //热门城市列表
            BMKOLSearchRecord* item = [_arrayHotCityData objectAtIndex:indexPath.row];
            cell.textLabel.text = item.cityName;
            //转换包大小
            NSString*packSize = [self getDataSizeString:item.size];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 70, 40)];
            UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0,view.width-20, 40)];
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(view.width - 20, 0, 20, 40);
            [imageView setImage:[UIImage imageNamed:@"lodingBlue"]];
            imageView.contentMode = UIViewContentModeCenter;
            [view addSubview:sizelabel];
            [view addSubview:imageView];
            sizelabel.text = packSize;
            sizelabel.font = [UIFont systemFontOfSize:12];
            sizelabel.backgroundColor = [UIColor clearColor];
            
            cell.accessoryView = view;
            
            BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:item.cityID];
            
            switch (element.status) {
                case 1:
                    sizelabel.text = @"正在下载";
                    sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                    
                    break;
                case 2:
                    sizelabel.text = @"等待下载";
                    sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                    break;
                case 3:
                    sizelabel.text = @"已暂停";
                    sizelabel.textColor = [UIColor redColor];
                    break;
                case 4:
                    sizelabel.text = @"已下载";
                    sizelabel.textColor  =[UIColor lightGrayColor];
                    [imageView setImage:[UIImage imageNamed:@"lodingGray"]];
                    
                    break;
                    
                default:sizelabel.text = packSize;
                    break;
            }
            

        }else //按省份查找
        {
            BMKOLSearchRecord* item = [_arrayOfflineCityData objectAtIndex:indexPath.row];
            cell.textLabel.text =item.cityName;
            
            if (item.childCities.count) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                imageView.contentMode = UIViewContentModeCenter;
                [imageView setImage:[UIImage imageNamed:@"downClose"]];
                
                cell.accessoryView  = imageView;
            }else
            {
                //转换包大小
                NSString*packSize = [self getDataSizeString:item.size];
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 70, 40)];
                UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0,view.width-20, 40)];
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.frame = CGRectMake(view.width - 20, 0, 20, 40);
                [imageView setImage:[UIImage imageNamed:@"lodingBlue"]];
                imageView.contentMode = UIViewContentModeCenter;
                [view addSubview:sizelabel];
                [view addSubview:imageView];
                sizelabel.text = packSize;
                sizelabel.font = [UIFont systemFontOfSize:12];
                sizelabel.backgroundColor = [UIColor clearColor];
                
                cell.accessoryView = view;
                BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:item.cityID];
                
                switch (element.status) {
                    case 1:
                        sizelabel.text = @"正在下载";
                        sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                        break;
                    case 2:
                        sizelabel.text = @"等待下载";
                        sizelabel.textColor = [UIColor colorWithRed:0 green:118/255.0 blue:1 alpha:1];
                        break;
                    case 3:
                        sizelabel.text = @"已暂停";
                        sizelabel.textColor = [UIColor redColor];
                        break;
                    case 4:
                        sizelabel.text = @"已下载";
                        sizelabel.textColor  =[UIColor lightGrayColor];
                        [imageView setImage:[UIImage imageNamed:@"lodingGray"]];
                        break;
                        
                    default:sizelabel.text = packSize;
                        break;
                }
                

            }
            
            

        }
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (self.segementControl.selectedSegmentIndex == 0) {
        
        if (_localUnFinishMapInfo.count != 0) {//有未完成的下载 三组
            switch (indexPath.section) {
                case 0:{
                    BMKOLUpdateElement *element = _localUnFinishMapInfo[indexPath.row];
                    SMLog(@"%tu",element.status);
                    if (element.status == 1 || element.status == 2) {
                   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                        
                         UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             [_offlineMap remove:element.cityID];
                             
                             
                             [self reLoadLocalArr];
                             [self.mainTB reloadData];
                         }];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }];
                       
                        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"暂停" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [_offlineMap pause:element.cityID];
                            
                            
                            [self reLoadLocalArr];
                            [self.mainTB reloadData];
                        }];
                        [alertController addAction:cancelAction];
                        
                        [alertController addAction:archiveAction];
                        [alertController addAction:deleteAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];

                    }else
                    {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                        
                        UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [_offlineMap remove:element.cityID];
                            [self reLoadLocalArr];
                            [self.mainTB reloadData];
                        }];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"开始下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [_offlineMap start:element.cityID];
                            
                            
                            [self reLoadLocalArr];
                            [self.mainTB reloadData];
                        }];
                        [alertController addAction:cancelAction];
                        
                        [alertController addAction:archiveAction];
                        [alertController addAction:deleteAction];
                 
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                   
                }
                    break;
                case 1:
                {
                     BMKOLUpdateElement *element = _localFinishMapInfo[indexPath.row];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [_offlineMap remove:element.cityID];
                        
                        
                        [self reLoadLocalArr];
                        [self.mainTB reloadData];
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    if (element.update == YES) {
                        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [_offlineMap update:element.cityID];
                        }];
                        [alertController addAction:updateAction];
                    }
                    
                    
                    [alertController addAction:cancelAction];
                    
                    [alertController addAction:deleteAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                    break;
                case 2:    //uiswitch
                {
                     
                }
                    
                default:
                    break;
            }
        }else{  //没有未完成 两组
            if (indexPath.section == 0) {
                BMKOLUpdateElement *element = _localFinishMapInfo[indexPath.row];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
                
                UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [_offlineMap remove:element.cityID];
                    
                    
                    [self reLoadLocalArr];
                    [self.mainTB reloadData];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                
                
                if (element.update == YES) {
                    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [_offlineMap update:element.cityID];
                    }];
                    [alertController addAction:updateAction];
                }
                
                [alertController addAction:cancelAction];
                
                [alertController addAction:deleteAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }else   //uiswitch
            {
                
            }
        }
        
        
        

    }else  // 城市列表
    {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                for (BMKOLSearchRecord *item in _arrayOfflineCityData ) {
                    
                    if ([item.cityName isEqualToString: _citiName]) {
                        [_offlineMap start:item.cityID];
                        [self reLoadLocalArr];
                    }
                    if([item.cityName isEqualToString: _province])
                    {
                        for (BMKOLSearchRecord *provinceItem in item.childCities) {
                            [_offlineMap start:provinceItem.cityID];
                            [self reLoadLocalArr];
                        }
                    }
                }
                

            }else{
                [_offlineMap start:1];
                [self reLoadLocalArr];
            }
            
            
            [tableView reloadData];
            
        }else if(indexPath.section == 1)
        {
            BMKOLSearchRecord *item = _arrayHotCityData[indexPath.row];
            [_offlineMap start:item.cityID];
            [self reLoadLocalArr];
            
            [tableView reloadData];

        }else  //点击按照省份查找的
        {
            BMKOLSearchRecord* item = [_arrayOfflineCityData objectAtIndex:indexPath.row];
            if (item.childCities.count > 0 ) {//有省份下城市数据则展开显示
                
                UITableView *shopsView = (UITableView *)self.shopsController.view;
                // 被点击的cell
                ShopTypeCell *cell = (ShopTypeCell *)[self.mainTB cellForRowAtIndexPath:indexPath];
                
                if (self.animRows) { // 关闭抽屉
//                       self.mainTB.userInteractionEnabled = YES;
                        [self closeWithCell:cell child:shopsView];
                    
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                        imageView.contentMode = UIViewContentModeCenter;
                        [imageView setImage:[UIImage imageNamed:@"downClose"]];
                        
                        cell.accessoryView  = imageView;
                        [self.mainTB reloadData];
               
                } else { // 打开抽屉
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                    [imageView setImage:[UIImage imageNamed:@"upOpen"]];
                    cell.accessoryView = imageView;
                    
                    // 隐藏底部的线
                    [cell showBottomLine:NO];
                    
                    // 设置控制器显示的内容
                    self.shopsController.shops = item.childCities;
                    // 刷新数据
                    [shopsView reloadData];
                    [self.mainTB insertSubview:shopsView atIndex:0];
                    
                    // 控制器view的高度
                    CGFloat shopsHeight = shopsView.frame.size.height;
                    // cell的y
                    CGFloat cellY = cell.frame.origin.y;
                    // 控制器View的Y值
                    CGFloat shopsY = cellY + cell.frame.size.height;
                    // 表格的总体高度
                    CGFloat tableHeight = self.mainTB. frame.size.height;
                    // 表格滚动过的Y值
                    CGFloat offsetY = self.mainTB.contentOffset.y;
                    
                    // 最大的间距
                    CGFloat shopsMaxDelta = tableHeight - shopsHeight;
                    CGFloat deltaY = shopsY - offsetY - shopsMaxDelta;
                    
                    // 初始化数组
                    self.animRows = [NSMutableArray array];
                    if (deltaY >= 0) { // 上面和下面都需要执行动画
                        shopsY -= deltaY;
                        CGFloat downHeight = tableHeight - (shopsY - offsetY);
                        [self up:deltaY down:downHeight indexPath:indexPath block:^CGRect(CGRect animaCellFrame, NSIndexPath *path, NSIndexPath *indexPath, CGFloat up, CGFloat down) {
                            if (path.row <= indexPath.row ) {
                                animaCellFrame.origin.y -= up;
                            } else {
                                animaCellFrame.origin.y += down;
                            }
                            return animaCellFrame;
                        }];
                    }
                    else { // 下面需要执行动画
                        [self up:0 down:shopsHeight indexPath:indexPath block:^CGRect(CGRect animaCellFrame, NSIndexPath *path, NSIndexPath *indexPath, CGFloat up, CGFloat down) {
                            if (path.row > indexPath.row) {
                                animaCellFrame.origin.y += down;
                            }
                            return animaCellFrame;
                        }];
                    }
                    
                    // 设置控制器view的边界
                    CGRect frame = shopsView.frame;
                    frame.origin.y = shopsY;
                    shopsView.frame = frame;
                }
            }else   //  没有省份的要收起来
            {
                UITableView *shopsView = (UITableView *)self.shopsController.view;
                // 被点击的cell
                ShopTypeCell *cell = (ShopTypeCell *)[self.mainTB cellForRowAtIndexPath:indexPath];
                [self closeWithCell:cell child:shopsView];
                
//               //没有省份的要直接下载
                if (!self.animRows) {
                    [_offlineMap start:item.cityID];
                    [self reLoadLocalArr];
                    
                    [tableView reloadData];
                }else
                {
                    [tableView reloadData];
                }
               
            }
        }
    }
}


#pragma mark 关闭抽屉
- (void)closeWithCell:(ShopTypeCell *)cell child:(UIView *)child{
    // 恢复位置
    [UIView animateWithDuration:kDuration  animations:^{
        for (NSIndexPath *path in self.animRows) {
            ShopTypeCell *animCell = (ShopTypeCell *)[self.mainTB cellForRowAtIndexPath:path];
            CGRect animaCellFrame = animCell.frame;
            animaCellFrame.origin.y = animCell.originY;
            animCell.frame = animaCellFrame;
            animCell.coverView.alpha = 0;
            
           
        }
    } completion:^(BOOL finished) {
        // 移除控制器的View
        [child removeFromSuperview];
        self.animRows = nil;
        // 可以滚动
        self.mainTB. scrollEnabled= YES;
        
        
        // 显示分隔线
        for (ShopTypeCell *childCell in self.mainTB.visibleCells) {
            [childCell showBottomLine:YES];

            
        }
    }];
}

#pragma mark 向上和向下挪动
- (void)up:(CGFloat)up down:(CGFloat)down indexPath:(NSIndexPath *)indexPath block:(CGRect (^)(CGRect animaCellFrame, NSIndexPath *path, NSIndexPath *indexPath, CGFloat up, CGFloat down))block{
    // 不能滚动
    self.mainTB.scrollEnabled = NO;
    [UIView animateWithDuration:kDuration animations:^{
        NSArray *paths = [self.mainTB indexPathsForVisibleRows];
        for (NSIndexPath *path in paths) {

            if (path.section == 2) {
                [self.animRows addObject:path];
                
                ShopTypeCell *animCell = (ShopTypeCell *)[self.mainTB cellForRowAtIndexPath:path];
                
                CGRect animaCellFrame = animCell.frame;
                animCell.originY = animaCellFrame.origin.y;
                
                // 调用block
                animCell.frame = block(animaCellFrame, path, indexPath, up, down);
                
                if (path.row != indexPath.row) {
                    animCell.coverView.alpha = kAlpha;
                    
//                    self.mainTB.userInteractionEnabled = NO;
                }

            }
        }
    }];
}





- (IBAction)segementChange:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            
            [self reLoadLocalArr];
            
            [self.mainTB setContentOffset:CGPointMake(0,0) animated:NO];
            if (_arraylocalDownLoadMapInfo.count == 0) {
                self.noShowView.hidden = NO;
                 _btnsView.hidden = YES;
                
                
            }else
            {
                self.noShowView.hidden = YES;
                _btnsView.hidden = NO;
            }
            
            break;
        case 1:
            
           [self.mainTB setContentOffset:CGPointMake(0,0) animated:NO];
            self.noShowView.hidden = YES;
             _btnsView.hidden = YES;
            break;
            
    }
    [self.mainTB reloadData];
}

-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}





@end
