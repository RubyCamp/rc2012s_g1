# coding utf-8
class Ending1
  def initialize
    #@ending = "無事に結婚し、さらに大きな屋敷も建ちました！"
    @font = Font.new(29, "ＭＳ ゴシック", weight:true)
    @back = Image.load("scenes/game/images/ending1.png")
    @n = 0
    soundRoot = "scenes/game/sounds/"
    @bgm = Sound.new("#{soundRoot}end_true.wav")
    @bgm.loopCount = -1
    @playBGM = true
  end

  def play
    if @playBGM
      @playBGM = false
      @bgm.play
    end
    #Window.drawFont(0,100,@ending[@n],@font,weight:true) 
    Window.draw(100,0,@back) 
    $RETRY = true
    $s = 0
  end
 def next
    if Input.keyPush?(K_RETURN)
      exit
    end
    if Input.keyPush?(K_SPACE)
      @bgm.stop
      @playBGM = true
      $opBGM.play
      Scene.set_scene(:title)
    end
 end



end