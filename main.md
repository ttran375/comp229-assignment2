Here's a step-by-step guide to creating the Online Market Application using Node.js, Express REST APIs, and MongoDB:

## 1. Setting Up MongoDB Database

1. **Create the Database and Collection**

   - **Create Database:**

     ```javascript
     use Marketplace
     ```

   - **Create Collection:**

     ```javascript
     db.createCollection("products")
     ```

   - **Add Sample Document:**

     ```javascript
     db.products.insert({
       name: "Sample Dress",
       description: "A beautiful summer dress",
       price: 49.99,
       quantity: 100,
       category: "Summer Collection"
     })
     ```

2. **Obtain Connection String (URI):**
   - Your connection string will look something like this:

     ```
     mongodb+srv://<username>:<password>@cluster0.mongodb.net/Marketplace?retryWrites=true&w=majority
     ```

3. **Snapshot of MongoDB:**
   - Use MongoDB Compass or MongoDB Atlas UI to capture screenshots of the database and collection.

## 2. Setting Up Node.js Application

1. **Initialize Node.js Project:**

   ```bash
   mkdir marketplace
   cd marketplace
   npm init -y
   ```

2. **Install Dependencies:**

   ```bash
   npm install express mongoose cors body-parser
   ```

3. **Create Basic Server:**
   - Create a file named `server.js` and add the following code:

     ```javascript
     const express = require('express');
     const cors = require('cors');
     const mongoose = require('mongoose');

     const app = express();

     // Middleware
     app.use(cors());
     app.use(express.json());

     // Connect to MongoDB
     const db = "your_mongo_db_connection_string";
     mongoose.connect(db, { useNewUrlParser: true, useUnifiedTopology: true })
       .then(() => console.log("MongoDB connected"))
       .catch(err => console.log(err));

     // Welcome Route
     app.get('/', (req, res) => {
       res.json({ message: "Welcome to DressStore application." });
     });

     // Start Server
     const PORT = process.env.PORT || 8080;
     app.listen(PORT, () => {
       console.log(`Server is running on port ${PORT}`);
     });
     ```

4. **Run the App:**

   ```bash
   node server.js
   ```

   - Open your browser and go to `http://localhost:8080` to see the welcome message.

5. **Snapshot of Running Server:**
   - Capture a screenshot of the browser displaying the welcome message.

## 3. Configuring MongoDB and Creating Mongoose Model

1. **Create Mongoose Model:**
   - Create a folder named `models` and add a file named `product.model.js`:

     ```javascript
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
     ```

## 4. Writing Controllers and Defining Routes

1. **Create Controllers:**
   - Create a folder named `controllers` and add a file named `product.controller.js`:

     ```javascript
     const Product = require('../models/product.model');

     // Create and Save a new Product
     exports.create = (req, res) => {
       // Validate request
       if (!req.body.name) {
         return res.status(400).send({
           message: "Product name can not be empty"
         });
       }

       // Create a Product
       const product = new Product({
         name: req.body.name,
         description: req.body.description,
         price: req.body.price,
         quantity: req.body.quantity,
         category: req.body.category
       });

       // Save Product in the database
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
       // Validate Request
       if (!req.body.name) {
         return res.status(400).send({
           message: "Product name can not be empty"
         });
       }

       // Find product and update it with the request body
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
     ```

2. **Define Routes:**
   - Create a folder named `routes` and add a file named `product.routes.js`:

     ```javascript
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
     ```

3. **Update Server File:**
   - Update `server.js` to include the routes:

     ```javascript
     const express = require('express');
     const cors = require('cors');
     const mongoose = require('mongoose');



     const app = express();

     // Middleware
     app.use(cors());
     app.use(express.json());

     // Connect to MongoDB
     const db = "your_mongo_db_connection_string";
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
       console.log(`Server is running on port ${PORT}`);
     });
     ```

## 5. Testing the REST APIs

1. **Test Using Postman:**
   - Import the following API endpoints in Postman:
     - **GET** `http://localhost:8080/api/products`
     - **GET** `http://localhost:8080/api/products/:id`
     - **POST** `http://localhost:8080/api/products`
     - **PUT** `http://localhost:8080/api/products/:id`
     - **DELETE** `http://localhost:8080/api/products/:id`
     - **DELETE** `http://localhost:8080/api/products`
     - **GET** `http://localhost:8080/api/products/published`
     - **GET** `http://localhost:8080/api/products?name=[kw]`

2. **Snapshot of Test Results:**
   - Capture screenshots of Postman showing the results of the API tests.

By following these steps, you will create and test a Node.js, Express, and MongoDB-based REST API for an online marketplace application.

