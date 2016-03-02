use "assert"
use "collections"
use "net/http"
use "net/ssl"
use "time"

class PollTimerNotify is TimerNotify
  let _sender: SlackListener

  new iso create(sender: SlackListener) =>
    _sender = sender

  fun ref apply(timer: Timer, count: U64): Bool =>
    _sender.poll()
    true

  fun ref cancel(timer: Timer) => None

interface SlackSubscriber
  be messageReceived(msg: String)

actor SlackListener
  let _env: Env
  let _token: String
  let _channel: String
  let _client: Client
  var _subscribers: Array[SlackSubscriber tag]

  new create(env: Env, subscriber: SlackSubscriber tag) =>
    _env = env
    _token = try _env.args(1) else "xoxp-16403402883-20720597988-23963616497-5d589467a3" end
    _channel = try _env.args(2) else "C0PU3PR62" end
    _subscribers = [subscriber]

    let sslctx = try
      recover
        SSLContext
          .set_client_verify(true)
          .set_authority("./cacert.pem")
      end
    end
    _client = Client(consume sslctx)

    let timers = Timers

    let listener = Timer(PollTimerNotify(this), 10000000000, 10000000000) // 10 seconds
    timers(consume listener)

  be poll() =>
    try
      let ts = Time.seconds() - 1
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
      var message: String = "Test message"

      for subscriber in _subscribers.values() do
        subscriber.messageReceived(message)
      end
    else
      _env.out.print("Failed: " + request.method + " " + request.url.string())
    end

actor Main
  let _env: Env

  new create(env: Env) =>
    _env = env
    SlackListener(_env, this)

  be messageReceived(msg: String) =>
    _env.out.print("Message received: " + msg)

