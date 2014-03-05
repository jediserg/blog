mongoose = require "mongoose"

articles_at_page = 10

ArticleSchema = new mongoose.Schema({
  title: 
  	type: String, required: true, unique: true, index: true
  url:
  	type: String, required: true, unique: true, index: true
  content:
  	type: String, required: true
  preview: String
  description: String
  keywords: String
  is_plain_text: Boolean
  img_url: String
  create_date: { type: Date, default: Date.now }
})

ArticleSchema.statics.getPages = (num, cb) ->
  model = @
  @find({}).sort(date: 1).skip((num - 1) * articles_at_page).limit(articles_at_page).exec (err, articles) ->
    if err
      console.log err
      cb({}, 0, 0)
    else
      model.count({}).exec (err, count) ->
        if err
          console.log err
          cb({}, 0, 0)
        else
          cb(articles, count, articles_at_page)
ArticleSchema.statics.crudOptions = create : "admin"
                                    read   : "all"
                                    update : "admin"
                                    del    : "admin"
 
module.exports = mongoose.model 'Article', ArticleSchema