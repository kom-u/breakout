_G.love = require("love")

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
_G.push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
_G.Class = require 'lib/class'

require 'src/constants'

require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'

require 'src/LevelMaker'

require 'src/StateMachine'

require 'src/Util'

-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/ServeState'
require 'src/states/GameOverState'
require 'src/states/VictoryState'
