//
//  WAPlainText.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAPlainText : NSObject {
    NSString * text;
}

@property (readonly) NSString * text;

- (id)initWithText:(NSString *)plainText;

@end
