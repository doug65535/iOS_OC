//
//  SMInsertLoaction.m
    
//
//  Created by lucifer on 15/9/2.
  
//

#import "SMInsertLoaction.h"

@interface SMInsertLoaction ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property(nonatomic,strong)NSMutableArray *poiArr;
@property(nonatomic,getter=isfinish) BOOL isfinish;
@end

@implementation SMInsertLoaction

-(NSMutableArray *)poiArr
{
    if (!_poiArr) {
        _poiArr = [NSMutableArray array];
    }
    return _poiArr;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    if (self.isfinish == NO) {
       BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
        
        option.reverseGeoPoint = _locService.userLocation.location.coordinate;


        BOOL flag = [_geocodesearch reverseGeoCode:option];
        if(flag)
        {
            
            SMLog(@"周边内检索发送成功");
            self.isfinish = YES;

        }
        else
        {
            SMLog(@"周边内检索发送失败");
            self.isfinish = YES;

        }
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.navigationController.navigationBar.translucent = NO;
//    }
    
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [_locService startUserLocationService];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    
    _locService.delegate = self;
    _geocodesearch.delegate = self;
}

-(void)backup
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)didStopLocatingUser
//{
//    
//}
//
//
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
// 
//
//}

- (void)didFailToLocateUserWithError:(NSError *)error;
{
    [SVProgressHUD showErrorWithStatus:@"定位失败"];
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        
        [self.poiArr addObject:result.address];
        
        for (int i = 0; i < result.poiList.count; i++) {
            BMKPoiInfo* poi = [result.poiList objectAtIndex:i];
            
            [self.poiArr addObject:poi];
            
            
            [self.tableView reloadData];
        
        }
        

    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else if(error == BMK_SEARCH_RESULT_NOT_FOUND){
        [SVProgressHUD showErrorWithStatus:@"没有检索到结果"];
    }
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return self.poiArr.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else
    {
        return @"您附近的位置";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"poiResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    if (indexPath.section == 1) {
        
        if ([self.poiArr[indexPath.row] isKindOfClass:NSClassFromString(@"BMKPoiInfo")]) {
            BMKPoiInfo *poi = self.poiArr[indexPath.row];
            [cell.imageView setImage:[UIImage imageNamed:@"UMS_place_map"]];
            
            cell.textLabel.text = poi.name;
            cell.detailTextLabel.text = poi.address;
        }else
        {
            NSString *str =self.poiArr[0];
            cell.textLabel.text =str;
        }
       
        return cell;
    }else
    {
        cell.textLabel.text = @"不显示所在位置";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        if ([self.delegate respondsToSelector:@selector(finishLocate:)]) {
            [self.delegate finishLocate:nil];
        }

    }else
    {
        if ([self.delegate respondsToSelector:@selector(finishLocate:)]) {
            if (indexPath.row == 0) {
                
                [self.delegate finishLocate:self.poiArr[0]];
            }else
            {
                 BMKPoiInfo *poi = self.poiArr[indexPath.row];
                [self.delegate finishLocate:poi.name];
            }
            
     
        }
    }
    
           [self dismissViewControllerAnimated:YES completion:nil];
}



@end
