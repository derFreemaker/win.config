config.args_parser:command("install i", "run install scripts")
config.parse_args()

print(config.args.install)
print(env.hostname)
