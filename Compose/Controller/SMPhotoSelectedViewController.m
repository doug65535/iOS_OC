

#import "SMPhotoSelectedViewController.h"
#import "SMPhotoSelectedCell.h"

#import "BoPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SMPhotoSelectedViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,SMPhotoSelectedCellDelegate,BoPhotoPickerProtocol>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;



@end

@implementation SMPhotoSelectedViewController
#pragma mark - 懒加载
- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}


static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }
}

/**
 *  添加图片
 */
-(void)addPhoto
{
    BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 8;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {

        for (int i =0 ; i< assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            if (self.images.count <= 7) {
                [self.images addObject:tempImg];
                [self.collectionView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"最多支持8张图片"];
            }

    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//超过最大选择项时
- (void)photoPickerDidMaximum:(BoPhotoPickerViewController *)picker {
//    NSLog(@"%s",__func__);
    [SVProgressHUD showErrorWithStatus:@"最多支持8张照片……"];
}
- (BOOL)checkCameraAvailability {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                __block status = YES;
            }else{
                __block status = NO;
            }
        }];
        
}
    return status;
}

- (void)photoPickerTapAction:(BoPhotoPickerViewController *)picker {
    if(![self checkCameraAvailability]){
       [SVProgressHUD showErrorWithStatus:@"您没有打开相机的权限 请到‘设置‘中打开"];
        return;
    }
   
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImagePickerController *cameraUI = [UIImagePickerController new];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
    
    [self presentViewController: cameraUI animated: YES completion:nil];
}
#pragma mark - UIImagePickerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  删除图片
 */
-(void)deletePhoto:(SMPhotoSelectedCell *)cell
{
    [self.images removeObjectAtIndex:cell.indexPath.item];
    // 2.刷新表格
    [self.collectionView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate
// 选中图片时调用

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 将图片保存起来
    [self.images addObject:image];
    // 刷新表格
    [self.collectionView reloadData];
    // 关闭图片选择器
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewWillLayoutSubviews
{
    // 初始化每一个item的相关属性
    // 1.设置间隙
    // 设置水平间隙
    self.layout.minimumInteritemSpacing = 10;
    // 设置垂直间隙
    self.layout.minimumLineSpacing = 10;
    // 设置全局左右间隙
    self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    // 2.设置宽高
    // 列数
    CGFloat col = 5;
    // 计算
    CGFloat width = (self.view.width - ((col + 1) * 10)) / 3.0;
    CGFloat height = width;
    // 设置全局item的size
    self.layout.itemSize = CGSizeMake(width, height);
    
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出cell
    SMPhotoSelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    // 2.设置数据
    // count = 0 item = 0
    // 等于item是让最后一张图片是加号
    if (self.images.count == indexPath.item) {
        cell.iconImage = nil; // 4
    }else
    {
        cell.indexPath = indexPath;
        cell.iconImage = self.images[indexPath.item];
    }
    // 3.返回cell
    return cell;
}


@end
