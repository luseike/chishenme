//
//  JYLComposeToolbar.m
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import "JYLComposeToolbar.h"
#import "UIView+Extension.h"

@implementation JYLComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        //添加所有的子控件
        [self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" tag:JYLComposeToolbarButtonTypeCamera];
        [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:JYLComposeToolbarButtonTypePicture];
        [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:JYLComposeToolbarButtonTypeMention];
        [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:JYLComposeToolbarButtonTypeTopic];
        //self.emotionButton =
        [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:JYLComposeToolbarButtonTypeEmotion];
    }
    return self;
}

-(UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(JYLComposeToolbarButtonType)tag{
    UIButton *button=[[UIButton alloc] init];
    button.tag=tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
    return button;
}

-(void)buttonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:button.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    int count=self.subviews.count;
    CGFloat buttonW=self.width/count;
    CGFloat buttonH=self.height;
    for (int i=0; i<count; i++) {
        UIButton *button=self.subviews[i];
        button.y=0;
        button.width=buttonW;
        button.height=buttonH;
        button.x=i*buttonW;
    }
}

@end
