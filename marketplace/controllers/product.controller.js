const Product = require('../models/product.model');

// Create and Save a new Product
exports.create = (req, res) => {
  if (!req.body.name) {
    return res.status(400).send({
      message: "Product name can not be empty"
    });
  }

  const product = new Product({
    name: req.body.name,
    description: req.body.description,
    price: req.body.price,
    quantity: req.body.quantity,
    category: req.body.category
  });

  product.save()
    .then(data => {
      res.send(data);
    }).catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Product."
      });
    });
};

// Retrieve and return all products from the database.
exports.findAll = (req, res) => {
  Product.find()
    .then(products => {
      res.send(products);
    }).catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving products."
      });
    });
};

// Find a single product with a productId
exports.findOne = (req, res) => {
  Product.findById(req.params.productId)
    .then(product => {
      if (!product) {
        return res.status(404).send({
          message: "Product not found with id " + req.params.productId
        });
      }
      res.send(product);
    }).catch(err => {
      if (err.kind === 'ObjectId') {
        return res.status(404).send({
          message: "Product not found with id " + req.params.productId
        });
      }
      return res.status(500).send({
        message: "Error retrieving product with id " + req.params.productId
      });
    });
};

// Update a product identified by the productId in the request
exports.update = (req, res) => {
  if (!req.body.name) {
    return res.status(400).send({
      message: "Product name can not be empty"
    });
  }

  Product.findByIdAndUpdate(req.params.productId, {
    name: req.body.name,
    description: req.body.description,
    price: req.body.price,
    quantity: req.body.quantity,
    category: req.body.category
  }, { new: true })
    .then(product => {
      if (!product) {
        return res.status(404).send({
          message: "Product not found with id " + req.params.productId
        });
      }
      res.send(product);
    }).catch(err => {
      if (err.kind === 'ObjectId') {
        return res.status(404).send({
          message: "Product not found with id " + req.params.productId
        });
      }
      return res.status(500).send({
        message: "Error updating product with id " + req.params.productId
      });
    });
};

// Delete a product with the specified productId in the request
exports.delete = (req, res) => {
  Product.findByIdAndRemove(req.params.productId)
    .then(product => {
      if (!product) {
        return res.status(404).send({
          message: "Product not found with id " + req.params.productId
        });
      }
      res.send({ message: "Product deleted successfully!" });
    }).catch(err => {
      if (err.kind === 'ObjectId' || err.name === 'NotFound') {
        return res.status(404).send({
          message: "Product not found with id " + req.params.productId
        });
      }
      return res.status(500).send({
        message: "Could not delete product with id " + req.params.productId
      });
    });
};

// Delete all products from the database.
exports.deleteAll = (req, res) => {
  Product.deleteMany({})
    .then(() => {
      res.send({ message: "All products deleted successfully!" });
    }).catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while removing all products."
      });
    });
};

// Find all published products
exports.findAllPublished = (req, res) => {
  Product.find({ published: true })
    .then(products => {
      res.send(products);
    }).catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving published products."
      });
    });
};

// Find all products by name
exports.findByName = (req, res) => {
  Product.find({ name: { $regex: req.query.name, $options: "i" } })
    .then(products => {
      res.send(products);
    }).catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving products by name."
      });
    });
};
