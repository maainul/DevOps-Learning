const request = require("supertest");
const app = require("../index.js");

describe("Test Express API endpoints", () => {
    test("GET / should return Home Message", async () => {
        const response = await request(app).get("/");
        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({
            status: 201,
            body: "Home Message",
        });
    });

    test("GET /f1 should return f1 Message", async () => {
        const response = await request(app).get("/f1");
        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({
            status: 201,
            body: "f1 Message",
        });
    });

    test("GET /get should return Get Message", async () => {
        const response = await request(app).get("/get");
        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({
            status: 201,
            body: "Get Message",
        });
    });
});
