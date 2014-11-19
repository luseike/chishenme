//
//  JYLComposeToolbar.m
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import "JYLComposeToolbar.h"
#import "UIView+Extension.h"

@interface JYLComposeToolbar()
@property(nonatomic,strong) UIView *composeItem;//发送选项（第二排的五个按钮）
@property(nonatomic,strong) UIView *composeSub;//发送子选项（显示地址和权限）
@end
@implementation JYLComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        UIView *composeSub=[[UIView alloc]init];
        self.composeSub=composeSub;
        [self addSubview:composeSub];
        
        UIView *composeItem=[[UIView alloc]init];
        self.composeItem.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        self.composeItem=composeItem;
        [self addSubview:composeItem];
        
   
        [self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" tag:JYLComposeToolbarButtonTypeCamera];
        [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:JYLComposeToolbarButtonTypePicture];
        [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:JYLComposeToolbarButtonTypeMention];
        [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:JYLComposeToolbarButtonTypeTopic];
        //self.emotionButton =
        [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:JYLComposeToolbarButtonTypeEmotion];
        
        [self addButtonWithIcon:@"near" title:@"中关村" tag:JYLComposeToolbarButtonTypeAddr];
        [self addButtonWithIcon:@"sharepublic" title:@"公开" tag:JYLComposeToolbarButtonTypeShareLimit];
        
    }
    return self;
}

-(UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(JYLComposeToolbarButtonType)tag{
    UIButton *button=[[UIButton alloc] init];
    button.tag=tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
   
    [self.composeItem addSubview:button];
    return button;
}

-(UIButton *)addButtonWithIcon:(NSString *)icon title:(NSString *)title tag:(JYLComposeToolbarButtonType)tag{
    UIButton *button=[[UIButton alloc] init];
    button.tag=tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
     [button setFont:[UIFont systemFontOfSize:12]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button.contentMode=UIViewContentModeCenter;
    [self.composeSub addSubview:button];
    return button;
}

-(void)buttonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:button.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.composeSub.frame=CGRectMake(0, 0, self.width, 20);
    UIButton *viewBtn1=[self.composeSub.subviews firstObject];
    viewBtn1.x=self.composeSub.x;
    viewBtn1.y=self.composeSub.y;
    viewBtn1.height=self.composeSub.height;
    viewBtn1.width=100;
//    viewBtn1.frame=CGRectMake(0, 0, 150, 15);
    
    UIButton *viewBtn2=[self.composeSub.subviews lastObject];
    viewBtn2.frame=CGRectMake(self.width-100, 0, 100, 15);
    
    self.composeItem.frame=CGRectMake(0, 20, self.width, 44);
    
    int count=(int)self.composeItem.subviews.count;
    CGFloat buttonW=self.width/count;
    CGFloat buttonH=self.height-20;
    for (int i=0; i<count; i++) {
        UIButton *button=self.composeItem.subviews[i];
        button.y=0;
        button.width=buttonW;
        button.height=buttonH;
        button.x=i*buttonW;
    }
}

@end
