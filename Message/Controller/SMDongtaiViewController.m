//
//  SMDongtaiViewController.m
    
//
//  Created by lucifer on 15/8/25.
  
//

#import "SMDongtaiViewController.h"
#import "SMNotifications.h"
#import "SMDianZanCell.h"
@interface SMDongtaiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControler;
- (IBAction)segementChange:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview0;
@property (weak, nonatomic) IBOutlet UITableView *tableview1;
@property (weak, nonatomic) IBOutlet UITableView *tabview2;


@property(nonatomic,strong) NSMutableArray *modelArr2;
@property(nonatomic,strong) NSMutableArray *modelArr1;
@property(nonatomic,strong) NSMutableArray *modelArr0;



@end

@implementation SMDongtaiViewController

-(NSMutableArray *)modelArr1
{
    if (!_modelArr1) {
        _modelArr1 = [[NSMutableArray alloc]init];
    }
    return _modelArr1;
}
-(NSMutableArray *)modelArr0
{
    if (!_modelArr0) {
        _modelArr0 = [[NSMutableArray alloc]init];
    }
    return _modelArr0;
}
-(NSMutableArray *)modelArr2
{
    if (!_modelArr2) {
        _modelArr2 = [[NSMutableArray alloc]init];
    }
    return _modelArr2;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"动态";
    self.segementControler.tintColor = [UIColor colorWithRed:1 green:136/255.0 blue:10/255.0 alpha:1];
    [self.view bringSubviewToFront:self.tableview0];
    
    [SVProgressHUD showWithStatus:@"正在努力加载"];
    
    [self getpinglun];
     [self getwd];
    [self getDianZan];
   
    
    self.tableview0.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getpinglun];
    }];
    
    self.tableview0.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getmorepinglun];
    }];
    
   
    
    self.tableview1.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getwd];
        
    }];
    
    self.tableview1.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getMoreWd];
        
    }];
    
    self.tabview2.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getDianZan];
        
    }];
    
    self.tabview2.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getMoreDianZan];
        
    }];
    
    
    if (self.isFormPinglun) {
        [self.segementControler setSelectedSegmentIndex:0];
       [self.view bringSubviewToFront:self.tableview0];
    }else if(self.isFormDianzan)
    {
        [self.segementControler setSelectedSegmentIndex:2];
        [self.view bringSubviewToFront:self.tabview2];
      
    }else
    {
        [self.segementControler setSelectedSegmentIndex:1];
          [self.view bringSubviewToFront:self.tableview1];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)segementChange:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.view bringSubviewToFront:self.tableview0];
            
            break;
        case 1:
            [self.view bringSubviewToFront:self.tableview1];
            
            break;
        case 2:
             [self.view bringSubviewToFront:self.tabview2];
            
            break;
        default:
            break;
    }
}


