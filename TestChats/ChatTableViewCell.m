//
//  ChatTableViewCell.m
//  TestChats
//
//  Created by Антон Дитятив on 21.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.textView];
    }
    return self;
}

-(UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    }
    return _nameLabel;
}

-(UITextView *)textView {
    if(!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(110, 0, screenWidth - 110, 44)];
        [_textView setEditable:NO];
    }
    return _textView;
}

- (CGSize)sizeThatFits:(CGSize)size;
{
    CGSize textViewSize = _textView.bounds.size;
    CGSize fitTextViewSize = CGSizeMake(textViewSize.width, size.height);
    CGSize sizeThatFitsSize = [self.textView sizeThatFits:fitTextViewSize];
    
    CGSize superSize = [super sizeThatFits:size];
    
    sizeThatFitsSize.height = MAX(superSize.height, sizeThatFitsSize.height);
    sizeThatFitsSize.width = superSize.width;
    
    return sizeThatFitsSize;
}

@end
