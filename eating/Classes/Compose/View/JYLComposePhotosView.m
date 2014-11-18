//
//  JYLComposePhotosView.m
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import "JYLComposePhotosView.h"
#import "UIView+Extension.h"

@implementation JYLComposePhotosView

-(void)addImage:(UIImage *)image{
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    imageView.image=image;
    [self addSubview:imageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    int count=self.subviews.count;
    int maxClosPerRow=4;
    CGFloat margin=10;
    CGFloat imageViewW=(self.width-(maxClosPerRow+1)*margin)/maxClosPerRow;
    CGFloat imageViewH=imageViewW;
    for (int i=0; i<count; i++) {
        int row=i/maxClosPerRow;
        int col=i%maxClosPerRow;
        
        UIImageView *imageView=self.subviews[i];
        imageView.width=imageViewW;
        imageView.height=imageViewH;
        imageView.x=col*(imageViewW+margin)+margin;
        imageView.y=row*(imageViewH+margin);
    }
}

-(NSArray *)images{
    NSMutableArray *array=[NSMutableArray array];
    for (UIImageView *imageView in self.subviews) {
        [array addObject:imageView.image];
    }
    return array;
}

@end
