//
//  WAErrorCell.m
//  Wolfram
//
//  Created by Alex Nichol on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAErrorCell.h"

@implementation WAErrorCell

- (id)initWithEventManager:(WAEventManager *)manager error:(NSString *)error {
    if ((self = [super initWithEventManager:manager title:@"Error"])) {
        errorMessage = error;
        
        CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), 12, NULL);
        drawString = CFAttributedStringCreateMutable(NULL, 0);
        CFAttributedStringReplaceString(drawString, CFRangeMake(0, 0), (__bridge CFStringRef)error);
        CFAttributedStringSetAttribute(drawString, CFRangeMake(0, [error length]),
                                       kCTFontAttributeName, font);
        CFRelease(font);
        
        // set the string's line spacing and line break
        CTLineBreakMode breakMode = kCTLineBreakByWordWrapping;
        
        struct CTParagraphStyleSetting breakSetting;
        breakSetting.spec = kCTParagraphStyleSpecifierLineBreakMode;
        breakSetting.valueSize = sizeof(breakMode);
        breakSetting.value = &breakMode;
        struct CTParagraphStyleSetting settings[1] = {
            breakSetting
        };
        
        CTParagraphStyleRef pStyle = CTParagraphStyleCreate(settings, 1);
        CFAttributedStringSetAttribute(drawString, CFRangeMake(0, [error length]),
                                       kCTParagraphStyleAttributeName, pStyle);
        CFRelease(pStyle);
    }
    return self;
}

- (void)resizeToWidth:(CGFloat)width {
    CGFloat height = CFAttributedStringDrawHeight(drawString, width - 20, NULL);
    NSRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height + 20;
    self.frame = frame;
}

- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, NSMakeRect(10, 7, self.frame.size.width - 20, self.frame.size.height - 14));
    
    ANTextFrame * frame = [[ANTextFrame alloc] initWithAttributedString:drawString
                                                                context:context path:path];
    CGContextSetTextPosition(context, 10, 7);
    [frame draw];
}

- (void)dealloc {
    CFRelease(drawString);
}

@end
