//
//  UIButton+Flip.m
//  WK
//
//  Created by Wei, Chengjiong on 8/24/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "UIButton+Flip.h"
#import <objc/runtime.h>



static char UIButtonFlipBlockKey;
static char UIButtonFlipAltButtonKey;
static char UIButtonFlipTransitionKey;
static char UIButtonFlipContainerViewKey;

typedef void (^UIButtonFlipActionBlock)(id sender);



@implementation UIButton (Flip)

- (void)flipButtonHandleControlEvent:(UIControlEvents)event
                            withBlock:(UIButtonFlipActionBlock)block
{
    objc_setAssociatedObject(self, &UIButtonFlipBlockKey, block, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(flipButtonCallFlipBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)flipButtonCallFlipBlock:(id)sender
{
    UIButtonFlipActionBlock block = objc_getAssociatedObject(self, &UIButtonFlipBlockKey);
    if (block) {
        block(sender);
    }
}

+ (UIButtonFlipActionBlock)getFlipButtonActionWithAnimationCurve:(UIViewAnimationCurve)curve
                                                        duration:(NSTimeInterval)duration
                                                          target:(id)target
                                                        selector:(SEL)selector
{
    UIButtonFlipActionBlock flipButtonAction = ^(id sender) {
        
        // get the alternate button & container
        UIButton *otherButton = (UIButton *)objc_getAssociatedObject(sender, &UIButtonFlipAltButtonKey);
        UIView *container = (UIView *)objc_getAssociatedObject(sender, &UIButtonFlipContainerViewKey);
        
        // figure out our transition
        NSNumber *transitionNumber = (NSNumber *)objc_getAssociatedObject(sender, &UIButtonFlipTransitionKey);
        UIViewAnimationTransition transition = (UIViewAnimationTransition)[transitionNumber intValue];
        
        [UIView animateWithDuration:duration animations:^ {
            
            [UIView setAnimationTransition:transition forView:container cache:YES];
            [UIView setAnimationCurve:curve];
            
            // the view has the last retain count on the sender button, so we need to retain it first
            objc_setAssociatedObject(otherButton, &UIButtonFlipAltButtonKey, sender, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            // change button
            [sender removeFromSuperview];
            [container addSubview:otherButton];
            
            // sender no longer needs to retain the other button, because the view now is...
            objc_setAssociatedObject(sender, &UIButtonFlipAltButtonKey, otherButton, OBJC_ASSOCIATION_ASSIGN);
            
        }];
        
        // call the original button handler
        SuppressPerformSelectorLeakWarning([target performSelector:selector withObject:self]);
    };
    return [flipButtonAction copy];
}

+ (UIView *)containerWithFirstButton:(UIButton *)firstButton
                        secondButton:(UIButton *)secondButton
                     firstTransition:(UIViewAnimationTransition)firstTransition
                    secondTransition:(UIViewAnimationTransition)secondTransition
{
    UIView *container = [[UIView alloc] initWithFrame:firstButton.bounds];
    [container addSubview:firstButton];
    
    // record state so the flip action works properly
    objc_setAssociatedObject(firstButton, &UIButtonFlipAltButtonKey, secondButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(firstButton, &UIButtonFlipTransitionKey, [NSNumber numberWithInt:firstTransition], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(firstButton, &UIButtonFlipContainerViewKey, container, OBJC_ASSOCIATION_ASSIGN);
    // button1 is in charge of the retains initially
    objc_setAssociatedObject(secondButton, &UIButtonFlipAltButtonKey, firstButton, OBJC_ASSOCIATION_ASSIGN); 
    objc_setAssociatedObject(secondButton, &UIButtonFlipTransitionKey, [NSNumber numberWithInt:secondTransition], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(secondButton, &UIButtonFlipContainerViewKey, container, OBJC_ASSOCIATION_ASSIGN);
    
    return container;
}

+ (UIView *)flipButtonWithFirstImage:(UIImage *)firstImage
                         secondImage:(UIImage *)secondImage
                     firstTransition:(UIViewAnimationTransition)firstTransition
                    secondTransition:(UIViewAnimationTransition)secondTransition
                      animationCurve:(UIViewAnimationCurve)curve
                            duration:(NSTimeInterval)duration
                              target:(id)target
                            selector:(SEL)selector
{
    UIButtonFlipActionBlock flipButtonAction = [self getFlipButtonActionWithAnimationCurve:curve
                                                                                  duration:duration
                                                                                    target:target
                                                                                  selector:selector];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:firstImage forState:UIControlStateNormal];
    [button1 flipButtonHandleControlEvent:UIControlEventTouchUpInside withBlock:flipButtonAction];
    [button1 setFrame:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:secondImage forState:UIControlStateNormal];
    [button2 flipButtonHandleControlEvent:UIControlEventTouchUpInside withBlock:flipButtonAction];
    [button2 setFrame:CGRectMake(0, 0, secondImage.size.width, secondImage.size.height)];
    
    UIView *container = [self containerWithFirstButton:button1
                                          secondButton:button2
                                       firstTransition:firstTransition
                                      secondTransition:secondTransition];
    
    return container;
}

+ (UIView *)flipButtonWithBackgroundImage:(UIImage *)backgroundImage
                               firstTitle:(NSString *)firstTitle
                              secondTitle:(NSString *)secondTitle
                          firstTransition:(UIViewAnimationTransition)firstTransition
                         secondTransition:(UIViewAnimationTransition)secondTransition
                           animationCurve:(UIViewAnimationCurve)curve
                                 duration:(NSTimeInterval)duration
                                   target:(id)target
                                 selector:(SEL)selector
{
    UIButtonFlipActionBlock flipButtonAction = [self getFlipButtonActionWithAnimationCurve:curve
                                                                                  duration:duration
                                                                                    target:target
                                                                                  selector:selector];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:firstTitle forState:UIControlStateNormal];
    [button1.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:13]];
    [button1 setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button1 flipButtonHandleControlEvent:UIControlEventTouchUpInside withBlock:flipButtonAction];
    [button1 setFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:secondTitle forState:UIControlStateNormal];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:13]];
    [button2 setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button2 flipButtonHandleControlEvent:UIControlEventTouchUpInside withBlock:flipButtonAction];
    [button2 setFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    UIView *container = [self containerWithFirstButton:button1
                                          secondButton:button2
                                       firstTransition:firstTransition
                                      secondTransition:secondTransition];
    
    return container;
}

@end
