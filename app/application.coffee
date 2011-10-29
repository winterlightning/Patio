$ = jQuery

class Task extends Spine.Model
  @configure "Task", "name", "done", "date"
  
  @extend Spine.Model.Local

  @active: ->
    @select (item) -> !item.done

  @done: ->
    @select (item) -> !!item.done
    
  @date: (date) ->
    @select (item) -> item.date == date

  @destroyDone: ->
    rec.destroy() for rec in @done()

class Tasks extends Spine.Controller
  events:
   "change   input[type=checkbox]": "toggle"
   "click    .destroy":             "remove"
   "dblclick .view":                "edit"
   "keypress input[type=text]":     "blurOnEnter"
   "blur     input[type=text]":     "close"
 
  elements:
    "input[type=text]": "input"

  constructor: ->
    super
    @item.bind("update",  @render)
    @item.bind("destroy", @destroy)
  
  render: =>
    @replace($("#taskTemplate").tmpl(@item))
    @
  
  toggle: ->
    @item.done = !@item.done
    @item.save()
  
  remove: ->
    @item.destroy()
  
  edit: ->
    @el.addClass("editing")
    @input.focus()
  
  blurOnEnter: (e) ->
    if e.keyCode is 13 then e.target.blur()
  
  close: ->
    @el.removeClass("editing")
    @item.updateAttributes({name: @input.val()})

class TaskApp extends Spine.Controller
  events:
    "submit form":   "create"
    "click  .clear": "clear"

  elements:
    ".items":     "items"
    ".countVal":  "count"
    ".clear":     "clear"
    "form input": "input"
  
  constructor: ->
    super
    Task.bind("create",  @addOne)
    Task.bind("refresh", @addAll)
    Task.bind("refresh change", @renderCount)
    @previous = null
    Task.fetch()
  
  addOne: (task) =>
    if task.date == @item.toDateString()
      view = new Tasks(item: task)
      @el.find(".items").append(view.render().el)
  
  addAll: =>
    #Task.each(@addOne)
    todays_tasks = Task.date(@item.toDateString() )
    
    @el.find(".items").html("")
    
    a = this
    
    $.each todays_tasks, (key, value) ->
      a.addOne(value)
      
    @previous = todays_tasks 

  create: (e) ->
    e.preventDefault()
    Task.create(name: @input.val(), date: @item.toDateString() )
    @input.val("")
  
  clear: ->
    Task.destroyDone()
    
#  render:
#    weekday = @item.toLocaleDateString().substr(0,3)
#    x = @item.toLocaleDateString().split(",")
#    monthstring = x[1] + "," + x[2]
#    
#    rendered = $("#tasklistTemplate").tmpl( { weekday: weekday, monthstring: monthstring } )
#    $("#content").append( rendered );
  
  renderCount: =>
    active = Task.active().length
    @count.text(active)
    
    inactive = Task.done().length
    if inactive 
      @clear.show()
    else
      @clear.hide()

#class TaskListApp extend Spine.Controller
#  constructor: ->
#    super
#   
#  render: =>
#    @replace( $("#tasklistTemplate").tmpl("test") )

$ ->
  #create the stuff for all five days
  counter = 0
  for divname in ["one", "two", "three", "four", "five", "six", "seven"]
    $("#content").append('<div id="'+divname+'"></div>')
    currentdiv = '#' + divname
    
    #increment current date
    current_date = new Date()
    current_date.setDate(current_date.getDate()+counter);
    
    weekday = current_date.toLocaleDateString().substr(0,3)
    x = current_date.toLocaleDateString().split(",")
    monthstring = x[1] + "," + x[2]
    $(currentdiv).html( $("#tasklistTemplate").tmpl( { weekday: weekday, monthstring: monthstring } ) )
    new TaskApp(el: $(currentdiv), item: current_date  )
    counter++
  
  #create the stuff for someday
  new TaskApp(el: $("#somedaytasks"), item: new Date(12, 20, 1960)  )