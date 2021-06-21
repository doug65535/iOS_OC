//
//  SMFollowersTbVc.m
    
//
//  Created by lucifer on 15/8/26.
  
//

#import "SMFollowersTbVc.h"
#import "RootTableViewController.h"
#import "SMGuanzhuFensiCell.h"
@interface SMFollowersTbVc ()
@property(nonatomic,strong)NSMutableArray *modelArr ;
@end

@implementation SMFollowersTbVc

-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
         [self getFollowsList];
    self.title = @"粉丝";
    
    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getFollowsList];
        
    }];
    
    //    去除多余横线。
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableHeaderView:view];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getMoreFollowsList];
        
    }];

    
}

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        self.hidesBottomBarWhenPushed = YES;
//        [super.navigationController setToolbarHidden:YES animated:TRUE];
//
//    }
//    return self;
//}

-(void)getFollowsList
{
    
    [SVProgressHUD showWithStatus:@"正在请求……"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    

    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    NSString *strUrl = [[NSString alloc]init];
    
    if (self.userModel.user_id) {
        strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followers",self.userModel.user_id];
    }else
    {

        strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followers",account.user_id];
    }
    
    [manager GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *modelArr = [SMUser objectArrayWithKeyValuesArray:responseObject[@"user_infos"]];
            [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:modelArr];
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}

-(void)getMoreFollowsList
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
  
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *strUrl = [NSString string];
    
    if (self.userModel.user_id) {
        strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followers",self.userModel.user_id];
        dic[@"id"] = self.userModel.user_id;
    }else
    {
        strUrl = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followers",account.user_id];
        dic[@"id"] = account.user_id;
    }
    
    
    NSString *lastStatusIdstr = [[self.modelArr lastObject] user_id];
    if (lastStatusIdstr != nil) {
        dic[@"last_id"] = lastStatusIdstr;
    }

    
    [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modelArr = [SMUser objectArrayWithKeyValuesArray:responseObject[@"user_infos"]];
        
        [self.modelArr addObjectsFromArray:modelArr];
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.modelArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMGuanzhuFensiCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cutomCell" forIndexPath:indexPath];
    
    SMUser *user = self.modelArr[indexPath.row];
    // 2.设置数据

//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]placeholderImage:[UIImage imageNamed:@"main_mine"]];
//    
//    cell.textLabel.text = user.login;
    
    cell.user =user;
  
//    cell.detailTextLabel.text = @"关注了";

    
    // 3.返回cell
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMProfileViewController" bundle:nil];
    
    RootTableViewController *rootVc = [sb instantiateInitialViewController];
    
    SMUser *user = self.modelArr[indexPath.row];
    
    rootVc.userModle = user;
    
    [self addChildViewController:rootVc];
    
    [self.navigationController pushViewController:rootVc animated:YES];
    
}
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
        vHeader.textLabel.text = @"还没有粉丝";
    }else{
        vHeader = nil;
    }
    
    
    return vHeader;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

@end
