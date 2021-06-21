//
//  SMComposeShareMapViewController.m
    
//
//  Created by lucifer on 15/8/10.
  
//

#import "SMComposeShareMapViewController.h"

#import "SMBiaoqianViewController.h"
#import "ZFTokenField.h"

#import "SMInputTextView.h"


#import "SMInputToolbar.h"


#import "SMPictures.h"

//#import "TSEmojiView.h"

#import "SMLikeFridensTableViewController.h"

#import "SMInsertLoaction.h"

#import "CoreEmotionView.h"
#import "NSArray+SubArray.h"
#import "EmotionModel.h"
#import "NSString+EmotionExtend.h"
@interface SMComposeShareMapViewController ()<UITextViewDelegate,SMInputToolbarDelegate,SMBiaoqianViewControllerDelegate
,SMLikeFridensTableViewControllerDelegate,SMInsertLoactionDelegate,ZFTokenFieldDataSource,ZFTokenFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mapSnapshot;

@property (weak, nonatomic) IBOutlet UIButton *tagBtn;

@property (weak, nonatomic) IBOutlet UIView *inputLaber;

- (IBAction)tagClick:(UIButton *)sender;

@property (nonatomic,strong)NSMutableArray *tagArr;

@property(nonatomic,copy)NSString *biaoqianName;
//@property (nonatomic,strong)NSMutableArray *picIdArr;
@property(nonatomic,copy)NSString *loactionName;
/**
 *  自定义输入框
 */
@property (weak, nonatomic) IBOutlet UIButton *insetLocation;
- (IBAction)insetLocation:(id)sender;

@property (weak, nonatomic) IBOutlet ZFTokenField *ZFTokenView;
@property (weak, nonatomic) IBOutlet SMInputTextView *inputView;

/**
 *  自定义工具条
 */
@property (nonatomic, weak) SMInputToolbar *toolbar;


//@property (nonatomic,strong)TSEmojiView *emojiView;



@property (nonatomic,copy)NSString *maptitle;

@property (nonatomic,strong) CoreEmotionView *emotionView;
//@property (nonatomic,assign) NSUInteger curve;
//@property (nonatomic,assign) CGFloat time;

//@property(nonatomic,strong)UIButton *emojiBtn;


@end



@implementation SMComposeShareMapViewController


//-(NSMutableArray *)picIdArr
//{
//    if (!_picIdArr) {
//        _picIdArr = [[NSMutableArray alloc] init];
//    }
//    return _picIdArr;
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    地图分享分为  从我的进入  还是从社区进入
     self.mapSnapshot.contentMode =  UIViewContentModeScaleAspectFill;
    
     self.mapSnapshot.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
     self.mapSnapshot.clipsToBounds  = YES;
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    if (self.creatModel) {
        self.maptitle = self.creatModel.title;
    }else
    {
       self.maptitle = self.model.map.title;
    }
    
    if (self.creatModel) {
        [self.mapSnapshot sd_setImageWithURL:[NSURL URLWithString:self.creatModel.snapshotURL]];
    }else
    {
        [self.mapSnapshot sd_setImageWithURL:[NSURL URLWithString:self.model.map.snapshot]];
    }
    
    // 1.设置导航条
    [self setupNav];
    // 2.设置输入控件
    [self setupInput];
    // 3.设置工具条
    [self setupToolbar];
    
    
    self.ZFTokenView.dataSource = self;
    self.ZFTokenView.delegate = self;
    [self.ZFTokenView reloadData];

}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.ZFTokenView indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tagArr removeObjectAtIndex:index];
        [self.ZFTokenView reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 20;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tagArr.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tagArr[index];
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 20)];
    view.frame = CGRectMake(0, 0, size.width + 87, 20);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}


- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tagArr removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return YES;
}

-(void)tokenFieldDidBeginEditing:(ZFTokenField *)tokenField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}



-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(NSString *)biaoqianName
{
    if (!_biaoqianName) {
        _biaoqianName = [[NSString alloc]init];
    }
    return _biaoqianName;
}
-(void)didClickSendBtnWithToken:(NSString *)token
{
    
//    self.biaoqianName =   [self.biaoqianName stringByAppendingString:@" #"];
//    
//    self.biaoqianName = [self.biaoqianName stringByAppendingString:token];
//    
//    self.biaoqianName = [self.biaoqianName stringByAppendingString:@"#"];
//    
//    
//    
//    [self.tagBtn setTitle:self.biaoqianName forState:UIControlStateNormal];


    [self.tagArr addObject:token];
    [self.ZFTokenView reloadData];
    
}

-(NSMutableArray *)tagArr
{
    if (!_tagArr) {
        _tagArr = [[NSMutableArray alloc] init];
    }
    return _tagArr;
}



//点击了表情
-(void)didClickEmoji
{
    
    //视图准备
    [self viewPrepare];
    
    //事件
    [self event];
    
    [_inputView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       _inputView.inputView=_inputView.inputView?nil:self.emotionView;
        
        
        
        [_inputView becomeFirstResponder];
    });
    if (!_inputView.inputView) {
        [_toolbar.subviews[0] setImage:[UIImage imageNamed:@"face_jianpan"] forState:UIControlStateNormal];
    }else
    {
        [_toolbar.subviews[0] setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    }

    
}


