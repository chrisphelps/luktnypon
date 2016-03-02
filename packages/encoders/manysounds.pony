primitive Neigh
  fun apply(): String => "Neigh"
primitive Whinny
  fun apply(): String => "Whinny"
primitive Chuff
  fun apply(): String => "Chuff"
primitive Groan
  fun apply(): String => "Groan"

type ManySounds is (Neigh | Whinny | Chuff | Groan)

primitive ManySoundsList
  fun tag apply(): Array[ManySounds] =>
    [Neigh, Whinny, Chuff, Groan]


primitive SoundEncoder
  fun doEncode(b: U8): String => 
    try ManySoundsList()(b.u64())() else "Barf" end

  fun encode(input: String): String =>
    var aggregator:String ref = recover String end

    for i in input.values() do
      let da: Array[U8] = [0,2,4,6]
      for d in da.values() do
        let b:U8 = (i and (0x03 << d)) >> d
        aggregator.append(doEncode(b) + " ") 
      end
    end
    aggregator.string()


actor Main
  new create(env: Env) =>
    try
      let inputString: String = env.args(1)
      env.out.print("Encoding: "+inputString)
      let r = SoundEncoder.encode(inputString)
      env.out.print("Result from fun was: " + r)
    else
      env.out.print("Why you no give param")
    end