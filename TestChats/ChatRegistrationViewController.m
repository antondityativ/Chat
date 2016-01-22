//
//  ChatRegistrationViewController.m
//  TestChats
//
//  Created by Антон Дитятив on 21.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "ChatRegistrationViewController.h"

@interface ChatRegistrationViewController ()

@property (strong, nonatomic)UITextField *nickNameTF;
@property (strong, nonatomic)UITextField *emailTF;
@property (strong, nonatomic)UITextField *passwordTF;

@end

@implementation ChatRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetupUI

-(void)setupUI {
    [self.view addSubview:self.emailTF];
    [self.view addSubview:self.nickNameTF];
    [self.view addSubview:self.passwordTF];
}

-(UITextField *)nickNameTF {
    if(!_nickNameTF) {
        _nickNameTF = [[UITextField alloc] init];
        [_nickNameTF setPlaceholder:@"Nick name"];
        [_nickNameTF setBackgroundColor:[UIColor whiteColor]];
        [_nickNameTF setTextAlignment:NSTextAlignmentCenter];
        _nickNameTF.layer.cornerRadius = 5;
        _nickNameTF.layer.borderWidth = 2;
        _nickNameTF.layer.borderColor = [UIColor blackColor].CGColor;
        [_nickNameTF setDelegate:self];
    }
    return _nickNameTF;
}

-(UITextField *)emailTF {
    if(!_emailTF) {
        _emailTF = [[UITextField alloc] init];
        [_emailTF setPlaceholder:@"Email"];
        [_emailTF setBackgroundColor:[UIColor whiteColor]];
        [_emailTF setTextAlignment:NSTextAlignmentCenter];
        _emailTF.layer.cornerRadius = 5;
        _emailTF.layer.borderWidth = 2;
        _emailTF.layer.borderColor = [UIColor blackColor].CGColor;
        [_emailTF setKeyboardType:UIKeyboardTypeEmailAddress];
        [_emailTF setDelegate:self];
    }
    return _emailTF;
}

-(UITextField *)passwordTF {
    if(!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        [_passwordTF setPlaceholder:@"Password"];
        [_passwordTF setBackgroundColor:[UIColor whiteColor]];
        [_passwordTF setTextAlignment:NSTextAlignmentCenter];
        _passwordTF.layer.cornerRadius = 5;
        _passwordTF.layer.borderWidth = 2;
        _passwordTF.layer.borderColor = [UIColor blackColor].CGColor;
        [_passwordTF setSecureTextEntry:YES];
        [_passwordTF setDelegate:self];
    }
    return _passwordTF;
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - layout

-(void)viewDidLayoutSubviews {
    [_emailTF setFrame:CGRectMake(35, screenHeight/2 - _emailTF.frame.size.height, screenWidth - 70, 50)];
    [_nickNameTF setFrame:CGRectMake(35, _emailTF.frame.origin.y - _emailTF.frame.size.height -10, screenWidth - 70, 50)];
    [_passwordTF setFrame:CGRectMake(35, CGRectGetMaxY(_emailTF.frame) + 10, screenWidth - 70, 50)];
}

@end
