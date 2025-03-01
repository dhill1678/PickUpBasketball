//
//  IQToolbar.m
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "IQToolbar.h"
#import "IQKeyboardManagerConstantsInternal.h"
#import "IQTitleBarButtonItem.h"
#import "IQUIView+Hierarchy.h"

#import <UIKit/UIViewController.h>

@implementation IQToolbar
@synthesize titleFont = _titleFont;

-(void)initialize
{
    [self sizeToFit];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
     if (IQ_IS_IOS7_OR_GREATER)
    {
        [self setTintColor:[UIColor blackColor]];
    }
    else
    {
        [self setBarStyle:UIBarStyleBlackTranslucent];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialize];
    }
    return self;
}


//-(CGSize)sizeThatFits:(CGSize)size
//{
//    CGSize sizeThatFit = [super sizeThatFits:size];
//
//    UIView *view = [[self viewController] view];
//    
//    if (view)
//    {
//        //Issue #52 fix
//        sizeThatFit.width = [view width];
//    }
//    
//    return sizeThatFit;
//}

//To resize IQToolbar on device rotation.
//- (void) layoutSubviews
//{
//    [super layoutSubviews];
//    CGRect origFrame = self.frame;
//    [self sizeToFit];
//    CGRect newFrame = self.frame;
//    newFrame.origin.y += origFrame.size.height - newFrame.size.height;
//    self.frame = newFrame;
//}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];

    for (UIBarButtonItem *item in self.items)
    {
        [item setTintColor:tintColor];
    }
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    for (UIBarButtonItem *item in self.items)
    {
        if ([item isKindOfClass:[IQTitleBarButtonItem class]])
        {
            [(IQTitleBarButtonItem*)item setFont:titleFont];
        }
    }
}


#pragma mark - UIInputViewAudioFeedback delegate
- (BOOL) enableInputClicksWhenVisible
{
	return YES;
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
