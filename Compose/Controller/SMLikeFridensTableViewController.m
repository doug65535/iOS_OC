//
//  SMLikeFridensTableViewController.m
    
//
//  Created by lucifer on 15/7/28.
  
//

#import "SMLikeFridensTableViewController.h"
#import "SMDetailZanShouCangTableViewCell.h"
@interface SMLikeFridensTableViewController ()


@property (nonatomic,strong)NSMutableArray *followsArr;
@end

@implementation SMLikeFridensTableViewController
-(NSMutableArray *)followsArr
{
    if (!_followsArr) {
        _followsArr = [[NSMutableArray alloc]init];
    }
    return _followsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   [SVProgressHUD showWithStatus:@"拼命加载您的关注人"];
    
     self.navigationItem.leftBarButtonItem.style = UIBarButtonSystemItemCancel;
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self
                                                                   action:@selector(close)];
    self.navigationItem.leftBarButtonItem = composeItem;
    
    
    
    [self loadUserFollowings];
    
}



-(void)loadUserFollowings
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSString *str = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/users/%@/followings",account.user_id];
    
  
    
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *model = responseObject[@"user_infos"];
        
         NSArray *arr =  [SMUser objectArrayWithKeyValuesArray:model];
        
        [self.followsArr addObjectsFromArray:arr];
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}


-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followsArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
    
    SMDetailZanShouCangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        //            [tableView  registerNib:[UINib nibWithNibName:@"SMDetailZanShouCangTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        //
//                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMDetailZanShouCangTableViewCell" owner:self options:nil]lastObject];
    }

 
    
    SMUser *user = self.followsArr[indexPath.row];
    [cell.avterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
//    
//    cell.avterImageView.layer.cornerRadius =25;
//    cell.avterImageView.clipsToBounds = YES;
    
  
    cell.title.text = user.login;
    
//    cell.detailTextLabel.text = user.tagline;

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didClickdidSelectWithLikerName:)]) {
        
         SMUser *user = self.followsArr[indexPath.row];
        
        [self.delegate didClickdidSelectWithLikerName:user.login];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *header = @"customHeader";
    UITableViewHeaderFooterView *vHeader;
    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    if (self.followsArr.count == 0) {
        vHeader.textLabel.textColor = [UIColor lightGrayColor];
        vHeader.textLabel.font = [UIFont systemFontOfSize:12];
        vHeader.textLabel.text = @"还没有关注人";
    }else
    {
        vHeader = nil;
    }
    return vHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.followsArr.count ==0) {
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

@end
