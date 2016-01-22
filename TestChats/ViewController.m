//
//  ViewController.m
//  TestChats
//
//  Created by Антон Дитятив on 20.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "ViewController.h"
#import "ChatsSegmentControl.h"
#import "ViewsWithoutChats.h"
#import "ViewForChats.h"

@interface ViewController ()

@property(strong,nonatomic) ChatsSegmentControl *control;
@property(strong,nonatomic) ViewsWithoutChats *famousView;
@property(strong,nonatomic) ViewForChats *chatView;
@property(strong,nonatomic) ViewsWithoutChats *infoView;
@property(strong,nonatomic) ViewsWithoutChats *chattersView;
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIScrollView *verticalScrollView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Политика";
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.verticalScrollView];
    [self.verticalScrollView addSubview:self.scrollView];
    [self.view addSubview:self.control];
    [self.scrollView addSubview:self.famousView];
    [self.scrollView addSubview:self.chatView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.chattersView];
}

-(ChatsSegmentControl *)control {
    if(!_control) {
        _control = [[ChatsSegmentControl alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 60) titles:@[@"Важное",@"Чат",@"Инфо",@"Чатеры"]];
        [_control addTarget:self action:@selector(changeTarget:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}


-(UIScrollView *)verticalScrollView {
    if(!_verticalScrollView) {
        _verticalScrollView = [[UIScrollView alloc] init];
        [_verticalScrollView setBackgroundColor:[UIColor whiteColor]];
        _verticalScrollView.delegate = self;
        _verticalScrollView.showsVerticalScrollIndicator = YES;
        _verticalScrollView.bounces = NO;
    }
    return _verticalScrollView;
}

-(UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGFloat x = scrollView.contentOffset.x / 4.0f;
        x = MAX(x, 0);
        //    x = MIN(x, self.view.bounds.size.width / 3.0f);
        
        if (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, 0)];
        } else
            if (scrollView.contentOffset.x < 0) {
                [scrollView setContentOffset:CGPointMake(0, 0)];
            } else {
                CGRect frame = self.control.indicator.frame;
                frame.origin.x = x;
                self.control.indicator.frame = frame;
            }
    }
    else {
//        [self.control setAlpha:(_scrollView.contentOffset.y + statusBarOffset)/navigationBarHeight];
//        [self.control setAlpha:self.control.alpha < 0 ? 0 : self.control.alpha > 1 ? 1 : self.control.alpha];
        
        
        CGPoint scrollPos = scrollView.contentOffset;
        
        if(scrollPos.y >= _control.frame.origin.y + _control.frame.size.height /* or CGRectGetHeight(yourToolbar.frame) */){
            [UIView animateWithDuration:1.f animations:^{
                [_control setHidden:YES];
            } completion:^(BOOL finished) {
               
            }];
        } else {
            [UIView animateWithDuration:1 animations:^{
                [_control setHidden:NO];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView == _scrollView) {
        self.control.selectedTab = (NSUInteger)roundf(scrollView.contentOffset.x / screenWidth);
    }
}

-(ViewsWithoutChats *)famousView {
    if(!_famousView) {
        _famousView = [[ViewsWithoutChats alloc] init];
    }
    
    [_famousView setBackgroundColor:[UIColor greenColor]];
    
    return _famousView;
}

-(ViewForChats *)chatView {
    if(!_chatView) {
        _chatView = [[ViewForChats alloc] init];
        _chatView.title = self.title;
        _chatView.control = _control;
    }
    return _chatView;
}

-(ViewsWithoutChats *)infoView {
    if(!_infoView) {
        _infoView = [[ViewsWithoutChats alloc] init];
    }
    
    [_infoView setBackgroundColor:[UIColor redColor]];
    
    return _infoView;
}

-(ViewsWithoutChats *)chattersView {
    if(!_chattersView) {
        _chattersView = [[ViewsWithoutChats alloc] init];
    }
    
    [_chattersView setBackgroundColor:[UIColor magentaColor]];
    
    return _chattersView;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_verticalScrollView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [_scrollView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    [_verticalScrollView setContentSize:CGSizeMake(screenWidth, screenHeight*3)];
    _scrollView.contentSize = CGSizeMake(screenWidth * 4, screenHeight);
//    [_control setFrame:CGRectMake(0, 0, screenWidth, 60)];
    [_famousView setFrame:CGRectMake(0, _control.frame.origin.y + _control.frame.size.height, screenWidth, screenHeight*3)];
    [_chatView setFrame:CGRectMake(screenWidth, _control.frame.origin.y + _control.frame.size.height, screenWidth, screenHeight*3)];
    [_infoView setFrame:CGRectMake(screenWidth*2, _control.frame.origin.y + _control.frame.size.height, screenWidth, screenHeight*3)];
    [_chattersView setFrame:CGRectMake(screenWidth*3, _control.frame.origin.y + _control.frame.size.height, screenWidth, screenHeight*3)];
    CGFloat x = screenWidth * _control.selectedTab;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    [_verticalScrollView setContentSize:CGSizeMake(screenWidth, screenHeight*3)];
}


-(void)changeTarget:(ChatsSegmentControl *)control {
    CGFloat x = screenWidth * control.selectedTab;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    if(control.selectedTab == 0) {
        [_chatView.inputView resignFirstResponder];
    }
    else if (control.selectedTab == 1) {
        [_chatView.inputView becomeFirstResponder];
        
    }
    else if(control.selectedTab == 2){
        [_chatView.inputView resignFirstResponder];
    }
    else {
        [_chatView.inputView resignFirstResponder];
    }
}


@end
