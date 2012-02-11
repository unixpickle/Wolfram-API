//
//  WAImage.h
//  Wolfram
//
//  Created by Alex Nichol on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAXMLDocument.h"

@interface WAImage : NSObject {
    CGSize size;
    NSURL * imageURL;
}

@property (readonly) CGSize size;
@property (readonly) NSURL * imageURL;

- (id)initWithElement:(WAXMLNode *)node;

@end
