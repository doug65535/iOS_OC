//
//  SMAnnoImageViewController.m
    
//
//  Created by lucifer on 16/3/24.
   
//

#import "SMAnnoImageViewController.h"
#import "SMAnnoImageCell.h"
#import "SMAnnoImageModel.h"
@interface SMAnnoImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *annoImageShow;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;
@property (weak, nonatomic) IBOutlet UICollectionView *collectAnnoView;

@property(nonatomic,strong)NSMutableArray *imgArr1;
//@property(nonatomic,strong)NSMutableArray *imgArr2;
@property(nonatomic,strong)NSMutableArray *imgArr3;

/**
 *  颜色
 */
@property (nonatomic,strong)NSMutableArray *urlArr1;
/**
 *  图形
 */
@property (nonatomic,strong)NSMutableArray *urlArr2;
/**
 *  大小
 */
@property (nonatomic,strong)NSMutableArray *urlArr3;



- (IBAction)segementClick:(UISegmentedControl *)sender;



@property(nonatomic,copy)NSString *colorStr;
@property(nonatomic,copy)NSString *sizeStr;
@property(nonatomic,copy)NSString *sharpeStr;

@property (weak, nonatomic) IBOutlet UIImageView *lodingImage;



@end

@implementation SMAnnoImageViewController



-(NSMutableArray *)imgArr1
{
    if (!_imgArr1) {
        _imgArr1 = [NSMutableArray arrayWithObjects:@"108",@"109",@"110", nil];
    }
    return _imgArr1;
}
//-(NSMutableArray *)imgArr2
//{
//    if (!_imgArr2) {
//        _imgArr2 =[NSMutableArray
//    return _imgArr2;
//}

-(NSMutableArray *)imgArr3
{
    if (!_imgArr3) {
        _imgArr3 = [NSMutableArray arrayWithObjects:@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118", nil];
    }
    return _imgArr3;
}


-(NSMutableArray *)urlArr1
{
    if (!_urlArr1) {
        _urlArr1 = [NSMutableArray arrayWithObjects:@"00bcce", @"5b8dd3", @"71bc4e", @"505050", @"b776bb", @"f63a39", @"ff793d", @"ffc84e", nil];
    }
    return _urlArr1;
}

-(NSMutableArray *)urlArr2
{
    if (!_urlArr2) {
        _urlArr2 = [NSMutableArray arrayWithObjects:@"null", @"circle-stroked", @"circle", @"square-stroked", @"square", @"triangle-stroked", @"triangle", @"star-stroked", @"star",
                    @"cross", @"marker-stroked",@"marker", @"religious-jewish", @"religious-christian", @"religious-muslim",
                    @"cemetery", @"airport", @"heliport", @"rail", @"rail-underground",
                    @"rail-above", @"bus", @"fuel", @"parking",@"parking-garage", @"london-underground",
                    @"airfield", @"roadblock", @"ferry", @"harbor", @"bicycle", @"pitch", @"soccer", @"america-football",
                    @"tennis", @"basketball", @"baseball", @"golf", @"swimming", @"cricket", @"skiing", @"school", @"college",
                    @"library", @"post", @"fire-station", @"town-hall", @"police", @"prison", @"embassy", @"waste-basket", @"toilets",
                    @"beer", @"restaurant", @"cafe", @"shop", @"fast-food", @"bar", @"bank", @"grocery", @"cinema", @"hospital",
                    @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b",
                    @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l",
                    @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z" , nil];
    }
    return _urlArr2;
}

-(NSMutableArray *)urlArr3
{
    if (!_urlArr3) {
        _urlArr3 = [NSMutableArray arrayWithObjects:@"s",@"m",@"l",nil];
    }
    return _urlArr3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"选择图标样式";
    
    
    self.collectAnnoView.delegate = self;
    self.collectAnnoView.dataSource = self;
    self.segement.selectedSegmentIndex = _selectindex;
    
    
    if (self.finalStr) {
        [self.annoImageShow  sd_setImageWithURL:[NSURL URLWithString:self.finalStr] placeholderImage:[UIImage imageNamed:@"create_synchronisms"] options:(SDWebImageLowPriority | SDWebImageRetryFailed ) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.annoImageShow sizeToFit];
        }];
    }else
    {
        [self.annoImageShow  sd_setImageWithURL:[NSURL URLWithString:@"http://a.dituhui.com/images/marker/icon/default/761458fbc7b4142e1ae92be936f822a3.png"] placeholderImage:[UIImage imageNamed:@"create_synchronisms"] options:(SDWebImageLowPriority | SDWebImageRetryFailed ) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.annoImageShow sizeToFit];
            
            
        }];
        
    }
    
    self.annoImageShow.contentMode = UIViewContentModeCenter;
    
    if (_indexItem1) {
        self.colorStr = self.urlArr1[_indexItem1];
    }else
    {
         self.colorStr = @"f63a39";
    }
   
    if (_indexItem2) {
        self.sharpeStr = self.urlArr2[_indexItem2];
    }else
    {
        self.sharpeStr = @"null";
    }
    
    if (_indexItem3) {
        self.sizeStr = self.urlArr3[_indexItem3];
    }else
    {
        self.sizeStr = @"s";
    }
  
  
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if ([self.delegate respondsToSelector:@selector(finalUrlPass:::::)]) {
  
        [self.delegate finalUrlPass:self.finalStr :_indexItem1 :_indexItem2 :_indexItem3 :self.segement.selectedSegmentIndex];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.segement.selectedSegmentIndex == 0) {
        return 8;
    }else if(self.segement.selectedSegmentIndex ==1)
    {
        return 98;
    }else
    {
        return 3;
    }
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
  
    SMAnnoImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    cell.annoImage.contentMode = UIViewContentModeScaleAspectFit;
    
  
