//
//  SMMakerResultViewController.m
    
//
//  Created by lucifer on 15/8/6.
  
//

#import "SMMakerResultViewController.h"

#import "SMAnno.h"

#import "SMZone.h"
#import "SMZoneDetailViewController.h"
#import "UIImage+RTTint.h"
#import "SMDetailZanShouCangTableViewCell.h"

@interface SMMakerResultViewController ()<BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


@property (nonatomic, strong) NSArray *resultMakers;
@property (nonatomic, strong) NSArray *resultZones;
@property(nonatomic,strong)NSArray *resultLines;
//@property(nonatomic,strong) BMKLocationService *locService;
//@property(nonatomic,strong) BMKGeoCodeSearch* geocodesearch;


//@property(nonatomic,strong) NSString *cityName;
@end

@implementation SMMakerResultViewController
-(NSArray *)resultLines
{
    if (!_resultLines) {
        _resultLines = [[NSArray alloc]init];
    }
    return _resultLines;
}

-(NSMutableArray *)linesArr
{
    if (!_linesArray) {
        _linesArray = [[NSMutableArray alloc]init];
    }
    return _linesArray;
}
-(NSMutableArray *)annoModelArr
{
    if (!_annoModelArr) {
        _annoModelArr = [[NSMutableArray alloc]init];
    }
    return _annoModelArr;
}


-(NSMutableArray *)poimodel
{
    if (!_poimodel) {
        _poimodel = [[NSMutableArray alloc]init];
        
    }return _poimodel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        //        self.edgesForExtendedLayout=UIRectEdgeNone;
//        self.navigationController.navigationBar.translucent = NO;
//    }
   
    
//    SMAccount *acount = [SMAccount accountFromSandbox];
//    if ([self.mapmodel.user_id isEqualToString:acount.user_id] ||
//        [self.mapmodel.edit_permission isEqualToString:@"public"] ||
//        //        [acount.groups containsObject:self.mapmodel.group_id]
//        [self isOperator]
//        ) {
    
        //初始化BMKLocationService
//        _locService = [[BMKLocationService alloc]init];
//        _locService.delegate = self;
//        //启动LocationService
//        [_locService startUserLocationService];
//        
    
//    }

    
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
}


-(void)viewWillDisappear:(BOOL)animated {


    _poisearch.delegate = nil; // 不用时，置nil
}


-(BOOL)isOperator
{
    SMAccount *acount = [SMAccount accountFromSandbox];
    
    for (NSNumber *num in acount.groups) {
        NSString *str = [NSString stringWithFormat:@"%@",num];
        if ([str isEqualToString:self.mapmodel.group_id]) {
            return YES;
            break;
        }
    }
    return NO;
}

- (void)setSearchText:(NSString *)searchText
{
    if (searchText.length == 0) return;
    
    _searchText = [searchText copy];
    
    SMAccount *acount = [SMAccount accountFromSandbox];
    if ((![self.mapmodel.app_name isEqualToString:@"LINE"])&&([self.mapmodel.user_id isEqualToString:acount.user_id] ||
        [self.mapmodel.edit_permission isEqualToString:@"public"] ||
        //        [acount.groups containsObject:self.mapmodel.group_id]
        [self isOperator])
        ) {

    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    //    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    
    
    citySearchOption.city= @"中国";
    citySearchOption.keyword = self.searchText;
    
    
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        
        NSLog(@"城市内检索发送失败");
    }
    
    }
    //    searchText = searchText.lowercaseString;
    
    // 根据搜索条件 - 搜索城市（谓词 - 过滤器）
    
    
    // 创建过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@ ", searchText];
    
    
    self.resultMakers = [self.annoModelArr filteredArrayUsingPredicate:predicate];
    
    if (self.zonesArr) {
        
         NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"title contains %@ ", searchText];
        self.resultZones = [self.zonesArr filteredArrayUsingPredicate:predicate1];
    }
    
    if (self.linesArray) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"title contains %@ ", searchText];
        self.resultLines = [self.linesArray filteredArrayUsingPredicate:predicate1];
    }
    
    //当搜索poi改变时清空以前的结果
    [self.poimodel removeAllObjects];
    
    // 刷新表格
    [self.tableView reloadData];
    
}
    

//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    
//    // 建议获取完经纬后停止位置更新  否则会一直更新坐标
//    if (userLocation.location.coordinate.latitude != 0) {
//        [_locService stopUserLocationService];
//    }
//    
//
//   
//    
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//    if (userLocation.location != nil) {
//        pt = userLocation.location.coordinate;
//    }
//    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//    
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//     _geocodesearch.delegate = self;
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
//
//   
//}

