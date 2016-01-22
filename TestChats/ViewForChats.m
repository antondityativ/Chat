//
//  ViewForChats.m
//  TestChats
//
//  Created by Антон Дитятив on 21.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "ViewForChats.h"

@interface ChatMessage : NSObject

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;

@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, readonly)  BOOL fromMe;

@end

@interface ViewForChats()

@property(strong, nonatomic)SRWebSocket *webSocket;
@property(strong, nonatomic)NSMutableArray *messages;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation ViewForChats

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _messages = [[NSMutableArray alloc] init];

        [self addSubview:self.tableView];
        [self _reconnect];
        [self.tableView reloadData];
    }
    return self;
}

- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"wss://ws.chateam.com"]]];
    _webSocket.delegate = self;
    
    [_webSocket open];
    
}

-(UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-160)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"SentCell"];
        [_tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"ReceivedCell"];
        [_tableView setBackgroundColor:[UIColor blueColor]];
        [_tableView addSubview:self.inputView];
    }
    return _tableView;
}

-(UITextView *)inputView {
    if(!_inputView) {
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 174, screenWidth, 48)];
        [_inputView setBackgroundColor:[UIColor lightGrayColor]];
        [_inputView setDelegate:self];
        _inputView.layer.cornerRadius = 5;
    }
    return _inputView;
}

#pragma mark - UITableViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _messages.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ChatTableViewCell *chatCell = (id)cell;
    ChatMessage *message = [_messages objectAtIndex:indexPath.row];
    chatCell.textView.text = message.message;
    chatCell.nameLabel.text = message.fromMe ? @"Me" : @"Other";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ChatMessage *message = [_messages objectAtIndex:indexPath.row];
    
    return [self.tableView dequeueReusableCellWithIdentifier:message.fromMe ? @"SentCell" : @"ReceivedCell"];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
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


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    [webSocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
    
    [self _reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    [_messages addObject:[[ChatMessage alloc] initWithMessage:message fromMe:NO]];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
    
    self.inputView.text = [NSString stringWithFormat:@"%@\n%@", self.inputView.text, message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
    [self _reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Websocket received pong");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text rangeOfString:@"\n"].location != NSNotFound) {
        NSString *message = [[textView.text stringByReplacingCharactersInRange:range withString:text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_webSocket send:message];
        [_messages addObject:[[ChatMessage alloc] initWithMessage:message fromMe:YES]];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollRectToVisible:self.tableView.tableFooterView.frame animated:YES];
        
        textView.text = @"";
        return NO;
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}



@end

@implementation ChatMessage

@synthesize message = _message;
@synthesize fromMe = _fromMe;

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;
{
    self = [super init];
    if (self) {
        _fromMe = fromMe;
        _message = message;
    }
    
    return self;
}

@end

