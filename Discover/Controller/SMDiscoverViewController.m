//
//  SMDisViewController.m
    
//
//  Created by lucifer on 15/7/9.
  
//

#import "SMDiscoverViewController.h"
#import "SMDisViewControllerLayout.h"
#import <UIImageView+WebCache.h>
#import "SMWebVc.h"

#import "SMDisCollecViewCell.h"

#import "SMDetailViewController.h"

#import "SDCycleScrollView.h"
#import "SMPicArrFire.h"

#import "SMSeachMapVc.h"

#import "SMTabBarController.h"

#import "CZSqliteTools.h"
static NSString* cellIdentifier = @"cell";
@interface SMDiscoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SMDisViewControllerLayoutDelegete,SDCycleScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray *statuses;
@property(nonatomic,strong)NSMutableArray *picArr;
@property (nonatomic,copy)NSString *picUrl;
@property (nonatomic,copy)NSString *picWidth;
@property (nonatomic,copy)NSString *picHeight;
@property (nonatomic,strong)NSMutableArray *PicArr;
@property (nonatomic,strong)NSMutableArray *TextArr;
@property (nonatomic,strong)NSMutableArray *UrlArr;
@property (nonatomic,strong)UICollectionView *ClView;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView2;
@end

@implementation SMDiscoverViewController



-(NSMutableArray *)UrlArr
{
    if (!_UrlArr) {
        _UrlArr = [[NSMutableArray alloc]init];
    }
    return _UrlArr;
}

-(NSMutableArray *)PicArr
{
    if (!_PicArr) {
        _PicArr = [[NSMutableArray alloc]init];
    }
    return _PicArr;
}
-(NSMutableArray *)TextArr
{
    if (!_TextArr) {
        _TextArr = [[NSMutableArray alloc]init];
    }
    return _TextArr;
}

-(void)aboutDB
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.000000000000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *models = [[CZSqliteTools shareSqliteTools] statusesWithParameters];
        if (models.count > 0) {
            // 加载本地缓存数据
            [self.statuses addObjectsFromArray:models];
            [self.ClView reloadData];
        }
    });
   
}

-(void)aboutADfromDB
{
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 133) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.delegate = self;
    cycleScrollView2.autoScrollTimeInterval = 5.0f;
    
    cycleScrollView2.dotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.ClView addSubview:cycleScrollView2];
    self.cycleScrollView2 = cycleScrollView2;
    
    NSArray *models = [[CZSqliteTools shareSqliteTools] adFromDB];
    if (models.count > 0 ) {
        // 加载本地缓存数据
        
        for (SMPicArrFire *dic in models) {
            [self.PicArr addObject:dic.picture];
            [self.TextArr addObject:dic.title];
        }
        _cycleScrollView2.titlesGroup = self.TextArr;
        _cycleScrollView2.imageURLStringsGroup = self.PicArr;
    }

    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"发现";

     [SVProgressHUD showWithStatus:@"努力加载中..."];

    [self aboutDB];
    
    [self loadStatuses];

    // 瀑布流
    SMDisViewControllerLayout *layout = [[SMDisViewControllerLayout alloc] init];
//    设置瀑布流内边距
    layout.sectionInset = UIEdgeInsetsMake(133 +8, 8, 0, 8);
    
    layout.delegate = self;
    
    UICollectionView *clView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight) collectionViewLayout:layout];
     [self.view addSubview:clView];
    // 在成为数据源之前告诉系统将来由哪个类创建UICollectionViewCell
      [clView registerClass:[SMDisCollecViewCell class]forCellWithReuseIdentifier: cellIdentifier];
    
    clView.delegate = self;
    clView.dataSource = self;

//    clView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    clView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    

      self.ClView = clView;

    [self aboutADfromDB];
    [self getImageUrlS];
    
   clView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self loadStatuses];
       [self getImageUrlS];
   }];
    
    
    clView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [SVProgressHUD showWithStatus:@"努力加载中..."];
        [self loadMore];
    }];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_faxian"] style:UIBarButtonItemStylePlain target:self action:@selector(seachMap)];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scollReload) name:SMDisReloadNotification object:nil];

}


