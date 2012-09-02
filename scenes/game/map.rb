require "dxruby"
require "dxrubyex"
require_relative "maps" 


class Map
  attr_accessor :map
  # EMP = 0
  # HEAL_ITEM = 10
  # TSURUHASHI_ITEM = 11
  # POWER_ITEM = 12
  # NORMAL_WALL = 20
  # FRAGILE_WALL = 30
  # SILVER_WALL0 = 40
  # SILVER_WALL1 = 41
  # SILVER_WALL2 = 42
  # SILVER_WALL3 = 43
  # SILVER_WALL4 = 44
   
  CELLSIZE = 32
  ORIGIN_X = 12
  ORIGIN_Y = 12
  INWIN_X = 556  # 600-12-32
  INWIN_Y = 556

  def initialize
    # 横18ブロック 縦18ブロック   1ブロックは32
    maps = Maps.new
    @map = maps.getMap(1)#rand(maps.size))

    @blocks = []
    @emptys = []

    resourceRoot = "scenes/game/images/icon/"
    # @chipsに画像を入れて、どの画像を表示するのかを@chipsで判断できるようにした
    @chips = []
    # 空洞の画像を読み込み
    errImg = Image.load("#{resourceRoot}error.png")
    # 配列中の空きを埋めておかないとエラーが出るので ↓
    50.times do |i|
      @chips[i] = errImg # 全体に空洞の画像を代入
    end
    @chips[0]  = Image.load("#{resourceRoot}empty.png")
    @chips[10] = Image.load("#{resourceRoot}heart_icon.png")
    @chips[11] = Image.load("#{resourceRoot}tsuruhashi2.png")
    @chips[12] = Image.load("#{resourceRoot}muteki.png")
    @chips[20] = Image.load("#{resourceRoot}wall.png")   # ブロックの画像を代入
    @chips[30] = Image.load("#{resourceRoot}wall_fragile.png")
    @chips[40] = Image.load("#{resourceRoot}wall_ag0.png")
    @chips[41] = Image.load("#{resourceRoot}wall_ag1.png")
    @chips[42] = Image.load("#{resourceRoot}wall_ag2.png")
    @chips[43] = Image.load("#{resourceRoot}wall_ag3.png")
    #@chips[44] = Image.load("#{resourceRoot}wall_ag4.png")
    @chips[50] = Image.load("#{resourceRoot}unknown.png")

  end

  def draw
    18.times do |my|
      18.times do |mx|
        # mapからpx表示に変換
        wx,wy = map_to_world(mx,my)
        if @map[my][mx] < 100 && $DIFFICULTY == :hard
          Window.draw(wx,wy,@chips[50], 1)
        else
          Window.draw(wx,wy,@chips[@map[my][mx]%100])
        end
      end      
    end
  end

  def state(x, y)
    return @map[y][x]%100
  end
  
  def visible(x, y)
    if @map[y][x] < 100
      return false
    else
      return true
    end
  end

  def set(x, y, state)
    @map[y][x] = state
  end

  def map_to_world(mx,my)
    wx = mx*CELLSIZE + ORIGIN_X
    wy = my*CELLSIZE + ORIGIN_Y
    return wx,wy
  end


end