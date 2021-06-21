//
//  SMTableViewCell.m
    
//
//  Created by lucifer on 15/7/20.
  
//

#import "SMTableViewCell.h"
#import "UMSocial.h"
#import "SMPhotoCollectViewCell.h"
#import "HZPhotoBrowser.h"
#import "SMDefaultView.h"

@interface SMTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,HZPhotoBrowserDelegate>

@property (strong, nonatomic) IBOutlet UIButton *zanBtn;
@property (strong, nonatomic) IBOutlet UIButton *shoucangBtn;
@property (strong, nonatomic) IBOutlet UIButton *pinglunBtn;

@property (strong, nonatomic) IBOutlet UIButton *fenxiangBtn;

- (IBAction)shoucang:(UIButton *)sender;

- (IBAction)pignlun:(UIButton *)sender;
- (IBAction)fenxiang:(UIButton *)sender;
- (IBAction)zan:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteBlog;

- (IBAction)deleteBlog:(UIButton *)sender;

@property (nonatomic, getter=isShoucangSelected) BOOL isShoucangSelected;

@property (nonatomic, getter=isZanSelected) BOOL isZanSelected;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collecHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *laout;

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,strong)SMPhotoCollectViewCell *collectCell;
@property(nonatomic,strong)UICollectionView *collect;
@property (nonatomic,strong)HZPhotoBrowser *photoBrowser;

@end
@implementation SMTableViewCell




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.status.map.snapshot) {
        return 1;
    }else if(self.status.pictures.count != 0){
        return self.status.pictures.count;
    }else
    {
        return 0;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    SMLog(@"%@",self.status.pictures);
    SMPhotoCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
  
//      SMLog(@"%@",self.status);

    self.collectCell = cell;
    
    if (self.status.map.snapshot != nil) {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",self.status.map.snapshot];
        cell.photo = strUrl;
        
        cell.photoView.contentMode =  UIViewContentModeScaleAspectFill;
        
        cell.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        cell.photoView.clipsToBounds  = YES;
        cell.width = self.photoCollectView.width;
        cell.height = 200;
        
        if ([self.status.map.app isEqual:@"marker"] || [self.status.map.app isEqualToString:@"marker_zone" ]||[self.status.map.app isEqualToString:@"line" ]) {
            
            UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"events map"]];
            CGFloat w = 55;
            CGFloat h = 24;
            //            self.picture 没生成出来会造成标签图片位移
            imageview.frame = CGRectMake(cell.width - w , 0, w, h);
            [cell.photoView addSubview:imageview];
        }else
        {
            for (UIImageView *view in cell.photoView.subviews) {
                [view removeFromSuperview];
            }
        }
       
    }
    
    if(self.status.pictures.count != 0){
        for (UIImageView *view in cell.photoView.subviews) {
            [view removeFromSuperview];
        }
        SMPictures *pic = self.status.pictures[indexPath.item];
        NSString *strUrl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
        
        cell.photo = strUrl;
        
        cell.photoView.contentMode =  UIViewContentModeScaleAspectFill;
        
        cell.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        cell.photoView.clipsToBounds  = YES;

        if (self.status.pictures.count ==1) {
            cell.width = self.photoCollectView.width;
            cell.height = 200;
        }else{
         
        NSUInteger count = self.status.pictures.count;
            // 有配图, 几张? 几行?
            // 1.计算行数
            NSUInteger row = 0;
            if(count % 3 == 0 )
            {
                row = count /  3;
            }else
            {
                row = count / 3 + 1;
            }
    
            CGFloat photoMargin = 3.0;
            
            CGFloat photoHeight = 0.0;
            if (count ==4) {
                photoHeight = ((kWidth -26) - photoMargin) / 2;
            }else if(count == 2)
            {
                photoHeight = ((kWidth -26) - photoMargin) / 2;
            }
            else
            {
                photoHeight = ((kWidth -26)-2*photoMargin) / 3;
            }

            cell.width = photoHeight;
            cell.height = photoHeight;

            self.laout.itemSize = cell.size;
            self.laout.minimumLineSpacing = photoMargin;
            self.laout.minimumInteritemSpacing = photoMargin;
            
        }
//             让UICollectionView重新加载数据
//            [self.photoCollectView reloadData];
        
            // 4.修改原创微博的高度等于配图的高度 = 原来的高度(正文最大的Y) + 配图的高度
//            self.originalVIewHeight.constant += self.photosViewHeight.constant + 10;

        
    }
    
