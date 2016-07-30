

#import <UIKit/UIKit.h>


typedef void(^XJGestureBlock) (id);
@interface UIGestureRecognizer (block)
//@property(nonatomic, copy)XJGestureBlock block;

+(instancetype)xjg_gestureRecognizerWithActionBlcok:(XJGestureBlock)block;
@end
