//
//  JYLTextView.m
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import "JYLTextView.h"
#import "UIView+Extension.h"

@interface JYLTextView()<UITextViewDelegate>
@property(nonatomic,weak) UILabel *placehoderLabel;
@end

@implementation JYLTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        //添加一个显示提示文字的label
        UILabel *placehoderLabel=[[UILabel alloc] init];
        placehoderLabel.numberOfLines=0;
        placehoderLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placehoderLabel=placehoderLabel;
        
        self.placehoderColor=[UIColor lightGrayColor];
        //self.
        //监听内部文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textDidChange{
    self.placehoderLabel.hidden=(self.text.length!=0);
}

#pragma mark - 内部设置
-(void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

-(void)setPlacehoder:(NSString *)placehoder{
    _placehoder=[placehoder copy];
    self.placehoderLabel.text=placehoder;
    [self setNeedsLayout];
}
-(void)setPlacehoderColor:(UIColor *)placehoderColor{
    _placehoderColor=placehoderColor;
    self.placehoderLabel.textColor=placehoderColor;
}
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placehoderLabel.font=font;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.placehoderLabel.y=8;
    self.placehoderLabel.x=5;
    self.placehoderLabel.width=self.width-2*self.placehoderLabel.x;
    //根据文字计算label的高度
    CGSize maxSize=CGSizeMake(self.placehoderLabel.width, MAXFLOAT);
    CGSize placehoderSize=[self.placehoder sizeWithFont:self.placehoderLabel.font];
    self.placehoderLabel.height=placehoderSize.height;
}

@end