//    if (self.status.pictures.count == 0 && self.status.map.snapshot == nil)
//    {
//        self.cellContentHeight.constant = self.cellContentHeight.constant - self.collecHeight.constant ;
//        
//
//        self.collecHeight.constant = 0;
//    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
// SMPhotoCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell"forIndexPath:indexPath];
    SMPhotoCollectViewCell *cell = (SMPhotoCollectViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _collect = collectionView;
    if ([self.status.map.app isEqualToString:@"marker"] || [self.status.map.app isEqualToString:@"marker_zone"] || [self.status.map.app isEqualToString:@"line"] ) {
        if ([self.delegate respondsToSelector:@selector(didClickMapPicture:shareImage:)]) {
            [self.delegate didClickMapPicture:self.status shareImage:cell.photoView.image];
        }
    }else
    {
        HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
        _photoBrowser  = browserVc;
//        browserVc.sourceImagesContainerView = cell.superview;
        browserVc.sourceView = cell;
        if (self.status.pictures.count) {
        
          browserVc.currentImageIndex =(int)indexPath.item ;
            browserVc.imageCount = self.status.pictures.count;
        }else
        {
            browserVc.imageCount = 1;
            browserVc.currentImageIndex = 0;
        }
        //     SMLog(@"%d",browserVc.currentImageIndex);
        self.image = cell.photoView.image;
        // 代理
        browserVc.delegate = self;
        
        //    SMLog(@"%@",cell);
        // 展示图片浏览器
        [browserVc show];
    }
   
}
-(void)cellChangeL:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SMPhotoCollectViewCell *cell = (SMPhotoCollectViewCell *)[_collect cellForItemAtIndexPath:indexPath];
      _photoBrowser.sourceImagesContainerView = cell;
}

-(UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.image;
}

-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.status.pictures.count) {
         SMPictures *pic = self.status.pictures[index];
        return [NSURL URLWithString:pic.url];

    }else
    {
        return [NSURL URLWithString:self.status.map.snapshot];
    }
   
  }

- (void)awakeFromNib {
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
     self.body.preferredMaxLayoutWidth = screenWidth - 10;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}



//cell高度
// 在此改变整体cell的高度
- (CGFloat)cellHeightWithStatus:(SMStatus *)status
{
    _status = status;

     [self layoutIfNeeded];
    
    if (status.map.snapshot != nil) {

        self.cellContentHeight.constant =300;
        self.collecHeight.constant = 200;

    }
    if (status.pictures.count != 0)
    {

//            self.picHeight.constant = 200;
//        self.cellContentHeight.constant =300;
        
        if (self.status.pictures.count ==1) {
            self.cellContentHeight.constant = 300;
                self.collecHeight.constant = 200;
        }else{
            
            NSUInteger count = self.status.pictures.count;
            // 有配图, 几张? 几行?
            // 1.计算行数
            NSUInteger row = 0;
            if(count % 3 == 0 )
            {
                row = count /  3;
            }else
            {
                row = count / 3 + 1;
            }
            
            CGFloat photoMargin = 3.0;
            
            CGFloat photoHeight = 0.0;
            if (count ==4) {
                photoHeight = ((kWidth -26) - photoMargin) / 2;
            }else if(count == 2)
            {
                photoHeight = ((kWidth -26) - photoMargin) / 2;
            }
            else
            {
                photoHeight = ((kWidth -26)-2*photoMargin) / 3;
            }
            
            // 2.计算高度
            // 行数 * 配图的高度 + (行数 – 1) * 间隙
            CGFloat photosHeight = row * photoHeight + (row - 1) * photoMargin;
//            SMLog(@"%f",photoHeight);
            self.cellContentHeight.constant = photosHeight+100;
            self.collecHeight.constant = photosHeight;
        }


    }
    if(status.pictures.count == 0 && status.map.snapshot ==nil){
        
//        self.cellContentHeight.constant = self.cellContentHeight.constant - self.collecHeight.constant ;
//          self.collecHeight.constant = 0;
        self.cellContentHeight.constant = 100;
    }
//    SMLog(@"%f",self.cellContentHeight.constant);
        return self.cellContentHeight.constant+52;
}

