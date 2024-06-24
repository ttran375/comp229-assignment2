const Product = require('../models/product.model.js');

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
        category: req.body.category,
        published: req.body.published || false
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

// Retrieve and return all products from the database, with optional filtering by name.
exports.findAll = (req, res) => {
  const nameQuery = req.query.name; // Get the name from query parameters
  if (nameQuery) {
    // Remove brackets and retrieve the content inside them
    const name = nameQuery.match(/\[(.*)\]/)?.[1];
    if (name) {
      Product.find({ name: { $regex: new RegExp(`^${name}`, 'i') } }) // Case-insensitive search
        .then(products => {
          res.send(products);
        }).catch(err => {
          res.status(500).send({
            message: err.message || "Some error occurred while retrieving products."
          });
        });
    } else {
      res.status(400).send("Invalid name format. Use name=[YourProductNameHere].");
    }
  } else {
    Product.find()
      .then(products => {
        res.send(products);
      }).catch(err => {
        res.status(500).send({
          message: err.message || "Some error occurred while retrieving products."
        });
      });
  }
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
        category: req.body.category,
        published: req.body.published || false
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
    Product.findByIdAndDelete(req.params.productId)
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

// Find all products with name containing 'kw'
exports.findByName = (req, res) => {
    const name = req.query.name;
    var condition = name ? { name: { $regex: new RegExp(name), $options: "i" } } : {};

    Product.find(condition)
        .then(products => {
            res.send(products);
        }).catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while retrieving products."
            });
        });
};
