//
//  ViewForChats.h
//  TestChats
//
//  Created by Антон Дитятив on 21.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "ChatTableViewCell.h"
#import "ChatsSegmentControl.h"

@interface ViewForChats : UIView <SRWebSocketDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic)NSString *title;
@property (nonatomic, retain) UITextView *inputView;
@property (nonatomic, retain) ChatsSegmentControl *control;
@end