//-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
//{
//       if (error == 0) {
//    if (self.mapmodel.level.floatValue > 1.0) {
//        self.cityName = @"全国";
//    }else
//    {
//        self.cityName = result.addressDetail.city;
//    }
//       }
//}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
    for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            
            [self.poimodel addObject:poi];
            
            
            //            SMLog(@"%@",self.poimodel);
            [self.tableView reloadData];
            
            
            //            [SVProgressHUD dismiss];
            
        }
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        SMLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark - 数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([self.mapmodel.app_name isEqualToString:@"MARKER_ZONE"]) {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            return 3;
        }else
        {
            return 2;
        }
    }else if([self.mapmodel.app_name isEqualToString:@"LINE"])
    {
        return 2;
    }
    
    else
    {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            return 2;
        }else
        {
            return 1;
        }

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.mapmodel.app_name isEqualToString:@"MARKER_ZONE"]) {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (section == 0) {
                return self.poimodel.count;
            }else if(section ==1){
                return self.resultMakers.count;
            }else {
                return self.resultZones.count;
            }
        }else
        {
            if(section ==0){
                return self.resultMakers.count;
            }else {
                return self.resultZones.count;
            }
        }
    }else if([self.mapmodel.app_name isEqualToString:@"LINE"])
    {
        if (section == 0) {
            return self.resultMakers.count;
        }else
        {
            return self.resultLines.count;
        }
    }
    else
    {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (section == 0) {
                return self.poimodel.count;
            }else{
                return self.resultMakers.count;
            }

        }else
        {
          return self.resultMakers.count;
        }
        
    }
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.mapmodel.app_name isEqualToString:@"MARKER_ZONE"]) {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (indexPath.section == 0) {
                static NSString *ID = @"poiResult";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                //
                if (self.poimodel) {
                    BMKPoiInfo *poi = self.poimodel[indexPath.row];
                    [cell.imageView setImage:[UIImage imageNamed:@"UMS_place_map"]];
                    
                    cell.textLabel.text = poi.name;
                    cell.detailTextLabel.text = poi.address;
                    
                    //                  [self.poimodel removeObject:poi];
                    
                    return cell;
                }else  return cell;
            }
            else if(indexPath.section == 1){
                static NSString *ID = @"makers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                if (self.resultMakers.count) {
                    SMAnno *anno = self.resultMakers[indexPath.row];
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
                    
                    cell.textLabel.text = anno.title;
                }
               
                return cell;
            }else{
                
                static NSString *ID = @"zones";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                
                if (self.resultZones.count) {
                    SMZone *zone = self.resultZones[indexPath.row];
                    
                    
                    UIImage *image = [UIImage imageNamed:@"whiteplaceholder"];
                    UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:zone.style.fill_color alpha:zone.style.fill_opacity] level:1.0f];
                    
                    [cell.imageView setImage:tinted];
                    
                    cell.textLabel.text = zone.title;
                    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
                }
                
                return cell;

            }
        }else//点 面
        {
            if (indexPath.section == 0) {
                static NSString *ID = @"makers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                
                if (self.resultMakers.count) {
                    SMAnno *anno = self.resultMakers[indexPath.row];
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
                    
                    cell.textLabel.text = anno.title;
                    
                }
                    return cell;
                
            }else
            {
                static NSString *ID = @"zones";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                
                if (self.resultZones.count) {
                    SMZone *zone = self.resultZones[indexPath.row];
                    
                    UIImage *image = [UIImage imageNamed:@"whiteplaceholder"];
                    UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:zone.style.fill_color alpha:zone.style.fill_opacity] level:1.0f];
                    
                    [cell.imageView setImage:tinted];
                    
                    cell.textLabel.text = zone.title;
                    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
                }
                
                
               
                return cell;

            }
            
        }
//不是点面地图
}else if([self.mapmodel.app_name isEqualToString:@"LINE"])
{
    if (indexPath.section == 0) {
        static NSString *ID = @"makers";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        if (self.resultMakers.count) {
            SMAnno *anno = self.resultMakers[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            
            cell.textLabel.text = anno.title;
            
        }
        return cell;

    }else
    {
        SMDetailZanShouCangTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SMDetailZanShouCangTableViewCell" owner:self options:nil] lastObject];
            
        }
        SMLine *line = self.linesArr[indexPath.row];
        
        UIImage *image = [UIImage imageNamed:@"nav_share"];
        UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:line.style.line_color alpha:line.style.line_alpha] level:1.0f];
        
        
        
        [cell.avterImageView setImage:tinted];
        //        cell.avterImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        cell.title.text = line.title;
        cell.title.font = [UIFont systemFontOfSize:16.0];
        return cell;
        
        
    }
}
    
    
    else
    {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (indexPath.section == 0) {
                static NSString *ID = @"poiResult";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                }
                //
                if (self.poimodel) {
                    BMKPoiInfo *poi = self.poimodel[indexPath.row];
                    [cell.imageView setImage:[UIImage imageNamed:@"UMS_place_map"]];
                    
                    cell.textLabel.text = poi.name;
                    cell.detailTextLabel.text = poi.address;
                    
                    //                  [self.poimodel removeObject:poi];
                    
                    return cell;
                }else  return cell;
            }else{
                static NSString *ID = @"makers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                
                SMAnno *anno = self.resultMakers[indexPath.row];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
                
                cell.textLabel.text = anno.title;
                return cell;
                
                
                
            }

        }else
        {
            
            static NSString *ID = @"makers";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            SMAnno *anno = self.resultMakers[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            
            cell.textLabel.text = anno.title;
            
            
            return cell;
        }
        
    }
}


