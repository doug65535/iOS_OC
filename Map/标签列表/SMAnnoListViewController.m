//
//  SMAnnoListViewController.m
    
//
//  Created by lucifer on 15/8/3.
  
//

#import "SMAnnoListViewController.h"
#import "SMAnnoDetailViewController.h"
#import "SMDetailZanShouCangTableViewCell.h"
#import "SMZone.h"

#import "UIImage+RTTint.h"

#import "SMZoneDetailViewController.h"

@interface SMAnnoListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,getter=isChange,assign) BOOL isChange;

@end

@implementation SMAnnoListViewController


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
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;

    switch (Index) {
        case 0:
            self.isChange = NO;
            [self.tableView reloadData];
            break;
        case 1:
            self.isChange = YES;
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.mapModel.app_name isEqualToString:@"LINE"]) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"数据列表(%tu)",self.annoDataArr.count],[NSString stringWithFormat:@"路线列表(%tu)",self.linesArr.count],nil];
        
        //初始化UISegmentedControl
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        
        segmentedControl.selectedSegmentIndex = 0;
        //        segmentedControl.frame = CGRectMake(20.0, 20.0, 250.0, 50.0);
        
        
        segmentedControl.tintColor = [UIColor whiteColor];
        
        
        
        [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
        
        self.navigationItem.titleView = segmentedControl;
    }
    
    
    if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"]) {

        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"数据列表(%tu)",self.annoDataArr.count],[NSString stringWithFormat:@"区域列表(%tu)",self.zonesArr.count],nil];
        
        //初始化UISegmentedControl
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        
        segmentedControl.selectedSegmentIndex = 0;
//        segmentedControl.frame = CGRectMake(20.0, 20.0, 250.0, 50.0);
        
        
        segmentedControl.tintColor = [UIColor whiteColor];
        

        
        [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
        
        self.navigationItem.titleView = segmentedControl;
    }else{
    self.title = [NSString stringWithFormat:@"数据列表(%tu)",self.annoDataArr.count];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 表格数据源和代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isChange) {
        if ([self.mapModel.app_name isEqualToString:@"LINE"]){
        return self.linesArr.count;
        }else
        {
            return self.zonesArr.count;
        }
        
    }else{
        

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
//    static NSString *ID = @"cell";
//    SMDetailZanShouCangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    SMDetailZanShouCangTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SMDetailZanShouCangTableViewCell" owner:self options:nil] lastObject];
        
    }
    
   
    
    if (self.isChange) {
        
        if ([self.mapModel.app_name isEqualToString:@"LINE"]){
            SMLine *line = self.linesArr[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"nav_share"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:line.style.line_color alpha:line.style.line_alpha] level:1.0f];
            
            [cell.avterImageView setImage:tinted];
            //        cell.avterImageView.contentMode = UIViewContentModeScaleAspectFit;
            
           
            
            cell.title.text = line.title;
            cell.title.font = [UIFont systemFontOfSize:16.0];

        }else
        {
            SMZone *zone = self.zonesArr[indexPath.row];
            
            UIImage *image = [UIImage imageNamed:@"whiteplaceholder"];
            UIImage *tinted = [image rt_tintedImageWithColor:[self getColor:zone.style.fill_color alpha:zone.style.fill_opacity] level:1.0f];
            
            
            
            [cell.avterImageView setImage:tinted];
            //        cell.avterImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            cell.avterImageView.layer.borderWidth= 2.0;
            cell.avterImageView.layer.borderColor= [[self getColor:zone.style.line_color alpha:@"0.8"] CGColor];
            
            cell.title.text = zone.title;
            cell.title.font = [UIFont systemFontOfSize:16.0];
        }
        
    }else{
      cell.avterImageView.contentMode = UIViewContentModeCenter;
    SMAnno *anno = self.annoDataArr[indexPath.row];
        
       
        
    [cell.avterImageView sd_setImageWithURL:[NSURL URLWithString:anno.icon.url] placeholderImage:[UIImage imageNamed:@"main_mine"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
//    cell.avterImageView.contentMode =  UIViewContentModeScaleAspectFit;
        
//    cell.avterImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

//    cell.textLabel.text = anno.title;
        
        cell.title.text = anno.title;

    cell.title.font = [UIFont systemFontOfSize:16.0];
    
    }
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 20;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.isChange) {
        
        
        
        SMZoneDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"SMZoneDetail" bundle:nil]instantiateInitialViewController];
        
        if ([self.mapModel.app_name isEqualToString:@"LINE"]){
            SMLine *line = self.linesArr[indexPath.row];
            detailVC.line = line;
            
        }else
        {
            SMZone *zone = self.zonesArr[indexPath.row];
            detailVC.zone = zone;

        }
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMAnnoDetail" bundle:nil];
    
    SMAnnoDetailViewController *annoDetailVc = [sb instantiateInitialViewController];
    
    [self addChildViewController:annoDetailVc];
    
    annoDetailVc.annoModel = self.annoDataArr[indexPath.row];
    annoDetailVc.mapModel = self.mapModel;
    
    [self.navigationController pushViewController:annoDetailVc animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isChange) {
        if ([self.mapModel.app_name isEqualToString:@"MARKER_ZONE"]) {
            if (self.zonesArr.count == 0) {
                return @"还没有任何区域";
            }else
            {
                return nil;
            }
        }else if([self.mapModel.app_name isEqualToString:@"LINE"])
        {
            if (self.linesArr.count ==0) {
                return @"还没有任何路线";
            }else
            {
                return nil;
            }
        }else
        {
            return nil;
        }
    }else
    {
        if (self.annoDataArr.count == 0) {
            return @"还没有任何点标记";
        }else
        {
            return nil;
        }
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
    UITableViewHeaderFooterView *vHeader = (UITableViewHeaderFooterView *)view;
    vHeader.textLabel.font = [UIFont systemFontOfSize:12];
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    NSString *str = [NSString stringWithFormat:@"共有%tu个标注点",self.annoDataArr.count];
//    return str;
//}

@end
