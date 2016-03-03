use "assert"
use "collections"
use "net/http"
use "net/ssl"

actor Main
  let _env: Env
  let _token: String
  let _client: Client
  let _channel: String
  let _name: String

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

    _token = "xoxp-16403402883-16552290308-23955244178-3e1b136b9e"
    _channel = "C0PU3PR62" //"%23luktnypon"
    _name = "RainbowDash"

    for i in Range(1, env.args.size()) do
      try
        let s = "https://slack.com/api/chat.postMessage?token=" + _token +
          "&username=" + _name +
          "&pretty=1" +
          "&channel=" + _channel +
          "&text=" + env.args(i)
        env.out.print(s)
        let url = URL.build(s)
        Fact(url.host.size() > 0)

        let req = Payload.request("GET", url, recover this~apply() end)
        _client(consume req)
      else
        try env.out.print("Malformed URL: " + env.args(i)) end
      end
    end

    try
      let s = "https://slack.com/api/channels.history?token=" + _token +
        "&pretty=1" +
        "&channel=" + _channel +
        "&count=" + "10"
      env.out.print(s)
      let url = URL.build(s)
      Fact(url.host.size() > 0)

      let req = Payload.request("GET", url, recover this~apply() end)
      _client(consume req)
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