//在此改变。content 内部cell的高度 另解决重用问题
- (void)setStatus:(SMStatus *)status
{
    _status = status;
    
    self.photoCollectView.delegate = self;
    self.photoCollectView.dataSource = self;
    
    self.photoCollectView.backgroundColor = [UIColor whiteColor];
    [self.photoCollectView reloadData];
    
    [self.touxiang sd_setImageWithURL:[NSURL URLWithString:status.user.avatar]];
    //  用户名
    [self.user_name setText:status.user.login];
    
    //    发布时间
    [self.fireTime setText:status.last_actived_at];
    //    地图图片
    if (status.map.snapshot != nil) {
        self.collecHeight.constant = 200;
        self.cellContentHeight.constant =300;
    }
//    帖子图片
    if (status.pictures.count != 0)
    {
        if (self.status.pictures.count == 1) {
            self.collecHeight.constant = 200;
            self.cellContentHeight.constant = 300;
        }else
        {
            NSUInteger count = self.status.pictures.count;
            // 有配图, 几张? 几行?
            // 1.计算行数
            NSUInteger row = 0;
            if(count % 3 == 0 )
            {
                row = count /  3;
            }else
            {
                row = count / 3 + 1;
            }
            
            CGFloat photoMargin = 3.0;
            
            CGFloat photoHeight = 0.0;
            if (count ==4) {
                photoHeight = ((kWidth -26) - photoMargin) / 2;
            }else if(count == 2)
            {
                photoHeight = ((kWidth -26) - photoMargin) / 2;
            }
            else
            {
                photoHeight = ((kWidth -26)-2*photoMargin) / 3;
            }
            
        
            // 2.计算高度
            // 行数 * 配图的高度 + (行数 – 1) * 间隙
            CGFloat photosHeight = row * photoHeight + (row - 1) * photoMargin;
            
            // 3.设置配图管理者的高度
            self.collecHeight.constant = photosHeight;
            self.cellContentHeight.constant = 100+photosHeight;
        }
        
    }
//    仅文字
    if(status.pictures.count == 0 && status.map.snapshot ==nil){
        
       self.cellContentHeight.constant = self.cellContentHeight.constant - self.collecHeight.constant ;
        self.collecHeight.constant = 0;
    }
        //设置文字介绍
    [self.body setText:status.body];
    
//    设置toolview的显示
    //设置评论数
    if ([status.replies_count isEqualToString:@"0"]) {
        status.replies_count = [status.replies_count stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    
    
    if (status.replies_count.intValue > 999) {
        status.replies_count = @"999+";
    }
    
    [self.pinglunBtn setTitle:status.replies_count forState:UIControlStateNormal];
    [self.pinglunBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.pinglunBtn.titleLabel setTextColor:[UIColor lightGrayColor]];
    

//    设置点赞数
    if ([status.likes_count isEqualToString:@"0"]) {
        status.likes_count = [status.likes_count stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    
    
    if (status.likes_count.intValue > 999) {
        status.likes_count = @"999+";
    }
    [self.zanBtn setTitle:status.likes_count forState:UIControlStateNormal];
    
    [self.zanBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.zanBtn.titleLabel setTextColor:[UIColor lightGrayColor]];
    
    
//    设置收藏数
    if ([status.favors_count isEqualToString:@"0"]) {
        status.favors_count = [status.favors_count stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    
    if (status.favors_count.intValue > 999) {
        status.favors_count = @"999+";
    }
    
    
    [self.shoucangBtn setTitle:status.favors_count forState:UIControlStateNormal];
    
    [self.shoucangBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.shoucangBtn.titleLabel setTextColor:[UIColor lightGrayColor]];
    /**
     *  如果之前已收藏 显示点击效果
     */
    if (status.has_favored == YES) {
        [self.shoucangBtn setImage:[UIImage imageNamed:@"cell_shoucang_press"] forState:UIControlStateNormal];
    }else
    {
          [self.shoucangBtn setImage:[UIImage imageNamed:@"cell_shoucang"] forState:UIControlStateNormal];
    }
    /**
     *  如果之前已点赞 显示点赞效果
     */
    if (status.has_liked == YES) {
        [self.zanBtn setImage:[UIImage imageNamed:@"cell_zan_press" ]forState:UIControlStateNormal];
    }
    else
    {
        [self.zanBtn setImage:[UIImage imageNamed:@"cell_zan"] forState:UIControlStateNormal];
    }
    SMAccount *acount = [SMAccount accountFromSandbox];
    if (self.isFromBlog && [acount.user_id isEqualToString:status.user.user_id]) {
        self.deleteBlog.hidden = NO;
    }

}
// toolView功能设置

- (IBAction)shoucang:(UIButton *)sender {
    

    SMAccount *account = [SMAccount accountFromSandbox];
    
    if (!account.token) {
        if ([self.delegate respondsToSelector:@selector(didclickunloginShoucang)]) {
            [self.delegate didclickunloginShoucang];
        }
        return;
    }
    
    if (self.status.has_favored) {
        [SVProgressHUD showErrorWithStatus:@"您已收藏过"];
        return;
    }
    [self.shoucangBtn setImage:[UIImage imageNamed:@"cell_shoucang_press"] forState:UIControlStateNormal];


        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"Token"];
    
        // 发送请求
        NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/favor",self.status.Lid];
        
      [manager POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          
          if (self.status.favors_count.intValue >= 999) {
              self.status.favors_count = [NSString stringWithFormat:@"%i",(self.status.favors_count.intValue )];
          }else{
          self.status.favors_count = [NSString stringWithFormat:@"%i",(self.status.favors_count.intValue +1)];
          }
          self.status.has_favored = YES;
          
          [self.shoucangBtn setTitle:self.status.favors_count forState:UIControlStateNormal];
          
          [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
          
          SMLog(@"%@",responseObject);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          SMLog(@"%@",error);
      }];
    
}

- (IBAction)pignlun:(UIButton *)sender  {
    
    if ([self.delegate respondsToSelector:@selector(cell:didClickpinglun:status:)]) {
        [self.delegate cell:self didClickpinglun:sender status:self.status];
    }
}

- (IBAction)fenxiang:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cell:didClickfenxaing:status:icon:)]) {
        [self.delegate cell:self didClickfenxaing:sender status:self.status icon:self.collectCell];
    }
}

- (IBAction)zan:(UIButton *)sender {
    
    
         SMAccount *account = [SMAccount accountFromSandbox];
    
    if (!account.token) {

        if ([self.delegate respondsToSelector:@selector(didClickUnLoginZan)]) {
            [self.delegate didClickUnLoginZan];
        }
        return;
    }
    if (self.status.has_liked) {
        [SVProgressHUD showErrorWithStatus:@"您已赞过"];
        return;
    }


    [self.zanBtn setImage:[UIImage imageNamed:@"cell_zan_press"] forState:UIControlStateNormal];
        // 收藏post请求
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        
        
        NSString *urlString = [NSString stringWithFormat:@"http://club.dituhui.com/api/v2/messages/%@/like",self.status.Lid];
    
        

        [manager POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.status.likes_count.intValue >= 999) {
                 self.status.likes_count = [NSString stringWithFormat:@"%i",(self.status.likes_count.intValue )];
            }else
            {
            self.status.likes_count = [NSString stringWithFormat:@"%i",(self.status.likes_count.intValue +1)];
            }
            self.status.has_liked = YES;
            
            [self.zanBtn setTitle:self.status.likes_count forState:UIControlStateNormal];
            
            [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            SMLog(@"%@",error);
        }];
}


- (IBAction)deleteBlog:(UIButton *)sender {
        if ([self.delegate respondsToSelector:@selector(didDelegateBlog:)]) {
            [self.delegate didDelegateBlog:self.status];
        }
  
}
@end
