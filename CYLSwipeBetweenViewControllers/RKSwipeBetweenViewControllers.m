//
//  RKSwipeBetweenViewControllers.m
//  CYLSwipeBetweenViewControllers
//
//  Created by chenyilong on 15/3/4.
//  Copyright (c) 2015年 chenyilong. All rights reserved.
//
#define TOPBARIMAGENOR @"topBar_btn"
#define TOPBARIMAGESEL @"topBar_btnSel"
#define TOPBARFENGGE @"fengge"

#define TOPBARWIDTH self.view.bounds.size.width/3
#define TOPBARHEIGHT 39

#define TOPBARHEIGHT 39
#define UI_TAB_BAR_HEIGHT               49
#define UI_NAVIGATION_BAR_HEIGHT        44

#import "RKSwipeBetweenViewControllers.h"

@interface RKSwipeBetweenViewControllers ()<UITableViewDelegate> {
    int  tagCount;
    int temp;
}
@property (nonatomic, strong)  UITableView *firstView;
@property (nonatomic, strong)  UITableView *secondView;
@property (nonatomic, strong)  UITableView *thirdView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation RKSwipeBetweenViewControllers

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    _titleArr = [[NSArray alloc] initWithObjects:@"视图一",@"视图二",@"视图三", nil];
    [self addTopBarView];
    [self initScrollView];
}


-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPBARHEIGHT, self.view.bounds.size.width, self.view.frame.size.height-UI_TAB_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-TOPBARHEIGHT-10)];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3,0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    float scollX2 = self.view.bounds.size.width*2;
    
    self.firstView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.frame.size.height-49-44-TOPBARHEIGHT) style:UITableViewStylePlain];
    self.firstView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-49-44-TOPBARHEIGHT-20);
    _firstView.tag = 1001;
    _firstView.showsVerticalScrollIndicator = NO;
    _firstView.backgroundView.hidden = YES;
    _firstView.backgroundColor = [UIColor blueColor];
    //    _firstView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _firstView.delegate = self;
    //    _firstView.dataSource = self;
    [_scrollView addSubview:_firstView];
    
#pragma mark 第二个视图
    self.secondView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.frame.size.height-49-44-39) style:UITableViewStylePlain];
    self.secondView.backgroundColor = [UIColor grayColor];
    _secondView.showsVerticalScrollIndicator = NO;
    _secondView.backgroundView.hidden = YES;
    //    _secondView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _secondView.delegate = self;
    //    _secondView.dataSource = self;
    [_scrollView addSubview:_secondView];
    
#pragma mark 第三个试图
    self.thirdView = [[UITableView alloc] initWithFrame:CGRectMake(scollX2, 0, self.view.bounds.size.width, self.view.frame.size.height-49-44-TOPBARHEIGHT) style:UITableViewStylePlain];
    if (([[UIScreen mainScreen] bounds].size.height == 568)) {
        _thirdView.frame = CGRectMake(scollX2,0, self.view.bounds.size.width, self.view.frame.size.height-49-44-TOPBARHEIGHT-45-30);
    }
    _thirdView.tag = 1000;
    _thirdView.showsVerticalScrollIndicator = NO;
    _thirdView.backgroundView.hidden = YES;
    //    _thirdView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _thirdView.delegate = self;
    //    _thirdView.dataSource = self;
    [_scrollView addSubview:_thirdView];
    _thirdView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:_scrollView];
    
    UIImage *nokdtImage;
    nokdtImage = [UIImage imageNamed:@"nokdy_img"];
}
/**
 *  使用Layout进行iOS7适配,此方法适用于有导航条且视图是UIViewController
 */
- (void)viewWillLayoutSubviews
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGFloat top = [self.topLayoutGuide length];
        CGRect bounds = self.view.bounds;
        bounds.origin.y = -top;
        self.view.bounds = bounds;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ( ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)addTopBarView {
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, TOPBARHEIGHT)];
    
    for (int i = 0;i<3;i++){
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIndex:)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+(1+TOPBARWIDTH)*i,0,TOPBARWIDTH,TOPBARHEIGHT)];
        imageView.image = [UIImage imageNamed:TOPBARIMAGENOR];
        if (i == 0){
            tagCount = 100;
            imageView.image = [UIImage imageNamed:TOPBARIMAGESEL];
        }
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100+i;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,TOPBARWIDTH,TOPBARHEIGHT)];
        label.text = [_titleArr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [imageView addSubview:label];
        [imageView addGestureRecognizer:tap];
        [_titleView addSubview:imageView];
    }
#pragma mark -----------xy:顶部选项卡的分割线
    UIImageView * fgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TOPBARFENGGE]];
    fgImageView.frame = CGRectMake(TOPBARWIDTH, 0, 1, TOPBARHEIGHT);
    UIImageView * fgImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TOPBARFENGGE]];
    fgImageView2.frame = CGRectMake(TOPBARWIDTH*2+1, 0, 1, TOPBARHEIGHT);
    [_titleView addSubview:fgImageView];
    [_titleView addSubview:fgImageView2];
    
    [self.view addSubview:_titleView];
}

-(void)changeIndex:(UITapGestureRecognizer *)sender
{
    
    UIImageView * imageView = (UIImageView *)[_titleView viewWithTag:sender.view.tag];
    imageView.image = [UIImage imageNamed:TOPBARIMAGESEL];
    UIImageView * imageView2 = (UIImageView *)[_titleView viewWithTag:tagCount];
    if (tagCount != sender.view.tag){
        imageView2.image = [UIImage imageNamed:TOPBARIMAGENOR];
    }
    tagCount = sender.view.tag;
    temp = tagCount-100;
    //我的关注判断是否登录，未登录跳到登录页面
    _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width*temp, 0);
    if (tagCount == 102){
    }else if(tagCount == 102){
        _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width*temp, 0);
    }
    if (tagCount == 101) {
        _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width*temp, 0);
    }
    if (tagCount == 100) {
        _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width*temp, 0);
    }else{
        
    }
}

#pragma mark - 设置选项卡背景与scrollerView关联
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView){
        temp = (scrollView.contentOffset.x+160)/self.view.bounds.size.width;
        UIImageView * imageView = (UIImageView *)[_titleView viewWithTag:tagCount];
        imageView.image = [UIImage imageNamed:TOPBARIMAGENOR];
        UIImageView * imageView2 = (UIImageView *)[_titleView viewWithTag:temp+100];
        imageView2.image = [UIImage imageNamed:TOPBARIMAGESEL];
        tagCount = temp+100;
        
        if (tagCount!=100) {
        }else{
        }
    }
}

//滚动结束就会调用此方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}
@end
