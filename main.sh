#!/bin/bash

# Variables
MONGODB_URI="mongodb+srv://ttran375:t8Uj2DGuCGIRtkqQ@cluster0.r9sqyo9.mongodb.net/Skeleton?retryWrites=true&w=majority&appName=Cluster0/users"

# Create project directory
mkdir marketplace
cd marketplace

# Initialize Node.js project
npm init -y

# Install necessary dependencies
npm install express mongoose cors body-parser

# Create server.js file
cat <<EOL > server.js
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
const db = "$MONGODB_URI";
mongoose.connect(db, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// Welcome Route
app.get('/', (req, res) => {
  res.json({ message: "Welcome to DressStore application." });
});

// Routes
require('./routes/product.routes')(app);

// Start Server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(\`Server is running on port \${PORT}\`);
});
EOL

# Create necessary directories and files
mkdir models controllers routes

# Create Mongoose model
cat <<EOL > models/product.model.js
const mongoose = require('mongoose');

const ProductSchema = mongoose.Schema({
  name: String,
  description: String,
  price: Number,
  quantity: Number,
  category: String
}, {
  timestamps: true
});

module.exports = mongoose.model('Product', ProductSchema);
EOL

# Create controller
cat <<EOL > controllers/product.controller.js
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
  Product.find({ name: { \$regex: req.query.name, \$options: "i" } })
    .then(products => {
      res.send(products);
    }).catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving products by name."
      });
    });
};
EOL

# Create routes
cat <<EOL > routes/product.routes.js
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
EOL

# Run the server
node server.js
