use "collections"

actor Counter
  var _count: U32

  new create() => _count = 0

  new init(count: U32) => _count = count

  fun ref doincrement() =>
    _count = _count + 1

  be increment() => 
    doincrement()

  be incrementWithOut(main: Main) =>
    main.displayWithMessage(_count, "increment")
    doincrement()

  be get_and_reset(main: Main) =>
    main.display(_count)
    _count = 0

actor Main
  var _env: Env

  new create(env: Env) =>
    _env = env

    var initial: U32 = try env.args(1).u32() else 0 end
    var count: U32 = try env.args(2).u32() else 10 end
    var counter = Counter.init(initial)

    env.out.print("Hello, counter!")

    for i in Range[U32](0, count) do
      counter.incrementWithOut(this)
    end

    counter.get_and_reset(this)

  be display(result: U32) =>
    _env.out.print(result.string())

  be displayWithMessage(result: U32, message: String) =>
    _env.out.print(message + " " + result.string())
