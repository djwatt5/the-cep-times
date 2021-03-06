@Articles = new Mongo.Collection('articles')

# Permissions: admins will be able to
# create, update, and destroy every article

requireUser = (userId, doc) -> !! userId

@Articles.allow
  insert: requireUser
  update: requireUser
  remove: requireUser

# NOTE: this bypasses all allow/deny calls;
# Meteor assumes the server can be trusted

Meteor.methods
  insertArticle: (attributes) ->
    ### TO-DO: fix validation
    check(Meteor.userId(), String)
    check(attributes, {
      title: String
      author: String
      category: String
      # TO-DO: add proper check for content and carousel image
    })
    ###
    
    article = _.extend(attributes, {
      userId: Meteor.user()._id
      submitted: new Date
    })
    
    _id: Articles.insert(article)