-(void)getpinglun
{
    [self.modelArr0 removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = @"http://club.dituhui.com/api/v2/notifications/replies";
    
    [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *model = [SMNotifications objectArrayWithKeyValuesArray:responseObject[@"notifications"]];
        
        [self.modelArr0 addObjectsFromArray:model];
        
        [self.tableview0 reloadData];
        [SVProgressHUD dismiss];
        [self.tableview0.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}

-(void)getmorepinglun
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = @"http://club.dituhui.com/api/v2/notifications/replies";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.modelArr0 lastObject] Lid];
    if (lastStatusIdstr != nil) {
        parameters[@"last_id"] = lastStatusIdstr;
    }
    
    [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *model = [SMNotifications objectArrayWithKeyValuesArray:responseObject[@"notifications"]];
        
        [self.modelArr0 addObjectsFromArray:model];
        
        [self.tableview0 reloadData];
        [self.tableview0.footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];

}


-(void)getwd
{
    [self.modelArr1 removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = @"http://club.dituhui.com/api/v2/notifications/mentions";
    
    [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *model = [SMNotifications objectArrayWithKeyValuesArray:responseObject[@"notifications"]];
        
        [self.modelArr1 addObjectsFromArray:model];
        
        [self.tableview1 reloadData];
        [SVProgressHUD dismiss];
        [self.tableview1.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}



-(void)getMoreWd
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = @"http://club.dituhui.com/api/v2/notifications/mentions";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.modelArr1 lastObject] Lid];
    if (lastStatusIdstr != nil) {
        parameters[@"last_id"] = lastStatusIdstr;
    }
    
    [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *model = [SMNotifications objectArrayWithKeyValuesArray:responseObject[@"notifications"]];
        
        [self.modelArr1 addObjectsFromArray:model];
        
        [self.tableview1 reloadData];
        [self.tableview1.footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];
}


-(void)getDianZan
{
    
    
       [self.modelArr2 removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = @"http://club.dituhui.com/api/v2/notifications/likes";
    
    [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        SMLog(@"%@",responseObject);
        NSArray *model = [SMNotifications objectArrayWithKeyValuesArray:responseObject[@"notifications"]];
        
        [self.modelArr2 addObjectsFromArray:model];
        
        [self.tabview2 reloadData];
        [SVProgressHUD dismiss];
         [self.tabview2.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}

-(void)getMoreDianZan
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *strUrl = @"http://club.dituhui.com/api/v2/notifications/likes";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.modelArr2 lastObject] Lid];
    if (lastStatusIdstr != nil) {
        parameters[@"last_id"] = lastStatusIdstr;
    }
    
    [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //        SMLog(@"%@",responseObject);
        NSArray *model = [SMNotifications objectArrayWithKeyValuesArray:responseObject[@"notifications"]];
        
        [self.modelArr2 addObjectsFromArray:model];
        
        [self.tabview2 reloadData];
        [self.tabview2.footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tabview2) {
         return self.modelArr2.count;
    }else if (tableView == self.tableview1) {
        return self.modelArr1.count;
    }else{
        return self.modelArr0.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.tabview2) {
        SMDianZanCell *cell2 = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell2" forIndexPath:indexPath];

        // 2.设置数据
        cell2.status = self.modelArr2[indexPath.row];
        
        // 3.返回cell
        return cell2;
    }else if(tableView == self.tableview1){
         SMDianZanCell *cell1 = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell1" forIndexPath:indexPath];
        cell1.status1 = self.modelArr1[indexPath.row];
        return cell1;
    }else
    {
        SMDianZanCell *cell0 = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell0" forIndexPath:indexPath];
        cell0.status0 = self.modelArr0[indexPath.row];
        return cell0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取 -- > 自定义cell
    // 1.拿到对应行的cell
    if (tableView == self.tabview2) {
        SMDianZanCell *cell2 = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell2"];
        
        return [cell2 cellHeightWithStatus:self.modelArr2[indexPath.row]];
        
    }else if(tableView == self.tableview1){
        SMDianZanCell *cell1 = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell1"];
        
        return [cell1 cellHeightWithStatus1:self.modelArr1[indexPath.row]];
    }else{
        
        SMDianZanCell *cell0 = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell0"];
        
        return [cell0 cellHeightWithStatus0:self.modelArr0[indexPath.row]];

    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    SMDetailViewController *vc = [[SMDetailViewController alloc] init];
    vc = [sb instantiateInitialViewController];
    
    [self addChildViewController:vc];
    
    if (tableView == _tableview1) {
        SMNotifications *status = self.modelArr1[indexPath.row];
        if (status.message) {
            vc.modle = status.message;
        }else{
            vc.modle = status.reply.message;
        }
    }else if(tableView == _tabview2){

        SMNotifications *status = self.modelArr2[indexPath.row];
        if (status.message) {
            vc.modle = status.message;
        }else{
            vc.modle = status.reply.message;
        }
        
//        vc.isneedZan = YES;
    }else
    {
        SMNotifications *status = self.modelArr0[indexPath.row];
        if (status.message) {
            vc.modle = status.message;
        }else{
            vc.modle = status.reply.message;
        }
        vc.isneedset = YES;
    }
      [self.navigationController pushViewController:vc animated:YES];
}

@end
