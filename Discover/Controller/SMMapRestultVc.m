//
//  SMMapRestultVc.m
    
//
//  Created by lucifer on 15/8/31.
  
//

#import "SMMapRestultVc.h"
#import "SMMapViewController.h"
#import "SMMapPorfileCell.h"
@interface SMMapRestultVc ()<SMMapViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *mapModelArr;
//@property (nonatomic,assign)int pageNum;
@end

@implementation SMMapRestultVc

-(NSMutableArray *)mapModelArr
{
    if (!_mapModelArr) {
        _mapModelArr = [[NSMutableArray alloc]init];
    }
    return _mapModelArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.pageNum = 2;
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];

}


-(void)loadMore
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"source"] = @"dituhui";
    dic[@"app_name"] = @"MARKER";
    dic[@"per_page"] = @20;
    
    
    if (self.mapModelArr.count % 20 == 0) {
        dic[@"page"] = [NSNumber numberWithInteger:(self.mapModelArr.count / 20 + 1)];
    }else{
        
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"已经加载完啦"];
        return;
    }
    

    
    NSString *text1 = [self.searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/search/maps/%@.json",text1];
    
    
    [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *model = [SMCreatMap objectArrayWithKeyValuesArray:responseObject[@"results"]];
        //        防止输入改变过快
        
        [self.mapModelArr addObjectsFromArray:model];
        [self.tableView reloadData];
        
//        if (self.mapModelArr.count == model.count) {
//            [SVProgressHUD dismiss];
//        }
//        
        
        self.view.hidden = NO;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
//
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
}

- (void)setSearchText:(NSString *)searchText
{
     _searchText = searchText;
//       self.pageNum = 2;
    if (searchText.length == 0) return;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"source"] = @"dituhui";
    dic[@"app_name"] = @"MARKER";
    dic[@"per_page"] = @20;
    dic[@"page"] = @1;
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/search/maps/%@.json",searchText];
    
    
    [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *model = [SMCreatMap objectArrayWithKeyValuesArray:responseObject[@"results"]];
//        防止输入改变过快

     
        [self.mapModelArr removeAllObjects];
        [self.mapModelArr addObjectsFromArray:model];
        [self.tableView reloadData];
        
        if (self.mapModelArr.count == model.count) {
            [SVProgressHUD dismiss];
        }
        
        self.view.hidden = NO;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];

    // 刷新表格
//    [self.tableView reloadData];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
}




#pragma mark - 数据源方法



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.mapModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *ID = @"cell";
    
    SMMapPorfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMapPorfileCell" owner:self options:nil]lastObject];
    }

    
    SMCreatMap *mapModel = self.mapModelArr[indexPath.row];
    
    cell.textLaber.text = mapModel.title;
    cell.textDetailLaber.text = mapModel.created_at;

    [cell.mapCellImageView sd_setImageWithURL:[NSURL URLWithString:mapModel.snapshotURL]placeholderImage:[UIImage imageNamed:@"marker_default"] options:SDWebImageLowPriority];
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


#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (self.mapModelArr.count == 0) {
        return @"未找到相关地图";
    }else
     return @"地图搜索结果";
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor clearColor];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    SMLog(@"%@",self.mapModel);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMMapViewController" bundle:nil];
    
    SMMapViewController *mapVc = [sb instantiateInitialViewController];
    mapVc.delegate = self;
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    
    [nav addChildViewController:mapVc];
    // 传入进入地图时的数据模型
    SMCreatMap *mapModel = self.mapModelArr[indexPath.row];
    
    mapVc.mapModel = mapModel;
    

    [self presentViewController:nav animated:YES completion:^{
        [SVProgressHUD showWithStatus:@"正在加载标注点"];
//        待解决  点特别少得时候 不能停止动画
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            
//        });
        
    }];
    
}


-(void)didFinishLoadAnno
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
    });
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}



@end
