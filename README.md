# Online Market Application -- Node.js, Express REST APIs & MongoDB

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ttran375/comp229-assignment2)

Dress Store -- Node.js, Express REST APIs & MongoDB

**Overview**: Create the Node.js Express exports REST APIs that
interacts with MongoDB Database using Mongoose ODM for an Online
Market application (Note: The Front-end of the application is not
included in this Assignment).

## Instructions

The Online Market Application:

1. Using MongoDB database, create:**(25 Marks):**

    a.  A database by name **Marketplace .**

    b.  Create the following collections with their respective property.
        (5 Marks: Functionality).

    I.  **products**

    > name: string
    >
    > description: string
    >
    > price: number
    >
    > quantity: number
    >
    > category: string

    c.  Obtain your connection string ( url or uri)

    d.  Provide the screen snapshot of your MongoDB database showing the above steps from 1a - c.

2. Using Visual studio code as the IDE: **(25 Marks)**

    a.  create a node.js App for the Marketplace by setting up the
        Express web server. Ensure to install all the necessary modules:
        express, mongoose, cors e.t.c.

    b.  Run the app and provide a screen snapshot of it running in the
        browser as follows: `http://localhost:8080`

        {
          "message": "Welcome to DressStore application."
        }

3. After creating the Express web server next: **(30 Marks)**

    a.  Add the configuration for the MongoDB database.

    b.  Create the product model with Mongoose.

    c.  Write the controller.

    d.  Define the routes for handling all CRUD operations.

Below is an overview of the REST APIs that will be exported:

| Methods | URLs                         | Actions                                    |
|---------|------------------------------|--------------------------------------------|
| GET     | api/products                 | get all Products                           |
| GET     | api/products/:id             | get Product by id                          |
| POST    | api/products                 | add new Product                            |
| PUT     | api/products/:id             | update Product by id                       |
| DELETE  | api/products/:id             | remove Product by id                       |
| DELETE  | api/products                 | remove all Products                        |
| GET     | api/products/published       | find all published Products                |
| GET     | api/products?name=[kw]       | find all Products which name contains 'kw' |

4.
    a. Test the REST APIs using Postman, Thunder client or any tool you are familiar with. e.t.c.

    b. Provide the screen snapshot of the test. **(20 Marks)**

### Install Packages

Navigate to API

```sh
cd dressstore
```

Install the necessary dependencies.

```sh
yarn
```

### Update .env File

Update the `.env` file located in the `dressstore`.

1. Navigate to the `client` directory.
2. Create a `.env` file. The example provided in `dressstore/.env.example` can be used as a reference.
3. Update the `MONGODB_URI` with the necessary credentials.

   ```.env
   MONGODB_URI=mongodb+srv://your_user:your_password@your_cluster.mongodb.net/YourDatabase?retryWrites=true&w=majority&appName=YourApp/yourcollection
   ```

### Start the Server

After installing the packages, start the server:

```sh
yarn start
```

### All Endpoint Examples

#### Get all Products

* **URL:** `/api/products`
* **Method:** `GET`
* **Response:**

  ```json
  [
    {
      "name": "Casual Summer Dress",
      "description": "A light and breezy dress perfect for summer outings.",
      "price": 49.99,
      "quantity": 30,
      "category": "Casual Wear",
      "published": true
    },
    {
      "name": "Elegant Evening Gown",
      "description": "A stunning gown for formal occasions.",
      "price": 199.99,
      "quantity": 10,
      "category": "Formal Wear",
      "published": false
    }
  ]
  ```

#### Get Product by ID

* **URL:** `/api/products/667824b7c60309b2287a21f8`
* **Method:** `GET`
* **URL Params:**
  * `id` - ID of the product
* **Response:**

  ```json
  {
    "name": "Casual Summer Dress",
    "description": "A light and breezy dress perfect for summer outings.",
    "price": 49.99,
    "quantity": 30,
    "category": "Casual Wear",
    "published": true
  }
  ```

#### Add new Product

* **URL:** `/api/products`
* **Method:** `POST`
* **Body:**

  ```json
  {
    "name": "Sporty Sundress",
    "description": "A casual dress ideal for outdoor activities.",
    "price": 39.99,
    "quantity": 20,
    "category": "Sportswear",
    "published": true
  }
  ```

* **Response:**

  ```json
  {
    "message": "Product added successfully!"
  }
  ```

#### Update Product by ID

* **URL:** `/api/products/667824b7c60309b2287a21f8`
* **Method:** `PUT`
* **URL Params:**
  * `id` - ID of the product
* **Body:**

  ```json
  {
    "name": "Sporty Sundress",
    "description": "A casual dress ideal for outdoor activities.",
    "price": 40.00,
    "quantity": 21,
    "category": "Sportswear",
    "published": true
  }
  ```

* **Response:**

  ```json
  {
    "message": "Product updated successfully!"
  }
  ```

#### Remove Product by ID

* **URL:** `/api/products/:id`
* **Method:** `DELETE`
* **URL Params:**
  * `id` - ID of the product
* **Response:**

  ```json
  {
    "message": "Product deleted successfully!"
  }
  ```

#### Remove all Products

* **URL:** `/api/products`
* **Method:** `DELETE`
* **Response:**

  ```json
  {
    "message": "All products deleted successfully!"
  }
  ```

#### Find all published Products

* **URL:** `/api/products/published`
* **Method:** `GET`
* **Response:**

  ```json
  [
    {
      "name": "Casual Summer Dress",
      "description": "A light and breezy dress perfect for summer outings.",
      "price": 49.99,
      "quantity": 30,
      "category": "Casual Wear",
      "published": true
    }
  ]
  ```

#### Find all Products which name contains 'kw'

* **URL:** `/api/products?name=[Sp]`
* **Method:** `GET`
* **Response:**

  ```json
  [
    {
      "name": "Sporty Sundress",
      "description": "A casual dress ideal for outdoor activities.",
      "price": 39.99,
      "quantity": 20,
      "category": "Sportswear",
      "published": true
    }
  ]
  ```
