# coding utf-8
class Tutorial
  def initialize
    @tut = ["基本説明\n\n矢印キーで移動\n銀のある壁を向いて\nスペースキーを押すことで銀が掘れる\n同様にひびの入った壁は壊れる\nアイテムをとることで\nさまざまな効果がある！\nクリア後スペースキーでリトライ\nプレイヤーキャラ　→ \n敵キャラ 　　　 　→\nアイテム　　　　　→\n銀　　　　　      	→\n\n銀をたくさん掘ってハイスコアを目指せ"]
    @img_pl = Image.load("scenes/game/images/icon/player_down.png")
    @img_en = Image.load("scenes/game/images/icon/enemy_down.png")
    @img_ag = Image.load("scenes/game/images/icon/wall_ag1.png")
    @img_tsuruhashi = Image.load("scenes/game/images/icon/tsuruhashi2.png")
    @img_muteki = Image.load("scenes/game/images/icon/muteki.png")
    @img_heart = Image.load("scenes/game/images/icon/heart_icon.png")
    @font = Font.new(38, "ＭＳ ゴシック", weight:true)
    @back = Image.load("scenes/game/images/opening3.png")
  end

  def play
    Window.draw(0,0,@back) 
    Window.drawFont(0,0,@tut[0],@font,weight:true) 
    Window.draw(400,342,@img_pl)
    Window.draw(400,380,@img_en)
    Window.draw(400,418,@img_tsuruhashi)
    Window.draw(432,418,@img_muteki)
    Window.draw(464,418,@img_heart)
    Window.draw(400,456,@img_ag)

  end

  def next
    Input.keyPush?(K_RETURN)
      $s = 1
      $opBGM.stop
      Scene.set_scene(:game)    
  end


end
