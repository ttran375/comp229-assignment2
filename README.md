# Online Market Application -- Node.js, Express REST APIs & MongoDB

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
