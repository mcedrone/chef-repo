name "round-three"
description "umasstransit.org 'round-three'.  Our core web-app"

run_list(
  "role[round-three-base]",
  "recipe[round-three::faye]",
  "recipe[fuelfocus-api]"
)
