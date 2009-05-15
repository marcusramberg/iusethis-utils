//
//  iusethisAction.m
//  iusethis
//
//  Created by Marcus Ramberg on 15.05.09.
//  Copyright Nordaaker Ltd 2009. All rights reserved.
//

#import "iusethisAction.h"

@implementation iusethisAction

- (QSObject *)openHomepageForApplication:(QSObject *)dObject{
   
    NSString *shortName=[self applicationShortName: [dObject stringValue]];
    NSWorkspace *ws=[NSWorkspace sharedWorkspace];
    [ws openURL: [NSURL URLWithString: [ NSString stringWithFormat: @"http://osx.iusethis.com/hp/%@",shortName ]]];
	return nil;
}

- (QSObject *)downloadLatestForApplication:(QSObject *)dObject{
    
    NSString *shortName=[self applicationShortName: [dObject stringValue]];
    NSWorkspace *ws=[NSWorkspace sharedWorkspace];
    [ws openURL: [NSURL URLWithString: [ NSString stringWithFormat: @"http://osx.iusethis.com/dl/%@",shortName ]]];
	return nil;
}

- (QSObject *)showIutProfileForApplication:(QSObject *)dObject{
    NSString *shortName=[self applicationShortName: [dObject stringValue]];
    NSWorkspace *ws=[NSWorkspace sharedWorkspace];
    [ws openURL: [NSURL URLWithString: [ NSString stringWithFormat: @"http://osx.iusethis.com/app/%@",shortName ]]];
	return nil;
}

     
- (NSString *)applicationShortName:(NSString *)name {
    if (!name)
        return nil;
    
    static NSMutableCharacterSet *allowedCharacters = nil;
    if (!allowedCharacters) {
        allowedCharacters = [[NSMutableCharacterSet alphanumericCharacterSet] retain];
        [allowedCharacters addCharactersInString:@"-_@"];
    }
    
    NSMutableString *mname = [NSMutableString stringWithString:name];
    int i;
    for (i = 0; i < [mname length]; i++) {
        if ([allowedCharacters characterIsMember:[mname characterAtIndex:i]])
            continue;               
        [mname replaceCharactersInRange:NSMakeRange(i--, 1) withString:@""];
    }
    name = [mname lowercaseString];
    
    // there is a length limitation for iusethis ids:
    // | short       | varchar(30) | YES  | UNI | NULL    |                |
    if ([name length] > 30)
        return [name substringToIndex:30];
    
    return name;
}

@end
