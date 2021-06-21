//
//  SMMapPartIn.m
    
//
//  Created by lucifer on 15/8/20.
  
//

#import "SMMapPartIn.h"

#import "SMLabelSettings.h"


#import "SMMapViewController.h"


#import "SMMapPorfileCell.h"
@interface SMMapPartIn ()
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation SMMapPartIn

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
//     [SVProgressHUD showWithStatus:@"努力加载中..."];
        [self loadMoreModel];
        
    }];
    
     [self loadModel];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)loadMoreModel
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/coord_maps.json",account.user_id];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.modelArr.count % 30 == 0) {
        parameters[@"page"] = [NSNumber numberWithInteger:(self.modelArr.count / 30 + 1)];
    }else{
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



-(void)loadModel
{
    
  
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/users/%@/coord_maps.json",account.user_id];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"page"] = @1;
    
    [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *model = [SMCreatMap objectArrayWithKeyValuesArray:responseObject];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:model];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSString *)segmentTitle
{
    return @"参与";
}

-(UIScrollView *)streachScrollView
{
    return self.tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *header = @"customHeader";
    UITableViewHeaderFooterView *vHeader;
    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    if (self.modelArr.count == 0) {
        vHeader.textLabel.textColor = [UIColor lightGrayColor];
        vHeader.textLabel.font = [UIFont systemFontOfSize:12];
        vHeader.textLabel.text = @"还没有参与的地图";
    }else
    {
        vHeader = nil;
    }
    return vHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.modelArr.count ==0) {
        return 30;
    }else
    {
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
    UITableViewHeaderFooterView *vHeader = (UITableViewHeaderFooterView *)view;
    vHeader.textLabel.font = [UIFont systemFontOfSize:12];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    
    SMMapPorfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMapPorfileCell" owner:self options:nil]lastObject];
    }
    
    //    cell.separatorInset = UIEdgeInsetsZero;
    
    
    SMCreatMap *mapModel = self.modelArr[indexPath.row];
    
    cell.textLaber.text = mapModel.title;
    
    //    cell.textLabel.numberOfLines = 1;
    
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
    

    
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    
    [nav addChildViewController:mapVc];
    
    
    // 传入进入地图时的数据模型
    SMCreatMap *mapModel = self.modelArr[indexPath.row];
    

    
    
    
    mapVc.mapModel = mapModel;
    
    [self presentViewController:nav animated:YES completion:nil];
}



@end
