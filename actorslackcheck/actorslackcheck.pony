use "collections"
use "../packages/slack"

actor Main
  new create(env: Env) =>
    var slackClient = SlackClient(env)

    var name: String = try env.args(1) else "Segmentation D Fault Esq" end

    for i in Range(2, env.args.size()) do
      try slackClient.speak(name, env.args(i)) end
    end

