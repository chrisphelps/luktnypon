use "assert"
use "collections"
use "net/http"
use "net/ssl"

actor Main
  let _env: Env
  let _client: Client

  new create(env: Env) =>
    _env = env

    let sslctx = try
      recover
        SSLContext
          .set_client_verify(true)
          .set_authority("./cacert.pem")
      end
    end

    _client = Client(consume sslctx)

    var name: String = try env.args(1) else "Segmentation D Fault Esq" end

    for i in Range(2, env.args.size()) do
      try speak(name, env.args(i)) end
    end


  fun speak(name: String, message: String) =>
    let s = "https://slack.com/api/chat.postMessage?" +
      "token=xoxp-16403402883-16552290308-23955244178-3e1b136b9e" +
      "&pretty=1" + 
      "&channel=%23luktnypon" +
      "&username=" + name +
      "&text=" + message
    try
        let url = URL.build(s)
        Fact(url.host.size() > 0)

        let req = Payload.request("GET", url, recover this~apply() end)
        _client(consume req)
      else
        _env.out.print("Malformed URL: " + s)
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

      for chunk in response.body().values() do
        _env.out.write(chunk)
      end

      _env.out.print("")
    else
      _env.out.print("Failed: " + request.method + " " + request.url.string())
    end
