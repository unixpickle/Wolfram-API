//
//  WAXMLElement.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WAXMLNode;

@interface WAXMLElement : NSObject {
    __weak WAXMLNode * parentElement;
}

@property (nonatomic, weak) WAXMLNode * parentElement;

@end
