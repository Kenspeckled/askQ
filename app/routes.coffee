homeController = require 'home.coffee'
producerController = require 'producer.coffee'
productController = require 'product.coffee'
checkoutController = require 'checkout.coffee'

routes = (router) ->
  if !(_scriptContext == 'server' or _scriptContext == 'client')
    throw new Error('_scriptContext not defined properly')

  router.get '/', homeController.index

  router.get '/producers', producerController.index
  router.get '/producers/:id', producerController.show

  router.get '/products', productController.index
  router.get '/products/:category', productController.index
  router.get '/products/:category/:id', productController.show

  router.get '/checkout', checkoutController.checkout

  if _scriptContext == 'client'
    router.start() 

  else if _scriptContext == 'server'
    
    router.get '/api/products/show.json', productController.showJSON
    router.get '/api/products/index.json', productController.indexJSON

    router.post '/blah', (req, res) ->
      res.send 'hello'

module.exports = routes

