//
//  TrainingResultControl.h
//  Triathlon
//
//  Created by Антон Дитятив on 14.12.15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatsSegmentControl : UIControl

-(instancetype)initWithTabTitles:(NSArray *)titles;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@property (nonatomic) NSUInteger selectedTab;
@property (nonatomic, strong) UIView *indicator;

-(void)setSelectedTab:(NSUInteger)tab animated:(BOOL)animated;

@end
