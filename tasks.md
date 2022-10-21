# Tasks

Task to finish the first version of tic tac toe game.

## 1.0
- [x] Can be able to access to phoenix local server in local network.
- [x] Rename liveviews (game -> game_live, player -> player_live).
- [x] Update elixir, erlang and libraries 
- [ ] Manage the player events with game server (centralized engine), not each liveview (peer to peer strategy).
- [ ] Manage player turn with game server.
- [ ] Draw events in the DOM.
- [ ] Save players victories, ties and defeats in the game server.
- [ ] Manage player's disconnection on game server, maybe close the game server if a player remains disconnected more than 10 seconds.
- [ ] When player reloads the game, liveview should recover the game state and continue in the same state.
- [ ] Manage and show player status (online, disconnected) to notify it between them.
- [ ] Add horde and libcluster to be able to distribute game server processes across erlang nodes.
- [ ] Libcluster should be integrated with adapter pattern, in case of changing with another tool (partisan).
- [ ] Install credo rules.
- [ ] Install dependacy bot (github).
- [ ] Make unit test for (genservers, liveview, bussiness logic).
- [ ] Install coverralls.
- [ ] Make a pipeline for CI (github actions).
- [ ] Make a release configuration to Gigalixir.
- [ ] Make docker file to run project.
- [ ] Fix the readme.

# 2.0
- [ ] Configure dark mode, allow players to change on dark and light mode.
- [ ] Make a timer if player remains too much time without finding a match, ask him if he wants to continue waiting for a game.
- [ ] Read `PartitionSupervisor`, maybe it's possible to partition in multiple genservers the user's wait list for a game.
- [ ] Make an authentication engine based on this [challengue](https://devchallenges.io/challenges/N1fvBjQfhlkctmwj1tnw)
  - [ ] Create authentication (login, recover passw, etc...)
  - [ ] Create user domain
  - [ ] Integrate users to the game logic
  - [ ] Manage statistic for users (average of wins, ties, defeats, played games, etc...)
