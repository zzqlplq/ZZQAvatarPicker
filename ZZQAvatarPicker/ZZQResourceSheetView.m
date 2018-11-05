//
//  ZZQResourceSheetView.m
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/10/31.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import "ZZQResourceSheetView.h"

#define ZZQ_ScreenWidth                   [UIScreen mainScreen].bounds.size.width
#define ZZQ_ScreenHeight                  [UIScreen mainScreen].bounds.size.height

static const CGFloat kDefaultCellHeight = 54;
static const CGFloat kFrontCancelTableViewCellHeight = 10;

@interface ZZQResourceSheetView ()<UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *resourceFroms;

@property (nonatomic, strong) NSArray *resourceDescFroms;

@property (nonatomic, assign) CGFloat bottomEdge;

@end


@implementation ZZQResourceSheetView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    [self addSubviews];
    [self makeSubviewsLayout];
}


- (void)addSubviews {
    [self.bgView addSubview:self];
    [self addSubview:self.tableView];
}


- (void)makeSubviewsLayout {
    
    CGFloat height = kDefaultCellHeight * [self totalCountOfResourceFroms] + kFrontCancelTableViewCellHeight + self.bottomEdge;
    self.frame = CGRectMake(0, ZZQ_ScreenHeight - height, ZZQ_ScreenWidth, height);
    self.tableView.frame = CGRectMake(0, 0, ZZQ_ScreenWidth, height);
}


- (NSInteger)totalCountOfResourceFroms {
    NSInteger count = 0;
    for (NSArray *temp in self.resourceFroms) {
        for (id mode in temp) {
            NSLog(@"%@", mode);
            count ++;
        }
    }
    return count;
}


- (void)show {
    [self bgViewAnimationShow];
    [self tableViewAnimationShow];
}


- (void)bgViewAnimationShow {
    [UIView animateWithDuration:0.2f animations:^{
        self.bgView.alpha = 1.f;
    }];
}


- (void)tableViewAnimationShow {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.2;
    [self.tableView.layer addAnimation:animation forKey:@"topAnimation"];
}


- (void)hide {
    [self tableViewAnimationHide];
    [self bgViewAnimationHide];
}


- (void)bgViewAnimationHide {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}


- (void)tableViewAnimationHide {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromBottom;
    animation.duration = 0.2;
    [self.tableView.layer addAnimation:animation forKey:@"bottomAnimation"];
    self.tableView.alpha = 0;
}


#pragma mark - <UITapGestureRecognizer>

- (void)tapHandle:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(ZZQResourceSheetView:seletedMode:)]) {
        [self.delegate ZZQResourceSheetView:self seletedMode:ResourceModeNone];
    }
    [self hide];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}



#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resourceFroms.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resourceFroms[section] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"resourceFromCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIndentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZZQ_ScreenWidth, kDefaultCellHeight)];
        label.textColor = [UIColor darkTextColor];
        label.font = [UIFont systemFontOfSize:20.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 12345;
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:12345];
    label.text = self.resourceDescFroms[indexPath.section][indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? kFrontCancelTableViewCellHeight : self.bottomEdge;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    CGFloat height = section == 0 ? kFrontCancelTableViewCellHeight : self.bottomEdge;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZZQ_ScreenWidth, height)];
    header.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    return header;
}



#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResourceMode mode = [self.resourceFroms[indexPath.section][indexPath.row] integerValue];
    if ([self.delegate respondsToSelector:@selector(ZZQResourceSheetView:seletedMode:)]) {
        [self.delegate ZZQResourceSheetView:self seletedMode:mode];
    }    
    [self hide];
}


#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
        UIView *window = [[[UIApplication sharedApplication] delegate] window];
        _bgView = [[UIView alloc] initWithFrame:window.bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        _bgView.alpha = 0.f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        tap.delegate = self;
        tap.cancelsTouchesInView = NO;
        [_bgView addGestureRecognizer:tap];
        [window addSubview:_bgView];
    }
    return _bgView;
}


- (NSArray *)resourceFroms {
    if (!_resourceFroms) {
        _resourceFroms = @[@[@(ResourceModeAlbum), @(ResourceModeCamera)], @[@(ResourceModeNone)]];
    }
    return _resourceFroms;
}


- (NSArray *)resourceDescFroms {
    if (!_resourceDescFroms) {
        _resourceDescFroms = @[@[@"从相册选取图片", @"拍照"], @[@"取消"]];
    }
    return _resourceDescFroms;
}



- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [UITableView new];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}


- (CGFloat)bottomEdge {
    if (!_bottomEdge) {
        if (@available(iOS 11.0, *)) {
            UIEdgeInsets edge = [[[UIApplication sharedApplication] windows] firstObject].safeAreaInsets;
            _bottomEdge = edge.bottom;
        } else {
            _bottomEdge = 0.f;
        }
    }
    return _bottomEdge;
}


- (void)dealloc {
    NSLog(@"sheet view dealloc");
}

@end
