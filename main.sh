#!/bin/bash

# Create project directory
mkdir dressstore
cd dressstore

# Initialize npm project
npm init -y

# Install necessary modules
npm install express mongoose cors dotenv

# Create server.js file
cat <<EOL > server.js
const dotenv = require("dotenv");
dotenv.config();

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Welcome route
app.get('/', (req, res) => {
    res.json({ message: "Welcome to DressStore application." });
});

const dbConfig = process.env.MONGODB_URI;

mongoose.connect(dbConfig, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log("Successfully connected to MongoDB.");
}).catch(err => {
    console.log("Connection error", err);
    process.exit();
});

require('./routes/product.routes.js')(app);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(\`Server is running on port \${PORT}.\`);
});
EOL

# Create models directory and product.model.js file
mkdir models
cat <<EOL > models/product.model.js
const mongoose = require('mongoose');

const ProductSchema = mongoose.Schema({
    name: String,
    description: String,
    price: Number,
    quantity: Number,
    category: String,
    published: Boolean
}, {
    timestamps: true
});

module.exports = mongoose.model('Product', ProductSchema);
EOL

# Create controllers directory and product.controller.js file
mkdir controllers
cat <<EOL > controllers/product.controller.js
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
      Product.find({ name: { \$regex: new RegExp(\`^\${name}\`, 'i') } }) // Case-insensitive search
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
    var condition = name ? { name: { \$regex: new RegExp(name), \$options: "i" } } : {};

    Product.find(condition)
        .then(products => {
            res.send(products);
        }).catch(err => {
            res.status(500).send({
                message: err.message || "Some error occurred while retrieving products."
            });
        });
};
EOL

# Create routes directory and product.routes.js file
mkdir routes
cat <<EOL > routes/product.routes.js
module.exports = app => {
    const products = require('../controllers/product.controller.js');

    var router = require('express').Router();

    router.post('/', products.create);
    router.get('/', products.findAll);
    router.get('/published', products.findAllPublished);
    router.get('/:productId', products.findOne);
    router.put('/:productId', products.update);
    router.delete('/:productId', products.delete);
    router.delete('/', products.deleteAll);

    app.use('/api/products', router);
};
EOL

# Create .env file
cp ../.env ./

# Start the server
node server.js
