//
//  WAViewItem.m
//  Wolfram
//
//  Created by Alex Nichol on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Drawing/UI code taken from ABCleaner: http://github.com/unixpickle/ABCleaner
//

#import "WAViewItem.h"

@interface WAViewItem (Private)

- (void)drawExpanded:(CGContextRef)context;
- (void)drawCollapsed:(CGContextRef)context;
- (void)drawTitleAtPoint:(CGPoint)point;

@end

@implementation WAViewItem

@synthesize itemCell;

#pragma mark - Properties -

- (WAEventManager *)eventManager {
    return eventManager;
}

- (void)setEventManager:(WAEventManager *)manager {
    eventManager = manager;
    itemCell.eventManager = manager;
}

- (BOOL)isFocused {
    return focused;
}

- (BOOL)isHighlighted {
    return highlighted;
}

- (void)setFocused:(BOOL)flag {
    focused = flag;
    [self setNeedsDisplay:YES];
}

- (void)setHighlighted:(BOOL)flag {
    highlighted = flag;
    [self setNeedsDisplay:YES];
}

#pragma mark - View Management -

- (id)initWithItemCell:(WAViewItemCell *)theCell {
    NSRect frame = NSMakeRect(0, 0, theCell.frame.size.width + 2,
                              kTitleHeight + 3 + theCell.frame.size.height);
    if ((self = [super initWithFrame:frame])) {
        focused = YES;
        itemCell = theCell;
        eventManager = theCell.eventManager;
        
        [itemCell addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
        
        expandButton = [[NSButton alloc] initWithFrame:NSMakeRect(5, frame.size.height - (kTitleHeight / 2 + 8), 13, 13)];
        [expandButton setBezelStyle:NSDisclosureBezelStyle];
        [expandButton setButtonType:NSOnOffButton];
        [expandButton setTitle:@""];
        [expandButton setState:1];
        [expandButton setTarget:self];
        [expandButton setAction:@selector(expandCollapsePress:)];
        [self addSubview:expandButton];
        
        loadIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(frame.size.width - 26,
                                                                              frame.size.height - 20,
                                                                              16, 16)];
        [loadIndicator setControlSize:NSSmallControlSize];
        [loadIndicator setStyle:NSProgressIndicatorSpinningStyle];
        
        [self fitBoundsToWidth];
        [self observeValueForKeyPath:@"loading" ofObject:itemCell change:nil context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        if ([itemCell isLoading]) {
            [loadIndicator startAnimation:self];
            if (![loadIndicator superview]) {
                [self addSubview:loadIndicator];
            }
        } else {
            [loadIndicator stopAnimation:self];
            if ([loadIndicator superview]) {
                [loadIndicator removeFromSuperview];
            }
        }
    }
}

- (void)dealloc {
    [itemCell removeObserver:self forKeyPath:@"loading"];
}

#pragma mark Focus

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)becomeFirstResponder {
    highlighted = YES;
    [self setNeedsDisplay:YES];
    return YES;
}

- (BOOL)resignFirstResponder {
    highlighted = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    [[self window] makeFirstResponder:self];
}

#pragma mark Content

- (CGFloat)totalViewHeight {
    if ([expandButton state] == 0) {
        return kTitleHeight + 2;
    } else {
        return kTitleHeight + 3 + [itemCell frame].size.height;
    }
}

- (void)fitBoundsToWidth {
    if ([self isExpanded]) {
        [itemCell setFrameOrigin:NSMakePoint(1, 1)];
        [itemCell resizeToWidth:self.frame.size.width - 2];
        if (![itemCell superview]) {
            [self addSubview:itemCell];
        }
    } else {
        if ([itemCell superview]) {
            [itemCell removeFromSuperview];
        }
    }
    CGFloat height = [self totalViewHeight];
    [expandButton setFrame:NSMakeRect(5, height - (kTitleHeight / 2 + 8), 13, 13)];
    [loadIndicator setFrame:NSMakeRect(self.frame.size.width - 26, height - 20, 16, 16)];
    NSRect frame = [self frame];
    frame.size.height = height;
    [self setFrame:frame];
    [self setNeedsDisplay:YES];
}

#pragma mark Expand/Collapse

- (void)expandCollapsePress:(id)sender {
    [self setExpanded:[expandButton state]];
}

- (void)setExpanded:(BOOL)expanded {
    CGFloat oldHeight = self.frame.size.height;
    
    if (expanded) {
        [self layoutExpanded];
    } else {
        [self layoutCollapsed];
    }
    
    CGFloat newHeight = self.frame.size.height;
    NSNumber * delta = [NSNumber numberWithFloat:newHeight - oldHeight];
    
    WAEvent * event = [WAEvent eventWithType:WAEventTypeExpandCollapse sender:self
                                      object:delta forKey:kWAEventDeltaHeightUserInfoKey];
    [eventManager postEvent:event];
}

- (BOOL)isExpanded {
    return [expandButton state];
}

- (void)layoutExpanded {
    [self fitBoundsToWidth];
}

- (void)layoutCollapsed {
    [self fitBoundsToWidth];
}

#pragma mark - Drawing -

- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    if ([self isExpanded]) {
        [self drawExpanded:context];
    } else {
        [self drawCollapsed:context];
    }
}

