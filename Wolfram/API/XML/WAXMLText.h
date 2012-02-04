//
//  WAXMLText.h
//  Wolfram
//
//  Created by Alex Nichol on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WAXMLElement.h"

@interface WAXMLText : WAXMLElement {
    NSString * text;
}

@property (nonatomic, retain) NSString * text;

- (id)initWithText:(NSString *)theText;

@end
