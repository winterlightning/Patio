(function() {
  var $, Slide, SlideApp, exports;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQuery;
  Slide = (function() {
    __extends(Slide, Spine.Model);
    function Slide() {
      Slide.__super__.constructor.apply(this, arguments);
    }
    Slide.configure("Slide", "name", "content");
    Slide.extend(Spine.Model.Local);
    return Slide;
  })();
  SlideApp = (function() {
    __extends(SlideApp, Spine.Controller);
    function SlideApp() {
      this.addAll = __bind(this.addAll, this);      SlideApp.__super__.constructor.apply(this, arguments);
      Slide.fetch();
      this.addAll();
    }
    SlideApp.prototype.addAll = function() {
      var all_slides;
      Slide.fetch();
      all_slides = Slide.all();
      $('#content').html("");
      return $.each(all_slides, function(key, value) {
        var each_slide;
        each_slide = '<section class="slide" id="' + value.id + '">' + value.content + '</section>';
        alert(each_slide);
        window.a = each_slide;
        return $('.deck-container').append(each_slide);
      });
    };
    return SlideApp;
  })();
  $(function() {
    return new SlideApp({
      el: $("#content"),
      item: "blarg"
    });
  });
  exports = this;
  exports.Slide = Slide;
  exports.SlideApp = SlideApp;
}).call(this);
