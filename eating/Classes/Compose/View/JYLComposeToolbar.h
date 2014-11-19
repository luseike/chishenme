//
//  JYLComposeToolbar.h
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JYLComposeToolbarButtonTypeCamera,
    JYLComposeToolbarButtonTypePicture,
    JYLComposeToolbarButtonTypeMention,
    JYLComposeToolbarButtonTypeTopic,
    JYLComposeToolbarButtonTypeEmotion,
    JYLComposeToolbarButtonTypeAddr,
    JYLComposeToolbarButtonTypeShareLimit
}JYLComposeToolbarButtonType;

@class JYLComposeToolbar;

@protocol JYLComposeToolbarDelegate <NSObject>

-(void)composeTool:(JYLComposeToolbar *)toolBar didClickedButton:(JYLComposeToolbarButtonType)buttonType;

@end

@interface JYLComposeToolbar : UIView
@property(nonatomic,weak) id<JYLComposeToolbarDelegate> delegate;


@end
