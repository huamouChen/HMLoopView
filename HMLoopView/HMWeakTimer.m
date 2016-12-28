//
//  HMWeakTimer.m
//  MedicalConsult
//
//  Created by minstone on 16/7/21.
//  Copyright © 2016年 minstone. All rights reserved.
//

#import "HMWeakTimer.h"


@interface HMWeakTimer ()
@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;
@end

@implementation HMWeakTimer
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    HMWeakTimer *weakTimer = [[HMWeakTimer alloc] init];
    weakTimer.target = aTarget;
    weakTimer.selector = aSelector;
    return  [NSTimer scheduledTimerWithTimeInterval:ti target:weakTimer selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
}

///
- (void)fire:(id)obj {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:obj];
#pragma clang diagnostic pop
}

@end
