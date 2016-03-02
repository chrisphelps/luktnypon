use "assert"
use "collections"
use "net/http"
use "net/ssl"
use "time"

class SlackListener is TimerNotify
  let _sender: Main

  new iso create(sender: Main) =>
    _sender = sender

  fun ref apply(timer: Timer, count: U64): Bool =>
    _sender.poll()
    true

  fun ref cancel(timer: Timer) => None

actor Main
  let _env: Env
  let _token: String
  let _channel: String
  let _client: Client

  new create(env: Env) =>
    _env = env
    _token = try _env.args(1) else "xoxp-16403402883-20720597988-23963616497-5d589467a3" end
    _channel = try _env.args(2) else "C0PU3PR62" end


    let sslctx = try
      recover
        SSLContext
          .set_client_verify(true)
          .set_authority("./cacert.pem")
      end
    end
    _client = Client(consume sslctx)

    let timers = Timers

    let listener = Timer(SlackListener(this), 5000000000, 5000000000) // 500ms
    timers(consume listener)

  be poll() =>
    try
      let ts = Time.seconds() - 5
      let s = "https://slack.com/api/channels.history?token=" + _token + "&channel=" + _channel + "&oldest=" + ts.string() + "&pretty=1"
      let url = URL.build(s)
      Fact(url.host.size() > 0)

      let req = Payload.request("GET", url, recover this~handleResponse() end)
      _client(consume req)
    else
      _env.out.print("Malformed URL")
    end

  be handleResponse(request: Payload val, response: Payload val) =>
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
