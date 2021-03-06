# Methods for both templates

getArticleAttributes = (e) ->
  title: $(e.target).find('#title').val()
  author: $(e.target).find('#author').val()
  category: $(e.target).find('#category').val()
  carouselImage: $(e.target).find('#carouselImage').val()
  content: $(e.target).find('#content').val()

submitCallback = (articleId) ->
  (error, result) ->
    if error then alert error.reason # TO-DO: add UI for alert
    navigate('articleShow', _id: articleId or result._id)

toggleDisabled = ->
  result = $('select').val() is 'live'
  console.log result
  $('#carouselImage').attr('disabled', $('select').val() is 'live')

# Options for parent template

Template.articleForm.helpers
  formTitle: ->
    if @_id then "Edit Article" else "New Article"
  categories: ->
    l = []
    for category of categories
      c = categories[category]
      c.value = category
      if c.isArticleCategory then l.push(c)
    l

Template.articleForm.events
  'change select': (e) ->
    toggleDisabled()

# Options for articleNew

Template.articleNew.events
  'submit form': (e) ->
    e.preventDefault()
    article = getArticleAttributes(e)
    Meteor.call 'insertArticle', article, submitCallback()

# Options for articleEdit

Template.articleEdit.events
  'submit form': (e) ->
    e.preventDefault()
    attributes = getArticleAttributes(e)
    Articles.update @_id, {$set: attributes}, submitCallback(@_id)
  
Template.articleEdit.rendered = ->
  category = @data.category
  $('select option').each ->
    $(@).prop('selected', true) if @value is category
  toggleDisabled()
