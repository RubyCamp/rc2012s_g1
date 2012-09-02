# coding utf-8 

require 'dxruby'
require 'dxrubyex'
require_relative 'game/map'
require_relative 'game/sidebar'
require_relative 'game/player'
require_relative 'game/enemy'

class Game
  #$DIFFICULTY = :hard

  FRAGILE = 30
  SILVER = 40
  SIL0 = 40
  SIL1 = 41
  SIL2 = 42
  SIL3 = 43

  def initialize
    $RETRY = false
    @first = true
    @endBGM = true
    
    @map = Map.new
    @player = Player.new(0,0,5)
    @enemies = []
  
    @playerFreeze = false
    @digTimer = [0,0,0,0]
    @time = 0
    @gameend = false
    @gameover = false
    @font = Font.new(80, "メイリオ")
    
    imgRoot = "scenes/game/images/"
    @frame = Image.load("#{imgRoot}frame.png")
    soundRoot = "scenes/game/sounds/"
    @bgm = Sound.new("#{soundRoot}gameBGM.wav")
    @bgm.loopCount = -1
    #@bgm.play
    @dig = Sound.new("#{soundRoot}break.wav")
    @dig.loopCount = 1
    @kill = Sound.new("#{soundRoot}explosion.wav")
    @kill.loopCount = 1
    @itemGet = Sound.new("#{soundRoot}itemget.wav")
    @itemGet.loopCount = 1
    @poka = Sound.new("#{soundRoot}poka.wav")
    @poka.loopCount = 1
    @clearSound = Sound.new("#{soundRoot}clear.wav")
    @clearSound.loopCount = 1
    @overSound = Sound.new("#{soundRoot}gameover.wav")
    @overSound.loopCount = 1
  end
  
  def play
    initialize if $RETRY
    if @first
      @bgm.play
      @first = false
      if $DIFFICULTY == :easy
        @heart_max = 10
        @tsuruhashi_max = 15
        @enemyWait = 5
      elsif $DIFFICULTY == :normal
        @heart_max = 5
        @tsuruhashi_max = 10
        @enemyWait = 3
      elsif $DIFFICULTY == :hard
        @heart_max = 5
        @tsuruhashi_max = 10
        @enemyWait = 2
      end
      @bar = Sidebar.new
      @bar.score = 0
      @bar.heart = @heart_max
      @bar.tsuruhashi = @tsuruhashi_max
    end
  
    unless @gameend
      @time += 1
  
      # playerの移動処理
      @player.move(Input.x, Input.y, @map) unless @playerFreeze
      xy = @player.where
  
      # enemyの移動処理
      @enemies.each do |enemy|
        enemy.move(@map)
      end
  
      # アイテム取得処理
      checkItem(xy)
      #@player.status = 1 if Input.keyPush?(K_Q)
  
      # 掘る処理（銀・壊せる壁共通）
      checkDig(xy)
  
      # 敵の出現処理
      if checkTime
        if $DIFFICULTY == :hard
          enemySpeed = 2#@enemies.size+1
        else
          enemySpeed = 2
        end
        rx = rand(18)
        ry = rand(18)
        if @map.state(rx,ry) < 20
          enemy = Enemy.new(rx,ry,enemySpeed)
          enemy.sleep(2*60)
        else
          enemy = Enemy.new(0,0,enemySpeed)
        end
        @enemies << enemy
      end
  
      # 敵との衝突判定
      checkEnemy(xy)
      
      # 描画
      Window.draw(0,0,@frame)
      @map.draw
      @bar.draw
      @enemies.each do |enemy|
        enemy.draw
      end
      @player.draw
    
      # ゲームクリア判定
      if xy[0]==17 && xy[1]==17
        @gameend = true
        @bgm.stop
        @bgm.dispose
        @bar.timer_stop
        @timeBonus = [(120 - @bar.get_time_sec),0].max * 20
        allMap = true
        18.times do |i|
          18.times do |j|
            allMap = false unless @map.visible(i,j)
          end
        end
        @mapBonus = 0
        @mapBonus = 1000 if allMap
        @bar.score = @bar.score + @timeBonus + @mapBonus
        $FINAL_SCORE = @bar.score
        @gameover = true if $FINAL_SCORE < 3000
      end
      # ゲームオーバー判定
      if @bar.heart <= 0
        @gameend = true
        @gameover = true
        @bgm.stop
        @bgm.dispose
        @bar.timer_stop
        $FINAL_SCORE = @bar.score
      end
    else
      # ゲーム終了時の処理
      Window.draw(0,0,@frame)
      @map.draw
      @bar.draw
      @player.draw
      @enemies.each do |enemy|
        enemy.draw
      end

      if @gameover
        # ゲームオーバー時の処理
        hashOver = {:z=>2, :color=>[255,0,0], :edge=>true, :edge_color=>[0,0,0]}
        Window.drawFontEx(200,200,"GAME OVER",@font,hashOver)
        Window.drawFontEx(160,280,"SCORE = #{$FINAL_SCORE}",@font,hashOver)
        if Input.keyPush?(K_RETURN)
          Scene.set_scene(:ending3)
        end
        if @endBGM
          @overSound.play
          @endBGM = false
        end
      else
        # ゲームクリア時の処理
        hashClear = {:z=>2, :color=>[0,0,255], :edge=>true, :edge_color=>[0,0,0]}
        Window.drawFontEx(200,200,"GAME CLEAR",@font,hashClear)
        if $DIFFICULTY == :hard
          Window.drawFontEx(150,280,"BONUS = #{@timeBonus}+#{@mapBonus}",@font,hashClear)          
        else
          Window.drawFontEx(150,280,"BONUS = #{@timeBonus}",@font,hashClear)          
        end
        Window.drawFontEx(160,360,"SCORE = #{$FINAL_SCORE}",@font,hashClear)
        if Input.keyPush?(K_RETURN)
          if $FINAL_SCORE >= 5000
            Scene.set_scene(:ending1)
          else
            Scene.set_scene(:ending2)
          end
        end
        if @endBGM
          @clearSound.play
          @endBGM = false
        end
      end
      
    end
  end
  
  def checkItem(xy)
    # @mapとxyを照会してアイテムの状態を反映
    state = @map.state(xy[0], xy[1])
    if state == 10 # 体力
      if @bar.heart <= @heart_max-2
        @bar.heart += 2
        @map.set(xy[0], xy[1], 0) # 空洞
        @itemGet.play
      end
    elsif state == 11 # ツルハシ
      if @bar.tsuruhashi <= @tsuruhashi_max-4
        @bar.tsuruhashi += 4
        @map.set(xy[0], xy[1], 0) # 空洞
        @itemGet.play
      end
    elsif state == 12 # 無敵アイテム
      if @player.status != 1 # 無敵
        @player.status = 1 # 無敵
        @map.set(xy[0], xy[1], 0) # 空洞
        @itemGet.play
      end
    end
  end
  
  def checkDig(xy)
    if @digTimer[2] != 0
      @digTimer[2] -= 1
      # 一定時間経過したときに銀を掘ってスコア計算
      if @digTimer[2] == 0
        @playerFreeze = false
        state = @map.state(@digTimer[0],@digTimer[1])
        case state
        when FRAGILE
          @map.set(@digTimer[0],@digTimer[1],0)
        when SIL0
          @bar.score = @bar.score + 600
          @map.set(@digTimer[0],@digTimer[1],20)
        when SIL1
          @bar.score = @bar.score + 250
          @map.set(@digTimer[0],@digTimer[1],SIL0)
        when SIL2
          @bar.score = @bar.score + 100
          @map.set(@digTimer[0],@digTimer[1],SIL1)
        when SIL3
          @bar.score = @bar.score + 50
          @map.set(@digTimer[0],@digTimer[1],SIL2)
        end
        @bar.tsuruhashi = @bar.tsuruhashi-1
        
        # スコアに応じたスピード設定
        if @bar.score >= 5000
          @player.speed = 1
        elsif @bar.score >= 4000
          @player.speed = 2
        elsif @bar.score >= 3000
          @player.speed = 2
        elsif @bar.score >= 2000
          @player.speed = 3
        elsif @bar.score >= 1000
          @player.speed = 4
        end
      end
    else
      if @bar.tsuruhashi!=0 && Input.keyPush?(K_SPACE)
        dir = @player.getDir
        if dir==LEFT && xy[0]>=0
          front = [xy[0]-1,xy[1]]
        elsif dir==UP && xy[1]>=0
          front = [xy[0],xy[1]-1]
        elsif dir==RIGHT && xy[0]<=17
          front = [xy[0]+1,xy[1]]
        elsif dir==DOWN && xy[1]<=17
          front = [xy[0],xy[1]+1]
        end
        if 0<=front[0] && front[0]<=17 && 0<=front[1] && front[1]<=17
          wall = @map.state(front[0],front[1])
          if wall>=SILVER
            @playerFreeze = true
            @digTimer = [front[0], front[1], (5-(wall-SILVER))*30]
            @dig.play
            #puts 5-(wall-SILVER)
          elsif wall == FRAGILE
            @playerFreeze = true
            @digTimer = [front[0], front[1], 60]
            @dig.play
          end
        end
      end
    end
  end
  
  def checkEnemy(xy)
    @enemies.each do |enemy|
      if enemy.where == xy && enemy.status == 0 # 通常
        if @player.status == 1 # 無敵
          enemy.status = 1 # 死亡
          @player.status = 0 # 通常
          @kill.play
        else
          sleepTime = 1*60
          enemy.sleep(sleepTime)
          @player.damage(sleepTime/2)
          @bar.heart -= 1
          @poka.play
          # puts "life=#{@life}"
        end
      end
    end
  end

  def checkTime
    # @enemyWait秒に1回trueになる
    if @time%(@enemyWait*60) == 0
      return true
    else
      return false
    end
  end
end