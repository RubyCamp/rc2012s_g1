# coding utf-8
class Ending3
  def initialize
    @ending = ["Spaceキーでリトライ"]
    @font = Font.new(38, "ＭＳ ゴシック", weight:true)
    @back = Image.load("scenes/game/images/ending3.png")
    @n = 0
    soundRoot = "scenes/game/sounds/"
    @bgm = Sound.new("#{soundRoot}end_bad.wav")
    @bgm.loopCount = -1
    @playBGM = true
  end

  def play
    if @playBGM
      @playBGM = false
      @bgm.play
    end
    Window.draw(100,0,@back) 
    #Window.drawFont(0,138,@ending[0],@font,color:[50,50,50]) 
    Window.drawFont(250,550,@ending[0],@font,color:[0,0,0]) 
    $RETRY = true
    $FINAL_SCORE = true
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