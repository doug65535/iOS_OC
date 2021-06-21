//
//  SMEditAnnoVC.m
    
//
//  Created by lucifer on 15/8/13.
  
//

#import "SMEditAnnoVC.h"
#import "SMPhotoSelectedViewController.h"

#import "SMAttributes.h"
#import "SMImg.h"

#import "SMInputTextView.h"
#import "SMEditAnnoTableViewCell.h"
#import "SMAnnoImageViewController.h"



@interface SMEditAnnoVC () <BMKMapViewDelegate,UIScrollViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SMAnnoImageViewControllerDelegate,BMKLocationServiceDelegate>
{
    NSMutableArray *keyValues;
    UITextField *selectTextFiled;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contantWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contantHeight;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *deleteAnno;

//@property (weak, nonatomic) IBOutlet UITextView *SMInputView;


- (IBAction)deleteAnno:(UIButton *)sender;

@property(nonatomic,copy)NSString *marker_id;


/**
 *  配图控制器
 */
@property (nonatomic, strong) SMPhotoSelectedViewController *photoSelectedViewController;

@property(nonatomic,strong)NSMutableArray *imageIDArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *annoImage;
- (IBAction)annoImageClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *annoButton;


@property (weak, nonatomic) IBOutlet UIButton *annoImageButton;
- (IBAction)dingwei:(UIButton *)sender;

- (IBAction)fangda:(id)sender;

- (IBAction)suoxiao:(id)sender;

@end

@implementation SMEditAnnoVC



{
NSInteger indexPath1;
   NSInteger indexPath2;
   NSInteger indexPath3;
NSInteger selectiindex;
    
    
        BMKLocationService* _locService;
    
}


-(NSMutableArray *)imageIDArr
{
    if (!_imageIDArr) {
        _imageIDArr = [[NSMutableArray alloc] init];
    }
    return _imageIDArr;
}

-(NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc]init];
    }
    
    return _images;
}

-(NSMutableArray *)imgArr
{
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc]init];
    }
    return _imgArr;
}

