//
//  SelectAddres.m
//  KYRR
//
//  Created by kyjun on 15/11/14.
//
//

#import "SelectAddres.h"
#import "EditAddress.h"
#import "MAddress.h"
#import "AddressCell.h"
#import "AppDelegate.h"

@interface SelectAddres ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UIView* headerView;
@property(nonatomic,strong) UIButton* btnAdd;
@property(nonatomic,strong) UIImageView* lineBlock;
@property(nonatomic,strong) UILabel* labelTitle;

@property(nonatomic,strong) NSMutableArray* arrayData;


@property(nonatomic,strong) MAddress* emptyItem;

@end

@implementation SelectAddres


-(instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNav];
    [self layoutUI];
    [self layoutConstraints];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshDataSource];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.navigationItem.title = @"地址管理";
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTouch:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark =====================================================  试图布局
-(void)layoutNav{
   
}
-(void)layoutUI{
    self.headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
    self.headerView.backgroundColor = theme_default_color;
    self.btnAdd  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnAdd setTitleColor:theme_title_color forState:UIControlStateNormal];
    [self.btnAdd setTitle:@"新增收货地址" forState:UIControlStateNormal];
    self.btnAdd.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.btnAdd addTarget:self action:@selector(addAddressTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.btnAdd];
    
    self.lineBlock = [[UIImageView alloc]init];
    self.lineBlock.backgroundColor = theme_line_color;
    [self.headerView addSubview:self.lineBlock];
    
    self.labelTitle = [[UILabel alloc]init];
    self.labelTitle.text = @"历史地址";
    self.labelTitle.font = [UIFont systemFontOfSize:14.f];
    [self.headerView addSubview:self.labelTitle];
    CALayer* border = [[CALayer alloc]init];
    border.frame= CGRectMake(0, 39.f, SCREEN_WIDTH, 1.f);
    border.backgroundColor = theme_line_color.CGColor;
    [self.labelTitle.layer addSublayer:border];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource =self;
    self.tableView.emptyDataSetDelegate =self;
    self.tableView.tableHeaderView = self.headerView;
}

-(void)layoutConstraints{
    self.btnAdd.translatesAutoresizingMaskIntoConstraints = NO;
    self.lineBlock.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.btnAdd addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SCREEN_WIDTH-20]];
    [self.btnAdd addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.f]];
    [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.f]];
    [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.f]];
    
    [self.lineBlock addConstraint:[NSLayoutConstraint constraintWithItem:self.lineBlock attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SCREEN_WIDTH]];
    [self.lineBlock addConstraint:[NSLayoutConstraint constraintWithItem:self.lineBlock attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:5.f]];
    [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineBlock attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.btnAdd attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.f]];
    [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineBlock attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.f]];
    
    [self.labelTitle addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:SCREEN_WIDTH-20]];
    [self.labelTitle addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.f]];
    [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lineBlock attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.f]];
    [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.f]];
    
}
#pragma mark =====================================================  数据源
-(void)queryData{
    
    NSDictionary* arg = @{@"ince":@"get_user_addr_ince",@"uid":self.Identity.userInfo.userID,@"is_default":@"0"};
   
    NetRepositories* repositories = [[NetRepositories alloc]init];
    [repositories queryAddress:arg complete:^(NSInteger react, NSArray *list, NSString *message) {
         [self.arrayData removeAllObjects];
        if(react == 1){
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayData addObject:obj];
            }];
        }else if(react == 400){
            [self alertHUD:message];
        }else{
           // [self alertHUD:message];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];

    
}

-(void)refreshDataSource{
    __weak typeof(self) weakSelf = (id)self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf checkNetWorkState:^(AFNetworkReachabilityStatus netWorkStatus) {
            if(netWorkStatus!=AFNetworkReachabilityStatusNotReachable){
                [weakSelf queryData];
            }else
                [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark =====================================================  UITableView 协议实现

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = (AddressCell*)[tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if(!cell)
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
    
    cell.entity = self.arrayData[indexPath.row];
    [cell disabledDelegate];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MAddress* item =self.arrayData[indexPath.row];
    [self setDefaultAddress:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationSelectedAddres object:item];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark =====================================================  AddressCell 协议shixian
-(void)editAddress:(MAddress *)item{
    EditAddress* controller = [[EditAddress alloc]initWithItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)delAddress:(MAddress *)item{
    self.emptyItem = item;
    
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
#pragma mark =====================================================  DZEmptyData 协议实现
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:tipEmptyDataTitle attributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor grayColor]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    return  [[NSMutableAttributedString alloc] initWithString:tipEmptyDataDescription attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:paragraph}];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return roundf(self.tableView.frame.size.height/10.0);
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark =====================================================  UIAlertView 协议实现
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex==1){
            [self delAddress];
        }
}

#pragma mark =====================================================  SEL
-(IBAction)addAddressTouch:(id)sender{
    EditAddress* controller = [[EditAddress alloc]initWithItem:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)cancelTouch:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)delAddress{
    [self checkNetWorkState:^(AFNetworkReachabilityStatus netWorkStatus) {
        if(netWorkStatus!=AFNetworkReachabilityStatusNotReachable){
            [self showHUD];
           
            NSDictionary* arg = @{@"ince":@"delete_user_addr",@"uid":self.Identity.userInfo.userID,@"itemid":self.emptyItem.rowID};
                        NetRepositories* repositories = [[NetRepositories alloc]init];
            [repositories updateAddres:arg complete:^(NSInteger react, id obj, NSString *message) {
                if(react == 1){
                    [self hidHUD:@"操作成功" ];
                    [self.tableView.mj_header beginRefreshing];
                }else if(react == 400){
                    [self hidHUD:message];
                }else{
                    [self hidHUD:message];
                }
            }];

        }
    }];
    
}
-(void)setDefaultAddress:(MAddress*)item{
    [self checkNetWorkState:^(AFNetworkReachabilityStatus netWorkStatus) {
        if(netWorkStatus!=AFNetworkReachabilityStatusNotReachable){
           // [self showHUD];
           
            NSDictionary* arg = @{@"ince":@"set_default",@"uid":self.Identity.userInfo.userID,@"itemid":item.rowID};
                      
            NetRepositories* repositories = [[NetRepositories alloc]init];
            [repositories updateAddres:arg complete:^(NSInteger react, id obj, NSString *message) {
                if(react == 1){
                    
                   // [self alertHUD: @"操作成功"];
                }else if (react == 400){
                    [self alertHUD:message];
                }else{
                    [self alertHUD:message];
                }
            }];

        }
    }];
    
}


#pragma mark =====================================================  属性封装
-(NSMutableArray *)arrayData{
    if(!_arrayData)
        _arrayData = [[NSMutableArray alloc]init];
    return _arrayData;
}

@end