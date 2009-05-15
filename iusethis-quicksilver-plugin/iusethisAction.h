//
//  iusethisAction.h
//  iusethis
//
//  Created by Marcus Ramberg on 15.05.09.
//  Copyright Nordaaker Ltd 2009. All rights reserved.
//

#import <QSCore/QSObject.h>
#import <QSCore/QSActionProvider.h>
#import "iusethisAction.h"

#define kiusethisAction @"iusethisAction"

@interface iusethisAction : QSActionProvider
{
}

- (QSObject *)openHomepageForApplication:(QSObject *)dObject;
- (QSObject *)downloadLatestForApplication:(QSObject *)dObject;
- (NSString *)applicationShortName: (NSString *)name;
- (QSObject *)showIutProfileForApplication:(QSObject *)dObject;

@end