//    if (cell.select1) {
//        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    }else
//    {
//        cell.backgroundColor = [UIColor clearColor];
//    }
    
    if (self.segement.selectedSegmentIndex == 0) {
        NSString *imageName1 = self.imgArr3[indexPath.item];
        [cell.annoImage setImage:[UIImage imageNamed:imageName1]];
        
      
            if (indexPath.item == _indexItem1) {
                cell.backgroundColor = [UIColor lightGrayColor];
            }else
            {
                cell.backgroundColor = [UIColor clearColor];
            }
        
        
    }else if(self.segement.selectedSegmentIndex ==1)
    {

        NSString *imageName2 = [NSString stringWithFormat:@"t (%ld)",(indexPath.item +1)];
//        NSLog(@"%@",imageName2);
        [cell.annoImage setImage:[UIImage imageNamed:imageName2]];
        
        if (indexPath.item == _indexItem2) {
            cell.backgroundColor = [UIColor lightGrayColor];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        
        
    }else{
        NSString *imageName3 = self.imgArr1[indexPath.item];
        [cell.annoImage setImage:[UIImage imageNamed:imageName3]];
        
        if (indexPath.item == _indexItem3) {
            cell.backgroundColor = [UIColor lightGrayColor];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    
    return cell;
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segement.selectedSegmentIndex == 0) {
        self.colorStr = self.urlArr1[indexPath.item];
        _indexItem1 = indexPath.item;
        
        
    }else if(self.segement.selectedSegmentIndex ==1)
    {
        self.sharpeStr =self.urlArr2[indexPath.item];
        _indexItem2 = indexPath.item;
        
        
    }else
    {
        self.sizeStr = self.urlArr3[indexPath.item];
        _indexItem3 = indexPath.item;
    }
   
    self.lodingImage.hidden = NO;
        
    
    NSString *strUrl = @"http://c.dituhui.com/image/generate";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
  
    
    dic[@"size"] = self.sizeStr;
    dic[@"color"] =self.colorStr;
    dic[@"symbol"] = self.sharpeStr;
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    [manager GET:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        SMAnnoImageModel *model = [SMAnnoImageModel objectWithKeyValues:responseObject];
        [self.annoImageShow  sd_setImageWithURL:[NSURL URLWithString:model.result] placeholderImage:nil options:(SDWebImageLowPriority | SDWebImageRetryFailed ) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.annoImageShow sizeToFit];
               SMLog(@"%f",self.annoImageShow.width);
        }];
        
        self.lodingImage.hidden = YES;
        self.finalStr = model.result;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"读取失败"];
    }];
    
 

    [collectionView reloadData];
}


- (IBAction)segementClick:(UISegmentedControl *)sender {
    
    [self.collectAnnoView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40 , 40);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

@end
