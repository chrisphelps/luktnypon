use "assert"
use "collections"
use "net/http"
use "net/ssl"
use "json"

actor Main
  let _env: Env
  let _client: Client

  new create(env: Env) =>
    _env = env

    _env.out.print("Applejack starting...")

    let sslctx = try
      recover
        SSLContext
          .set_client_verify(true)
          .set_authority("./cacert.pem")
      end
    end

    _env.out.print("Applejack started.")

    _client = Client(consume sslctx)

    for i in Range(1, env.args.size()) do
      try
        let s = "https://api.giphy.com/v1/gifs/translate?api_key=dc6zaTOxFJmzC&fmt=json&rating=y&s=" + env.args(i) + "%20pony"
        let url = URL.build(s)
        Fact(url.host.size() > 0)

        let req = Payload.request("GET", url, recover this~apply() end)
        _client(consume req)
      else
        try env.out.print("Malformed URL: " + env.args(i)) end
      end
    end

  be apply(request: Payload val, response: Payload val) =>
    if response.status != 0 then
      // TODO: aggregate as a single print
      _env.out.print(
        response.proto + " " +
        response.status.string() + " " +
        response.method)

      for (k, v) in response.headers().pairs() do
        _env.out.print(k + ": " + v)
      end

      _env.out.print("")
      _env.out.print("Here is the output from gliphy")
      _env.out.print("")

      var jsonResponse = ""

      for chunk in response.body().values() do
        _env.out.print(chunk) // chunk is a ByteSeq

        //blergh = chunk.toString()
        //_env.out.write(blergh)

        for i in Range(0, chunk.size()) do
          try
            let c = chunk(i)
            let c2 = String.from_utf32(c.u32())
            // _env.out.write("Current char: " + c2)
            jsonResponse = jsonResponse + c2
          end
        end

        // let c : Pointer[U8] ref = chunk.cstring()


        // jsonResponse = jsonResponse

        _env.out.print("Our jsonResponse: " + jsonResponse)        

        let json: JsonDoc = JsonDoc
        try
          json.parse(jsonResponse)

          _env.out.print("HERE!!!!!")

          match json.data 
          | let o: JsonObject => 
            _env.out.print("THE JSON DOC PARSED: " + o.string())


            for k in o.data.keys() do
              _env.out.print("GGGGGG: " + k)
            end

            try
              match o.data("data")
              | let o2: JsonObject => 
                _env.out.print("THE JSON DATA PARSED: " + o2.string())

              try
                match o2.data("embed_url")
                | let o3: String =>  _env.out.print("What we actually want: " + o3)
                end
              else
                _env.out.print("Not a String!")  
              end
            end

            else
              _env.out.print("No embed_url!")  
            end


            // let giphyUrl = o.data("embed_url") as String
            // _env.out.print("The Giphy URL: " + giphyUrl)
          else
            _env.out.print("Shit")
          end
          // let x1 = json.data as JsonObject
          // _env.out.print("THE JSON DOC PARSED: " + x1.string())
        end


        

      end

      // _env.out.print("THE JSON RESPONSE: " + jsonResponse)

      _env.out.print("")

    else
      _env.out.print("Failed: " + request.method + " " + request.url.string())
    end
