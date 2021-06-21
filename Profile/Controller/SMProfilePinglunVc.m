//
//  SMPofileBlogTBVC.m
    
//
//  Created by lucifer on 15/8/20.
  
//

#import "SMProfilePinglunVc.h"


#import "SMTableViewCell.h"
#import "UMSocial.h"
#import "DockMenuView.h"
#import "SMPingLun.h"

#import "SMPingLunCustomCell.h"

@interface SMProfilePinglunVc ()
/**
 *  内容数组(里面存储的是所有内容的模型)
 */
@property (nonatomic, strong) NSMutableArray *statuses;

@property (nonatomic,strong) SMTableViewCell *cell;
@end

@implementation SMProfilePinglunVc
- (NSMutableArray *)statuses
{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBlogStatus];
    
    //
    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadBlogStatus];
        
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreBlogStatus];
        
    }];
}


-(void)loadBlogStatus
{
    if (self.userModel) {
        [SVProgressHUD showWithStatus:@"努力加载中..."];
        
        [self.statuses removeAllObjects];
        // 创建网络管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        // 发送请求
        NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/replies",self.userModel.user_id];
        
        [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *modle = [SMPingLun objectArrayWithKeyValuesArray:responseObject[@"replies"]];
            [self.statuses addObjectsFromArray:modle];
            
            SMLog(@"%@",responseObject);
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            [self.tableView.header endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
            
        }];

    }else{
    
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    [self.statuses removeAllObjects];
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    // 发送请求
    NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/replies",account.user_id];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modle = [SMPingLun objectArrayWithKeyValuesArray:responseObject[@"replies"]];
        [self.statuses addObjectsFromArray:modle];
        
        SMLog(@"%@",responseObject);
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];
    
}
}
-(void)loadMoreBlogStatus
{
    if (self.userModel) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSString *lastStatusIdstr = [[self.statuses lastObject] Lid];
        if (lastStatusIdstr != nil) {
            parameters[@"last_id"] = lastStatusIdstr;
        }
        
        
        // 发送请求
        NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/replies",self.userModel.user_id];
        
        [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *modle = [SMPingLun objectArrayWithKeyValuesArray:responseObject[@"replies"]];
            
            [self.statuses addObjectsFromArray:modle];
            
            [self.tableView reloadData];
            
            [self.tableView.footer endRefreshing];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
            
        }];
    }else{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.statuses lastObject] Lid];
    if (lastStatusIdstr != nil) {
        parameters[@"last_id"] = lastStatusIdstr;
    }
    
    
    // 发送请求
       NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/replies",account.user_id];
    
    [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modle = [SMPingLun objectArrayWithKeyValuesArray:responseObject[@"replies"]];
        
        [self.statuses addObjectsFromArray:modle];
        
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];
    
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Table view data source


//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (self.statuses.count == 0) {
//        return @"还没有评论过的帖子";
//    }else
//    {
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
    UITableViewHeaderFooterView *vHeader;
    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    if (self.statuses.count == 0) {
        vHeader.textLabel.textColor = [UIColor lightGrayColor];
        vHeader.textLabel.font = [UIFont systemFontOfSize:12];
        vHeader.textLabel.text = @"还没有评论过的帖子";
    }else
    {
        vHeader = nil;
    }
    return vHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.statuses.count ==0) {
        return 30;
    }else
    {
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    
    SMPingLunCustomCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell" forIndexPath:indexPath];
        cell.userModel = self.userModel;
    SMPingLun *status = self.statuses[indexPath.row];

    // 2.设置数据
    cell.status = status;

    // 3.返回cell
    return cell;
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取 -- > 自定义cell
    // 1.拿到对应行的cell
    
    SMPingLunCustomCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell"];

    
    return [cell rowHeight:self.statuses[indexPath.row]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    SMDetailViewController *vc = [[SMDetailViewController alloc] init];
    vc = [sb instantiateInitialViewController];
    
    SMPingLun *status = self.statuses[indexPath.row];
    vc.modle = status.message;
    
    vc.isneedset = YES;
    
//    SMNavgationController *nav = [[SMNavgationController alloc]initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}




-(NSString *)segmentTitle
{
    return @"评论";
}


@end
