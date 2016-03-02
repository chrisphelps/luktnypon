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
      var inputString: String = env.args(1)
      env.out.print("Encoding: "+inputString)
      for n in NeighEntryList().values() do
        env.out.print("Entry "+n())
      end
    else
      env.out.print("Why you no give param")
    end
