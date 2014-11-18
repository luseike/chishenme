//
//  JYLComposePhotosView.h
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYLComposePhotosView : UIView
/**
 *  添加一张图片到相册内部
 */
-(void)addImage:(UIImage *)image;

-(NSArray *)images;

-(void)removeAllPhotos;
@end
