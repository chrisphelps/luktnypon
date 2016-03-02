primitive Neigh
  fun apply(): String => "NEIGH"
  fun ord(): U8 => 0
primitive Naigh
  fun apply(): String => "NAIGH"
  fun ord(): U8 => 1
primitive Neeigh
  fun apply(): String => "NEEIGH"
  fun ord(): U8 => 2
primitive Naaigh
  fun apply(): String => "NAAIGH"
  fun ord(): U8 => 3

type NeighEntry is (Neigh | Naigh | Neeigh | Naaigh)

primitive NeighEntryList
  fun tag apply(): Array[NeighEntry] =>
    [Neigh, Naigh, Neeigh, Naaigh]
  fun tag find(v: String): NeighEntry? =>
    for n in NeighEntryList().values() do
      if v == n() then
        return n
      end
    end
    error

actor Main
  let _env: Env
  new create(env: Env) =>
    _env = env
    try
      let command: String = _env.args(1)
      let input: String = _env.args(2)
      match command
        | "dec" => decode(input)
        | "enc" => encode(input)
      else
        usage()
      end
    else
      usage()
    end

  fun usage() =>
    try
      _env.out.print("Usage "+_env.args(0)+" (dec|enc) string")
      _env.exitcode(2)
    else
      _env.out.print("Could not access arguments!")
    end

  fun encode(input: String) =>
      _env.out.print("Encoding: "+input)
      let r = StringEncoder
      NeighEncoder.encode(input, r)
      r.display(_env)
      _env.exitcode(0)

  fun decode(input: String) =>
      _env.out.print("Decoding: "+input)
      let r = StringDecoder
      NeighEncoder.decode(input, r)
      r.display(_env)
      _env.exitcode(0)

interface EncoderResult
  be write(b: U8)

actor StringEncoder
  var result: String ref = recover String end

  new create() => None
  fun ref append(h: String) => result.append(h)

  be write(b: U8) =>
    try
      append(NeighEntryList()(b.u64())())
      append("! ")
    end

  be display(env: Env) => env.out.print("Result: "+result)

actor StringDecoder
  var result: Array[U8] ref = recover Array[U8] end

  new create() => None

  fun ref append(b: U8) => result.push(b)

  fun ref getResult(): String? =>
    var res = String(result.size())
    var idx:U64 = 0
    for c in result.values() do
      res.append(" ")
      res.update(idx,c)
      idx = idx + 1
    end
    res.string()

  be write(b: U8) => append(b)
  be display(env: Env) =>
    try
      env.out.print("Result: "+getResult())
    else
      env.out.print("ERROR printing!")
    end

primitive NeighEncoder
  fun encode(input: String, out: EncoderResult tag) =>
    let da: Array[U8] = [0,2,4,6]
    for i in input.values() do
      for d in da.values() do
        let b:U8 = (i and (0x03 << d)) >> d
        out.write(b)
      end
    end

  fun decode(input: String, out: EncoderResult tag) =>
    let da: Array[U8] = [0,2,4,6]
    let listOfNeigh: Array[String] box = input.split("! \\")
    var b: U8 = 0
    var step: U64 = 0
    for n in listOfNeigh.values() do
      if n.size() != 0 then
        try
          let c = NeighEntryList.find(n).ord()
          b = b or (c << da(step))
          step = step + 1
        else
          for er in ("ERROR"+n).values() do
            out.write(er)
          end
        end
        if (step == 4) then
          // We have a full U8 in b
          out.write(b)
          b = 0
          step = 0
        end
      end
    end

