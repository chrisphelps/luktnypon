primitive Neigh
  fun apply(): String => "NEIGH"
primitive Naigh
  fun apply(): String => "NAIGH"
primitive Neeigh
  fun apply(): String => "NEEIGH"
primitive Naaigh
  fun apply(): String => "NAAIGH"

type NeighEntry is (Neigh | Naigh | Neeigh | Naaigh)

primitive NeighEntryList
  fun tag apply(): Array[NeighEntry] =>
    [Neigh, Naigh, Neeigh, Naaigh]

actor Main
  new create(env: Env) =>
    try
      let inputString: String = env.args(1)
      env.out.print("Encoding: "+inputString)
      //for n in NeighEntryList().values() do
      //  env.out.print("Entry "+n())
      //end
      let r = StringNeigh
      NeighEncoder.encode(inputString, r)
      r.display(env)
    else
      env.out.print("Why you no give param")
    end

interface EncoderResult
  be write(b: U8)

actor DisplayNeigh
  let env: Env
  new create(env': Env) =>
    env = env'
  be write(b: U8) =>
    try
      env.out.print(NeighEntryList()(b.u64())() + "! ")
    else
      env.out.print("Come on! Cannot convert U8 to U64?!?")
    end

actor StringNeigh
  var result: String ref = recover String end

  new create() => None

  fun ref append(h: String) => result.append(h)

  be write(b: U8) =>
    try
      append(NeighEntryList()(b.u64())())
      append("! ")
    end

  be display(env: Env) => env.out.print("Result: "+result)


primitive NeighEncoder
  fun encode(input: String, out: EncoderResult tag) =>
    for i in input.values() do
      let da: Array[U8] = [0,2,4,6]
      for d in da.values() do
        let b:U8 = (i and (0x03 << d)) >> d
        out.write(b)
      end
    end