-(CoreEmotionView *)emotionView{
    
    if(_emotionView==nil){
        _emotionView = [CoreEmotionView emotionView];
    }
    
    return _emotionView;
}
/*
 *  视图准备
 */
-(void)viewPrepare{
    
    self.emotionView.textView=self.inputView;
    
    //设置代理
    self.inputView.delegate=self;
    //    //监听通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNoti:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}



/*
 *  事件
 */
-(void)event{
    
    //删除按钮点击事件
    __weak typeof(self) weakSelf=self;
    self.emotionView.deleteBtnClickBlock=^(){
        
        [weakSelf.inputView deleteBackward];
    };
}



//点击了 @关联按钮

-(void)didclickmentionbutton
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMLikeFirends" bundle:nil];
    SMLikeFridensTableViewController *mentionVc = [sb instantiateInitialViewController];
    
    mentionVc.delegate = self;
    
    //
    SMNavgationController *nav = [[SMNavgationController alloc] init];
    
    [nav addChildViewController:mentionVc];
    
    
    // 3.弹出授权控制器
    [self presentViewController:nav animated:YES completion:nil];
}

//点击@好友 的回调
-(void)didClickdidSelectWithLikerName:(NSString *)name
{
    
    
    self.inputView.placeholder = nil;
    self.inputView.text = [NSString stringWithFormat:@"%@ @%@", self.inputView.text, name];
}


- (void)setupNav
{
    
    
    // 1.设置导航条标题/ 左右按钮
    self.navigationItem.title = @"发布分享动态";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(composeStatusWithImage)];
}

- (void)setupInput
{
    
    // 2.创建输入控件
//    SMInputTextView *inputView = [[SMInputTextView alloc] init];
//    inputView.frame = CGRectMake(0, 0, self.view.width, 300);
//    // 默认清空下TextView是不能滚动的, 但是可以通过设置某些属性让其默认就可以滚动
//    inputView.alwaysBounceVertical = YES;
//    inputView.delegate = self;
//    
    NSString *str = [NSString stringWithFormat:@"分享地图 %@",self.maptitle];
//
//    self.inputView.placeholder = @"请输入分享地图内容";
    _inputView.text =str;
//
//    [self.inputLaber addSubview:inputView];
//    self.inputView = inputView;
}


- (void)setupToolbar
{
    // 3.创建自定义工具条
    SMInputToolbar *toolbar = [[SMInputToolbar alloc] init];
    toolbar.backgroundColor = [UIColor colorWithRed:1 green:231/255.0 blue:204/255.0 alpha:1];
    toolbar.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    toolbar.delegate = self;
    
    // 监听键盘的弹出和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}



- (void)keyboardDidShow:(NSNotification *)note
{
    
    // 1.取出键盘的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘高度
    CGFloat keyboardHeigth = keyboardFrame.size.height;
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardHeigth);
    } completion:nil];
    
    
}

- (void)keyboardDidHide:(NSNotification *)note
{
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    } completion:nil];
}


/**
 *  发送带图片的帖子
 */
- (void)composeStatusWithImage
{

    
    // 1.封装请求参数
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"body"] =self.inputView.text;
    
//    parameters[@"pictures"] =self.picIdArr;
    if (self.creatModel) {
        parameters[@"map"]  =  self.creatModel.Lid;
    }else
    {
         parameters[@"map"]  =  self.model.map.map_id;
    }
    

//    if (self.creatModel) {
//       parameters[@"pictures"] = self.creatModel.sn
//    }

    
    if (self.tagArr) {
        parameters[@"tags"] = self.tagArr;
    }
    // 2.发送请求
    if (self.loactionName) {
        parameters[@"address"] = self.loactionName;
    }
    NSString *url = @"http://club.dituhui.com/api/v2/messages";
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 0.关闭键盘
        [self.view endEditing:YES];
        // 1.关闭当前控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        // 2.弹出提示用户
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"发送失败"];
    }];
}

- (IBAction)tagClick:(UIButton *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BiaoqianViewController" bundle:nil];
    SMBiaoqianViewController *biaoqian = [sb instantiateInitialViewController];
    
    biaoqian.delegate = self;
    
    //
    SMNavgationController *nav = [[SMNavgationController alloc] init];
    
    [nav addChildViewController:biaoqian];
    
    
    // 3.弹出授权控制器
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (IBAction)insetLocation:(id)sender {

    SMInsertLoaction *locatVc = [[UIStoryboard storyboardWithName:@"SMInsertLocation" bundle:nil]instantiateInitialViewController];
    locatVc.delegate = self;
    
    SMNavgationController *nav = [[SMNavgationController alloc] initWithRootViewController:locatVc];
    
    
    [self presentViewController:nav animated:YES completion:nil];

}

-(void)finishLocate:(NSString *)locateStr
{
    //  用此方法文字只能和以前一样长
    //    self.locteBtn.titleLabel.text = locateStr;
    
    [self.insetLocation setTitle:locateStr forState:UIControlStateNormal];
    
    self.loactionName = locateStr;
}
@end
