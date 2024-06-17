module.exports = (app) => {
  const products = require('../controllers/product.controller.js');

  const router = require('express').Router();

  // Create a new Product
  router.post('/', products.create);

  // Retrieve all Products
  router.get('/', products.findAll);

  // Retrieve all published Products
  router.get('/published', products.findAllPublished);

  // Retrieve all Products by name
  router.get('/', products.findByName);

  // Retrieve a single Product with productId
  router.get('/:productId', products.findOne);

  // Update a Product with productId
  router.put('/:productId', products.update);

  // Delete a Product with productId
  router.delete('/:productId', products.delete);

  // Delete all Products
  router.delete('/', products.deleteAll);

  app.use('/api/products', router);
};
