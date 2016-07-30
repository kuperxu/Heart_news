



#import "UIGestureRecognizer+block.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const int target_key;

@implementation UIGestureRecognizer (block)


+(instancetype)xjg_gestureRecognizerWithActionBlcok:(XJGestureBlock)block{
    return [[self alloc]initWithActionBlock:block];
}

-(instancetype)initWithActionBlock:(XJGestureBlock)block{
    self = [self init];
    [self addActionBlcok:block];
    [self addTarget:self action:@selector(invoke:)];
    return self;
}

- (void)addActionBlcok:(XJGestureBlock)block{
    if(block){
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)invoke:(id)sender{
    XJGestureBlock block=objc_getAssociatedObject(self, &target_key);
    if(block)
        block(sender);
}

@end
