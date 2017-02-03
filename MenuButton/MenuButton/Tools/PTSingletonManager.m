//
//  PTSingletonManager.m
//  MenuButton
//
//  Created by xiangronghua on 2017/2/3.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

#import "PTSingletonManager.h"

@implementation PTSingletonManager

+ (PTSingletonManager *)shareInstance {
    static PTSingletonManager *singletonManager = nil;
    @synchronized (self) {
        if (!singletonManager) {
            singletonManager = [[PTSingletonManager alloc] init];
        }
    }
    return singletonManager;
}

@end
