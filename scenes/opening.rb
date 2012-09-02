# coding utf-8
class Opening
  def initialize
    @bun = ["","      時代は江戸時代までさかのぼる。",
          "      あるところに一人の男がいた。",
          "   男はある女に恋をしていたが、\n   家の間柄が悪く\n   結婚を許してもらうことができなかった。",
          "      しかし、男はあきらめなかった。",
          "   男は好きな女と一緒に家を出て、\n     二人で暮らすことを決めたのだった。",
          "    このことを女に言うと",
          "「私はこの家を大切に思っております。\n ですが、\n あなた様が本気でそう思っているのでしたら\n 私もついて参りましょう」",
          "   これを聞き、\n   男はどうすればいいのかをたずねた。",
          "「銀を持ってきてください。\n そうすれば私も安心してお供できます」",
          "  女の言葉を聴き終えると\n    男は帰り準備を始めた。",
          "      石見銀山へ行く準備を……",
          "   そして、それを見た女の家来達も\n     男を追って石見銀山へと向かった。"]

    @font = Font.new(38, "ＭＳ ゴシック", weight:true)
    @back = Image.load("scenes/game/images/opening3.png")  
    @n = 0
  end

  def play
    
    if (@bun.length) == @n
      Scene.set_scene(:select)
    end
    unless (@bun.length) == @n
      Window.draw(0,0,@back) 

      Window.drawFont(0,100,@bun[@n],@font,weight:true)
    end 
  end
  def next
    @n += 1
  end
  def sound
     @bgm = Sound.new("scenes/game/sounds/opening.mid")  # bgm.mid読み込み
     @bgm.play
  end
end
