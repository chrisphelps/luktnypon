primitive Neigh
  fun apply(): String => "Neigh"
  fun ord(): U8 => 0
primitive Whinny
  fun apply(): String => "Whinny"
  fun ord(): U8 => 1
primitive Chuff
  fun apply(): String => "Chuff"
  fun ord(): U8 => 2
primitive Groan
  fun apply(): String => "Groan"
  fun ord(): U8 => 3

type ManySounds is (Neigh | Whinny | Chuff | Groan)

primitive ManySoundsList
  fun tag apply(): Array[ManySounds] =>
    [Neigh, Whinny, Chuff, Groan]
  fun tag find(v: String): ManySounds? =>
    for n in ManySoundsList().values() do
      if v == n() then
        return n
      end
    end
    error


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

  fun decode(input: String): String =>
    let da: Array[U8] = [0,2,4,6]
    let listOfNeigh: Array[String] box = input.split(" ")
    var b: U8 = 0
    var step: U64 = 0
    var length: I64 = 0
    var aggregator: String ref = recover String end
    for n in listOfNeigh.values() do
      if n.size() != 0 then
        try
          let c = ManySoundsList.find(n).ord()
          b = b or (c << da(step))
          step = step + 1
        else
          for er in ("ERROR"+n).values() do
            aggregator.append(er.string())
          end
        end
        if (step == 4) then
          // We have a full U8 in b
          aggregator.insert_byte(length+1, b)
          length = length + 1
          b = 0
          step = 0
        end
      end
    end
    aggregator.string()


actor Main
  new create(env: Env) =>
    try
      let inputString: String = env.args(1)
      env.out.print("Encoding: " + inputString)
      let encoded = SoundEncoder.encode(inputString)
      env.out.print("Result from fun was: " + encoded)

      env.out.print("Decoding: " + encoded)
      let decoded = SoundEncoder.decode(encoded)
      env.out.print("Result from decode was " + decoded)
    else
      env.out.print("Why you no give param")
    end