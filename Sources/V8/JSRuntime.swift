import CV8
import Platform

public class JSRuntime {
    let platform: UnsafeMutableRawPointer
    let isolate: UnsafeMutableRawPointer

    public static var global: JSRuntime = {
        return JSRuntime()
    }()

    public required init() {
        // used to load snapshot_blob, natives_blob, icudtl.dat
        let libsPath = Environment["NODE_PATH"] ?? "/usr/local/lib/"
        self.platform = initialize(libsPath)
        self.isolate = createIsolate()
    }

    deinit {
        disposeIsolate(isolate)
        dispose(platform)
    }
}

extension V8.JSContext {
    public convenience init(_ runtime: JSRuntime = JSRuntime.global) {
        self.init(isolate: runtime.isolate)
    }
}

extension JSRuntime: JavaScript.JSRuntime {
    public func createContext() -> V8.JSContext {
        return JSContext()
    }
}
