const express = require("express");

const app = express();

app.get("/", async (req, res) => {
    return res.json({
        status: 201,
        body: "Home Message",
    });
});

app.get("/f1", async (req, res) => {
    return res.json({
        status: 201,
        body: "f1 Message",
    });
});

app.get("/get", async (req, res) => {
    return res.json({
        status: 201,
        body: "Get Messag",
    });
});

module.exports = app; // Export only the app
