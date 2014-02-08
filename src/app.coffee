$.event.add window, "load", ->
  window.nicolayer = new NicoLayer($('#nicolayer'))
  setInterval("window.nicolayer.observe()", 150)

  for i in [0..40]
    r = parseInt(Math.random()*30)
    if r > 15
      r += 40
    str = ""
    c = parseInt(Math.random()*10)
    cs = ["あ","い","う","え","お","亜","意","鵜","絵","尾"]
    for j in [0..r]
      str += cs[c]
    size = ['large', 'normal', 'small'][parseInt(Math.random()*3)]
    nicolayer.send({speed:3000, size:size}, str)
