$ = jQuery

class Slide extends Spine.Model
  @configure "Slide", "name", "content"
  
  @extend Spine.Model.Local

class SlideApp extends Spine.Controller
  
  constructor: ->
    super
    Slide.fetch()
    @addAll()
    #Task.bind("create",  @addOne)
    #Task.bind("refresh", @addAll)
    
#  addOne: (task) =>
#    if task.date == @item.toDateString()
#      view = new Tasks(item: task)
#      @el.find(".items").append(view.render().el)
  
  addAll: =>
    Slide.fetch()
    #Task.each(@addOne)
    all_slides = Slide.all()
    
    if all_slides.length == 0
      alert("here")
      Slide.create({name: "one", content: '<h1>This is your first slide! Edit it!</h1>'});
      all_slides = Slide.all()
    
    $('#content').html("")
    
    $.each all_slides, (key, value) ->
      #each_slide = $("#slideTemplate").tmpl(value)
      each_slide = '<section class="slide" id="'+value.id+'">' + value.content + '</section>'
      window.a = each_slide
      $('.deck-container').append(each_slide)
    
    $.deck('.slide')


$ ->
 window.slideapp = new SlideApp(el: $("#content"), item: "blarg"  )

exports = this
exports.Slide = Slide
exports.SlideApp = SlideApp