- (IBAction)didDown:(UITextField *)sender {
    [self.titleField resignFirstResponder];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isAddAnno) {
        return self.attr.count;
    }else{
    return _annoModel.attributes.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMEditAnnoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textfiled.delegate = self;
    
    
    if (self.attr.count != 0 && self.isAddAnno) {
         SMAttributes *atrr = self.attr[indexPath.row];
        cell.laber.text = atrr.key;
    }else
    {
        SMAttributes *atrr = self.annoModel.attributes[indexPath.row];
        
        cell.laber.text = atrr.key;
        
        cell.textfiled.text = atrr.value;
    }
    
    cell.textfiled.tag = indexPath.row;
    
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    SMEditAnnoTableViewCell *cell =(SMEditAnnoTableViewCell *) textField.superview.superview;
 
    
    if (_isAddAnno) {
        for (SMAttributes *arr  in self.attr) {
            if (cell.laber.text == arr.key) {
                arr.value = textField.text;
            }
        }
    }else
    {
        for (SMAttributes *arr  in self.annoModel.attributes) {
            if (cell.laber.text == arr.key) {
                
                arr.value = textField.text;
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//   
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self.view bringSubviewToFront:self.mapView];
    
    self.contantWith.constant = kWidth;
    
    if (_isAddAnno) {
        self.tableViewHeight.constant = 55 *self.attr.count +10;
        //    jia200 shurukuang
        self.contantHeight.constant = 513 +self.tableViewHeight.constant -200 ;
    }else{
    
    self.tableViewHeight.constant = 55 *_annoModel.attributes.count +10;
    //    jia200 shurukuang
    self.contantHeight.constant = 513 +self.tableViewHeight.constant -200 ;
    }
    
    keyValues = [[NSMutableArray alloc]init];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    self.annoButton.contentMode = UIViewContentModeCenter;
    self.annoImage.contentMode = UIViewContentModeBottom;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    
    
//   如果没进回调  默认传红色默认标注点图片
    if (!self.finalStr) {
        self.finalStr = @"http://a.dituhui.com/images/marker/icon/default/761458fbc7b4142e1ae92be936f822a3.png";
    }

    self.title = @"添加点标记";
    self.contantWith.constant = kWidth;
    self.mScrollView.delegate = self;

    BMKMapStatus *status = [[BMKMapStatus alloc]init];
    
    if (self.temImage) {
        
        
        status.targetGeoPt = CLLocationCoordinate2DMake([self.altitude doubleValue], [self.longtitude doubleValue]);
        
        status.fLevel = self.level;
        
            [self.mapView setMapStatus:status withAnimation:YES];
        
        
            [self.photoSelectedViewController.images addObject:self.temImage];
            [self.photoSelectedViewController.collectionView reloadData];

        self.titleField.text = self.temImageTitle;
    }else{
    
    status.targetGeoPt = CLLocationCoordinate2DMake(self.coordinate.latitude , self.coordinate.longitude);
    
    status.fLevel = self.level;
    
    }
    [self.mapView setMapStatus:status withAnimation:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(composeAnno)];
    
    if (self.poiModel) {
        self.titleField.text = self.poiModel.name;
    }
    // 从判断为私有的点标注详情点进来
    if (self.annoModel ) {
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更新标注点" style:UIBarButtonItemStylePlain target:self action:@selector(updataOldAnno)];
        
//        self.annoImage.hidden = YES;
//       
//        self.annoImageButton.hidden = YES;
        
        
        self.titleField.text = self.annoModel.title;
//        for (SMAttributes *attr in self.annoModel.attributes) {
//            self.SMInputView.text = attr.value;
//        }
        
        

        if (self.imageIDArr) {
    UIImageView *imageView = [[UIImageView alloc]init];
            for (SMImg *imgData in self.imgArr) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imgData.url]];
                if (imageView.image) {
                    [self.photoSelectedViewController.images addObject:imageView.image];
                    [self.photoSelectedViewController.collectionView reloadData];
                }
        }
            
            if (self.images) {
                [self.photoSelectedViewController.images addObjectsFromArray:self.images];
                [self.photoSelectedViewController.collectionView reloadData];
            }
     

        }
        
//        自己或者在群组可删除
        
//        要加入 自己的点 可删除的情况
        
        NSString *str = [NSString stringWithFormat:@"%tu",(self.annoModel.creator_id.integerValue *12345 +54321)];
        SMAccount *acount = [SMAccount accountFromSandbox];
        if ([self.mapModel.user_id isEqualToString:acount.user_id] ||
//            [acount.groups containsObject:self.mapModel.group_id]
            [self isOperator]
            || [str isEqualToString:acount.user_id] ) {
            self.deleteAnno.hidden = NO;
        }
        
    }else
    {
   
        if (!self.attr.count) {
            SMAnno *annoModel = [[SMAnno alloc]init];
            SMAttributes *att = [[SMAttributes alloc]init];
            att.key = @"描述";
            NSArray *array = [NSArray arrayWithObject:att];
            annoModel.attributes = array;
            _annoModel = annoModel;
            self.attr = array;
            
            if (_isAddAnno) {
                self.tableViewHeight.constant = 55 *self.attr.count +10;
                //    jia200 shurukuang
                self.contantHeight.constant = 513 +self.tableViewHeight.constant -200;
            }else{
                
                self.tableViewHeight.constant = 55 *_annoModel.attributes.count +10;
                //    jia200 shurukuang
                self.contantHeight.constant = 513 +self.tableViewHeight.constant -200;
            }
            
            
            [self.tableView reloadData];

        }
        
}
    
    
 
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldscorll) name:UIKeyboardDidShowNotification object:nil];
//    
    
//    self.annoImage.contentMode =UIViewContentModeBottom;
    
//   self.annoImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    
//    self.annoImage.clipsToBounds  = YES;
    
    
    [self.annoImage sd_setImageWithURL:[NSURL URLWithString:self.finalStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.annoImage sizeToFit];
    }];
    
   
    
    
    [self.annoButton sd_setImageWithURL:[NSURL URLWithString:self.finalStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pin"]];
    
    
  

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.titleField) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        return;
    }else{
        selectTextFiled = textField;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)keyboardDidHide:(NSNotification *)note
{
    // 获取动画时间
//    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    // 2.设置工具条的Y值向上移动键盘的高度
//    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
//        self.mScrollView.transform = CGAffineTransformIdentity;
//    } completion:nil];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    // 1.取出键盘的frame
//    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘高度
//    CGFloat keyboardHeigth = keyboardFrame.size.height;
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
//        self.mScrollView.transform = CGAffineTransformMakeTranslation(0, self.mScrollView.contentOffset.y -(220 + selectTextFiled.tag +1) * 44 );
        
        
        self.mScrollView.contentOffset  = CGPointMake(0, 170+ (selectTextFiled.tag +1) * 55) ;
        SMLog(@"%tu",selectTextFiled.tag);
    } completion:nil];
    
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}



