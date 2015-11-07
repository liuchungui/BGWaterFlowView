//
//  Common.h
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#ifndef Common_h
#define Common_h
typedef struct BGEdgeInsets {
    CGFloat top, left, bottom, right;
} BGEdgeInsets;

UIKIT_STATIC_INLINE BGEdgeInsets BGEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    BGEdgeInsets insets = {top, left, bottom, right};
    return insets;
}

//color
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//system
#define bScreenWidth [UIScreen mainScreen].bounds.size.width
#define bScreenHeight [UIScreen mainScreen].bounds.size.height

//user
#define CHANGE_MODEL 1

#endif /* Common_h */
