# coding utf-8
class Title
  def initialize
    #@title = "タイトル"
    @font = Font.new(29, "ＭＳ ゴシック", weight:true)
    @n = 0
    @back = Image.load("scenes/game/images/opening.png")  
    soundRoot = "scenes/game/sounds/"
    $opBGM = Sound.new("#{soundRoot}op.wav")
    $opBGM.loopCount = -1
    $playOpBGM = true
  end

  def play
    if $playOpBGM
      $playOpBGM = false
      $opBGM.play
    end
      Window.draw(0,0,@back) 
      #Window.drawFont(0,100,@title,@font,weight:true) 
  end
 def next
    if Input.keyPush?(K_RETURN)
      Scene.set_scene(:opening)
    end
 end

  def sound
     #@bgm = Sound.new("scenes/game/sounds/opening.mid")  # bgm.mid読み込み
     #@bgm.play
  end


end