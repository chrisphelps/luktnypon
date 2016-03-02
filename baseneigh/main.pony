actor Main
  new create(env: Env) =>
    try
      env.out.print("Encoding: "+env.args.apply(1))
    else
      env.out.print("Why you no give param")
    end
