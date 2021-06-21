//
//  TableViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "SMPofileMapCreatVc.h"


#import "SMLabelSettings.h"


#import "SMMapViewController.h"

#import "SMMapPorfileCell.h"

@interface SMPofileMapCreatVc ()<SMMapViewControllerDelegate>

@property (nonatomic,strong)NSMutableArray *modelArr;

@property(nonatomic,assign)NSInteger didRow;


@end

@implementation SMPofileMapCreatVc


-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc]init];
    }
        return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    

    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [SVProgressHUD showWithStatus:@"努力加载中..."];
        [self loadModel];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
//        [SVProgressHUD showWithStatus:@"努力加载中..."];
        [self loadMoreModel];
        
    }];
    
    
     [self loadModel];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

}

-(void)loadModel
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    NSString *strUrl  = [NSString copy];
    if (self.userModel) {
        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/maps.json",self.userModel.user_id];
  
    }else{
        
        strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/maps.json",account.user_id];
          [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    }
  
        
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"page"] = @1;
    
    
    [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *model = [SMCreatMap objectArrayWithKeyValuesArray:responseObject];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];
    
}
-(void)loadMoreModel
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = [NSString copy];
    
    if (self.userModel) {
     
        
      strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/maps.json",self.userModel.user_id];
        
    }else{
        
    
        strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/maps.json",account.user_id];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
//        得到的结果 是30的倍数 说明还跌继续加载
    if (self.modelArr.count % 30 == 0) {
        parameters[@"page"] = [NSNumber numberWithInteger:(self.modelArr.count / 30 + 1 )];
    }else
    {
        [self.tableView.footer endRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:@"已经加载完啦"];
        return;
    }
    
    [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *model = [SMCreatMap objectArrayWithKeyValuesArray:responseObject];
        if (model.count == 0) {
            [self.tableView.footer endRefreshing];
            
            [SVProgressHUD showSuccessWithStatus:@"已经加载完啦"];
            return;
        }
        
        [self.modelArr addObjectsFromArray:model];
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
    
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)segmentTitle
{
    return @"创建";
}

-(UIScrollView *)streachScrollView
{
   return self.tableView;
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (self.modelArr.count == 0) {
//        return @"还没有发布过地图";
//    }else{
//   
//        return nil;
//    }
//}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
    UITableViewHeaderFooterView *vHeader = (UITableViewHeaderFooterView *)view;
    vHeader.textLabel.font = [UIFont systemFontOfSize:12];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *header = @"customHeader";
//
    UITableViewHeaderFooterView *vHeader;
//

    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];

    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    
    vHeader.textLabel.textColor = [UIColor lightGrayColor];
    vHeader.textLabel.font = [UIFont systemFontOfSize:12];
    
        if (self.modelArr.count == 0) {
            vHeader.textLabel.text = @"还没有发布过的地图";
        }else{
            vHeader = nil;
        }

    
    return vHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.modelArr.count == 0) {
        return 30;
    }else
    {
        return 0;
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 50;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    
    SMMapPorfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    
    if (cell == nil) {

        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMapPorfileCell" owner:self options:nil]lastObject];
    }
    

    
    SMCreatMap *mapModel = self.modelArr[indexPath.row];
    
    cell.textLaber.text = mapModel.title;


    
    cell.textDetailLaber.text = mapModel.created_at;
//    cell.detailTextLabel.numberOfLines = 0;
//    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//    cell.detailTextLabel.numberOfLines = 0;
    
    NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",mapModel.snapshotURL];

  [cell.mapCellImageView sd_setImageWithURL:[NSURL URLWithString:strurl]
                    placeholderImage:[UIImage imageNamed:@"marker_default"]
                             options:SDWebImageLowPriority|SDWebImageRetryFailed];

//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:strurl]];
    
//    显示地图类型
    CGFloat w = 55;
    CGFloat h = 24;
    UIImageView *imageView = [[UIImageView alloc] init];

    imageView.frame = CGRectMake(150 - w , 0, w, h);

    
    [cell.mapCellImageView addSubview:imageView];
    
    if ([mapModel.edit_permission isEqualToString:@"public"]) {

        [imageView setImage:[UIImage imageNamed:@"crowdsource"]];
        
    }else if([mapModel.edit_permission isEqualToString:@"group"])
    {
        [imageView setImage:[UIImage imageNamed:@"group"]];

    }else if ([mapModel.permission isEqualToString:@"pri"]) {
            
            [imageView setImage:[UIImage imageNamed:@"person"]];
        }
    else if([mapModel.permission isEqualToString:@"pas"])
        {
            [imageView setImage:[UIImage imageNamed:@"secret"]];
        }
    else
    {
        for (UIImageView *imageview in cell.mapCellImageView.subviews ) {
            [imageview removeFromSuperview];
        }
    }
    
    
//    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(10,  99 , 380, 1)];
//    
//    
//    
//    separator.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    
//    
//    
//    [cell addSubview:separator];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    SMLog(@"%@",self.mapModel);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil];
    
    SMMapViewController *mapVc = [sb instantiateInitialViewController];
    
    mapVc.delegate = self;
    
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    
    [nav addChildViewController:mapVc];

    
    // 传入进入地图时的数据模型
    SMCreatMap *mapModel = self.modelArr[indexPath.row];
    
    self.didRow = indexPath.row;
    
    mapVc.mapModel = mapModel;
    
    [self presentViewController:nav animated:YES completion:nil];
////    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)willRoladData:(SMCreatMap *)newModel
{
  
    /**
     *  刷新表格指定行的数据 
     */
      self.modelArr[self.didRow] = newModel;
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:self.didRow inSection:0];
    
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    [self.tableView cellForRowAtIndexPath:indexPath_1];
    [self.tableView reloadData];
}



@end
