class Comment
  constructor: (str) ->
    @body = $("<span class='nicoComment'>#{str}</span>")
  
  number: (number) ->
    @body.css 'id', 'item#{number}'
    @

  append: (parent) ->
    @body.appendTo parent
    @
  
  fontsize: (command) ->
    if command.size == 'large'
      scale = 1.2
    else if command.size == 'small'
      scale = 0.8
    else
      scale = 1.0

    size = parseInt(@body.css('font-size')) * scale
    @body.css 'font-size', size + 'px'
    @

  left: () -> @body.position().left
  top: () -> @body.position().top
  width: () -> @body.width()
  height: () -> @body.height()

class NicoLayer
  constructor: (@el) ->
    @width = @el.width()
    @height = @el.height()
    @queue = []
    @wqueue = []
    @number = 0

  observe: () ->
    nqueue = _.filter @queue, (i) -> i.left() != 0
    @queue = nqueue

    while true
      break if @wqueue.length == 0
      l = @queue.length
      @add(@wqueue.shift())
      if l == @queue.length
        @wqueue.unshift(@wqueue.pop())
        break

  format: (command, str) ->
    @number += 1
    comment = new Comment(str)
    comment.number(@number).append(@el)
    comment.fontsize(command)

  view: (c, y) ->
    offset = c.body.offset({
      top: y + @el.offset().top,
      left: @width + @el.offset().left
    })

    animation = offset.animate(
      left: -c.width(),
      {
        duration: 3*(@width + c.width()),
        easing: 'linear'
        complete: =>
          animation.remove()
      }
    )

  search_space: () ->
    fill_space = []
    for i in @queue
      if i.left() > @width - i.width()
        fill_space.push({y:i.top(), w:i.height()})
    
    fill_space = _.sortBy fill_space, (i) -> i.y
 
    space = []
    sp = 0
    for i in fill_space
      diff = i.y - sp
      if diff != 0
        space.push({y:sp, w:diff})
      sp = i.y + i.w

    if sp != @height
      space.push({y:sp, w:@height - sp})
     
    return space

  get_position: (c) ->
    space = @search_space()
    pos = (_.find space, (i) -> i.w > c.height())

    if pos?
      pos.y
    else
      undefined

  add: (comment) ->
    y = @get_position(comment)
    if y?
      @queue.push(comment)
      @view(comment, y)
    else
      @wqueue.push(comment)


  send: (command, str) ->
    c = @format(command, str)
    @add(c)

@NicoLayer = NicoLayer
module?.exports = NicoLayer