- (void)drawExpanded:(CGContextRef)context {
    CGFloat topGradient = (focused ? 227.0 / 255.0 : 241.0 / 255.0);
    CGFloat bottomGradient = (focused ? 199.0 / 255.0 : 214.0 / 255.0);
    CGFloat borderColor = 153.0 / 255.0;
    CGFloat separatorColor = 168.0 / 255.0;
    
    CGRect frame = NSRectToCGRect(self.bounds);
    
    // create the gradient to be drawn as the background
    CGFloat colors[8] = {topGradient, 1, bottomGradient, 1};
    CGFloat locations[2] = {0, 1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
    CGColorSpaceRelease(colorSpace);
    
    // variables used for the path
    CGFloat minX = CGRectGetMinX(frame) + 1, minY = CGRectGetMinY(frame) + 1;
    CGFloat maxX = CGRectGetMaxX(frame) - 1, maxY = CGRectGetMaxY(frame) - 1;
    CGFloat cornerRadius = 7;
    
    // path covering the entire view (with rounded top corners)
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX + cornerRadius, maxY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, minX, maxY - cornerRadius, cornerRadius);
    CGPathAddLineToPoint(path, NULL, minX, minY);
    CGPathAddLineToPoint(path, NULL, maxX, minY);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, minX + cornerRadius, maxY, cornerRadius);
    
    // stroke the view's border
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextClosePath(context);
    if (!highlighted) {
        CGContextSetGrayStrokeColor(context, borderColor, 1);
    } else {
        CGContextSetRGBStrokeColor(context, 72.0 / 255.0, 139.0 / 255.0, 208.0 / 255.0, 1);
    }
    CGContextSetLineWidth(context, 2);
    CGContextStrokePath(context);
    
    // fill the view's content
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextSetGrayFillColor(context, 0.91, 1);
    CGContextFillRect(context, frame);
    CGContextRestoreGState(context);
    
    // draw the title gradient
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minX + cornerRadius, maxY);
    CGContextAddArcToPoint(context, minX, maxY, minX, maxY - cornerRadius, cornerRadius);
    CGContextAddLineToPoint(context, minX, maxY - kTitleHeight);
    CGContextAddLineToPoint(context, maxX, maxY - kTitleHeight);
    CGContextAddLineToPoint(context, maxX, maxY - cornerRadius);
    CGContextAddArcToPoint(context, maxX, maxY, minX + cornerRadius, maxY, cornerRadius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, maxY), CGPointMake(0, maxY - kTitleHeight), 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    // draw the title border
    CGPoint titleSeparatorPoints[] = {CGPointMake(minX, maxY - kTitleHeight - 0.5),
        CGPointMake(maxX, maxY - kTitleHeight - 0.5)};
    CGContextSetGrayStrokeColor(context, separatorColor, 1);
    CGContextSetLineWidth(context, 1);
    CGContextStrokeLineSegments(context, titleSeparatorPoints, 2);
    
    [self drawTitleAtPoint:CGPointMake(22, self.frame.size.height - (kTitleHeight / 2) - 8)];
}

- (void)drawCollapsed:(CGContextRef)context {
    CGFloat topGradient = (focused ? 227.0 / 255.0 : 241.0 / 255.0);
    CGFloat bottomGradient = (focused ? 199.0 / 255.0 : 214.0 / 255.0);
    CGFloat borderColor = 153.0 / 255.0;
    
    CGRect frame = NSRectToCGRect(self.bounds);
    
    // create the gradient to be drawn as the background
    CGFloat colors[8] = {topGradient, 1, bottomGradient, 1};
    CGFloat locations[2] = {0, 1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the path for the rounded corners
    CGFloat minX = CGRectGetMinX(frame) + 1, minY = CGRectGetMinY(frame) + 1;
    CGFloat maxX = CGRectGetMaxX(frame) - 1, maxY = CGRectGetMaxY(frame) - 1;
    
    CGFloat cornerRadius = 7;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX + cornerRadius, minY);
    CGPathAddArcToPoint(path, NULL, minX, minY, minX, maxY - cornerRadius, cornerRadius);
    CGPathAddArcToPoint(path, NULL, minX, maxY, maxX - cornerRadius, maxY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, minY + cornerRadius, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, minY, minX + cornerRadius, minY, cornerRadius);
    CGPathCloseSubpath(path);
    
    // stroke the border of the view
    if (!highlighted) {
        CGContextSetGrayStrokeColor(context, borderColor, 1);
    } else {
        CGContextSetRGBStrokeColor(context, 72.0 / 255.0, 139.0 / 255.0, 208.0 / 255.0, 1);
    }
    CGContextSetLineWidth(context, 2);
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    // fill the gradient background
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, frame.size.height - 1), CGPointMake(0, 1), 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
    
    [self drawTitleAtPoint:CGPointMake(22, self.frame.size.height - (kTitleHeight / 2) - 8)];
}

- (void)drawTitleAtPoint:(CGPoint)point {
    NSShadow * textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [NSColor whiteColor];
    textShadow.shadowOffset = NSMakeSize(0, -1);
    textShadow.shadowBlurRadius = 0.5;
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont boldSystemFontOfSize:11], NSFontAttributeName,
                                 textShadow, NSShadowAttributeName, 
                                 [NSColor colorWithDeviceWhite:0.224 alpha:1], NSForegroundColorAttributeName,
                                 nil];
    
    NSString * title = [itemCell title];
    NSAttributedString * aStr = [[NSAttributedString alloc] initWithString:title
                                                                attributes:attributes];
    CGFloat maxWidth = self.frame.size.width - 30;
    NSMutableString * modTitle = [title mutableCopy];
    while ([aStr size].width > maxWidth) {
        if ([modTitle length] > 0) {
            [modTitle deleteCharactersInRange:NSMakeRange([modTitle length] - 1, 1)];
        } else {
            break;
        }
        aStr = [[NSAttributedString alloc] initWithString:[modTitle stringByAppendingString:@"..."]
                                               attributes:attributes];
    }
    [aStr drawAtPoint:NSMakePoint(point.x, point.y)];
}

@end
