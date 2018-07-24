//
//  History.m
//  ConvertProject
//
//  Created by Trung Kiên on 7/23/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "History.h"

@implementation History
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.table  forKey:@"table"];
    [encoder encodeObject:self.price forKey:@"price"];
    
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.date = [decoder decodeObjectForKey:@"date"];
    self.table = [decoder decodeObjectForKey:@"table"];
    self.price = [decoder decodeObjectForKey:@"price"];
    return self;
}
@end
