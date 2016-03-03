use "collections"
use "../packages/slack"
use "../packages/encoders"

actor Main
  var _name: String
  var _slackClient: SlackClient

  new create(env: Env) =>
    _slackClient = SlackClient(env)
    _name = try env.args(1) else "Segmentation D Fault Esq" end
    let command = try env.args(2) else "enc" end

    for i in Range(3, env.args.size()) do
      try
        match command
          | "dec" => _slackClient.speak(_name, SoundEncoder.decode(env.args(i)))
          | "enc" => _slackClient.speak(_name, SoundEncoder.encode(env.args(i)))
        end
      end
    end
