//
//  CSConfigMacros.h
//  CSMBP
//
//  Created by liluoxing on 8/2/16.
//  Copyright © 2016 China Southern Airlines. All rights reserved.
//

#ifndef CSConfigMacros_h
#define CSConfigMacros_h

// block self
#define BlockWeakObject(o) __typeof(o) __weak
#define BlockWeakSelf BlockWeakObject(self)


#ifdef DEBUG
#define CS_KeyPath(Classname, keypath) ({\
Classname *_cs_keypath_obj; \
__unused __typeof(_cs_keypath_obj.keypath) _cs_keypath_prop; \
@#keypath; \
})

#define CS_Obj_KeyPath(object, keypath) ({\
__typeof(object) _cs_keypath_obj; \
__unused __typeof(_cs_keypath_obj.keypath) _cs_keypath_prop; \
@#keypath; \
})

#define CS_Protocol_KeyPath(ProtocolName, keypath) ({\
id<ProtocolName> _cs_keypath_obj; \
__unused __typeof(_cs_keypath_obj.keypath) _cs_keypath_prop; \
@#keypath; \
})
#else
#define CS_KeyPath(Classname, keypath) (@#keypath)
#define CS_Obj_KeyPath(self, keypath) (@#keypath)
#define CS_Protocol_KeyPath(ProtocolName, keypath) (@#keypath)
#endif

//取消performSelector编译警告的宏
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* CSConfigMacros_h */
