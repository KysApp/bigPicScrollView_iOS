//
//  UIView+UserData.m
//  MaiXiLP
//
//  Created by yangyanxiang on 15/12/17.
//  Copyright © 2015年 KYS. All rights reserved.
//

#import "UIView+UserData.h"
#import <objc/runtime.h>
static const void *OBJECT_OBJ = &OBJECT_OBJ;
@implementation UIView (UserData)
@dynamic _userDate;

-(NSObject*) _userDate{
    return objc_getAssociatedObject(self, OBJECT_OBJ);
}

-(void)set_userDate:(NSObject *)_userDate{
    objc_setAssociatedObject(self, OBJECT_OBJ, _userDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint * constraint = [self constraintForAttribute:attribute];
    if(constraint)
    {
        [constraint setConstant:constant];
        return YES;
    }else
    {
        [self.superview addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:constant]];
        return NO;
    }
}


- (CGFloat) constraintConstantforAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint * constraint = [self constraintForAttribute:attribute];
    
    if (constraint) {
        return constraint.constant;
    }else
    {
        return NAN;
    }
    
}


- (NSLayoutConstraint*) constraintForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@", attribute, self];
    NSArray *fillteredArray = [[self.superview constraints] filteredArrayUsingPredicate:predicate];
    if(fillteredArray.count == 0)
    {
        return nil;
    }else
    {
        return fillteredArray.firstObject;
    }
}


- (void)hideByHeight:(BOOL)hidden
{
    [self hideView:hidden byAttribute:NSLayoutAttributeHeight];
}


- (void)hideByWidth:(BOOL)hidden
{
    [self hideView:hidden byAttribute:NSLayoutAttributeWidth];
}



- (void)hideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute
{
    if (self.hidden != hidden) {
        CGFloat constraintConstant = [self constraintConstantforAttribute:attribute];
        
        if (hidden)
        {
            
            if (!isnan(constraintConstant)) {
                self.alpha = constraintConstant;
            }else
            {
                CGSize size = [self getSize];
                self.alpha = (attribute == NSLayoutAttributeHeight)?size.height:size.width;
            }
            
            [self setConstraintConstant:0 forAttribute:attribute];
            self.hidden = YES;
            
        }else
        {
            if (!isnan(constraintConstant) ) {
                self.hidden = NO;
                [self setConstraintConstant:self.alpha forAttribute:attribute];
                self.alpha = 1;
            }
        }
    }
}


- (CGSize) getSize
{
    [self updateSizes];
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

- (void)updateSizes
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)sizeToSubviews
{
    [self updateSizes];
    CGSize fittingSize = [self systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, 320, fittingSize.height);
}

@end
