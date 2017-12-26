//
//  CModuleManager.h
//  CApplication
//
//  Created by 张九州 on 2017/12/22.
//

#import <Foundation/Foundation.h>

#define CExportModule(p) \
+ (void)load { \
    [[CModuleManager sharedManager] registerModuleWithProtocol:@protocol(p) class:[self class]]; \
}
#define CModule(p) [[CModuleManager sharedManager] moduleWithProtocol:@protocol(p)]

@interface CModuleManager : NSObject

+ (instancetype)sharedManager;

- (void)registerModuleWithProtocol:(Protocol *)protocol block:(id (^)(void))block;
- (void)registerModuleWithProtocol:(Protocol *)protocol class:(Class)klass;
- (void)registerModuleWithProtocol:(Protocol *)protocol object:(id)object;
- (id)moduleWithProtocol:(Protocol *)protocol;

@end