-(BOOL)isOperator
{
    SMAccount *acount = [SMAccount accountFromSandbox];
    
    for (NSNumber *num in acount.groups) {
        NSString *str = [NSString stringWithFormat:@"%@",num];
        if ([str isEqualToString:self.mapModel.group_id]) {
            return YES;
            break;
        }
    }
    return NO;
}
// textView 退出键盘方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//-(void)textFieldscorll
//{
//    [self.mScrollView setContentOffset:CGPointMake(0, 195) animated:YES];
//}




/**
 *  编辑大头针后更新大头针
 */
-(void)updataOldAnno
{
    [SVProgressHUD showWithStatus:@"正在更新点标记"];
    if (self.photoSelectedViewController.images.count != 0) {
       
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        
        
        NSString *imagepostStr = @"http://www.dituhui.com/api/v2/markers/image";
        for (UIImage *image in self.photoSelectedViewController.images) {
            
            [manager POST:imagepostStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                // 2.将图片转换为二进制
                NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);
                
                [ formData appendPartWithFileData:iamgeData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                
                SMImg *imageModel = [SMImg objectWithKeyValues:responseObject];
                [self.imageIDArr addObject:imageModel.Lid];
                //
                // 判断是否加载完毕
                
                if (self.imageIDArr.count == self.photoSelectedViewController.images.count) {
//                     加载完毕后调用更新接口
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    
                    SMAccount *account = [SMAccount accountFromSandbox];
                    
                    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
                    
                    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/markers/%@",self.annoModel.Lid];
                    
                    NSMutableDictionary *pramars = [[NSMutableDictionary alloc]init];
                    
                    pramars[@"id"] = self.annoModel.Lid;
                    pramars[@"title"] = self.titleField.text;
                    pramars[@"icon_url"] = self.finalStr;
                    
                    
                    NSMutableDictionary *attr = [[NSMutableDictionary alloc]init];
                    
                    [[UIApplication sharedApplication].keyWindow endEditing:YES];

                    
                    for (SMAttributes *attri in _annoModel.attributes) {
                     
                        attr[attri.key] = attri.value;
                    }


                    pramars[@"attributes"] = attr;
                    
                    pramars[@"img_ids"] = [self.imageIDArr JSONString];
                    
                    pramars[@"xy"] = [NSString stringWithFormat:@"(%f,%f)",self.mapView.centerCoordinate.longitude,self.mapView.centerCoordinate.latitude];
                    
                    [manager PUT:strUrl parameters:pramars success:^(NSURLSessionDataTask *task, id responseObject) {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
//                      成功后发送代理关闭控制器
                        if ([self.delegate respondsToSelector:@selector(willgiveToDetail:title:detailTitle:makerId:)]) {
                            [self.delegate willgiveToDetail:self.photoSelectedViewController.images title:self.titleField.text detailTitle:nil makerId:self.annoModel.Lid];
                        }
//                        发布通知
                        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.annoModel forKey:@"editmodel"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:SMDetailEditAnnoNotification object:nil userInfo:dic];
                        
                        
                [self.navigationController popToRootViewControllerAnimated:YES];
                        
//                        SMLog(@"%@",responseObject);
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                        SMLog(@"%@",error);
                    }];
                }
                

            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                //        [SVProgressHUD dismiss];
                if([error.userInfo[@"NSLocalizedDescription"]rangeOfString:@"401" ].location != NSNotFound) {
                    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                        SMNavgationController *nav = [[SMNavgationController alloc]init];
                        [nav addChildViewController:logVc];
                        [self presentViewController:nav animated:YES completion:nil];
                    }]];
                    
                    
                    [self presentViewController:alertVC animated:YES completion:nil];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
            }];
        }
        
//  没有配图
    }else
    {
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        SMAccount *account = [SMAccount accountFromSandbox];
        
        [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
        
        NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/markers/%@",self.annoModel.Lid];
        
        NSMutableDictionary *pramars = [[NSMutableDictionary alloc]init];
        
        pramars[@"id"] = self.annoModel.Lid;
        pramars[@"title"] = self.titleField.text;
        pramars[@"icon_url"] = self.finalStr;
        
        NSMutableDictionary *attr = [[NSMutableDictionary alloc]init];
        
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        for (SMAttributes *abuts in _annoModel.attributes) {
            attr[abuts.key] = abuts.value;
        }
        
        pramars[@"attributes"] = attr;

        pramars[@"xy"] = [NSString stringWithFormat:@"(%f,%f)",self.mapView.centerCoordinate.longitude,self.mapView.centerCoordinate.latitude];
        
        pramars[@"img_ids"] = nil;
        
        [manager PUT:strUrl parameters:pramars success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
 
            NSDictionary *dic = [NSDictionary dictionaryWithObject:self.annoModel forKey:@"editmodel"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SMDetailEditAnnoNotification object:nil userInfo:dic];
            
            //                      成功后发送代理关闭控制器
            if ([self.delegate respondsToSelector:@selector(willgiveToDetail:title:detailTitle:makerId:)]) {
                [self.delegate willgiveToDetail:nil title:self.titleField.text detailTitle:nil makerId:self.annoModel.Lid];
            }
            
      
            
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
//             SMLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //      [SVProgressHUD dismiss];
            if([error.userInfo[@"NSLocalizedDescription"]rangeOfString:@"401" ].location != NSNotFound) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:logVc];
                    [self presentViewController:nav animated:YES completion:nil];
                }]];
                
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:@"失败"];
            }
        }];
    }
}

