//
//  DYFStoreConverter.m
//
//  Created by dyf on 2014/11/4.
//  Copyright © 2014 dyf. ( https://github.com/dgynfi/DYFStoreKit )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFStoreConverter.h"

@implementation DYFStoreConverter

+ (NSData *)encodeObject:(id)object {
    
    if (!object) { return nil; }
    
    if (@available(iOS 11.0, *)) {
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
        [archiver encodeObject:object];
        
        return archiver.encodedData;
    }
    
    return [NSKeyedArchiver archivedDataWithRootObject:object];
}

+ (id)decodeObject:(NSData *)data {
    
    if (!data) { return nil; }
    
    if (@available(iOS 11.0, *)) {
        
        NSError *error = nil;
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
        if (!error) {
            id object = [unarchiver decodeObject];
            [unarchiver finishDecoding];
            
            return object;
        }
        
        NSLog(@"[DYFStoreConverter decodeObject:] error: %@", error.localizedDescription);
        
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSData *)jsonWithObject:(id)obj {
    return [self jsonWithObject:obj options:kNilOptions];
}

+ (NSData *)jsonWithObject:(id)obj options:(NSJSONWritingOptions)options {
    
    if (!obj) { return nil; }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:options error:&error];
    if (!error) {
        return data;
    }
    
    NSLog(@"[NSJSONSerialization dataWithJSONObject:options:error:] error: %@", error.localizedDescription);
    
    return nil;
}

+ (NSString *)jsonStringWithObject:(id)obj {
    return [self jsonStringWithObject:obj options:kNilOptions];
}

+ (NSString *)jsonStringWithObject:(id)obj options:(NSJSONWritingOptions)options {
    NSData *data = [self jsonWithObject:obj options:options];
    
    if (!data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

+ (id)jsonObjectWithData:(NSData *)data {
    return [self jsonObjectWithData:data options:kNilOptions];
}

+ (id)jsonObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options {
    
    if (!data) { return nil; }
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
    if (!error) {
        return obj;
    }
    
    NSLog(@"[NSJSONSerialization JSONObjectWithData:options:error:] error: %@", error.localizedDescription);
    
    return nil;
}

+ (id)jsonObjectWithJSON:(NSString *)json {
    return [self jsonObjectWithJSON:json options:kNilOptions];
}

+ (id)jsonObjectWithJSON:(NSString *)json options:(NSJSONReadingOptions)options {
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) { return nil; }
    
    return [self jsonObjectWithData:data options:options];
}

@end