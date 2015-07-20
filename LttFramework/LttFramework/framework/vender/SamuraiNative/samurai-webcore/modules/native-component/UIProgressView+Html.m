//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "UIProgressView+Html.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlRenderScope.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIProgressView(Html)

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Element;
}

#pragma mark -

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	NSString * isBar = [dom.attributes objectForKey:@"is-bar"];

	if ( isBar )
	{
		self.progressViewStyle = UIProgressViewStyleBar;
	}
	else
	{
		self.progressViewStyle = UIProgressViewStyleDefault;
	}
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[super html_applyStyle:style];

	self.progressTintColor = [style computeColor:self.progressTintColor];
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

#pragma mark -

- (id)html_serialize
{
	return [super html_serialize];
}

- (void)html_unserialize:(id)obj
{
	[super html_unserialize:obj];
}

- (void)html_zerolize
{
	[super html_zerolize];
}

#pragma mark -

- (void)html_forView:(UIView *)hostView
{
	if ( [hostView isKindOfClass:[UIScrollView class]] )
	{
		[hostView addObserver:self
				   forKeyPath:@"contentOffset"
					  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
					  context:(void *)hostView];
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//	NSObject * oldValue = [change objectForKey:@"old"];
	NSObject * newValue = [change objectForKey:@"new"];
	
	if ( newValue )
	{
		UIView * hostView = (__bridge UIView *)(context);
		
		if ( [hostView isKindOfClass:[UIScrollView class]] )
		{
			UIScrollView * scrollView = (UIScrollView *)hostView;
			
			if ( NO == CGSizeEqualToSize( scrollView.contentSize, CGSizeZero ) )
			{
				CGFloat width = 0;
				CGFloat offset = 0;
				
				CGFloat contentWidth = scrollView.contentSize.width;
				CGFloat contentHeight = scrollView.contentSize.height;
				
				CGFloat frameWidth = scrollView.frame.size.width;
				CGFloat frameHeight = scrollView.frame.size.height;
				
				if ( contentWidth > frameWidth && contentHeight <= frameHeight )
				{
					// horizontal
					
					width	= contentWidth - frameWidth;
					offset	= scrollView.contentOffset.x;
				}
				else if ( contentHeight > frameHeight && contentWidth <= frameWidth )
				{
					// vertical
					
					width	= contentHeight - frameHeight;
					offset	= scrollView.contentOffset.y;
				}
				else
				{
					width	= 0.0f;
					offset	= 0.0f;
				}
				
				[self setProgress:(offset / width) animated:YES];
			}
			else
			{
				[self setProgress:0.0f animated:YES];
			}
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, UIProgressView_Html )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
