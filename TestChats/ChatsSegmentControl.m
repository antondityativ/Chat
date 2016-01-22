//
//  TrainingResultControl.m
//  Triathlon
//
//  Created by Антон Дитятив on 14.12.15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import "ChatsSegmentControl.h"

@interface ChatsSegmentControl ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *tabs;


@end

@implementation ChatsSegmentControl

@synthesize selectedTab = _selectedTab;

-(instancetype)initWithTabTitles:(NSArray *)titles {
    return [self initWithFrame:CGRectZero titles:titles];
}

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        [self setup];
    }
    return self;
}

-(void)setup {
    self.backgroundColor = [UIColor colorWithRed:246./255. green:246./255. blue:246./255. alpha:1];
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (NSString *title in self.titles) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:74/255. green:74/255. blue:74/255. alpha:1] forState:UIControlStateNormal];
        [self addSubview:button];
        [buttons addObject:button];
        [button addTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tabs = buttons;
    
    CGFloat tabWidth = [UIScreen mainScreen].bounds.size.width / self.titles.count;
    
    self.indicator = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 4, tabWidth, 4)];
    self.indicator.backgroundColor = [UIColor colorWithRed:66/255. green:147/255. blue:241/255. alpha:1];
    [self addSubview:self.indicator];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    int i = 0;
    CGFloat tabWidth = [UIScreen mainScreen].bounds.size.width / self.titles.count;
    CGFloat tabHeight = self.bounds.size.height;
    
    [self.indicator setFrame:CGRectMake(0, self.frame.size.height - 4, tabWidth, 4)];

    for (UIButton *button in self.tabs) {
        button.frame = CGRectMake(i * tabWidth, 0, tabWidth, tabHeight);
        ++i;
    }
}

-(void)setSelectedTab:(NSUInteger)tab animated:(BOOL)animated {
    if (_selectedTab == tab) {
        return;
    }
    _selectedTab = tab;
    CGFloat tabWidth = [UIScreen mainScreen].bounds.size.width / self.titles.count;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicator.frame = CGRectMake(self.selectedTab * tabWidth, self.bounds.size.height-4, tabWidth, 4);
        }];
    } else {
        self.indicator.frame = CGRectMake(self.selectedTab * tabWidth, self.bounds.size.height-4, tabWidth, 4);
    }
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(NSUInteger)selectedTab {
    return _selectedTab;
}

-(void)setSelectedTab:(NSUInteger)selectedTab {
    [self setSelectedTab:selectedTab animated:NO];
}

-(void)tabPressed:(UIButton *)button {
    NSUInteger index = [self.tabs indexOfObject:button];
    
    _selectedTab = index;
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


@end
