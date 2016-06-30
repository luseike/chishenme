//
//  UIBarButtonItem+Extension.h
//  eating
//
//  Created by jyl on 14-11-17.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
@end
