//
//  SMSeachTBViewController.m
    
//
//  Created by lucifer on 15/8/6.
  
//

#import "SMSeachTBViewController.h"

#import "SMAnno.h"
#import "SMMakerResultViewController.h"
#import "ALView+PureLayout.h"
#import "SMAnnoDetailViewController.h"
#import "SMZone.h"
#import "UIImage+RTTint.h"
#import "SMZoneDetailViewController.h"

@interface SMSeachTBViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 遮盖 */
@property (nonatomic, weak) IBOutlet UIButton *cover;


@property (nonatomic, weak)SMMakerResultViewController  *makerResultVc;

@end

@implementation SMSeachTBViewController

- (SMMakerResultViewController *)makerResultVc
{
    if (!_makerResultVc) {
        SMMakerResultViewController *makerResultVc = [[SMMakerResultViewController alloc] init];
        
            makerResultVc.mapmodel = self.mapModel;
        
        [self addChildViewController:makerResultVc];
        [self.view addSubview:makerResultVc.view];
        
//        makerResultVc.delegate = self;
    
        makerResultVc.linesArray = self.linesArr;
        [makerResultVc.annoModelArr addObjectsFromArray:self.annoDataArr];
//
        makerResultVc.zonesArr = self.zonesArr;
        [makerResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        
        [makerResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tableView];
        
        
        self.makerResultVc = makerResultVc;
    }
    return _makerResultVc;
}

//-(void)didScroll
//{
//    [self.searchBar endEditing:YES];
//}

-(NSMutableArray *)annoDataArr
{
    if (!_annoDataArr) {
        _annoDataArr = [[NSMutableArray alloc]init];
    }
    return _annoDataArr;
}
-(NSMutableArray *)linesArr
{
    if (!_linesArr) {
        _linesArr = [[NSMutableArray alloc]init];
    }
    return _linesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    self.title = @"搜索标注点";
    
    // 设置表格的索引文字颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];

    [self.cover addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


-(void)resign
{
    
    [self.searchBar resignFirstResponder];
    // 1.让搜索框背景变为灰色
    _searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 2.隐藏cancel按钮
    [_searchBar setShowsCancelButton:NO animated:YES];
    // 3.导航条出现（通过动画向下出现）
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//     4.移除蒙版
        self.cover.hidden = YES;
//     5.清空搜索框文字
        _searchBar.text = nil;
//     6.隐藏搜索结果控制器
        self.makerResultVc.view.hidden = YES;
}
//- (void)setupNav
//{
//    // 1.main_find_press
//    // 2.搜索框
//    
//    UIView *titleView = [[UIView alloc] init];
//    titleView.width = 250;
//    titleView.height = 35;
//    self.navigationItem.titleView = titleView;
//    
//    UISearchBar *searchBar = [[UISearchBar alloc] init];
//    searchBar.frame = titleView.bounds;
////    searchBar.backgroundImage = [UIImage imageNamed:@"main_find_press"];
//    searchBar.delegate = self;
//    [titleView addSubview:searchBar];
//    self.searchBar = searchBar;
//}


#pragma mark - <UISearchBarDelegate>
/**
 *  当搜索框已经进入编辑状态（键盘已经弹出）
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1.让搜索框背景变为绿色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 2.出现cancel按钮
//    [searchBar setShowsCancelButton:YES animated:YES];
    // 3.导航条消失（通过动画向上消失）
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 4.添加蒙版
    self.cover.hidden = NO;
}

/**
 *  当搜索框已经退出编辑状态（键盘已经退下）
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.让搜索框背景变为灰色
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 2.隐藏cancel按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    // 3.导航条出现（通过动画向下出现）
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 4.移除蒙版
//    self.cover.hidden = YES;
    // 5.清空搜索框文字
//    searchBar.text = nil;
    // 6.隐藏搜索结果控制器
//    self.makerResultVc.view.hidden = YES;
}

/**
 *  点击取消按钮
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
//     4.移除蒙版
        self.cover.hidden = YES;
//     5.清空搜索框文字
        searchBar.text = nil;
//     6.隐藏搜索结果控制器
        self.makerResultVc.view.hidden = YES;
}

/**
 *  搜索框的文字改变
 *
 *  @param searchText 搜索框当前的文字（搜索条件）
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.makerResultVc.view.hidden = (searchText.length == 0);
    self.makerResultVc.searchText = searchText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"] || [self.mapModel.app_name isEqualToString:@"LINE"]) {
        return 2;
    }else
    {
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"]) {
        if (section == 0) {
            return @"标记数据";
        }else
        {
            return @"区域数据";
        }
    }else if([self.mapModel.app_name isEqualToString:@"LINE"]){
        if (section == 0) {
            return @"标记数据";
            
        }else
        {
            return @"路线数据";
        }
    }
    else
    {
        
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"]) {
        if (section == 0) {
            return self.annoDataArr.count;
        }else
        {
            return self.zonesArr.count;
        }
    }else if([self.mapModel.app_name isEqualToString:@"LINE"])
    {
        if (section == 0) {
            return self.annoDataArr.count;
        }else
        {
            return self.linesArr.count;
        }
    }
    
    else{
    return self.annoDataArr.count;
    }
}


-(UIColor *)getColor:(NSString *)hexColor alpha:(NSString *)alpha{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha.floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    if (indexPath.section == 0) {
        SMAnno *anno = self.annoDataArr[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        
        cell.textLabel.text = anno.title;
    }else{
        if ([self.mapModel.app_name isEqualToString:@"LINE"]){
            SMLine *line = self.linesArr[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"nav_share"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:line.style.line_color alpha:line.style.line_alpha] level:1.0f];
            
            
            
            [cell.imageView setImage:tinted];
            //        cell.avterImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            
            
            cell.textLabel.text = line.title;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            
        }else
        {
            
            SMZone *zone = self.zonesArr[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"whiteplaceholder"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:zone.style.fill_color alpha:zone.style.fill_opacity] level:1.0f];
            
            [cell.imageView setImage:tinted];
            
            cell.textLabel.text = zone.title;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }

       
    }
    
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"]) {
        
        if (indexPath.section == 0) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAnnoDetail" bundle:nil];
            
            SMAnnoDetailViewController *annoDetailVc = [sb instantiateInitialViewController];
            
            [self addChildViewController:annoDetailVc];
            
            annoDetailVc.annoModel = self.annoDataArr[indexPath.row];
            annoDetailVc.mapModel = self.mapModel;
            
            [self.navigationController pushViewController:annoDetailVc animated:YES];
        }else{
        SMZoneDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"SMZoneDetail" bundle:nil]instantiateInitialViewController];
        
        SMZone *zone = self.zonesArr[indexPath.row];
        detailVC.zone = zone;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if([self.mapModel.app_name isEqualToString:@"LINE"])
    {
        if (indexPath.section == 0) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAnnoDetail" bundle:nil];
            
            SMAnnoDetailViewController *annoDetailVc = [sb instantiateInitialViewController];
            
            [self addChildViewController:annoDetailVc];
            
            annoDetailVc.annoModel = self.annoDataArr[indexPath.row];
            annoDetailVc.mapModel = self.mapModel;
            
            [self.navigationController pushViewController:annoDetailVc animated:YES];

        }else
        {
            SMZoneDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"SMZoneDetail" bundle:nil]instantiateInitialViewController];
            
            SMLine *line = self.linesArr[indexPath.row];
            detailVC.line = line;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
    
    else{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAnnoDetail" bundle:nil];
        
        SMAnnoDetailViewController *annoDetailVc = [sb instantiateInitialViewController];
        
        [self addChildViewController:annoDetailVc];
        
        annoDetailVc.annoModel = self.annoDataArr[indexPath.row];
        annoDetailVc.mapModel = self.mapModel;
        
        [self.navigationController pushViewController:annoDetailVc animated:YES];
    }


}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
   
}

@end
