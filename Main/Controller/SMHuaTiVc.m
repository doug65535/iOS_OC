//
//  SMHuaTiVc.m
    
//
//  Created by lucifer on 15/9/24.
 
//

#import "SMHuaTiVc.h"
#import "SMMapPorfileCell.h"

@interface SMHuaTiVc ()
@property(nonatomic,strong)NSMutableArray *statusArr;
@end

@implementation SMHuaTiVc

-(NSMutableArray *)statusArr
{
    if (!_statusArr ) {
        _statusArr = [[NSMutableArray alloc]init];
    }
    return _statusArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.huati;
    [SVProgressHUD showWithStatus:@"正在加载标签帖子列表"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"tag_name"] = self.huati;
    
    [manager GET:@"http://club.dituhui.com/api/v2/messages" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject){
        NSArray *model = [SMStatus objectArrayWithKeyValuesArray:responseObject];
        [self.statusArr addObjectsFromArray:model];
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
}


-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"cell";
    
    SMMapPorfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMapPorfileCell" owner:self options:nil]lastObject];
    }
    
    SMStatus *status = self.statusArr[indexPath.row];
    
    cell.textLaber.text = status.title;
//    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
//    cell.textLabel.numberOfLines = 0;
    
    cell.textDetailLaber.text = status.body;
    //    cell.detailTextLabel.numberOfLines = 0;
//    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    
    if (status.pictures.count != 0) {
        for (SMPictures *pic in status.pictures) {
            NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",pic.url];
            [cell.mapCellImageView sd_setImageWithURL:[NSURL URLWithString:strurl]placeholderImage:[UIImage imageNamed:@"marker_default"] options:SDWebImageLowPriority];
        }
    }else if(status.map.snapshot)
    {
        NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",status.map.snapshot];
        [cell.mapCellImageView sd_setImageWithURL:[NSURL URLWithString:strurl]placeholderImage:[UIImage imageNamed:@"marker_default"] options:SDWebImageLowPriority];
    }else
    {
        cell.mapCellImageView.image = nil;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil]instantiateInitialViewController];
    vc.modle = self.statusArr[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