#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([self.mapmodel.app_name isEqualToString:@"MARKER_ZONE"]) {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (section == 0) {
                if (self.poimodel.count == 0) {
                    return @"未检索到POI结果";
                }else
                    return @"地图搜索结果";
            }else if(section == 1){
                return [NSString stringWithFormat:@"%zd个标注点搜索结果", self.resultMakers.count];
            }else
            {
                return [NSString stringWithFormat:@"%zd个区域搜索结果", self.resultZones.count];
            }
        }else
        {
            if (section == 0) {
                 return [NSString stringWithFormat:@"%zd个标注点搜索结果", self.resultMakers.count];
            }else
            {
                return [NSString stringWithFormat:@"%zd个区域搜索结果", self.resultZones.count];
            }
        }
    }
    
    if ([self.mapmodel.app_name isEqualToString:@"LINE"])
    {

            if (section == 0) {
                return [NSString stringWithFormat:@"%zd个标注点搜索结果", self.resultMakers.count];
            }else
            {
                return [NSString stringWithFormat:@"%zd个路线搜索结果", self.resultLines.count];
            }


    }
    
    
    
    
    else
    {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (section == 0) {
                if (self.poimodel.count == 0) {
                    return @"未检索到POI结果";
                }else
                    return @"地图搜索结果";
            }else
                return [NSString stringWithFormat:@"%zd个标注点搜索结果", self.resultMakers.count];
        }else
        {
            return [NSString stringWithFormat:@"共有%zd个搜索结果", self.resultMakers.count];
        }
        
    }

//    SMAccount *acout = [SMAccount accountFromSandbox];
//    if ([self.mapmodel.user_id isEqualToString:acout.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"] ||
////        [acout.groups containsObject:self.mapmodel.group_id]
//          [self isOperator]
//        ){
//        if (section == 0) {
//            if (self.poimodel.count == 0) {
//                return @"未检索到POI结果";
//            }else
//             return @"地图搜索结果";
//        }else
//           return [NSString stringWithFormat:@"%zd个标注点搜索结果", self.resultMakers.count];
//    }else
//    return [NSString stringWithFormat:@"共有%zd个搜索结果", self.resultMakers.count];
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor clearColor];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.mapmodel.app_name isEqualToString:@"MARKER_ZONE"]) {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
            if (indexPath.section == 0) {
                BMKPoiInfo* poi = self.poimodel[indexPath.row];
                if (self.poimodel) {
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:poi forKey:@"poiModel"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetPOIseachNotification object:nil userInfo:dic];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                }else{
                    return;
                }
                
            }else if(indexPath.section ==1){
                NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultZones[indexPath.row] forKey:@"model"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetZoneNotification object:nil userInfo:dic];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else
        {
            if(indexPath.section ==0){
                NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultZones[indexPath.row] forKey:@"model"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetZoneNotification object:nil userInfo:dic];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    
    if ([self.mapmodel.app_name isEqualToString:@"LINE"])
    {
        if (indexPath.section == 0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultLines[indexPath.row] forKey:@"model"];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetLineNotification object:nil userInfo:dic];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    
    
    else
    {
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapmodel.user_id isEqualToString:acount.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"]||
            //        [acount.groups containsObject:self.mapmodel.group_id]
            [self isOperator]
            ) {
//            点 poi
            if (indexPath.section == 0) {
                BMKPoiInfo* poi = self.poimodel[indexPath.row];
                if (self.poimodel) {
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:poi forKey:@"poiModel"];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetPOIseachNotification object:nil userInfo:dic];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                }else{
                    return;
                }
                
            }else{
                NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
        }else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }

    
//    SMAccount *acout = [SMAccount accountFromSandbox];
//   if ([self.mapmodel.user_id isEqualToString:acout.user_id] || [self.mapmodel.edit_permission isEqualToString:@"public"] ||
////       [acout.groups containsObject:self.mapmodel.group_id]
//         [self isOperator]
//       )
//    {
//        if (indexPath.section == 0) {
//             BMKPoiInfo* poi = self.poimodel[indexPath.row];
//                if (self.poimodel) {
//           
//                    NSDictionary *dic = [NSDictionary dictionaryWithObject:poi forKey:@"poiModel"];
//                
//                
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetPOIseachNotification object:nil userInfo:dic];
//                    
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//
//                
//                }else{
//                    return;
//                }
//            
//        }else{
//            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
//            
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//
//        }
//    }else{
//        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.resultMakers[indexPath.row] forKey:@"model"];
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:SMSectetAnnoNotification object:nil userInfo:dic];
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    }
}
    

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
   

}
@end
