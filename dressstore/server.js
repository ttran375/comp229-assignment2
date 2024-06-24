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
    console.log(`Server is running on port ${PORT}.`);
});