-(void)composeAnno
{
    if (self.titleField.text.length >0) {
        if (self.photoSelectedViewController.images.count != 0) {
            [self postAnnoImage];
        }else
        {
            [self composeNewAnno];
        }

    }else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 拿到配图控制器
    self.photoSelectedViewController = segue.destinationViewController;
}


-(void)postAnnoImage
{
    
    [SVProgressHUD showWithStatus:@"正在添加点标记"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    
    NSString *imagepostStr = @"http://www.dituhui.com/api/v2/markers/image";
    
    for (UIImage *image in self.photoSelectedViewController.images) {
        
        [manager POST:imagepostStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

            // 2.将图片转换为二进制
            NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);
            
            [formData appendPartWithFileData:iamgeData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            SMImg *imageModel = [SMImg objectWithKeyValues:responseObject];
            if (self.temImage) {
                [self.imageIDArr removeAllObjects];
            }
            
            [self.imageIDArr addObject:imageModel.Lid];
            
            
//            
            // 判断是否加载完毕
            if (self.imageIDArr.count == self.photoSelectedViewController.images.count) {
                [self composeNewAnno:self.imageIDArr];
            }
            
//                        SMLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
                  [SVProgressHUD dismiss];
            if([error.userInfo[@"NSLocalizedDescription"]rangeOfString:@"401" ].location != NSNotFound) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                    SMNavgationController *nav = [[SMNavgationController alloc]init];
                    [nav addChildViewController:logVc];
                    [self presentViewController:nav animated:YES completion:nil];
                }]];
                
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:@"失败"];
            }
        }];
    }
    


    
    
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
//}

-(void)composeNewAnno
{
    [SVProgressHUD showWithStatus:@"正在添加点标记"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    NSString *urlStr = @"http://www.dituhui.com/api/v2/markers";
    
    NSMutableDictionary *parmaers = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *attr = [[NSMutableDictionary alloc]init];

    parmaers[@"map_id"] = self.mapModel.Lid;
    parmaers[@"xy"] = [NSString stringWithFormat:@"(%f,%f)",self.mapView.centerCoordinate.longitude,self.mapView.centerCoordinate.latitude];
    parmaers[@"title"] = self.titleField.text;
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (_isAddAnno) {
        
        for (SMAttributes *arr in self.attr) {
            attr[arr.key] = arr.value;
        }
    }else{
    
    for (SMAttributes *arr in  self.annoModel.attributes) {
        attr[arr.key] = arr.value;
    }
        
    }
    parmaers[@"attributes"] = attr;
    
    if (self.finalStr) {
         parmaers[@"icon_url"] = self.finalStr;
    }
   
    
    [manager POST:urlStr parameters:parmaers success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
        self.marker_id = responseObject[@"marker_id"];
//        SMLog(@"%@",responseObject);
        
        
        if ([self.delegate respondsToSelector:@selector(willgiveToDetail:title:detailTitle:makerId:)]) {
            [self.delegate willgiveToDetail:nil title:nil detailTitle:nil makerId:self.marker_id];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [SVProgressHUD dismiss];
    if([error.userInfo[@"NSLocalizedDescription"]rangeOfString:@"401" ].location != NSNotFound) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:logVc];
            [self presentViewController:nav animated:YES completion:nil];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }
    }];

}

