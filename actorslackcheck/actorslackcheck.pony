use "collections"
use "../packages/slack"
use "../packages/encoders"

actor Main
  var _name: String
  var _slackClient: SlackClient

  new create(env: Env) =>
    _slackClient = SlackClient(env)
    _name = try env.args(1) else "Segmentation D Fault Esq" end

    for i in Range(2, env.args.size()) do
      try
        _slackClient.speak(_name, SoundEncoder.encode(env.args(i)))
      end
    end

