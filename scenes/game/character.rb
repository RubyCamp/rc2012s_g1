require 'dxruby'
require 'dxrubyex'

resourceRoot = "scenes/game/images/icon/"

$images = {}
[:player, :muteki, :damage, :enemy].each do |name|
  $images[name] = []
  ["#{resourceRoot}#{name}_left.png",
   "#{resourceRoot}#{name}_up.png",
   "#{resourceRoot}#{name}_right.png",
   "#{resourceRoot}#{name}_down.png"].each do |pic|
    $images[name] << Image.load(pic)
  end
end

class Game
  LEFT  = 0
  UP    = 1
  RIGHT = 2
  DOWN  = 3
end

class Character
  attr_accessor :speed
  attr_accessor :status

  def initialize(x, y, speed)
    @x = x*32 + 12
    @y = y*32 + 12
    @status = 0
    @dir = Game::DOWN
    @speed = speed
    @restX = 0
    @restY = 0
    @count
  end
    
  def wait(time)
    @count = time
    @status = 2
  end
  
  def countDown
    @count -= 1
    @status = 0 if @count == 0
  end

  def where
    i = 0
    j = 0
    
    loop do
      break if (@x - 12) <= (32 * (i + 1) -16)
      i += 1
    end
    
    loop do
      break if (@y - 12) <= (32 * (j + 1) - 16)
      j += 1
    end

    xy = [i, j]
    return xy
   
  end
  
  def status=(s)
    @status = s
  end
    
  def draw
    raise "must override!"
  end

  def getDir
    @dir
  end
  
  def dir(val)
    @dir = val
  end
  
  def goForward
    spX = [@restX.abs, @speed].min
    spY = [@restY.abs, @speed].min
    # 右へ動く
    if @restX>0
      @x += spX
      @restX -= spX
    # 左へ動く
    elsif @restX<0
      @x -= spX
      @restX += spX
    end
    # 下へ動く
    if @restY>0
      @y += spY
      @restY -= spY
    # 上へ動く
    elsif @restY<0
      @y -= spY
      @restY += spY
    end
  end
end