-(void)composeNewAnno:(NSMutableArray *)imageIDArr
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    NSString *urlStr = @"http://www.dituhui.com/api/v2/markers";
    
    NSMutableDictionary *parmaers = [[NSMutableDictionary alloc]init];
    
    parmaers[@"icon_url"] = self.finalStr;
    
    parmaers[@"map_id"] = self.mapModel.Lid;
    
    if (self.temImage) {
         parmaers[@"xy"] = [NSString stringWithFormat:@"(%f,%f)",[self.longtitude doubleValue],[self.altitude doubleValue]];
    }else{
         parmaers[@"xy"] = [NSString stringWithFormat:@"(%f,%f)",self.mapView.centerCoordinate.longitude,self.mapView.centerCoordinate.latitude];
    }

    parmaers[@"title"] = self.titleField.text;

        NSMutableDictionary *attr = [[NSMutableDictionary alloc]init];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
 
    
    if (_isAddAnno) {
        
        for (SMAttributes *arr in self.attr) {
            attr[arr.key] = arr.value;
        }
    }else{
        
        for (SMAttributes *arr in  self.annoModel.attributes) {
            attr[arr.key] = arr.value;
        }
        
    }

    
    parmaers[@"attributes"] =attr;

    parmaers[@"img_ids"] = [imageIDArr JSONString];
    
    [manager POST:urlStr parameters:parmaers success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
        self.marker_id = responseObject[@"marker_id"];
        SMLog(@"%@",responseObject);
        
        
        if ([self.delegate respondsToSelector:@selector(willgiveToDetail:title:detailTitle:makerId:)]) {
            [self.delegate willgiveToDetail:nil title:nil detailTitle:nil makerId:self.marker_id];
        }
        
      [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if([error.userInfo[@"NSLocalizedDescription"]rangeOfString:@"401" ].location != NSNotFound) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
                SMNavgationController *nav = [[SMNavgationController alloc]init];
                [nav addChildViewController:logVc];
                [self presentViewController:nav animated:YES completion:nil];
            }]];
            
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"失败"];
        }
    }];
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
   
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     [_mapView viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
     _locService.delegate = nil;
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }

        if (_locService) {
            _locService.delegate = nil;
        }
        

}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}







- (IBAction)deleteAnno:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在删除标注点"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    NSString *strUrl = [NSString stringWithFormat:@"http://www.dituhui.com/api/v2/markers/%@",self.annoModel.Lid];
    
    [manager DELETE:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
//        SMLog(@"%@",responseObject);
//        发布通知
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.annoModel forKey:@"deletemodel"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SMDetailDeleteAnnoNotification object:nil userInfo:dic];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        SMLog(@"%@",error);
    }];

}
- (IBAction)annoImageClick:(id)sender {
    SMAnnoImageViewController *vc= [[UIStoryboard storyboardWithName:@"SMAnnoImage" bundle:nil]instantiateInitialViewController];
    vc.delegate =self;
    
    vc.indexItem1 = indexPath1;
    vc.indexItem2 = indexPath2;
    vc.indexItem3 = indexPath3;
    vc.selectindex = selectiindex;
    vc.finalStr = self.finalStr;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)finalUrlPass:(NSString *)finalUrl :(NSInteger)indexItem1 :(NSInteger)indexItem2 :(NSInteger)indexItem3 :(NSInteger)selectindex
{
    if (finalUrl) {
        [self.annoImage sd_setImageWithURL:[NSURL URLWithString:finalUrl] placeholderImage:[UIImage imageNamed:@"create_synchronisms"] options:(SDWebImageRetryFailed | SDWebImageLowPriority) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.annoImage sizeToFit];
        }];
//        [self.annoButton sd_setImageWithURL:[NSURL URLWithString:finalUrl] forState:UIControlStateNormal] ;
        
        [self.annoButton sd_setImageWithURL:[NSURL URLWithString:finalUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

//            [self.annoButton.imageView sizeToFit];
            
        }];
        self.finalStr  = finalUrl;
    }else
    {
        [self.annoImage sd_setImageWithURL:[NSURL URLWithString:@"http://a.dituhui.com/images/marker/icon/default/761458fbc7b4142e1ae92be936f822a3.png"]];
        [self.annoButton sd_setImageWithURL:[NSURL URLWithString:@"http://a.dituhui.com/images/marker/icon/default/761458fbc7b4142e1ae92be936f822a3.png"] forState:UIControlStateNormal];
    }
    
    indexPath1 = indexItem1;
    indexPath2 = indexItem2;
    indexPath3 = indexItem3;
    selectiindex = selectindex;
}

- (IBAction)dingwei:(UIButton *)sender {
    
    //定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status=[CLLocationManager authorizationStatus];
    if(enable && status>=3)  {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
        //    static dispatch_once_t onceToken;
        //    dispatch_once(&onceToken, ^{
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
    }else
    {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }

}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
- (IBAction)fangda:(id)sender {
    
    float level =  self.mapView.zoomLevel;
    if (3.0 < level <19.0) {
        self.mapView.zoomLevel = self.mapView.zoomLevel + 1.0;
    }
    
}

- (IBAction)suoxiao:(id)sender {

    float level =  self.mapView.zoomLevel;
    if (3.0 < level <19.0) {
        self.mapView.zoomLevel = self.mapView.zoomLevel - 1.0;
    }

}
@end