-(void)scollReload
{

    [self.ClView setContentOffset:CGPointMake(0, self.view.y -64)];

}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)seachMap
{
    SMSeachMapVc *searchMapVc = [[UIStoryboard  storyboardWithName:@"SMSeachMapVc" bundle:nil] instantiateInitialViewController];
    
    SMNavgationController *nav = [[SMNavgationController alloc] initWithRootViewController:searchMapVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)getImageUrlS
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    NSString *strUrl = @"http://club.dituhui.com/api/v2/advertisements";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"type"] = @1;
    dic[@"count"] = @3;
    
    [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *model = [SMPicArrFire objectArrayWithKeyValuesArray:responseObject[@"advertisements"]];
         [[CZSqliteTools shareSqliteTools]deleteADdict];
        for (NSDictionary *dict in responseObject[@"advertisements"]) {
            // 存储微博数据
           
            BOOL success =  [[CZSqliteTools shareSqliteTools] insertADDict:dict];
            if (success) {
//                SMLog(@"插入成功");
            }else
            {
                SMLog(@"插入失败");
            }
        }
        
        [self.PicArr removeAllObjects];
        [self.TextArr removeAllObjects];
        [self.UrlArr removeAllObjects];
        
        for (SMPicArrFire *picModel in model) {
            
            [self.PicArr addObject:picModel.picture];
            [self.TextArr addObject:picModel.title];
            [self.UrlArr addObject:picModel.url];
        }
        
        if (self.PicArr.count == 3) {
            
            _cycleScrollView2.titlesGroup = self.TextArr;
            _cycleScrollView2.imageURLStringsGroup = self.PicArr;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@",error);
    }];
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *url = self.UrlArr[index];
    NSString *title = self.TextArr[index];
    
        NSString *str = @"club.dituhui";
    
    if ([url rangeOfString:str].location != NSNotFound) {
        NSArray *strArr = [url componentsSeparatedByString:@"/t/"];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        [manager GET:[NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@",strArr[1]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            SMStatus *status = [SMStatus objectWithKeyValues:responseObject];
            SMDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil]instantiateInitialViewController];
                detailVC.modle = status;
                detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }else{
        
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMWebVc" bundle:nil];
    SMWebVc *webVc = [sb instantiateInitialViewController];
    
    webVc.url = url;
    webVc.webTitle = title;
    SMNavgationController *nav = [[SMNavgationController alloc]init];
    [nav addChildViewController:webVc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    }
}

#pragma 加载数据
-(void)loadMore
{
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *lastStatusIdstr = [[self.statuses lastObject] Lid];
    if (lastStatusIdstr != nil) {

        parameters[@"last_id"] = lastStatusIdstr;
    }
    
    // 发送请求
    NSString *urlString = @"http://club.dituhui.com/api/v2/messages/recommends";
    [manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
  
        for (NSDictionary *dict in responseObject) {
            // 存储微博数据
            BOOL success =  [[CZSqliteTools shareSqliteTools] insertDict:dict];
            if (success) {
//                SMLog(@"插入成功");
            }else
            {
                SMLog(@"插入失败");
            }
        }

        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject];
        [self.statuses addObjectsFromArray:modle];
        
        
        [self.ClView reloadData];
        

    
        
        [SVProgressHUD dismiss];

       [self.ClView.footer endRefreshing];
      
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        
    }];

}


- (void)loadStatuses
{
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    // 发送请求
    NSString *urlString = @"http://club.dituhui.com/api/v2/messages/recommends";
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *modle = [SMStatus objectArrayWithKeyValuesArray:responseObject];
        [[CZSqliteTools shareSqliteTools]deleteDict];
        for (NSDictionary *dict in responseObject) {
            // 存储帖子数据
            BOOL success =  [[CZSqliteTools shareSqliteTools] insertDict:dict];
            if (success) {
//                SMLog(@"插入成功");
            }else
            {
                SMLog(@"插入失败");
            }
        }

        
        
        [self.statuses removeAllObjects];
        [self.statuses addObjectsFromArray:modle];
        
//        NSRange range = NSMakeRange(0, modle.count);
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.statuses insertObjects:modle atIndexes:indexSet];
//        

        [self.ClView reloadData];
        

        [SVProgressHUD dismiss];
            [self.ClView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SMLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络状态差,再试一次!"];
        [self.ClView.header endRefreshing];
       
    }];
}

-(NSMutableArray *)statuses
{
    if (!_statuses) {
        _statuses = [[NSMutableArray alloc]init];
    }
    return _statuses;
}


#pragma layout的代理方法

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SMDisViewControllerLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMStatus *model = self.statuses[indexPath.row];
    for (SMPictures *pic in model.pictures) {
        self.picWidth = pic.width;
        self.picHeight = pic.height;
    }
    if (model.pictures.count != 0) {
        return [model cellHeightWithImageHeight:self.picHeight andImageWidth: [NSNumber numberWithInteger:[self.picWidth integerValue]]]+50;
    }else{
        return 50+160;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.statuses.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SMDisCollecViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  
    cell.model = self.statuses[indexPath.row];
    
     return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPatha
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMDetailVC" bundle:nil];
    
    SMDetailViewController *vc = [[SMDetailViewController alloc] init];
    
     vc = [sb instantiateInitialViewController];
    
    vc.modle = self.statuses[indexPatha.row];
    
//    SMNavgationController *nav = [[SMNavgationController alloc]initWithRootViewController:vc];

    vc.hidesBottomBarWhenPushed = YES;
    
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
