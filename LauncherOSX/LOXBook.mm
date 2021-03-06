//  Created by Boris Schneiderman.
//  Copyright (c) 2012-2013 The Readium Foundation.
//
//  The Readium SDK is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "LOXBook.h"
#import "LOXBookmark.h"

@interface LOXBook()

@property (retain, nonatomic, readwrite) NSArray *bookmarks;

@end

@implementation LOXBook {

    NSMutableArray *_bookmarks;
}

@synthesize name;
@synthesize filePath;
@synthesize bookmarks = _bookmarks;
@synthesize dateCreated;
@synthesize dateOpened;

+(id) bookFromDictionary:(NSDictionary *)dict
{
    LOXBook * book = [[[LOXBook alloc] init] autorelease];

    for(id key in dict.allKeys) {

        if([@"bookmarks" isEqualToString:key]) {

            for (NSDictionary * bmDict in dict[key]) {
                [book addBookmark:[LOXBookmark bookmarkFromDictionary:bmDict]];
            }

        }
        else {

            [book setValue:dict[key] forKey:key];
        }

    }

    return book;
}

-(NSDictionary *) toDictionary
{
    NSMutableArray *bookmarks = [NSMutableArray array];

    for (LOXBookmark *bookmark in self.bookmarks) {
        [bookmarks addObject:[bookmark toDictionary]];
    }

    return @{   @"filePath"       : self.filePath,
                @"packageId"      : self.packageId,
                @"name"           : self.name,
                @"dateCreated"    : self.dateCreated,
                @"dateOpened"     : self.dateOpened,
                @"bookmarks"      : bookmarks };
}

-(id)init
{
    self = [super init];
    if (self){

        self.name = @"";
        self.filePath = @"";
        self.bookmarks = [NSMutableArray array];
        self.dateCreated = [NSDate date];
        self.dateOpened = self.dateCreated;
    }

    return self;
}

-(void)addBookmark:(LOXBookmark *)bookmark
{
    bookmark.book = self;
    [_bookmarks addObject:bookmark];
}

- (void)dealloc
{
    [name release];
    [filePath release];
    [dateOpened release];
    [dateCreated release];
    [_bookmarks release];
    [super dealloc];
}

- (void)removeBookmark:(LOXBookmark *)bookmark
{
    [_bookmarks removeObject:bookmark];
}
@end
